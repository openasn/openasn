# 🛰️ OpenASN — open-source IP origin intelligence

**Classify any IP as residential, mobile, hosting, VPN, Tor, relay, business, or unknown — offline, explainably, without API calls.**

OpenASN is an open data project: a legally clean, offline database for answering *"what kind of network is this IP really coming from?"* It compiles permissively licensed ASN metadata, IP→ASN backbones, VPN/datacenter overlays, and hand-curated corrections into small binary artifacts (~6MB for all of IPv4) that applications query locally in microseconds — zero API calls, zero per-lookup cost, and no user IPs ever sent to a third party.

This repository is the **dataset**: the curated override layer, the pinned upstream licenses, the public specs (artifact format, spot-check panel, Tier B fetch manifest), and the nightly releases. It is the heart of the OpenASN project:

| repo | what |
|---|---|
| [`openasn/openasn`](https://github.com/openasn/openasn) | **this repo** — the open data: curation, specs, provenance receipts, releases |
| [`openasn/openasn-pipeline`](https://github.com/openasn/openasn-pipeline) | the compiler: fetch → legal/quality gates → pack → validate → publish (runs nightly via [this repo's workflow](.github/workflows/nightly-build.yml)) |
| [`openasn/openasn-ruby`](https://github.com/openasn/openasn-ruby) | the first client: the `openasn` Ruby gem (see [Clients](#clients)) |

The artifact format is public and language-neutral ([FORMAT.md](FORMAT.md)) — clients in any language are welcome.

**Where this is going.** OpenASN aims to be the biggest and most complete open database of ASNs and everything related to them — not just "is this IP infrastructure?", but who operates the network: the organization and its ownership chain, brands, services, jurisdiction, infrastructure footprint, and how it relates to other ASNs. Two tiers keep that ambition compatible with the legal spine ([DECISIONS.md](DECISIONS.md) D-DATA-1). The **core** — the artifacts and `data/overrides/` — stays **CC0 forever**, with the strict provenance rules below: only data whose exact redistributed form carries explicit rights, aggregators never, ShareAlike never. The **extended tier** — the rich per-ASN record, compiled in our own words from every source we may legally consult, with an exact source URL and date on every fact — is licensed per its inputs (CC BY-SA 4.0 by default), will be published separately with its own LICENSE and ATTRIBUTION, and is **never mixed into the core** or used to relicense it. That work is in progress; the network-origin verdict is and remains the product.

## Clients

<!-- Maintainer: flip the Python and JS rows to `pip install openasn` / `npm install openasn` + "live on PyPI / npm" the day those packages publish. -->

| Language | Install | Status |
|---|---|---|
| Ruby — [`openasn/openasn-ruby`](https://github.com/openasn/openasn-ruby) | `gem install openasn` | **Live on RubyGems.** The reference client. |
| Python | — | Release candidate in preparation |
| JavaScript / TypeScript | — | Release candidate in preparation |
| Any other language | — | The format is public ([FORMAT.md](FORMAT.md)); new clients are welcome |

Every client must return the **same verdict for the same IP on the same bytes** — that contract, the shared spot-check panel that proves it, and the handful of deliberate, documented differences between clients live in [CONFORMANCE.md](CONFORMANCE.md).

> [!IMPORTANT]
> **What OpenASN is NOT.** It is not a fraud engine. It cannot prove an IP is safe or that a user is human. **A clean or `residential_isp` verdict is absence of evidence, not proof of innocence.** Residential proxies — malicious traffic exiting through real home IP addresses — are structurally hard to detect offline, and OpenASN does not claim to detect them. `vpn`, `hosting`, and `tor_exit` verdicts are high-confidence; treat everything else as a signal, not a sentence. Never hard-block `relay`, `cgnat`, or `mobile` — those are real people. OpenASN is a first line of defense, not a fraud engine.

## What you get (nightly, from the [`latest` release](https://github.com/openasn/openasn/releases/latest))

| File | What it is |
|---|---|
| `openasn-ipv4.bin` / `openasn-ipv6.bin` | Packed classification artifacts: IP→ASN backbone with category/role/flag bits + VPN/datacenter range overlays. Byte spec: [FORMAT.md](FORMAT.md) |
| `openasn-orgs.bin` | Optional sidecar: ASN → organization name ("OORG", same byte spec). CC0 names only (our sourced overrides + Wikidata). Clients work fully without it; `as_org` is simply nil until it's downloaded |
| `asn-categories.csv` | Human-friendly table: every ASN → org, country, category, network role, OpenASN flags (CC0). `org` is filled where we hold a CC0 name (our sourced overrides + Wikidata) and empty otherwise; see [D-SRC-2](DECISIONS.md) |
| `manifest.json` | Build id, per-file SHA-256, and full source provenance (upstream URL, license, license-file hash, fetch time) |
| `fetch-manifest.json` | The Tier B recipe (see "Legal design") that clients execute themselves |
| `ATTRIBUTION.md` / `SHA256SUMS` | Credits and checksums |

Always download via the tag-addressed URL `releases/download/latest/<file>` — assets are replaced nightly. A dated release is cut weekly for pinning (`releases/download/<vYYYY.MM.DD>/<file>`, e.g. `v2026.07.05`; see DECISIONS.md). Do NOT use `releases/latest/download/<file>`: it resolves via GitHub's "Latest" badge, not the `latest` tag, and can serve a stale weekly snapshot (see DECISIONS.md D-REL-1).

The same artifacts are also mirrored nightly to Hugging Face — [`datasets/openasn/openasn`](https://huggingface.co/datasets/openasn/openasn) — where `asn-categories.csv` is browsable in the dataset viewer.

### Choosing a format

The same Tier A core is also specified as three portable representations, for
consumers who would rather query SQL, import a range table, or point an
existing MMDB reader at a file than decode bit offsets: `openasn.sqlite.gz`,
`openasn.csv.gz`, and `openasn.mmdb`. Their full contract (schema, field
meanings, classification profile, input policy, update protocol) is
[EXPORT_FORMATS.md](EXPORT_FORMATS.md), with public conformance fixtures in
[`conformance/exports/v1/`](conformance/exports/v1/) and the reasoning in
[DECISIONS.md](DECISIONS.md) (D-FMT-1).

> [!NOTE]
> **The contract is published ahead of the assets.**
> [`export-contract.json`](export-contract.json) carries `required_mode`, the
> export mode a release must satisfy. While it reads `none`, releases contain
> the native artifacts only and no portable export is expected in any release.
> Read the `manifest.json` of the release you are downloading rather than
> assuming an asset is there.

| Need | Recommended artifact |
|---|---|
| Dependency-free OpenASN SDK, edge byte buffers | Native OASN (`openasn-ipv4.bin` / `openasn-ipv6.bin`), optional OORG (`openasn-orgs.bin`) |
| Local SQL, a PHP dashboard, a Windows desktop app | SQLite (`openasn.sqlite.gz`) |
| An existing generic MMDB reader, custom network-tool fields | MMDB (`openasn.mmdb`) |
| Import to a warehouse or custom storage, comparing ranges between builds | Range CSV (`openasn.csv.gz`) |
| All ASNs, including those without observed routes | ASN catalog CSV (`asn-categories.csv`) |

Every portable export is a projection of the same build: same inputs, same
build id, same Tier A scope. None of them carries Tier B evidence, so a
`core_verdict` never says `tor_exit` or `relay`; those still come from the
`fetch-manifest.json` recipe a client executes itself.

#### One query, one row

The whole SQLite integration is a predecessor lookup plus a containment check.
Bind an IPv4 address as an integer, an IPv6 address as a 16-byte big-endian
BLOB, and read the columns by name:

```sql
SELECT * FROM (
  SELECT * FROM v4 WHERE start <= :ip ORDER BY start DESC LIMIT 1
) AS candidate
WHERE end >= :ip;
```

```
asn            15169            core_verdict      hosting
as_org         Google LLC       core_sources      ["x4b_dc"]
category       hosting          vpn_range         0
network_role   midsize_transit  datacenter_range  1
bad_asn        1                hosting_extra     0
cdn            0                vpn_provider      0
```

That row is a real lookup of `8.8.8.8`, and it illustrates the point on its
own: the verdict is `hosting`, but `hosting_extra` is `0` and `cdn` is `0`.
The datacenter range overlay decided it, which is what `core_sources` says.
`bad_asn` is `1` and did **not** decide anything.

Three things that are easy to get wrong here, and that the conformance
fixtures check:

- **`asn IS NULL` is a hit, not a miss.** Some ranges are covered by the
  datacenter or VPN overlay with no BGP base row behind them. They are real
  records with a real verdict, and org/category/role are null while the range
  flags still apply. Treating them as "not found" loses genuine coverage.
  Do not infer presence from truthiness either: `0` is a valid ASN, and
  `if ($asn)` is false for it in most languages.
- **`vpn_range` and `datacenter_range` are range overlays, independent of the
  ASN-level `vpn_provider` and `hosting_extra` bits.** An address can be
  `vpn` with `vpn_provider = 0`, and `hosting` with `hosting_extra = 0`. The
  bits are corroborating evidence, not the verdict; `core_verdict` is the
  verdict and `core_sources` says which rule won.
- **`bad_asn` still means what it means above**: hosting/cloud/colo list
  membership, never an abuse score, and as the row above shows it is often
  set on entirely ordinary infrastructure. It must not be surfaced to a human
  as "bad" or "malicious".

Special addresses (RFC 1918, CGNAT, loopback, link-local, multicast,
reserved) are deliberately **not rows**. They are answered by lookup policy 1
before the database is consulted, which is why a consumer needs the small
helper described in
[EXPORT_FORMATS.md](EXPORT_FORMATS.md) rather than a bare `SELECT`. Runnable
PHP, C# and nginx consumers live in
[openasn/openasn-examples](https://github.com/openasn/openasn-examples).

## Verdict taxonomy

Clients classify with a strict precedence ladder (overlays outrank ASN classification; specials outrank everything):

`residential_isp` · `mobile` · `business` · `hosting` · `vpn` · `tor_exit` · `relay` · `enterprise_gateway` · `education` · `government` · `cgnat` · `private` · `unknown`

Design notes that keep verdicts honest:

- **`relay` and `enterprise_gateway` are first-class, never folded into `vpn`/`hosting`.** iCloud Private Relay egress lives inside Cloudflare/Akamai space and Apple explicitly says to treat it like carrier-grade NAT; Zscaler/iboss egress is entire companies and school districts. Misfiling either blocks real humans.
- **VPN and datacenter signals are independent bits, not a hierarchy** — measured: only ~70% of known-VPN space sits inside datacenter lists. Both overlays are recorded separately.
- **Pure tier-1 backbone space classifies `unknown` on purpose** (Cogent, Lumen, Arelion…): "we can't tell" beats a confident wrong answer. The four consumer giants that also run tier-1 backbones (AT&T, Verizon, Deutsche Telekom, Liberty Global) are eyeball-confirmed by curation. Full reasoning: [DECISIONS.md](DECISIONS.md).
- **`unknown` is a feature.** Mixed-use ASNs (an ISP that also sells VPS) stay `unknown` with the raw category/role exposed, so *you* choose the policy.
- **The enum is a cross-language contract and it is append-only**: verdicts are never removed, renamed, or redefined; additions arrive via client releases (never via data refreshes — artifacts carry ranges and flag bits, clients compile the verdict mapping). Every OpenASN client must document the same guarantee ([details](DECISIONS.md)). The portable exports ("Choosing a format" above) do materialize a verdict into the data, which is exactly why they carry a frozen, separately versioned profile name and a strictly smaller vocabulary ([D-FMT-1](DECISIONS.md)).

## Architecture: the three tiers

```
Tier A (this repo, in the artifact)      Tier B (your server fetches directly)
─────────────────────────────────       ─────────────────────────────────────
RouteViews RIBs  (CC BY)¹   backbone     Apple Private Relay egress → :relay
ipverse as-metadata (CC0)   categories   Tor Project exits          → :tor_exit
ipverse as-ip-blocks(CC0)   prefixes     AWS/GCP/Azure/OCI/DO/…     → :hosting+provider
X4BNet lists_vpn    (MIT)   vpn/dc       Proton/Mullvad/IVPN/PIA…   → :vpn+provider
bad-asn-list        (MIT)   hosting      Cloudflare ranges          → context flag
Wikidata P3797      (CC0)   org names    Zscaler egress             → :enterprise_gateway
data/overrides/     (CC0)   our layer    Nord/VPN Gate              → opt-in :vpn+provider
                                         ipverse WHOIS org names    → as_org (fetched locally)
```

**Tier A** sources carry explicit redistribution rights and are compiled into the published artifacts. ¹The one exception to "we compile their data" is the backbone: we compile no RouteViews file, only the prefix → origin-ASN facts our own code recomputes from their BGP RIB dumps, with the attribution their terms ask for ([ATTRIBUTION.md](ATTRIBUTION.md); rule 1 below). **Tier B** sources are either license-restricted from republishing or too fast-moving for a nightly file (Tor exits change hourly) — so we publish the *recipe* (`fetch-manifest.json`: URL, parser id, cadence, failure policy) and clients pull from the original authorities at runtime. **Tier C** (bring-your-own MaxMind/IP2Location, planned) never touches this pipeline. The catalog of rejected sources and why (PeeringDB's AUP, GPL lists, ShareAlike databases, aggregator repackaging…) lives in the project history — the short version is the next section.

## Reading OpenASN labels correctly

The client-facing `verdict` is the product contract. The raw ASN labels are context.

| Field | Meaning | Example |
|---|---|---|
| `verdict` | The application-level answer emitted by a client (`residential_isp`, `hosting`, `vpn`, ...) | DIGI Spain home broadband → `residential_isp` |
| `category` | Upstream ASN category compiled into the artifact (`isp`, `hosting`, `business`, ...) | DIGI Spain → `isp`; Amazon → `hosting` |
| `network_role` | Upstream routing role (`access_provider`, `midsize_transit`, `tier1_transit`, ...) | Telefónica retail → `access_provider`; Cogent backbone → `tier1_transit` |
| `openasn_flags` | Extra OpenASN bits such as `bad_asn`, `vpn_provider`, `mobile_carrier`, `enterprise_gw`, `cdn`, `hosting_extra` | Microsoft/Amazon ASNs often carry `bad_asn` as hosting corroboration |
| `sources` | Runtime client explanation of which rule won | `x4b_dc`, `asn_category`, `aws`, `asn_bad_asn` |

`bad_asn` is unfortunately named upstream, but useful: it means membership in `brianhama/bad-asn-list`, a curated MIT-licensed list of hosting/cloud/colo ASNs. In OpenASN it is just an infrastructure signal. It does not mean the ASN is malicious, unsafe, or block-worthy by itself.

`category=isp` and `verdict=residential_isp` are intentionally different words. The category describes the ASN; the verdict is the safer app-facing label after precedence rules. A real ISP can still be `unknown` if it is pure tier-1 backbone space, and a hosting ASN can become `vpn` when a VPN overlay is more specific.

## Provider enrichment roadmap

OpenASN's MVP answers the most important question first: human-ish access network vs infrastructure. The next layer is provider attribution: "this hosting IP is AWS" or "this VPN IP is Mullvad." The public source ledger lives in [PROVIDER_SOURCES.md](PROVIDER_SOURCES.md), and the slower provider/operator dossiers live in [VPN_PROVIDER_DOSSIERS.md](VPN_PROVIDER_DOSSIERS.md). The rules for adding that layer are stricter than "can we scrape it":

- **Exact IP hits may set `provider`.** A first-party or license-clean list containing the observed exit IP can produce `provider: "mullvad"` or `provider: "ivpn"`.
- **Nearby-prefix inference is context only.** Seeing an IP in the same `/24` as known Mullvad relays is useful analyst context, but it must not silently become a provider verdict.
- **Tier A still requires redistribution rights.** Most provider lists belong in Tier B recipes, where clients fetch from the original authority.
- **Every source needs parser tests, live smoke fixtures, cadence, keep-stale behavior, and a legal note.**

The enrichment pass added exact-IP Tier B recipes for Mullvad (also Mozilla/Firefox VPN infrastructure), IVPN, Private Internet Access, AirVPN, Windscribe, PrivadoVPN, RiseupVPN, WLVPN/IPVanish white-label infrastructure, WorldVPN, OVPN, Anonine, NordVPN (opt-in heavy), and VPN Gate (opt-in public relays). It also added opt-in DNS-expanded recipes for provider-published hostnames from Surfshark, IPVanish, PrivateVPN, PureVPN, TorGuard, FastestVPN, VPNSecure, TunnelBear, StrongVPN, VyprVPN, Giganews VyprVPN, SlickVPN, AzireVPN, VPN.AC, Trust.Zone, VPNBook, and FreeVPN.us. Apple Private Relay stays `relay`, and Cloudflare ranges stay context-only. The public source/dossier ledgers also document negative findings for major brands such as Opera VPN, Brave/Guardian VPN, Cloudflare WARP, Google One VPN / VPN by Google, Hotspot Shield, Touch VPN, Betternet, VPN 360, UltraVPN, Norton VPN, McAfee VPN, Bitdefender, Kaspersky, ESET, F-Secure, Avast/AVG, Urban VPN, Hola VPN, Bright VPN, Mysterium VPN, Planet VPN, Turbo VPN, 1ClickVPN, VeePN, SkyVPN, X-VPN, MEGA VPN, Spaceship/FastVPN, BullVPN, hidemy.name, FineVPN, ZoogVPN, SuperVPN, VPN Super, FreeVPN.org/FreeVPNApp.org, VPNLY, ExpressVPN, CyberGhost, Perfect Privacy, SuperFree VPN, VpnHood, StarVPN, Ivacy, SaferVPN, Tailscale, OpenVPN Connect, SoftEther, TP-Link router VPN docs, Sophos VPN guidance, Canadian Centre VPN guidance, and VPN.com. Those entries are intentional product documentation, not private scratch notes or dead ends; peer/residential/decentralized services are especially important to document because misclassifying real residential nodes as provider-operated `vpn` exits would be worse than missing them. Still-open research candidates include ProtonVPN official alternatives, Kape/Pango white-label brands, Cloudflare WARP-specific egress, and other provider APIs that expose exact IPs without client impersonation. The standard is source quality first, provider coverage second.

## Legal design (load-bearing, do not weaken)

1. **The published artifact contains only data whose exact redistributed form carries explicit rights** — PDDL, CC0, or MIT-explicitly-covering-output — **or uncopyrightable facts that our own code recomputes from a primary source whose terms require nothing beyond attribution.** The second arm exists for one input today: prefix → origin-ASN facts derived by `tools/rib2origin` from RouteViews BGP RIB dumps, credited in [ATTRIBUTION.md](ATTRIBUTION.md) in RouteViews' own words ([D-SRC-2 (backbone)](DECISIONS.md)). It admits facts, never a copy of anyone's files or tables, and never a source whose terms add anything beyond attribution (non-commercial, ShareAlike, no-derivatives, usage caps) or that is protected by a database right we would need permission for: **RIPE RIS stays excluded** (EU sui generis database right plus RIPE NCC's own terms). A builder repo's license does not sanitize the third-party data it aggregates; aggregators are excluded no matter how convenient. That holds for a single field too: ipverse's CC0 covers its categories, but its organization names are bulk RIR WHOIS, so they are a Tier B recipe and never ship ([D-SRC-2](DECISIONS.md)).
2. **Fetching ≠ redistributing.** Anything we may fetch but not republish moves to Tier B: the end user's server fetches it from the original authority, and the data never transits our infrastructure.
3. **ShareAlike never enters the composite** (it would virally relicense everything).
4. **Every upstream license file is SHA-256-pinned** (`data/licenses/`); the nightly build fails loudly if any license text changes. Licenses have changed under projects before (MaxMind, Dec 2019).
5. Our outputs: **pipeline code MIT** ([LICENSE-CODE](LICENSE-CODE)), **data + overrides CC0, forever** ([LICENSE-DATA](LICENSE-DATA)). The open data is the contract: future commercial anything must build *around* it, never by closing it.

## Data quality gates (every nightly build)

- **License pin gate** — any upstream license drift fails the build and opens an issue.
- **Cross-check gate** — ipverse's `category` field is young (added 2026-02) and single-maintainer, so every build measures its hosting coverage against two independent hand-curated reference sets (X4BNet datacenter ASNs ∪ bad-asn-list; 91.3% coverage at floor-setting time, hard floor 60%), holds the hosting-ASN count above an absolute floor of 10,000, and gates day-over-day drift.
- **Delta gate** — every artifact layer must stay within ±20% of the previous build's record count (warning at 5%).
- **Drift policy** ([D-GATE-1](DECISIONS.md)) — drift is judged against the previous build **and** the two most recent weekly dated pins, which are immutable and therefore survive a publish outage. Drops fail above 10%, rises above 20%, both warn above 5%. A move that fails against yesterday but lands within ±5% of a weekly pin is a **recovery** — yesterday was the anomaly — so the build passes and says so in `manifest.json`. A verified-real upstream move can be published by re-running the workflow with an `ack_drift` reason, which is stamped into the manifest permanently. For a permanent step, the ack can also name the metric (`ack_drift_reanchor`), which records the acked value as that metric's reviewed baseline, so the following clean nights pass and weekly pinning resumes (a reviewed baseline is not a pin). Slow slides — a drift small enough to clear the nightly warn line but cumulatively past the drop line versus the best weekly pin — warn loudly, because that is how a degradation reaches production without any single night tripping. This design replaced a single symmetric threshold that deadlocked the nightly for twelve nights in 2026-08/09 (write-up in [DECISIONS.md](DECISIONS.md)).
- **Round-trip gate** — artifacts are reparsed and sample records re-found via the same binary search clients use.
- **Spot panel** — [spotchecks.yml](spotchecks.yml): known IPs (Google, AWS, Cloudflare-via-category, M247, Telefónica residential, T-Mobile, Zscaler, Cogent-stays-unknown, CGNAT boundaries, …) must classify exactly as expected, including *which rule* fired. It is also the cross-client conformance kit — 98 rows covering every rule of the ladder, in both address families, run by the pipeline and by every client: see [CONFORMANCE.md](CONFORMANCE.md).

## The overrides layer (`data/overrides/`)

Our owned, CC0 curation: the classes upstream metadata lacks (`vpn_provider`, `mobile_carrier`, `enterprise_gateway`, `cdn`), extra hosting coverage, eyeball confirmations, per-ASN corrections, and the published organization names (`org_names.txt`, each sourced to a first-party or CC0 page, never to WHOIS). Ground rules:

- **Every line carries a source comment** (`AS9009  # M247 … src: <url> (date)`) — the build *fails* on unsourced lines.
- Candidates are generated from data (`rake overrides:candidates` in the [pipeline repo](https://github.com/openasn/openasn-pipeline) sweeps X4B seeds, org-name patterns, and the crosscheck gap); humans graduate lines into the files. LLM-assisted drafting is welcome; unreviewed bulk imports are not. Every PR here gets instant format feedback from [`scripts/lint_overrides.rb`](scripts/lint_overrides.rb).
- Prefer false negatives: a missed VPN ASN costs a little recall; a mislabeled eyeball ISP hurts real users. When unsure, leave it out or write a `corrections.yml` entry that yields `unknown`.
- Genuine upstream errors should also be PR'd to [ipverse/as-metadata](https://github.com/ipverse/as-metadata) — fix data at the source.

The whole contributor flow — evidence URL → one sourced line → lint → PR, the curation bar for each file, and what we don't accept — is in [CONTRIBUTING.md](CONTRIBUTING.md). Wrong verdict for an IP? [Open a data correction](.github/ISSUE_TEMPLATE/data-correction.yml). Security reports have their own private channel ([SECURITY.md](SECURITY.md)); a wrong verdict is a data error, not a vulnerability.

## What this can and cannot tell you

**Can:** recognize known infrastructure (datacenters, VPN providers, Tor exits, cloud egress) with high confidence; identify the network type behind an IP (residential ISP, mobile carrier, business, education, government); tell you *why* (every verdict is auditable to a source).

**Cannot:** classify address space nobody announces in BGP (the backbone is origin ASN *as RouteViews' peers see it*; an allocated-but-unannounced block returns `unknown`; unannounced space carries essentially no public traffic, and a prefix seen by only one RouteViews peer AS is treated the same way); detect residential proxies (real home IPs relaying malicious traffic — that requires behavioral data nobody can ship offline); prove any IP is "safe"; keep up with VPN infrastructure churn faster than its nightly cadence + your Tier B refresh; guarantee IPv6 overlay parity (the VPN/dc range overlays are IPv4-only upstream; v6 leans on ASN-level flags — documented lower confidence).

**Wrong users:** banks, crypto exchanges, KYC flows, high-chargeback marketplaces. You need paid behavioral intelligence (MaxMind Anonymous IP/Residential Proxy, IPQS, …); OpenASN is at most your prefilter.

## Building the dataset yourself

The compiler lives in [`openasn/openasn-pipeline`](https://github.com/openasn/openasn-pipeline) (MIT). Clone both repos side by side:

```bash
git clone https://github.com/openasn/openasn
git clone https://github.com/openasn/openasn-pipeline
cd openasn-pipeline
ruby pipeline/run.rb           # full build into build/dist/ (~950MB downloads incl. RouteViews RIBs; needs Ruby + Go)
rake 'lookup[8.8.8.8]'         # classify an IP against your build
```

The nightly build runs from [this repo's workflow](.github/workflows/nightly-build.yml) at 03:17 UTC and publishes to the rolling `latest` release; PRs to this repo get instant data lint (`scripts/lint_overrides.rb`, stdlib-only).

## Related projects

OpenASN stands on excellent shoulders: [RouteViews](https://www.routeviews.org/) (BGP RIB archives, CC BY 4.0, University of Oregon — our IP→ASN backbone is recomputed from them), [ipverse/as-metadata](https://github.com/ipverse/as-metadata) (CC0 ASN categories), [X4BNet/lists_vpn](https://github.com/X4BNet/lists_vpn) (MIT VPN/dc ranges), [brianhama/bad-asn-list](https://github.com/brianhama/bad-asn-list) (MIT hosting ASNs). If OpenASN is useful to you, star them too — and send corrections upstream. Earlier releases used [sapics/ip-location-db](https://github.com/sapics/ip-location-db) (PDDL) as the backbone; thank you, sapics.

[![Powered by RouteViews](https://assets.routeviews.org/logos/png/transparent-background/routeviews-powered-by-black_transparent_SMALL.png)](https://www.routeviews.org/)

## License

Code: [MIT](LICENSE-CODE). Data (artifacts + `data/overrides/`): [CC0 1.0](LICENSE-DATA). Attribution for MIT- and CC BY-licensed inputs ships in every release ([ATTRIBUTION.md](ATTRIBUTION.md)).
