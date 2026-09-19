#!/usr/bin/env ruby
# frozen_string_literal: true

# Standalone lint for this repo's curated data files — the check that runs
# on every PR (see .github/workflows/lint.yml). Stdlib only, zero setup, so
# contributors get fast feedback without access to the build pipeline.
#
# DELIBERATE DUPLICATION: the authoritative parser lives in the pipeline
# repo (openasn/openasn-pipeline, pipeline/lib/overrides.rb) and runs
# inside every nightly build — this lint mirrors its rules so PR feedback
# is instant. If the two ever disagree, the nightly is right and this file
# has the bug; fix it here, and keep both in sync when the rules evolve.
#
# Rules enforced:
#   * overrides/*.txt lines: `AS<number>  # comment` where the comment
#     contains a source URL (or `src:`) — provenance is non-negotiable.
#   * no ASN may appear in eyeball_confirm.txt AND an infrastructure list.
#   * org_names.txt: `AS<number>  <name>  # src: <url>`, the src never a
#     registry/aggregator host (D-SRC-2).
#   * asn_country.txt: `AS<number>  <CC>  # src: <url>`, CC an ISO 3166-1
#     alpha-2 country code, the src never a registry/aggregator host
#     (D-SRC-2, country).
#   * corrections.yml: integer keys; required fields; valid vocabulary.
#   * fetch-manifest.json: parses; every source has id/parser/maps_to and
#     a url or resolver.
#   * spotchecks.yml: parses; every row has ip + a verdict from the enum.

require "json"
require "yaml"
require "ipaddr"
require "set"
require "uri"

ROOT = File.expand_path("..", __dir__)
FAILURES = []

def fail_check(msg) = FAILURES << msg

# --- overrides/*.txt ---------------------------------------------------------

FLAG_FILES = %w[vpn_provider hosting_extra mobile_carrier enterprise_gateway cdn eyeball_confirm].freeze
sets = {}

FLAG_FILES.each do |name|
  path = File.join(ROOT, "data", "overrides", "#{name}.txt")
  sets[name] = Set.new
  next unless File.exist?(path)

  File.foreach(path).with_index(1) do |line, lineno|
    stripped = line.strip
    next if stripped.empty? || stripped.start_with?("#")

    unless (m = stripped.match(/\AAS(\d+)\s*#\s*(.+)\z/))
      fail_check("#{name}.txt:#{lineno}: expected `AS<number>  # comment`, got: #{stripped[0, 80].inspect}")
      next
    end
    asn, comment = m[1].to_i, m[2]
    unless comment.match?(%r{https?://|\bsrc:}i)
      fail_check("#{name}.txt:#{lineno}: AS#{asn} has no source URL in its comment — every line must be traceable")
    end
    fail_check("#{name}.txt:#{lineno}: duplicate AS#{asn}") if sets[name].include?(asn)
    sets[name] << asn
  end
end

infra = sets.values_at("vpn_provider", "hosting_extra", "enterprise_gateway", "cdn").reduce(Set.new, :|)
conflicts = sets["eyeball_confirm"] & infra
unless conflicts.empty?
  fail_check("overrides conflict: in eyeball_confirm AND an infrastructure list: " \
             "#{conflicts.to_a.sort.map { |a| "AS#{a}" }.join(', ')} — resolve via corrections.yml, not both-ways membership")
end

# --- org_names.txt ---------------------------------------------------------------
# Mirrors Overrides#parse_org_names in the pipeline. The host list mirrors
# WikidataNames::RESTRICTED_REF_HOSTS there. Keep the two in sync.

ORG_NAME_RESTRICTED_HOSTS = %w[
  arin.net ripe.net apnic.net lacnic.net afrinic.net
  registro.br nic.br jpnic.ad.jp nic.ad.jp twnic.net.tw kisa.or.kr cnnic.cn cnnic.net.cn idnic.net irinn.in
  peeringdb.com bgp.he.net bgp.tools bgpview.io ipinfo.io ipip.net
  ipgeolocation.io bigdatacloud.com radar.qrator.net radar.cloudflare.com
  caida.org db-ip.com ipverse.net
].freeze

org_names_path = File.join(ROOT, "data", "overrides", "org_names.txt")
org_names = Set.new
if File.exist?(org_names_path)
  File.foreach(org_names_path, encoding: "UTF-8").with_index(1) do |line, lineno|
    stripped = line.strip
    next if stripped.empty? || stripped.start_with?("#")

    unless (m = stripped.match(/\AAS(\d+)\s+(.+?)\s+#\s*(.+)\z/))
      fail_check("org_names.txt:#{lineno}: expected `AS<number>  <name>  # src: <url> (<date>)`, got: #{stripped[0, 80].inspect}")
      next
    end
    asn, name, comment = m[1].to_i, m[2], m[3]
    fail_check("org_names.txt:#{lineno}: AS#{asn} name longer than 200 chars") if name.length > 200
    url = comment[%r{https?://\S+}]
    if url.nil?
      fail_check("org_names.txt:#{lineno}: AS#{asn} has no source URL")
    else
      host = (URI.parse(url).host.to_s.downcase rescue "")
      if ORG_NAME_RESTRICTED_HOSTS.any? { |h| host == h || host.end_with?(".#{h}") }
        fail_check("org_names.txt:#{lineno}: AS#{asn} cites #{host}, a registry/aggregator host; cite a first-party or CC0 page (D-SRC-2)")
      end
    end
    fail_check("org_names.txt:#{lineno}: duplicate AS#{asn}") if org_names.include?(asn)
    org_names << asn
  end
end

# --- asn_country.txt -------------------------------------------------------------
# Mirrors Overrides#parse_countries in the pipeline (same host list as
# org_names.txt above; same non-country codes as Overrides::NOT_COUNTRIES).

NOT_COUNTRY_CODES = %w[XX ZZ EU AP AA QM QN QO QP QQ QR QS QT QU QV QW QX QY QZ].freeze
countries_path = File.join(ROOT, "data", "overrides", "asn_country.txt")
countries = Set.new
if File.exist?(countries_path)
  File.foreach(countries_path, encoding: "UTF-8").with_index(1) do |line, lineno|
    stripped = line.strip
    next if stripped.empty? || stripped.start_with?("#")

    unless (m = stripped.match(/\AAS(\d+)\s+(\S+)\s+#\s*(.+)\z/))
      fail_check("asn_country.txt:#{lineno}: expected `AS<number>  <CC>  # src: <url> (<date>)`, got: #{stripped[0, 80].inspect}")
      next
    end
    asn, cc, comment = m[1].to_i, m[2], m[3]
    unless cc.match?(/\A[A-Z]{2}\z/) && !NOT_COUNTRY_CODES.include?(cc)
      fail_check("asn_country.txt:#{lineno}: AS#{asn} #{cc.inspect} is not an ISO 3166-1 alpha-2 country code")
    end
    url = comment[%r{https?://\S+}]
    if url.nil?
      fail_check("asn_country.txt:#{lineno}: AS#{asn} has no source URL")
    else
      host = (URI.parse(url).host.to_s.downcase rescue "")
      if ORG_NAME_RESTRICTED_HOSTS.any? { |h| host == h || host.end_with?(".#{h}") }
        fail_check("asn_country.txt:#{lineno}: AS#{asn} cites #{host}, a registry/aggregator host; cite a first-party or CC0 page (D-SRC-2, country)")
      end
    end
    fail_check("asn_country.txt:#{lineno}: duplicate AS#{asn}") if countries.include?(asn)
    countries << asn
  end
end

# --- corrections.yml ----------------------------------------------------------

VALID_CATEGORIES = %w[isp hosting business education_research government_admin none].freeze
VALID_ROLES = %w[tier1_transit major_transit midsize_transit access_provider content_network stub none].freeze

corrections_path = File.join(ROOT, "data", "overrides", "corrections.yml")
if File.exist?(corrections_path)
  begin
    (YAML.safe_load_file(corrections_path, permitted_classes: [Date]) || {}).each do |asn, fields|
      fail_check("corrections.yml: key #{asn.inspect} is not an integer ASN") unless asn.is_a?(Integer)
      %w[reason source_url date].each do |req|
        fail_check("corrections.yml: AS#{asn} missing `#{req}`") if fields[req].to_s.empty?
      end
      if fields["category"] && !VALID_CATEGORIES.include?(fields["category"])
        fail_check("corrections.yml: AS#{asn} invalid category #{fields['category'].inspect}")
      end
      if fields["network_role"] && !VALID_ROLES.include?(fields["network_role"])
        fail_check("corrections.yml: AS#{asn} invalid network_role #{fields['network_role'].inspect}")
      end
    end
  rescue StandardError => e
    fail_check("corrections.yml: #{e.message}")
  end
end

# --- fetch-manifest.json --------------------------------------------------------

begin
  manifest = JSON.parse(File.read(File.join(ROOT, "fetch-manifest.json")))
  (manifest["sources"] || []).each do |s|
    %w[id parser maps_to].each do |req|
      fail_check("fetch-manifest.json: source #{s['id'].inspect} missing `#{req}`") if s[req].to_s.empty?
    end
    fail_check("fetch-manifest.json: source #{s['id']} needs a url or resolver") if s["url"].to_s.empty? && s["resolver"].to_s.empty?
  end
rescue StandardError => e
  fail_check("fetch-manifest.json: #{e.message}")
end

# --- spotchecks.yml ---------------------------------------------------------------

VERDICTS = %w[residential_isp mobile business hosting vpn tor_exit relay
              enterprise_gateway education government cgnat private unknown].freeze
begin
  (YAML.safe_load_file(File.join(ROOT, "spotchecks.yml"))["checks"] || []).each_with_index do |row, i|
    begin
      IPAddr.new(row["ip"].to_s)
    rescue IPAddr::Error
      fail_check("spotchecks.yml row #{i + 1}: bad ip #{row['ip'].inspect}")
    end
    fail_check("spotchecks.yml row #{i + 1} (#{row['ip']}): invalid verdict #{row['expect'].inspect}") unless VERDICTS.include?(row["expect"])
  end
rescue StandardError => e
  fail_check("spotchecks.yml: #{e.message}")
end

# --- verdict --------------------------------------------------------------------

if FAILURES.empty?
  total = sets.values.sum(&:size)
  puts "lint OK: #{total} override entries across #{FLAG_FILES.size} lists, #{org_names.size} org names, #{countries.size} countries, corrections/fetch-manifest/spotchecks all valid"
else
  puts "LINT FAILED:"
  FAILURES.each { |f| puts "  - #{f}" }
  exit 1
end
