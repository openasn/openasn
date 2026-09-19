#!/usr/bin/env ruby
# frozen_string_literal: true

# Standalone lint for the portable-export contract: the check that runs on
# every PR alongside scripts/lint_overrides.rb (see .github/workflows/lint.yml).
# Stdlib only, zero setup, no pipeline checkout.
#
# What it protects: EXPORT_FORMATS.md, export-contract.json, and the tracked
# fixtures under conformance/exports/v1/ are one contract split across five
# files, and third parties implement against them. Two of those files restate
# the same facts by necessity (the spec embeds the DDL so an implementer can
# read it in place; the spec and the fixtures both carry the special-range
# table), so this lint's main job is to prove the copies still agree. A silent
# divergence here is worse than a missing file: every implementation that
# vendored the other copy is now wrong and nothing says so.
#
# Rules enforced:
#   * export-contract.json: exact key set, known modes, identities equal to
#     the v1 contract, asset lists nested none < portable < all, and one
#     format descriptor per asset.
#   * conformance fixtures parse, have unique ids, and use only the frozen
#     core-v1 verdict/source vocabulary.
#   * projection-fixture.json's own arithmetic: ordered, disjoint, coverage
#     and overlay-only counts equal to its declared totals, misses uncovered.
#   * lookup-policy-fixtures.json covers every special range's first and last
#     address, and agrees with the table printed in EXPORT_FORMATS.md.
#   * EXPORT_FORMATS.md embeds exactly one SQL block and it is byte-identical
#     to conformance/exports/v1/sqlite-v1.sql; the CSV header line is present
#     verbatim; nothing links into the gitignored docs/ directory.

require "json"

ROOT = File.expand_path("..", __dir__)
CONFORMANCE = File.join(ROOT, "conformance", "exports", "v1")
SPEC_PATH = File.join(ROOT, "EXPORT_FORMATS.md")
FAILURES = []

def fail_check(msg) = FAILURES << msg

def load_json(path, label)
  JSON.parse(File.read(path))
rescue Errno::ENOENT
  fail_check("#{label}: missing (expected at #{path.delete_prefix("#{ROOT}/")})")
  nil
rescue JSON::ParserError => e
  fail_check("#{label}: does not parse. #{e.message}")
  nil
end

# The frozen core-v1 vocabulary (EXPORT_FORMATS.md section 3). These literals
# are the point of this file: if a fixture grows a verdict, the profile has
# changed and that needs a new profile name, not a passing lint.
VERDICTS = %w[residential_isp mobile business hosting vpn
              enterprise_gateway education government unknown].freeze
SOURCES = %w[x4b_vpn asn_vpn_provider asn_enterprise_gw x4b_dc
             asn_bad_asn asn_hosting_extra asn_cdn asn_category
             asn_mobile_carrier isp_transit_ambiguous asn_no_category unrouted].freeze
POLICY_VERDICTS = %w[private cgnat].freeze
CSV_HEADER = "ip_version,start_ip,end_ip,asn,as_org,category,network_role,bad_asn," \
             "vpn_provider,mobile_carrier,enterprise_gw,cdn,hosting_extra," \
             "vpn_range,datacenter_range,core_verdict,core_sources"
MODES = %w[none portable all].freeze
IDENTITIES = { "schema_version" => 1, "schema_revision" => 0,
               "classification_profile" => "core-v1", "lookup_policy_version" => 1 }.freeze

def check_vocabulary(label, verdict, sources, allowed_verdicts: VERDICTS, allowed_sources: SOURCES)
  fail_check("#{label}: verdict #{verdict.inspect} is not in the frozen vocabulary") unless allowed_verdicts.include?(verdict)
  unless sources.is_a?(Array) && !sources.empty? && sources.all?(String)
    fail_check("#{label}: sources must be a non-empty array of strings, got #{sources.inspect}")
    return
  end
  (sources - allowed_sources).each { |s| fail_check("#{label}: source #{s.inspect} is not in the frozen vocabulary") }
end

# --- export-contract.json ----------------------------------------------------

contract = load_json(File.join(ROOT, "export-contract.json"), "export-contract.json")
if contract
  required = %w[config_version required_mode modes mode_order schema_version schema_revision
                classification_profile lookup_policy_version assets asset_formats].freeze
  keys = contract.keys.reject { |k| k.start_with?("_comment") }
  (required - keys).each { |k| fail_check("export-contract.json: missing key `#{k}`") }
  (keys - required).each { |k| fail_check("export-contract.json: unknown key `#{k}`. This file is validated strictly") }

  fail_check("export-contract.json: config_version must be 1") unless contract["config_version"] == 1
  IDENTITIES.each do |k, v|
    fail_check("export-contract.json: #{k} must be #{v.inspect} for the v1 contract, got #{contract[k].inspect}") unless contract[k] == v
  end
  fail_check("export-contract.json: modes must be #{MODES.inspect}") unless contract["modes"] == MODES
  fail_check("export-contract.json: mode_order must be #{MODES.inspect} (none < portable < all)") unless contract["mode_order"] == MODES
  unless MODES.include?(contract["required_mode"])
    fail_check("export-contract.json: required_mode #{contract['required_mode'].inspect} is not one of #{MODES.inspect}")
  end

  assets = contract["assets"]
  formats = contract["asset_formats"]
  if assets.is_a?(Hash) && formats.is_a?(Hash)
    fail_check("export-contract.json: assets must list exactly the modes #{MODES.inspect}") unless assets.keys.sort == MODES.sort
    fail_check("export-contract.json: mode `none` must declare no assets") unless assets["none"] == []
    MODES.each do |mode|
      names = assets[mode]
      next fail_check("export-contract.json: assets.#{mode} must be an array") unless names.is_a?(Array)

      fail_check("export-contract.json: assets.#{mode} has duplicate names") if names.uniq.size != names.size
      (names - formats.keys).each { |n| fail_check("export-contract.json: assets.#{mode} names #{n.inspect} with no asset_formats entry") }
    end
    # Modes are cumulative: activating a higher mode may only ADD mandatory
    # assets. A name that vanished between modes would make a "higher" mode
    # publish less than a lower one.
    MODES.each_cons(2) do |lower, higher|
      missing = Array(assets[lower]) - Array(assets[higher])
      fail_check("export-contract.json: mode `#{higher}` drops #{missing.inspect} that `#{lower}` requires. Modes must be cumulative") unless missing.empty?
    end
    (formats.keys - Array(assets["all"])).each { |n| fail_check("export-contract.json: asset_formats describes #{n.inspect}, which no mode requires") }

    formats.each do |name, desc|
      next fail_check("export-contract.json: asset_formats.#{name} must be an object") unless desc.is_a?(Hash)

      %w[format media_type content_encoding uncompressed_name].each do |k|
        fail_check("export-contract.json: asset_formats.#{name} missing `#{k}`") unless desc.key?(k)
      end
      gzipped = name.end_with?(".gz")
      expected_encoding = gzipped ? "gzip" : "identity"
      unless desc["content_encoding"] == expected_encoding
        fail_check("export-contract.json: asset_formats.#{name} content_encoding must be #{expected_encoding.inspect}")
      end
      if gzipped
        fail_check("export-contract.json: asset_formats.#{name} needs uncompressed_name #{name.delete_suffix('.gz').inspect}") unless desc["uncompressed_name"] == name.delete_suffix(".gz")
      elsif !desc["uncompressed_name"].nil?
        fail_check("export-contract.json: asset_formats.#{name} is uncompressed and must carry uncompressed_name null")
      end
    end
  else
    fail_check("export-contract.json: assets and asset_formats must both be objects")
  end
end

# --- conformance/exports/v1/profile-fixtures.json ----------------------------

profile = load_json(File.join(CONFORMANCE, "profile-fixtures.json"), "profile-fixtures.json")
if profile
  cases = profile["cases"]
  if cases.is_a?(Array) && !cases.empty?
    ids = cases.map { |c| c["id"] }
    ids.tally.each { |id, n| fail_check("profile-fixtures.json: duplicate case id #{id.inspect} (#{n}x)") if n > 1 }
    cases.each do |c|
      fail_check("profile-fixtures.json: a case has no id") if c["id"].to_s.empty?
      check_vocabulary("profile-fixtures.json case #{c['id']}", c["verdict"], c["sources"])
    end
  else
    fail_check("profile-fixtures.json: `cases` must be a non-empty array")
  end
  fail_check("profile-fixtures.json: `invalid_inputs` must be a non-empty array") unless profile["invalid_inputs"].is_a?(Array) && !profile["invalid_inputs"].empty?
end

# --- conformance/exports/v1/projection-fixture.json --------------------------

projection = load_json(File.join(CONFORMANCE, "projection-fixture.json"), "projection-fixture.json")
if projection
  rows = projection["expected"]
  if rows.is_a?(Array) && !rows.empty?
    rows.each { |r| check_vocabulary("projection-fixture.json row #{r['start']}", r["core_verdict"], r["core_sources"]) }

    rows.each_cons(2) do |a, b|
      fail_check("projection-fixture.json: rows #{a['start']} and #{b['start']} are unordered or overlapping") unless a["end"] < b["start"]
    end
    rows.each { |r| fail_check("projection-fixture.json: row #{r['start']} has end < start") if r["end"] < r["start"] }

    covered = rows.sum { |r| r["end"] - r["start"] + 1 }
    overlay_only = rows.select { |r| r["asn"].nil? }.sum { |r| r["end"] - r["start"] + 1 }
    fail_check("projection-fixture.json: #{rows.size} rows but expected_effective_rows says #{projection['expected_effective_rows']}") unless rows.size == projection["expected_effective_rows"]
    fail_check("projection-fixture.json: rows cover #{covered} addresses but expected_covered_addresses says #{projection['expected_covered_addresses']}") unless covered == projection["expected_covered_addresses"]
    fail_check("projection-fixture.json: overlay-only rows cover #{overlay_only} addresses but expected_overlay_only_addresses says #{projection['expected_overlay_only_addresses']}") unless overlay_only == projection["expected_overlay_only_addresses"]

    # A null ASN means "covered by an overlay only", so every ASN field must
    # be null or an integer, and every overlay-only row must carry a flag.
    rows.each do |r|
      next unless r["asn"].nil?

      fail_check("projection-fixture.json: overlay-only row #{r['start']} carries no range flag") unless r["vpn_range"] || r["datacenter_range"]
    end

    Array(projection["miss_offsets"]).each do |off|
      hit = rows.find { |r| off >= r["start"] && off <= r["end"] }
      fail_check("projection-fixture.json: miss offset #{off} is covered by row #{hit['start']}..#{hit['end']}") if hit
    end
  else
    fail_check("projection-fixture.json: `expected` must be a non-empty array")
  end
end

# --- conformance/exports/v1/lookup-policy-fixtures.json ----------------------

policy = load_json(File.join(CONFORMANCE, "lookup-policy-fixtures.json"), "lookup-policy-fixtures.json")
policy_ranges = nil
if policy
  fail_check("lookup-policy-fixtures.json: lookup_policy_version must be 1") unless policy["lookup_policy_version"] == 1
  miss = policy["miss_result"]
  unless miss.is_a?(Hash) && miss["lookup_status"] == "unrouted" && miss["verdict"] == "unknown" && miss["sources"] == ["unrouted"]
    fail_check("lookup-policy-fixtures.json: miss_result must be unrouted/unknown/[\"unrouted\"]")
  end

  policy_ranges = policy["special_ranges"]
  cases = policy["cases"]
  if policy_ranges.is_a?(Array) && cases.is_a?(Array) && !cases.empty?
    ids = cases.map { |c| c["id"] } + Array(policy["invalid_inputs"]).map { |c| c["id"] }
    ids.tally.each { |id, n| fail_check("lookup-policy-fixtures.json: duplicate id #{id.inspect} (#{n}x)") if n > 1 }

    cases.each do |c|
      label = "lookup-policy-fixtures.json case #{c['id']}"
      fail_check("#{label}: valid must be true (invalid literals belong in invalid_inputs)") unless c["valid"] == true
      fail_check("#{label}: family must be 4 or 6") unless [4, 6].include?(c["family"])
      fail_check("#{label}: normalized must be a non-empty string") if c["normalized"].to_s.empty?

      case c["policy"]
      when "special"
        fail_check("#{label}: a special case must have lookup_status \"special\"") unless c["lookup_status"] == "special"
        fail_check("#{label}: a special case is never data_dependent") unless c["data_dependent"] == false
        check_vocabulary(label, c["verdict"], c["sources"],
                         allowed_verdicts: POLICY_VERDICTS,
                         allowed_sources: Array(policy_ranges).map { |r| r["source"] }.uniq)
        fail_check("#{label}: a special case has exactly one source") unless Array(c["sources"]).size == 1
      when "query"
        if c["data_dependent"] == true
          unless c["lookup_status"].nil? && c["verdict"].nil? && c["sources"].nil?
            fail_check("#{label}: a data-dependent case must leave lookup_status/verdict/sources null")
          end
        elsif c["data_dependent"] == false
          unless c["lookup_status"] == miss["lookup_status"] && c["verdict"] == miss["verdict"] && c["sources"] == miss["sources"]
            fail_check("#{label}: a query case that is not data-dependent must state the miss_result")
          end
        else
          fail_check("#{label}: data_dependent must be true or false")
        end
      else
        fail_check("#{label}: policy must be \"special\" or \"query\", got #{c['policy'].inspect}")
      end
    end

    # Every special range must have its first and last address asserted, in
    # both cases with the range's own verdict and source. This is the check
    # that the "first, last, before and after" coverage requirement survived.
    policy_ranges.each do |r|
      %w[first last].each do |edge|
        hit = cases.find { |c| c["input"] == r[edge] && c["policy"] == "special" }
        if hit.nil?
          fail_check("lookup-policy-fixtures.json: no special case for the #{edge} address #{r[edge].inspect} of #{r['cidr']}")
        elsif hit["verdict"] != r["verdict"] || hit["sources"] != [r["source"]]
          fail_check("lookup-policy-fixtures.json: case #{hit['id']} disagrees with the #{r['cidr']} row (#{r['verdict']}/#{r['source']})")
        end
      end
    end
  else
    fail_check("lookup-policy-fixtures.json: `special_ranges` and `cases` must both be non-empty arrays")
  end

  invalid = policy["invalid_inputs"]
  if invalid.is_a?(Array) && !invalid.empty?
    invalid.each do |c|
      fail_check("lookup-policy-fixtures.json invalid input #{c['id'].inspect}: valid must be false") unless c["valid"] == false
      fail_check("lookup-policy-fixtures.json invalid input #{c['id'].inspect}: needs a `reason`") if c["reason"].to_s.empty?
      fail_check("lookup-policy-fixtures.json: an invalid input has no id") if c["id"].to_s.empty?
    end
  else
    fail_check("lookup-policy-fixtures.json: `invalid_inputs` must be a non-empty array")
  end
end

# --- EXPORT_FORMATS.md -------------------------------------------------------

spec = begin
  File.read(SPEC_PATH)
rescue Errno::ENOENT
  fail_check("EXPORT_FORMATS.md: missing")
  nil
end

vendored_ddl = begin
  File.read(File.join(CONFORMANCE, "sqlite-v1.sql"))
rescue Errno::ENOENT
  fail_check("conformance/exports/v1/sqlite-v1.sql: missing")
  nil
end

if spec
  schema_blocks = spec.scan(/^```sql\n(.*?)^```$/m).flatten.select { |b| b.include?("CREATE TABLE v4") }
  if schema_blocks.size != 1
    fail_check("EXPORT_FORMATS.md: expected exactly one ```sql block defining the schema, found #{schema_blocks.size}")
  elsif vendored_ddl && schema_blocks.first != vendored_ddl
    fail_check("EXPORT_FORMATS.md: the embedded SQL block differs from conformance/exports/v1/sqlite-v1.sql. " \
               "there is one schema, and the two copies must be byte-identical")
  end

  fail_check("EXPORT_FORMATS.md: the exact v1 CSV header line is missing") unless spec.include?(CSV_HEADER)

  IDENTITIES.each do |k, v|
    fail_check("EXPORT_FORMATS.md: does not mention #{k}") unless spec.include?(k)
    fail_check("EXPORT_FORMATS.md: does not state #{k} = #{v}") unless spec.match?(/#{Regexp.escape(k)}\D{0,40}#{Regexp.escape(v.to_s)}/)
  end

  # docs/ is gitignored and private. A tracked file that links into it sends
  # every external reader to a 404.
  spec.scan(%r{\]\(([^)]*\bdocs/[^)]*)\)}).flatten.each do |target|
    fail_check("EXPORT_FORMATS.md: links to #{target.inspect}, which is inside the gitignored docs/ directory")
  end

  # The special-range table is printed in the spec and encoded in the fixture.
  # Neither is allowed to drift from the other.
  if policy_ranges.is_a?(Array)
    table = spec.scan(/^\| (IPv4|IPv6) \| `([^`]+)` \| `([^`]+)` \| `([^`]+)` \|$/)
    table_rows = table.map { |fam, cidr, verdict, source| { "family" => fam == "IPv4" ? 4 : 6, "cidr" => cidr, "verdict" => verdict, "source" => source } }
    fixture_rows = policy_ranges.map { |r| r.slice("family", "cidr", "verdict", "source") }
    if table_rows != fixture_rows
      fail_check("EXPORT_FORMATS.md: the special-range table does not match lookup-policy-fixtures.json " \
                 "(spec has #{table_rows.size} rows, fixture has #{fixture_rows.size}; first difference: " \
                 "#{(table_rows - fixture_rows).first.inspect} vs #{(fixture_rows - table_rows).first.inspect})")
    end
  end
end

# --- verdict -----------------------------------------------------------------

if FAILURES.empty?
  mode = contract ? contract["required_mode"] : "?"
  puts "export contract OK: schema 1.0 / core-v1 / policy 1, required_mode=#{mode}, " \
       "#{Array(profile && profile['cases']).size} profile cases, " \
       "#{Array(projection && projection['expected']).size} projection rows, " \
       "#{Array(policy && policy['cases']).size} policy cases + #{Array(policy && policy['invalid_inputs']).size} invalid inputs, " \
       "DDL matches the vendored schema"
else
  puts "EXPORT CONTRACT LINT FAILED:"
  FAILURES.each { |f| puts "  - #{f}" }
  exit 1
end
