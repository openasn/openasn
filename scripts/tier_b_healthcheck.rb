#!/usr/bin/env ruby
# frozen_string_literal: true

# Tier B health check — fetch every recipe in fetch-manifest.json ONCE, live,
# and parse it with the openasn gem's own parsers.
#
# What it answers, per source: is the endpoint still there, did it change
# shape, and does the gem still get data out of it. Nothing else. It never
# writes an overlay, never resolves DNS (hostname sources report a hostname
# count instead), and never modifies the manifest.
#
# Read the results with this in mind: a fetch failure is a claim about the
# observer as often as about the endpoint. Cloudflare `error code: 1005` means
# the network you are fetching from is banned — leave the recipe alone. A
# challenge interstitial means the operator does not want automated fetchers —
# stop recommending that source on by default. HTTP 404 on a URL that used to
# work means the source moved or died, and only that case is a manifest bug.
#
# Usage:
#   ruby scripts/tier_b_healthcheck.rb                            # all sources
#   ruby scripts/tier_b_healthcheck.rb scaleway_ranges aws        # named sources
#   ONLY=vpn ruby scripts/tier_b_healthcheck.rb                   # id substring filter
#
# Environment:
#   GEM_LIB   path to the openasn gem's lib/  (default: ../openasn-ruby/lib if present,
#             otherwise the installed gem)
#   MANIFEST  path to fetch-manifest.json     (default: the one next to this repo's root)
#   OUT       output basename                 (default: ./tier-b-health-YYYY-MM-DD)
#   THREADS   concurrent fetches              (default 6 — these are mostly free endpoints;
#                                              being a good citizen is part of the deal)
#   TIMEOUT   per-request seconds             (default 60)
#
# Writes <OUT>.json (machine-readable) and <OUT>.md (the table that goes into
# PROVIDER_SOURCES.md), and prints a live summary to stderr. Exit status is 0
# only when every source is healthy.

require "json"
require "net/http"
require "uri"
require "time"

REPO_ROOT  = File.expand_path("..", __dir__)
MANIFEST   = ENV.fetch("MANIFEST", File.join(REPO_ROOT, "fetch-manifest.json"))
OUT        = ENV.fetch("OUT", "tier-b-health-#{Time.now.utc.strftime('%Y-%m-%d')}")
THREADS    = Integer(ENV.fetch("THREADS", "6"))
TIMEOUT    = Integer(ENV.fetch("TIMEOUT", "60"))
USER_AGENT = "openasn-research/1.0 (+https://github.com/openasn/openasn)"
MAX_REDIRECTS = 5

gem_lib = ENV["GEM_LIB"] || begin
  sibling = File.expand_path("../openasn-ruby/lib", REPO_ROOT)
  Dir.exist?(sibling) ? sibling : nil
end
$LOAD_PATH.unshift(gem_lib) if gem_lib
begin
  require "openasn"
rescue LoadError
  abort "cannot load the openasn gem — set GEM_LIB=/path/to/openasn-ruby/lib or `gem install openasn`"
end

manifest = JSON.parse(File.read(MANIFEST))
sources  = manifest["sources"]
wanted   = ARGV.reject { |a| a.start_with?("-") }
filter   = ENV["ONLY"]
sources = sources.select { |s| wanted.include?(s["id"]) } unless wanted.empty?
sources = sources.select { |s| s["id"].include?(filter) } if filter && !filter.empty?
abort "no sources matched" if sources.empty?

# --- HTTP -------------------------------------------------------------------
# Deliberately NOT the gem's HttpClient: the health check must see the raw
# status of a redirect chain and must not inherit any client-side policy that
# could mask a broken endpoint.
def fetch(url, limit = MAX_REDIRECTS, method: :get, form: nil)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  http.open_timeout = TIMEOUT
  http.read_timeout = TIMEOUT

  request =
    if method == :post
      Net::HTTP::Post.new(uri).tap { |r| r.set_form_data(form || {}) }
    else
      Net::HTTP::Get.new(uri.request_uri)
    end
  request["User-Agent"] = USER_AGENT
  request["Accept"] = "*/*"

  response = http.request(request)
  if response.is_a?(Net::HTTPRedirection) && limit.positive?
    location = response["location"]
    return fetch(URI.join(url, location).to_s, limit - 1, method: method, form: form) if location
  end
  [response.code.to_i, response.body.to_s, response["content-type"].to_s]
rescue StandardError => e
  [0, "", "#{e.class}: #{e.message}"]
end

# Azure's real JSON URL rotates weekly behind a download page; mirror the
# gem's resolver so the check exercises the path production takes.
def resolve_azure(page_url)
  _, body, = fetch(page_url)
  body[%r{https://download\.microsoft\.com/download/[^"'\s]+ServiceTags_Public_\d+\.json}]
end

def urls_for(source)
  urls = []
  if source["resolver"] == "azure_download_page"
    resolved = resolve_azure(source["page_url"])
    urls << resolved if resolved
  elsif source["url"]
    urls << source["url"]
  end
  urls.concat(source["urls"]) if source["urls"].is_a?(Array)
  urls << source["url_ipv6"] if source["url_ipv6"]
  urls
end

def hostname?(token)
  token.match?(/\A(?=.{1,253}\z)(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,63}\z/i)
end

# --- the check ---------------------------------------------------------------
def check(source)
  row = { "id" => source["id"], "parser" => source["parser"], "maps_to" => source["maps_to"],
          "provider" => source["provider"], "role" => source["role"],
          "enabled_default" => source["enabled_default"],
          "http" => 0, "bytes" => 0, "tokens" => 0, "v4" => 0, "v6" => 0,
          "hostnames" => 0, "result" => "", "detail" => "", "urls" => [] }

  urls = urls_for(source)
  if urls.empty?
    row["result"] = "FAIL no-url"
    row["detail"] = "resolver #{source['resolver'].inspect} produced no URL"
    return row
  end
  row["urls"] = urls

  method = source["method"].to_s.upcase == "POST" ? :post : :get
  tokens = []
  urls.each do |url|
    status, body, ctype = fetch(url, method: method, form: source["form"])
    row["http"] = status if row["http"].zero? || status != 200
    row["bytes"] += body.bytesize
    if status != 200
      row["result"] = "FAIL http"
      row["detail"] = "#{url} -> #{status} (#{ctype})"
      return row
    end
    begin
      tokens.concat(OpenASN::Parsers.parse(source["parser"], body))
    rescue OpenASN::Parsers::ParseError => e
      row["result"] = "FAIL parse"
      row["detail"] = e.message[0, 300]
      return row
    end
  end
  row["http"] = 200 if row["http"].zero?

  row["tokens"] = tokens.length
  # No DNS here on purpose: a hostname source's answer depends on the resolver
  # and the vantage point, which would make the check unreproducible.
  direct, hosts = tokens.partition { |t| OpenASN::CidrUtils.parse(t.to_s.strip) }
  row["hostnames"] = hosts.count { |t| hostname?(t.to_s.strip) }
  ranges = OpenASN::CidrUtils.ranges_by_family(direct)
  row["v4"] = ranges[:ipv4].length
  row["v6"] = ranges[:ipv6].length

  row["result"] =
    if row["v4"].positive? || row["v6"].positive? || row["hostnames"].positive?
      "ok"
    else
      row["detail"] = "parser returned #{row['tokens']} tokens, none of them a range or a hostname"
      "FAIL empty"
    end
  row
end

# --- run ---------------------------------------------------------------------
queue = Queue.new
sources.each { |s| queue << s }
rows = []
mutex = Mutex.new
started = Time.now.utc

workers = [THREADS, sources.length].min.times.map do
  Thread.new do
    loop do
      source = begin
        queue.pop(true)
      rescue ThreadError
        break
      end
      row = check(source)
      mutex.synchronize do
        rows << row
        warn format("%-32s %-9s %6s  %10s B  %5s v4  %5s v6  %5s hosts",
                    row["id"], row["result"], row["http"], row["bytes"],
                    row["v4"], row["v6"], row["hostnames"])
      end
    end
  end
end
workers.each(&:join)

order = sources.map { |s| s["id"] }
rows.sort_by! { |r| order.index(r["id"]) }

def thousands(number) = number.to_s.reverse.scan(/\d{1,3}/).join(",").reverse

ok = rows.count { |r| r["result"] == "ok" }
report = { "checked_at" => started.iso8601, "manifest" => MANIFEST,
           "user_agent" => USER_AGENT, "sources" => rows.length, "ok" => ok,
           "failures" => rows.length - ok, "rows" => rows }
File.write("#{OUT}.json", "#{JSON.pretty_generate(report)}\n")

md = +"## Tier B health check #{started.strftime('%Y-%m-%d')}\n\n"
md << "Every recipe in `fetch-manifest.json` fetched ONCE, live, with the identifying\n"
md << "User-Agent `#{USER_AGENT}` and parsed with\n"
md << "the gem's own parsers. \"Tokens\" is what the parser returned; \"v4/v6 ranges\" is after\n"
md << "merging; \"Hostnames\" counts DNS-expanded sources, which report hostnames rather than\n"
md << "ranges because the health check does no DNS.\n\n"
md << "**#{ok} of #{rows.length} healthy.**\n\n"
md << "| Source id | HTTP | Bytes | Tokens | v4 ranges | v6 ranges | Hostnames | Result |\n"
md << "|---|---|---|---|---|---|---|---|\n"
rows.each do |r|
  md << format("| `%s` | %s | %s | %s | %s | %s | %s | %s |\n",
               r["id"], r["http"], thousands(r["bytes"]), thousands(r["tokens"]),
               r["v4"], r["v6"], r["hostnames"], r["result"])
end
failures = rows.reject { |r| r["result"] == "ok" }
unless failures.empty?
  md << "\n### Failures\n\n| Source id | Result | Detail |\n|---|---|---|\n"
  failures.each { |r| md << "| `#{r['id']}` | #{r['result']} | #{r['detail'].gsub('|', '\\|')} |\n" }
end
File.write("#{OUT}.md", md)

warn ""
warn "#{ok}/#{rows.length} healthy — wrote #{OUT}.json and #{OUT}.md"
exit(failures.empty? ? 0 : 1)
