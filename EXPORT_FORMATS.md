# OpenASN portable exports: contract v1

This is the normative contract for three portable representations of the
OpenASN Tier A core:

- `openasn.sqlite.gz`, expanding to `openasn.sqlite`
- `openasn.csv.gz`, expanding to `openasn.csv`
- `openasn.mmdb`, uncompressed

It is written for third-party implementers. Everything needed to write a
reader, a validator, or an updater is in this file: schema, field meanings,
classification rules, input policy, manifest shape, and the update protocol.
No OpenASN client source is required to consume these assets.

The native byte artifacts (`openasn-ipv4.bin`, `openasn-ipv6.bin`,
`openasn-orgs.bin`) are specified in [FORMAT.md](FORMAT.md) and are not
changed by this document. The exports are a projection of the same build:
same inputs, same build id, no new source, no Tier B data, no enrichment.
They exist so a consumer with SQL, a CSV importer, or a generic MMDB reader
can use the core without decoding OpenASN bit offsets.

**Status.** This contract is published ahead of the assets.
[`export-contract.json`](export-contract.json) carries `required_mode`, the
export mode every successful release must satisfy. While it reads `none`, a
release contains the native artifacts only and no portable export is expected
in any release, published or dated. Activation is a reviewed change to that
file, coordinated with the producer's toolchain. Do not infer availability
from this document; read the manifest of the release you are downloading.

The rationale for materializing classification into data at all is recorded in
[DECISIONS.md](DECISIONS.md) as D-FMT-1.

## 1. Version identities

Four independent identities govern an export. All four are carried in the
asset itself and in the release manifest entry, and all four must be checked
before an asset is installed.

| Identity | v1 value | What it gates |
|---|---|---|
| `schema_version` | `1` | The breaking major: table/column/key structure of an asset. A v1 reader supports exactly `1`. |
| `schema_revision` | `0` | Compatible additions within a major. |
| `classification_profile` | `core-v1` | The verdict vocabulary and the precedence that produced `core_verdict`/`core_sources`. |
| `lookup_policy_version` | `1` | How an input string becomes an address, and which ranges answer without touching the database. |

Compatibility rules:

- **Unknown major, profile, or policy: refuse installation.** Keep the
  generation currently installed and emit an actionable error naming the
  identity and the value seen. A half-understood dataset is worse than a
  failed update, because a failed update keeps last-good data.
- **A compatible revision may add** fields, metadata keys, or CSV columns. It
  may not remove or reorder the v1 CSV columns, change an existing type or
  nullability, or change a meaning. New CSV columns append after the v1
  header. Locate columns by name and ignore unknown appended fields.
- **Unknown revision, extra fields: accept**, provided every mandatory field
  of the declared major validates.
- **`core-v1` has a fixed rule set and a fixed vocabulary.** Adding a verdict,
  adding a source token, or changing precedence requires a new profile name.
  An implementation bug is corrected to restore the profile defined here, and
  the fix is documented; the profile does not move to match the bug.
- **Names stay on v1.** The asset names above belong to schema 1, profile
  core-v1, policy 1. An incompatible successor ships alongside under new names
  (`openasn-v2.sqlite.gz` and so on) and coexists during migration; it never
  silently replaces these filenames.
- **The release-level `format_version` is the OASN byte-format version**
  (currently `1`, see [FORMAT.md](FORMAT.md)). It is not a bundle-wide export
  version and must not be read as one.
- Data cadence never appears in a client library version. Exports are
  republished by the build, not by a package release.

## 2. The logical record

Every export carries the same logical record stream. One record is a
**maximal inclusive interval over which the entire payload is constant**.
Intervals within a family are strictly ordered by `start` and are disjoint.
Their union is exactly the union of the build's base, VPN-overlay, and
datacenter-overlay coverage: a range present in any of the three layers is
present here, and nothing else is.

Gaps are omitted. There is no record covering unrouted space; a miss is a
miss, and the reader turns it into `unknown`/`unrouted` (section 7).

| Field | Domain | Meaning and rules |
|---|---|---|
| `ip_version` | integer `4` or `6` | Address family. An integer, never the string `"4"`. |
| `start`, `end` | unsigned integer address | Inclusive bounds, `start <= end`, within the family's bound. Internal integers, never JSON floating point; a 128-bit endpoint is never a JSON number. |
| `asn` | null, or integer 0…4294967295 | The announcing AS. **Null means there is no base row here**: the interval is covered only by an overlay. Detect presence by null check, never by truthiness, because `0` is a legal value. An input AS0 is preserved as `0`; AS0 is never manufactured to stand for absence. |
| `as_org` | null, or non-empty UTF-8 | The organization name for `asn` from the same build, at most 96 bytes. Reproduced exactly: no trimming, case folding, or normalization. |
| `category` | null, or `isp`, `hosting`, `business`, `education_research`, `government_admin` | The upstream ASN category compiled into the build. Describes the ASN, not the address. |
| `network_role` | null, or `tier1_transit`, `major_transit`, `midsize_transit`, `access_provider`, `content_network`, `stub` | The upstream routing role. |
| `bad_asn` | boolean | Membership in the curated hosting/cloud/colo ASN list. |
| `vpn_provider` | boolean | The ASN is a VPN provider's own AS. |
| `mobile_carrier` | boolean | The ASN is a dedicated mobile carrier. |
| `enterprise_gw` | boolean | The ASN is SWG/SASE vendor egress (Zscaler, iboss and similar). Not a company's own AS. |
| `cdn` | boolean | The ASN is a CDN. |
| `hosting_extra` | boolean | Extra hosting coverage curated by OpenASN. |
| `vpn_range` | boolean | The VPN range overlay covers **the whole interval**. |
| `datacenter_range` | boolean | The datacenter range overlay covers **the whole interval**. |
| `core_verdict` | non-empty, from the fixed vocabulary | The core-v1 result for this interval (section 3). |
| `core_sources` | ordered, non-empty array of strings | Which core-v1 rules produced that verdict, in the fixed order of section 3. |

Consistency rules that every valid record satisfies:

- When `asn` is null, `as_org`, `category`, and `network_role` are null and
  all six ASN flags are false. The two range flags may be true; that is the
  only reason such a record exists.
- An interval with no base row and neither range flag is **not** exported. A
  no-evidence record is not a record.
- A base row whose flags decode to a null category and a null role is still a
  real row. It yields `unknown` with `["asn_no_category"]`, which is not the
  same statement as `["unrouted"]`.
- `vpn_range` and `datacenter_range` are independent signals, not a hierarchy.
  Both may be true on the same interval.

Four things this record does not say, spelled out because each has been
misread before:

- **`bad_asn` is list membership, not an abuse claim.** It means the ASN
  appears in `brianhama/bad-asn-list`, a curated list of hosting, cloud, and
  colocation ASNs. Large legitimate clouds carry it. It does not mean the
  network is malicious, unsafe, or block-worthy, and nothing in this contract
  authorises presenting it that way.
- **`hosting_extra` is one corroborating signal, not the hosting verdict.**
  The hosting verdict is `core_verdict == "hosting"`, which four independent
  rules can produce. Reading `hosting_extra` as "is hosting" both over- and
  under-counts.
- **`vpn_provider` is the ASN flag only.** The `vpn_range` overlay is
  independent evidence and outranks it, so a record can carry
  `core_verdict == "vpn"` with `vpn_provider` false. Neither field alone is
  the VPN answer; `core_verdict` is.
- **`as_org` is the announcing ASN's organization.** It is not necessarily
  the retail brand a subscriber pays, the corporate parent, the physical
  location of the address, or the VPN brand reselling the capacity.

v1 carries no country, provider, parent, reputation, connection-quality, or
crawler attribute. The all-ASN catalog, including ASNs with no observed
routes, remains a separate asset (`asn-categories.csv`) with its own columns.

## 3. Classification profile core-v1

core-v1 operates on already-compiled evidence for **an ordinary address**. It
never receives an IP, so it cannot and does not perform special-address
handling; that is lookup policy 1 (section 7), applied before the database is
consulted. The separation is deliberate: the stored verdict stays valid
whatever a caller passes in.

First matching row wins.

| Order | Predicate | `core_verdict` | `core_sources` |
|---:|---|---|---|
| 1 | `vpn_range` | `vpn` | `["x4b_vpn"]` |
| 2 | `vpn_provider` | `vpn` | `["asn_vpn_provider"]` |
| 3 | `enterprise_gw` | `enterprise_gateway` | `["asn_enterprise_gw"]` |
| 4 | `datacenter_range` | `hosting` | `["x4b_dc"]` |
| 5 | `bad_asn OR hosting_extra OR cdn OR category == hosting` | `hosting` | every true hosting reason, in the order below |
| 6 | `mobile_carrier` | `mobile` | `["asn_mobile_carrier"]` |
| 7 | `category == isp AND network_role != tier1_transit` | `residential_isp` | `["asn_category"]` |
| 8 | `category == business` | `business` | `["asn_category"]` |
| 9 | `category == education_research` | `education` | `["asn_category"]` |
| 10 | `category == government_admin` | `government` | `["asn_category"]` |
| 11 | `category == isp` | `unknown` | `["isp_transit_ambiguous"]` |
| 12 | `asn` is not null | `unknown` | `["asn_no_category"]` |
| 13 | otherwise | `unknown` | `["unrouted"]` |

Row 5 is the only rule that emits more than one source. Include every true
reason, in exactly this order:

```text
bad_asn              -> asn_bad_asn
hosting_extra        -> asn_hosting_extra
cdn                  -> asn_cdn
category == hosting  -> asn_category
```

Reasons are never collected after another rule has won. A datacenter-overlay
hit carries `["x4b_dc"]` alone even when the ASN category also says hosting,
because the overlay is the more specific evidence and the explanation should
name what actually decided. VPN and datacenter flags may both be true; VPN
wins and is the only source. Enterprise gateway beats datacenter and hosting;
hosting beats mobile.

Row 7 versus row 11 is the one place where a role changes the answer: an ISP
with any role other than `tier1_transit`, including a null role, is
`residential_isp`. Only pure tier-1 backbone space stays ambiguous. The
measurement behind that split is in [DECISIONS.md](DECISIONS.md) (D-IMPL-1).

**Verdict vocabulary, exactly nine values:**

```text
residential_isp  mobile  business  hosting  vpn
enterprise_gateway  education  government  unknown
```

`private` and `cgnat` are lookup-policy results (section 7); they never appear
in a stored record. `relay` and `tor_exit` cannot arise from Tier A evidence
at all: the sources that produce them are Tier B, fetched by clients at
runtime, and are not in these assets. A `core_verdict` therefore has no Tier B
attribution, and an export consumer that needs relay or Tor detection still
needs the Tier B recipe in `fetch-manifest.json`.

**Source vocabulary, exactly twelve tokens:**

```text
x4b_vpn  asn_vpn_provider  asn_enterprise_gw  x4b_dc
asn_bad_asn  asn_hosting_extra  asn_cdn  asn_category
asn_mobile_carrier  isp_transit_ambiguous  asn_no_category  unrouted
```

None of them contains `|`, which is what makes the CSV encoding in section 5
unambiguous. Lookup policy adds `special_*` tokens, which a stored record
never carries.

## 4. SQLite v1

`openasn.sqlite.gz` decompresses to `openasn.sqlite`: two range tables and a
metadata table. It requires neither the JSON1 extension nor STRICT-table
support, so it opens on old SQLite builds and on PHP's bundled `pdo_sqlite`.

### 4.1 Schema

This DDL is the single source of truth. It is vendored verbatim at
[`conformance/exports/v1/sqlite-v1.sql`](conformance/exports/v1/sqlite-v1.sql),
and CI fails if the two copies diverge.

```sql
-- Normative SQLite schema: export v1 / core-v1 / lookup policy 1.
-- EXPORT_FORMATS.md is the authority for semantic and cross-row validation.
-- No JSON1 or STRICT-table dependency. core_sources is canonical JSON text.
PRAGMA page_size = 4096;
PRAGMA journal_mode = DELETE;
PRAGMA user_version = 1;

CREATE TABLE v4 (
  start INTEGER PRIMARY KEY CHECK(typeof(start) = 'integer' AND start BETWEEN 0 AND 4294967295),
  end INTEGER NOT NULL CHECK(typeof(end) = 'integer' AND end BETWEEN start AND 4294967295),
  asn INTEGER CHECK(asn IS NULL OR (typeof(asn) = 'integer' AND asn BETWEEN 0 AND 4294967295)),
  as_org TEXT CHECK(as_org IS NULL OR (typeof(as_org) = 'text' AND length(CAST(as_org AS BLOB)) BETWEEN 1 AND 96)),
  category TEXT CHECK(category IS NULL OR category IN ('isp','hosting','business','education_research','government_admin')),
  network_role TEXT CHECK(network_role IS NULL OR network_role IN ('tier1_transit','major_transit','midsize_transit','access_provider','content_network','stub')),
  bad_asn INTEGER NOT NULL CHECK(typeof(bad_asn) = 'integer' AND bad_asn IN (0,1)),
  vpn_provider INTEGER NOT NULL CHECK(typeof(vpn_provider) = 'integer' AND vpn_provider IN (0,1)),
  mobile_carrier INTEGER NOT NULL CHECK(typeof(mobile_carrier) = 'integer' AND mobile_carrier IN (0,1)),
  enterprise_gw INTEGER NOT NULL CHECK(typeof(enterprise_gw) = 'integer' AND enterprise_gw IN (0,1)),
  cdn INTEGER NOT NULL CHECK(typeof(cdn) = 'integer' AND cdn IN (0,1)),
  hosting_extra INTEGER NOT NULL CHECK(typeof(hosting_extra) = 'integer' AND hosting_extra IN (0,1)),
  vpn_range INTEGER NOT NULL CHECK(typeof(vpn_range) = 'integer' AND vpn_range IN (0,1)),
  datacenter_range INTEGER NOT NULL CHECK(typeof(datacenter_range) = 'integer' AND datacenter_range IN (0,1)),
  core_verdict TEXT NOT NULL CHECK(core_verdict IN ('residential_isp','mobile','business','hosting','vpn','enterprise_gateway','education','government','unknown')),
  core_sources TEXT NOT NULL CHECK(typeof(core_sources) = 'text'),
  CHECK(asn IS NOT NULL OR (
    as_org IS NULL AND category IS NULL AND network_role IS NULL AND
    bad_asn = 0 AND vpn_provider = 0 AND mobile_carrier = 0 AND
    enterprise_gw = 0 AND cdn = 0 AND hosting_extra = 0
  ))
);

CREATE TABLE v6 (
  start BLOB PRIMARY KEY NOT NULL CHECK(typeof(start) = 'blob' AND length(start) = 16),
  end BLOB NOT NULL CHECK(typeof(end) = 'blob' AND length(end) = 16 AND end >= start),
  asn INTEGER CHECK(asn IS NULL OR (typeof(asn) = 'integer' AND asn BETWEEN 0 AND 4294967295)),
  as_org TEXT CHECK(as_org IS NULL OR (typeof(as_org) = 'text' AND length(CAST(as_org AS BLOB)) BETWEEN 1 AND 96)),
  category TEXT CHECK(category IS NULL OR category IN ('isp','hosting','business','education_research','government_admin')),
  network_role TEXT CHECK(network_role IS NULL OR network_role IN ('tier1_transit','major_transit','midsize_transit','access_provider','content_network','stub')),
  bad_asn INTEGER NOT NULL CHECK(typeof(bad_asn) = 'integer' AND bad_asn IN (0,1)),
  vpn_provider INTEGER NOT NULL CHECK(typeof(vpn_provider) = 'integer' AND vpn_provider IN (0,1)),
  mobile_carrier INTEGER NOT NULL CHECK(typeof(mobile_carrier) = 'integer' AND mobile_carrier IN (0,1)),
  enterprise_gw INTEGER NOT NULL CHECK(typeof(enterprise_gw) = 'integer' AND enterprise_gw IN (0,1)),
  cdn INTEGER NOT NULL CHECK(typeof(cdn) = 'integer' AND cdn IN (0,1)),
  hosting_extra INTEGER NOT NULL CHECK(typeof(hosting_extra) = 'integer' AND hosting_extra IN (0,1)),
  vpn_range INTEGER NOT NULL CHECK(typeof(vpn_range) = 'integer' AND vpn_range IN (0,1)),
  datacenter_range INTEGER NOT NULL CHECK(typeof(datacenter_range) = 'integer' AND datacenter_range IN (0,1)),
  core_verdict TEXT NOT NULL CHECK(core_verdict IN ('residential_isp','mobile','business','hosting','vpn','enterprise_gateway','education','government','unknown')),
  core_sources TEXT NOT NULL CHECK(typeof(core_sources) = 'text'),
  CHECK(asn IS NOT NULL OR (
    as_org IS NULL AND category IS NULL AND network_role IS NULL AND
    bad_asn = 0 AND vpn_provider = 0 AND mobile_carrier = 0 AND
    enterprise_gw = 0 AND cdn = 0 AND hosting_extra = 0
  ))
) WITHOUT ROWID;

CREATE TABLE meta (
  k TEXT PRIMARY KEY NOT NULL CHECK(typeof(k) = 'text' AND length(k) > 0),
  v TEXT NOT NULL CHECK(typeof(v) = 'text')
) WITHOUT ROWID;

```

Notes a reader depends on:

- `PRAGMA user_version` is `1` and equals `schema_version`. Check it at open
  time; it is the cheapest possible wrong-file detector.
- IPv4 uses `INTEGER PRIMARY KEY`, so `start` is the rowid and the predecessor
  search below is a b-tree seek.
- IPv6 uses a fixed 16-byte BLOB primary key with `WITHOUT ROWID`. Big-endian
  bytes make bytewise BLOB comparison identical to unsigned numeric
  comparison, which is why no 128-bit integer type is needed. Binding those
  bytes as TEXT silently breaks both the type check and the ordering, so bind
  them explicitly as a blob.
- Booleans are integers constrained to 0/1. There is no other true value.
- `core_sources` is compact JSON text, for example `["asn_cdn","asn_category"]`.
  The DDL constrains it to text and no further; enforcing JSON in the schema
  would require JSON1. Parse it and validate that it is an array of strings
  from the section 3 vocabulary, and fail loudly rather than returning a
  half-parsed result.
- The table-level `CHECK` enforces the null-ASN rule from section 2.
- There are no secondary indexes. Add none without a measured query need: the
  primary keys already serve the only two queries this schema exists for, and
  every index costs bytes in a file that is downloaded weekly.
- DDL constraints are a defence against malformed rows, not a substitute for
  validation. Non-overlap across rows, maximal coalescing, metadata
  completeness, source ordering, and profile consistency are checked by the
  producer's validator and by the updater (section 9), not by SQLite.

### 4.2 The `meta` table

Every value is TEXT. Scalars are unquoted strings; integers are non-negative
base 10 with no leading zeros; boolean scalars are `true` or `false`. The keys
marked JSON hold compact deterministic JSON: UTF-8, no insignificant
whitespace, object keys sorted lexically, array order preserved. Every key
below is mandatory for schema 1 revision 0.

| Key | Value / encoding |
|---|---|
| `schema_version` | `1` |
| `schema_revision` | `0` |
| `classification_profile` | `core-v1` |
| `lookup_policy_version` | `1` |
| `edition` | `core` |
| `scope` | `tier_a` |
| `tier_b_included` | `false` |
| `build_id` | The release's ISO-8601 UTC timestamp string, exactly as the manifest carries it |
| `built_at` | The same timestamp as `build_id` |
| `build_unix_ts` | The OASN build epoch in decimal seconds |
| `records_ipv4` | Coalesced logical IPv4 rows |
| `records_ipv6` | Coalesced logical IPv6 rows |
| `records_total` | The sum of those two |
| `source_format_version` | `1` (the OASN byte format the records were projected from) |
| `input_layer_counts` | JSON object: base/vpn/dc/relay counts for both families |
| `input_artifacts` | JSON array of `{name,sha256,bytes}` for the two OASN files and OORG, sorted by name |
| `data_repo_commit` | Full git commit of the dataset inputs |
| `pipeline_repo_commit` | Full git commit of the compiler |
| `working_tree_dirty` | `true` when a relevant input tree had uncommitted changes, otherwise `false` |
| `exporter_version` | Exporter code release marker, `1.0.0` initially. Not a data date. |
| `producer` | JSON object: the Ruby, Python, SQLite engine, and writer/Go versions actually used, or null where a component was not enabled |
| `sources` | JSON array identical in meaning and order to the manifest's sources, including null fetch timestamps where unknown |
| `license` | `CC0-1.0`, OpenASN's contribution and output contract. Upstream attribution notices are still retained. |
| `attribution` | The exact UTF-8 bytes of the same build's `ATTRIBUTION.md` |

Provenance rules worth stating, because they are what makes this metadata
worth trusting:

- A published build records exact repository revisions. The literal string
  `unknown` is permitted only for a local non-publishing build, where the
  reason is logged; it is rejected for anything published.
- `working_tree_dirty` being `true` is allowed locally and is useful. A
  production publication requires clean relevant tracked inputs.
- The build timestamp is never substituted for an upstream `fetched_at`.
  Inputs can be cached, so a new build id on its own guarantees nothing about
  upstream freshness.
- The metadata contains no hash of the file it lives in and no copy of the
  release manifest. Both would be circular. The manifest is the outer
  envelope and hashes the export, not the other way round.

### 4.3 The required query

A range lookup is a predecessor search followed by a containment check. Both
halves are mandatory:

```sql
SELECT * FROM (
  SELECT * FROM v4 WHERE start <= :ip ORDER BY start DESC LIMIT 1
) AS candidate
WHERE end >= :ip;
```

The same query serves `v6`. Bind the parameter as an integer for `v4` and as a
16-byte blob for `v6`, including in the outer predicate.

Isolating exactly one predecessor before testing containment is what keeps the
work bounded. A two-predicate range scan (`start <= :ip AND end >= :ip`) looks
equivalent and is not: for an address in a gap it can walk backwards through
rows. Never drop the outer `end >= :ip` check either; without it, an address
in a gap returns the previous interval's ASN, which is a wrong answer rather
than a miss. `EXPLAIN QUERY PLAN` must show a primary-key search with no table
scan and no temporary sort.

Production helpers select the columns they need by name, so an additive
revision that appends a column does not break them.

## 5. Range CSV v1

`openasn.csv.gz` decompresses to `openasn.csv`: one file for both families,
intended as import input for a warehouse, a trie build, or a diff between
releases.

Exact header, one line, first line:

```text
ip_version,start_ip,end_ip,asn,as_org,category,network_role,bad_asn,vpn_provider,mobile_carrier,enterprise_gw,cdn,hosting_extra,vpn_range,datacenter_range,core_verdict,core_sources
```

Rules:

- UTF-8 without a BOM. The header is followed directly by records. Each line,
  including the header, is terminated by LF. There is no metadata preamble, no
  comment line, and no repeated header.
- Family order is 4 then 6. Within a family, records ascend numerically by
  `start`. Textual IP strings are never lexically sorted, which would
  interleave `10.` between `1.` and `2.`.
- **IPv4** is dotted decimal with no leading zeros.
- **IPv6** is lowercase RFC 5952 canonical text: leading zeros removed from
  each hextet, the longest run of two or more zero hextets compressed to `::`,
  the leftmost run on a tie, a single zero hextet never compressed, all-zero
  written `::`. Addresses are written as **pure hextets**, never with an
  embedded dotted quad: `::ffff:808:808`, not `::ffff:8.8.8.8`. Several
  standard library formatters emit the dotted form for the mapped prefix, so
  a writer cannot delegate this and a reader should not accept the dotted form
  as canonical.
- Standard double-quote CSV escaping. A field is quoted when it contains a
  comma, a double quote, CR, or LF; embedded quotes are doubled. There is no
  formula escaping: a leading `=`, `+`, `-`, or `@` in an organization name is
  left exactly as it is. This file is data-import input, not a
  spreadsheet-safe product; mutating data to protect a spreadsheet would
  corrupt the field OpenASN promises to reproduce byte for byte.
- A null `asn`, `as_org`, `category`, or `network_role` is an **empty cell**.
  `asn` is a decimal integer when present, including a literal `0` when the
  input really carries AS0.
- Every boolean is `0` or `1`. Never empty, never `True`, never a packed
  bitfield integer.
- `core_sources` is the ordered list joined with a literal `|`, for example
  `asn_bad_asn|asn_cdn`. The frozen tokens contain no `|`. Split that field,
  and only that field; other string fields are free text.
- Organization names are preserved exactly, including commas, quote
  characters, and embedded newlines. **Count records with a CSV parser, never
  by counting physical newlines**, because one record can span several lines.
- No `build_id` column. Repeating the build identity on every row would make
  every row textually different between builds and destroy the file's main
  analytical use, which is diffing two releases. Build identity, schema, and
  provenance live in the release manifest.

Both gzipped exports use compression level 6, mtime 0, and no original
filename or comment header, so identical inputs reproduce identical bytes
within a recorded producer environment. Byte identity across different zlib
implementations is not promised. A compressed asset decompresses to exactly
the advertised raw length and hash, contains exactly one member, and has no
trailing bytes; an installer uses a bounded, stream-safe decompressor and
rejects anything else (section 9).

CSV and SQLite carry the same logical row count and the same evidence for
every row. `asn-categories.csv` is unrelated and unchanged: it is the full ASN
catalog including ASNs with no observed routes, while this file is an
IP-range projection of routed and overlay-covered space.

## 6. MMDB v1

`openasn.mmdb` is published uncompressed, because MMDB readers memory-map the
file and a generic consumer expects to point a reader straight at it.

### 6.1 Database type and writer options

The database type is `OpenASN-Core-v1`. A reader must validate it and refuse
anything else; the file is not a GeoIP2 database and does not decode with
GeoIP2 City or ASN model classes. Use a generic MaxMind DB reader with custom
record decoding.

The writer options are part of the contract:

```go
mmdbwriter.Options{
    DatabaseType: "OpenASN-Core-v1",
    IPVersion: 6,
    RecordSize: 28,
    BuildEpoch: buildUnixTS,
    IncludeReservedNetworks: true,
    DisableIPv4Aliasing: true,
    Description: map[string]string{"en": description},
}
```

Intervals are inserted as exact inclusive ranges. An interval is never widened
to an enclosing CIDR to make it fit; a range that cannot be represented fails
the build. Record size is not silently increased and records are not skipped
on overflow. Base and overlay evidence is never inserted as separate
replace-with layers: the payload is already composed, and layering it would
let a later insert erase a field.

### 6.2 Payload

Every leaf payload carries the 14 logical payload fields, `asn` through
`core_sources`. There is no `ip_version`, no start/end, no row id, and no
per-row timestamp: bounds are implicit in the search tree, and per-row
identity would defeat the deduplication that keeps the file small.

- `asn` is MMDB `uint32`. Booleans are native MMDB booleans. Strings are
  UTF-8. `core_sources` is an ordered MMDB array of strings.
- **MMDB has no null type.** A nullable field whose value is null is
  *omitted*. Every boolean is present, including when false. A helper
  normalizes an absent key back to null, so the result of an MMDB lookup and
  the result of a SQLite lookup are identical objects.
- The prefix a reader returns is not the original interval. The tree may
  subdivide an interval across several prefixes, so a returned prefix is not a
  stable range identifier and must not be presented as one.

### 6.3 Metadata and description

Standard MMDB metadata carries the database type, binary format version,
build epoch, record size, IP version, and description. The writer offers no
arbitrary custom metadata map, so nothing else is added there.

`description.en` is deterministic text:

```text
OpenASN core; schema_version=1; schema_revision=0; classification_profile=core-v1; lookup_policy_version=1; scope=tier_a; build_id=<BUILD>; records_ipv4=<N4>; records_ipv6=<N6>\n<ATTRIBUTION_TEXT>
```

The `\n` shown is one real newline in the stored string, and
`<ATTRIBUTION_TEXT>` is the same attribution text embedded in the SQLite
metadata and shipped in the release.

The description is for humans. A helper validates the standard
`database_type` and `build_epoch` against its installed manifest and never
parses prose out of the description. The MMDB tree's `node_count` is a
structural number and is **not** the OpenASN logical row count; the manifest
is the source of exact record counts (section 8). Tree and prefix counts may
be logged as separately named diagnostics.

### 6.4 Address representation restrictions

A combined MMDB represents IPv4 inside the low IPv6 subtree `::/96`. With a
generic reader, the IPv6 literal `::808:808` therefore resolves the IPv4
record for `8.8.8.8`, even though native OpenASN returns unknown for that
literal. Disabling IPv4 aliases does not remove this: it is how the shared
tree works.

The consequences are normative:

- **Native IPv6 data overlapping `::/96` is rejected before MMDB generation.**
  So is native IPv6 data overlapping the mapped prefix `::ffff:0:0/96`, where
  address normalization in readers and writers could collapse two distinct
  payloads into one. Both are hard build failures. Neither range is reachable
  as native IPv6 under lookup policy 1, but dropping records quietly would
  violate the guarantee that the export preserves the build exactly. If either
  ever appears, the representation is revisited; the data is not discarded.
- A helper normalizes **only** IPv4-mapped `::ffff:0:0/96` input to IPv4,
  before lookup.
- For a genuine IPv6 input inside `::/96`, a helper applies the `::1` special
  rule and otherwise returns the defined no-data result. It does not search
  the IPv4 subtree.
- 6to4 `2002::/16` and Teredo `2001::/32` are **not** mapped to IPv4. Their
  data, if any exists, is IPv6 data. No writer alias is created for them.
- No other range is filtered by the writer's reserved-network policy.
  `IncludeReservedNetworks` is true precisely so the input stays
  authoritative.

A generic tool with no such normalization can still use this file for
validated ordinary public addresses. It is not equivalent to the full OpenASN
input policy for arbitrary raw input, and documentation that claims otherwise
is wrong.

## 7. Lookup policy 1

Lookup policy 1 defines how a caller's string becomes an address and which
addresses are answered without consulting the data. It is versioned
separately from the schema and the profile because it governs input, not
content.

### 7.1 Input parsing

The input is **one string IP literal**. Not a hostname, URL, CIDR, port,
bracketed address, whitespace-padded string, integer shorthand, or IPv6 with a
scope/zone identifier. Malformed input raises an error
(`InvalidArgumentException` in PHP, `ArgumentException` in C#). It is never
DNS-resolved, never trimmed into validity, never converted to zero, and never
reported as `unknown`: a parse error is a caller bug, and reporting it as a
verdict hides it.

- **IPv4**: exactly four decimal octets, each 0 to 255, with no leading zeros
  except the single digit `0`. Validate this lexically **before** handing the
  string to a platform parser. Platform parsers accept shorthand forms
  (`1.2.3`, octal-looking octets, integer addresses) that differ between
  languages, and accepting them would make two conforming implementations
  disagree.
- **IPv6**: reject `%`, `/`, surrounding brackets, whitespace, and port
  syntax first, then use the platform's binary parser. Uppercase and
  compressed forms are accepted.
- An IPv4-mapped address is normalized to IPv4 before anything else. No other
  IPv6 embedding scheme is normalized.

This is deliberately narrower than any accidental permissiveness in an older
OpenASN SDK parser. Policy 1 defines the new helper contract; it does not
retroactively describe historical parser quirks.

### 7.2 Special ranges

Applied to the normalized address **before** either family table is queried.
Ranges are inclusive. This table is frozen for policy 1: it is a mirror of
existing client behavior, not an invitation to substitute a platform
`is_private` or `is_global` predicate, which cover different sets and change
between language versions.

| Family | CIDR | Verdict | Source |
|---|---|---|---|
| IPv4 | `0.0.0.0/8` | `private` | `special_reserved` |
| IPv4 | `10.0.0.0/8` | `private` | `special_rfc1918` |
| IPv4 | `100.64.0.0/10` | `cgnat` | `special_cgnat` |
| IPv4 | `127.0.0.0/8` | `private` | `special_loopback` |
| IPv4 | `169.254.0.0/16` | `private` | `special_link_local` |
| IPv4 | `172.16.0.0/12` | `private` | `special_rfc1918` |
| IPv4 | `192.168.0.0/16` | `private` | `special_rfc1918` |
| IPv4 | `224.0.0.0/4` | `private` | `special_multicast` |
| IPv4 | `240.0.0.0/4` | `private` | `special_reserved` |
| IPv6 | `::1/128` | `private` | `special_loopback` |
| IPv6 | `fc00::/7` | `private` | `special_ula` |
| IPv6 | `fe80::/10` | `private` | `special_link_local` |

- A special match **suppresses data evidence** even when a table happens to
  carry a row underneath it, consistent with existing client precedence.
- Documentation and example addresses such as `192.0.2.1` and `2001:db8::1`
  are **not** special under policy 1. They are queried like any other address
  and usually miss.
- `::ffff:10.0.0.1` normalizes to IPv4 and returns `private` /
  `special_rfc1918`.
- Adding further IANA special-purpose ranges requires a new
  `lookup_policy_version`. Implementations do not extend this table locally.

### 7.3 The result

A conforming helper returns an explicit result object with these fields:

```json
{
  "ip":"8.8.8.8",
  "verdict":"hosting",
  "sources":["asn_cdn","asn_category"],
  "asn":15169,
  "as_org":"Google LLC",
  "category":"hosting",
  "network_role":"content_network",
  "signals":{
    "bad_asn":false,"vpn_provider":false,"mobile_carrier":false,
    "enterprise_gw":false,"cdn":true,"hosting_extra":false,
    "vpn_range":false,"datacenter_range":false
  },
  "lookup_status":"matched",
  "build_id":"2026-09-18T08:14:36Z",
  "scope":"tier_a"
}
```

The shape is normative; the values are an illustration. Category, role, and
flags for any particular address are data and change between builds.

- `ip` is the original validated input string.
- `verdict` and `sources` come from the stored `core_verdict` and
  `core_sources` on an ordinary hit.
- Every signal is a real language boolean. An absent MMDB key becomes null,
  not false, for nullable fields.
- `start`/`end` are not returned by default. They are internal storage
  columns, and serializing a 16-byte blob endpoint into JSON has no good
  default answer.

`lookup_status` is one of:

- `matched`: a record was found. This includes an overlay-only hit with a
  null ASN.
- `unrouted`: no record. ASN, org, category, and role are null, all signals
  are false, `verdict` is `unknown`, `sources` is `["unrouted"]`.
- `special`: lookup policy matched. ASN, org, category, and role are null, all
  signals are false, `verdict` is `private` or `cgnat`, and `sources` is the
  single `special_*` token from the table above.

Distinguishing `matched` from `unrouted` is what keeps an overlay-only hit
(real evidence, no ASN) from looking like no data at all.

Two things a helper must not do: set a `provider` field from `as_org`, which
would assert a retail brand the data does not carry; and label a network with
`bad_asn` true as malicious. A consumer that wants a simple badge derives it
from `verdict`, while the raw signals stay independently readable.

## 8. Release manifest entry

Existing manifest file entries keep their keys and meanings. An export adds a
nested `export` object:

```json
{
  "name":"openasn.sqlite.gz",
  "sha256":"<64 lowercase hex of the downloadable gzip bytes>",
  "bytes":12134626,
  "records":573933,
  "export":{
    "format":"sqlite",
    "media_type":"application/vnd.sqlite3",
    "content_encoding":"gzip",
    "schema_version":1,
    "schema_revision":0,
    "classification_profile":"core-v1",
    "lookup_policy_version":1,
    "scope":"tier_a",
    "tier_b_included":false,
    "records_by_family":{"ipv4":448108,"ipv6":125825},
    "uncompressed":{
      "name":"openasn.sqlite",
      "bytes":58937344,
      "sha256":"<64 lowercase hex of the finalized SQLite bytes>"
    }
  }
}
```

The numbers above illustrate the shape and are not fixed expectations.

- `sha256` and `bytes` always describe the **downloadable** bytes. For a
  gzipped asset, `export.uncompressed` describes the decoded file. Verify
  both: the transport hash proves the download, the decoded hash proves the
  decompression.
- `media_type` describes the decoded content; `content_encoding` describes
  transport compression.
- CSV uses format `csv`, media type `text/csv; charset=utf-8`, encoding
  `gzip`, decoded name `openasn.csv`.
- MMDB uses format `mmdb`, media type `application/octet-stream`, encoding
  `identity`, and **omits** `uncompressed`, because its `bytes` and hash
  already describe the reader's bytes.
- `records` and `records_by_family` always count coalesced effective
  intervals, in every format including MMDB. They are never MMDB prefixes,
  tree nodes, unique payloads, physical CSV lines, or input base ranges.
- Top-level `build_id` and `sources` are unchanged. A top-level
  `export_producer` object carries exporter and tool versions, and
  `stats.export_counts` carries export metrics. `stats.layer_counts` continues
  to count native input layers, not effective rows.
- `manifest.json` and `SHA256SUMS` are envelope files. They are not entries
  in `manifest.files` and do not hash themselves. `SHA256SUMS` lists each
  registered payload, sorted lexically by filename, as
  `lowercase_sha256`, two ASCII spaces, filename, LF; for a gzipped asset it
  carries the compressed hash.

An older client that does not understand exports reads only the native files
it knows and ignores the additional entries. That is why export metadata is
nested rather than added as new top-level keys.

## 9. Consumer update and verification protocol

This section is the contract an updater must satisfy. It exists because a
rolling release is not atomic: while payloads are replaced, an old manifest
can briefly reference new bytes, and caches lag. Publication order (payloads,
then `SHA256SUMS`, then `manifest.json` last) narrows the window; the
consumer rules below close it.

### 9.1 Installed layout

Generations are immutable and a small pointer selects one:

```text
data/
  current.json
  update.lock
  generations/
    <generation-id>/
      manifest.json
      openasn.sqlite           # or openasn.mmdb
      installed.json
```

`<generation-id>` is derived from the selected decoded artifact's full SHA-256
hex, not from a timestamp, so it is safe as a filename and collides only on
identical content. `current.json` holds `{"generation":"<id>"}` with a
hex-only basename and no relative path component. `installed.json` records the
original artifact name, transport hash, installed hash, `build_id`,
schema/profile/policy identities, validation completion, and download time.
Download time is local diagnostics; it never modifies the database or the
manifest.

A request resolves the pointer once and uses that generation for its entire
operation. It does not re-read the pointer between fetching a row and reading
metadata, which would let one response mix two builds. A short-lived process
picks up updates naturally. A long-lived process reopens only when the
generation changes: validate and open the replacement, swap the resolver
reference atomically, and let in-flight users finish on the old one before
disposing it.

### 9.2 Update algorithm

1. Take a non-blocking local updater lock. A second updater reports `locked`
   and exits; it does not wait and write concurrently. Readers never take this
   lock.
2. Resolve the requested tag. Only `latest` or a validated `vYYYY.MM.DD` is
   accepted. Always use tag-addressed URLs
   (`releases/download/<tag>/<file>`); the "Latest" badge form resolves by
   badge, not by tag, and can serve a stale weekly snapshot (D-REL-1 in
   [DECISIONS.md](DECISIONS.md)).
3. Fetch the manifest over HTTPS with a bounded timeout, optionally
   conditional on ETag. A network failure or missing manifest retains the
   current generation. A first installation with no previous data fails
   clearly rather than inventing an empty one.
4. Parse a bounded manifest. Find exactly one expected asset and validate its
   name, byte length, hash syntax, mandatory export descriptor,
   schema/profile/policy identities, and record counts. Unknown extra file
   entries are ignored. A release that predates the export yields
   `format_unavailable` and keeps the existing data; it is not a corrupt
   release.
5. If the selected artifact's installed hash equals the current installed
   hash and the metadata agrees, return `unchanged`. **Never treat a build id
   alone as proof that bytes are unchanged.** An explicit dated pin may
   deliberately roll backwards; report the target build and install it.
6. Download into a fresh staging directory on the target filesystem. Bound
   the transfer to the advertised size and detect extra bytes. Verify exact
   length and hash against the manifest already in hand, never against a
   checksum file fetched separately, which may belong to another generation.
   Do not request or accept transparent content decoding: the transport hash
   is over the exact `.gz` bytes the manifest names.
7. For a gzipped asset, decompress while hashing into a candidate file.
   Reject a stream exceeding the advertised decoded size or a configured
   safety cap, an invalid CRC, a truncated stream, an unexpected extra member,
   or trailing bytes. Verify the decoded length and hash. For `identity`
   encoding, validate the raw hash directly.
8. Validate the candidate's structure: schema, profile, policy, embedded
   build identity, and counts against the manifest. For SQLite run
   `integrity_check` (preferred at this size) or `quick_check` plus exact
   counts and a schema check, once, during the update. Do not hash or
   integrity-check the database per lookup or per row. For MMDB verify library
   metadata and structure. Build-side validation evidence is context, never a
   substitute for the consumer's own checksum.
9. Write the installed manifest and receipt into the candidate generation.
   Flush and close every file, fsync where supported, then move the finished
   directory to `generations/<id>`. Never mutate an existing generation with
   that id: verify equality and reuse, or fail.
10. Write a complete temporary pointer, flush and close it, then atomically
    replace `current.json` on the same filesystem. Do not emulate atomicity
    by deleting the old pointer first: a crash in that window leaves no
    pointer at all.
11. Release the lock and report the new build. Keep the previous generation.
    Cleanup is a separate, explicit operation that refuses to remove the
    current generation.

### 9.3 Retries, limits, and failure semantics

- **Retry** at most three complete attempts, with 2-second then 5-second
  backoff, for a hash or size mismatch, a transient 404 or 5xx, or a payload
  that changed mid-download during a rolling replacement. Each attempt starts
  with a fresh manifest and fresh staging. **Never combine a manifest from one
  attempt with bytes accepted under another.** Cache validators must not trap
  a retry on the same stale manifest; an unconditional refetch is allowed
  after a mismatch.
- **Do not retry** an unsupported schema, profile, or policy, a bad local
  configuration, a permission failure, or an invalid requested tag. Those fail
  immediately with an actionable message.
- Retry exhaustion returns non-zero, leaves the pointer and previous
  generation untouched, and names the stage, artifact, and build in the log.
  No self-healing path ever removes a checksum or relaxes an expectation.
- Suggested client limits: manifest at most 2 MiB, 30-second connect and
  300-second download ceilings, decoded SQLite at most 512 MiB, transfer at
  most 256 MiB. These protect the client; they are not statements about the
  data. If a legitimate future asset exceeds one, fail clearly and let an
  operator raise it deliberately. Never infer that a huge advertised length is
  legitimate because it is advertised.
- **Before pointer replacement, every failure and every crash leaves the old
  generation active.** After replacement, the new generation is complete and
  validated. An orphaned candidate directory is tolerable and is found by
  cleanup. There is no moment at which a reader can see a pointer to partially
  written data.
- On Windows, never rename or overwrite an open database file. Immutable
  versioned directories avoid the problem entirely. A failed pointer
  replacement keeps the old pointer and reports failure.
- An installation that cannot hash or decompress fails. There is no
  skip-verification mode.

## 10. Conformance fixtures

Hand-authored fixtures for this contract are tracked at
[`conformance/exports/v1/`](conformance/exports/v1/):

| File | Covers |
|---|---|
| `profile-fixtures.json` | Every core-v1 precedence row, the hosting source ordering, and inputs a canonical writer must reject |
| `projection-fixture.json` | A ten-row effective-interval stream with overlay splits, an overlay-only segment, gaps, and coverage counts |
| `lookup-policy-fixtures.json` | Policy 1 parsing, every special range's first, last, preceding, and following address, and the invalid-input list |
| `sqlite-v1.sql` | The schema above, as the one machine-readable copy |

Expected values in those files are hand-specified. An implementation must not
regenerate them from its own output: a fixture derived from the code under
test proves only that the code agrees with itself.
