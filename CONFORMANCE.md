# Conformance

Every OpenASN client — the Ruby gem, the Python package, the JS package, the
pipeline's own reference classifier — must return the **same verdict for the
same IP on the same bytes**. This file is the contract that makes "same" a
testable claim, and [`spotchecks.yml`](spotchecks.yml) is the kit that proves
it: 97 rows covering every rule of the precedence ladder.

## The panel

`spotchecks.yml` has two kinds of row.

**Tier A rows (81).** Canonical semantics: the compiled artifacts only, **no
Tier B overlays**. These are the rows the pipeline asserts on every build
(gate G5) and the rows a client asserts with Tier B disabled.

**`context: gem` rows (16).** Rules 3, 4, 5 and 8 of the ladder — relay, Tor,
provider-attributed VPN, cloud provider ranges — exist only client-side,
because Tier B lists are fetched by the client and never redistributed by this
project. The pipeline skips these rows; clients assert them with a fixture
overlay for the named `tier_b` source.

### Row fields

| field | who asserts it | meaning |
|---|---|---|
| `ip` | everyone | the probe |
| `expect` | everyone | the verdict, as the closed enum in README §verdicts |
| `rule` | pipeline (gate G5) | the single winning rule name, in the **pipeline validator's** vocabulary |
| `gem_sources` | clients | the same winner as it appears in a client `Result#sources`, which is a **list** |
| `asn` | everyone | the announcing ASN |
| `tier_b` | clients | the Tier B source id expected to win (`context: gem` rows) |
| `provider` | clients | the provider attribution that source must carry |
| `context_flags` | clients | context flags that must be present (they never decide verdicts) |
| `context` | — | `gem` marks a row the pipeline skips |
| `note` | humans | why the row exists |

### Why `rule` and `gem_sources` are two fields

The pipeline validator and the clients name three rules differently, and the
clients return a list where the pipeline returns one symbol:

| situation | pipeline `rule` | client `sources` |
|---|---|---|
| mobile carrier ASN | `asn_mobile` | `[asn_mobile_carrier]` |
| routed ASN with no category | `no_category` | `[asn_no_category]` |
| hosting from a curated flag | `asn_category` | `[asn_bad_asn]` / `[asn_hosting_extra]` / `[asn_cdn]`, plus `asn_category` when the ASN's own category is `hosting` |

Everything else — the special ranges, `x4b_vpn`, `x4b_dc`,
`asn_vpn_provider`, `asn_enterprise_gw`, `isp_transit_ambiguous`, `unrouted`,
and `asn_category` for the non-hosting category verdicts — is spelled
identically on both sides. The client names are the **published API contract**
and are append-only under D-IMPL-6, so the panel carries both names rather
than weakening either assertion. A future pipeline change may alias its three
names to the client ones; until then, assert the column that belongs to you.

### When `rule` is asserted, and when it deliberately is not

`rule` is asserted on 65 of the 81 Tier A rows: everywhere the path is
structural, where a change of path means a real change of meaning. It is
deliberately **not** asserted where the winner is one of the canonical X4B
range overlays (`x4b_dc`, `x4b_vpn`) or flag-driven hosting: those lists are
re-published upstream nightly, the verdict is the contract, and the choice
between two interchangeable hosting signals is not — asserting it would fail
builds on non-events. Three rows opt back in because the path *is* the point
(Cloudflare must not come from the dc overlay; the `hosting_extra` override
must be what makes vsys.host hosting; Host Europe shows the same override
losing to rule 9, by design).

## Running the panel

```bash
# pipeline reference classifier (all Tier A rows) — this is gate G5
OFFLINE=1 OPENASN_DATA_REPO=/path/to/this/repo ruby pipeline/run.rb

# Ruby gem, Tier A rows: point data_dir at the artifacts, Tier B disabled
# Ruby gem, context: gem rows: same artifacts + a fixture overlay per tier_b id
# Python: PYTHONPATH=src python -m unittest tests.test_spotchecks
```

A client that cannot yet implement a rule must **skip** the affected rows
loudly, never redefine them.

## Known, deliberate divergences between clients

These are documented behaviour differences, not bugs. Any other difference is
a bug in the client that differs from the gem.

1. **Tier B hostname resolution ordering (Python).** The Python client resolves
   provider hostnames *after* the HTTP 304 check; the gem resolves first and
   discards the result when the source was unchanged. Behaviour-identical,
   strictly politer toward volunteer-run endpoints.
2. **No bundled seed (Python, JS).** The gem falls back to a ~10 MB dataset
   shipped inside the gem. The Python wheel and the npm package ship none: a
   missing dataset is an error that names the fix (`python -m openasn update`)
   rather than a silent downgrade to stale bundled bytes.
3. **Result key casing (JS).** `toJSON()` emits the gem's exact snake_case key
   names, because conformance depends on them; the object also exposes
   camelCase accessors for idiomatic JS.

## Tier B sources are untrusted input

A Tier B list is fetched from a party this project does not control, and
whatever it contains becomes a verdict on the client. Two consequences every
client must honour:

1. **Transport.** Follow redirects only to `http`/`https`, at every hop. A
   `Location: file:///…` must be refused, not followed. (Fixed in the gem
   2026-09-12; the Python client already refused.)
2. **Content.** A provider list can contain address space that is not the
   provider's. Live audit, 2026-09-12: Vultr's RFC 8805 geofeed
   (`https://geofeed.constant.com/`) publishes `192.0.2.0/24`,
   `198.51.100.0/24`, `203.0.113.0/24`, `2001:2::/48`, `2001:10::/28`,
   `2001:db8::/32` and `2002::/16` — IANA special-purpose space, including all
   of 6to4, which carries real end users — as Vultr's own. Twenty-one other
   sources were clean. Clients should filter IANA special-purpose prefixes out
   of Tier B overlays and log what they dropped.

## Keeping the panel honest

The panel is a **tripwire, not gospel** (its own header says so). Routing
changes and providers move blocks. When a row fails: find out what actually
changed (`rake 'lookup[IP]'`), then either fix the bug it caught or update the
row in a reviewed PR whose description says why the internet changed. Never
bulk-edit rows to make CI green.

Panel v2 (2026-09-12) was generated, not hand-written: each probe is its ASN's
largest announced range +10 addresses (never a range edge, where a
more-specific could silently swallow it), and every `expect`/`rule`/`asn`/
`gem_sources`/`provider` value was read back from a real classification —
Tier A rows from the pipeline classifier and the gem, `context: gem` rows from
the gem with all 22 Tier B sources refreshed live.
