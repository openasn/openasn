# 🛰️ OpenASN — open-source IP origin intelligence

**Classify any IP as residential, mobile, hosting, VPN, Tor, relay, business, or unknown — offline, explainably, without API calls.**

OpenASN is an open data project: a legally clean, offline database for answering *"what kind of network is this IP really coming from?"* It compiles permissively licensed ASN metadata, IP→ASN backbones, VPN/datacenter overlays, and hand-curated corrections into small binary artifacts (~6MB for all of IPv4) that applications query locally in microseconds — zero API calls, zero per-lookup cost, and no user IPs ever sent to a third party.

This repository is the **dataset**: the curated override layer, the pinned upstream licenses, the public specs (artifact format, spot-check panel, Tier B fetch manifest), and the nightly releases. It is the heart of the OpenASN project:

| repo | what |
|---|---|
| [`openasn/openasn`](https://github.com/openasn/openasn) | **this repo** — the open data: curation, specs, provenance receipts, releases |
| [`openasn/openasn-pipeline`](https://github.com/openasn/openasn-pipeline) | the compiler: fetch → legal/quality gates → pack → validate → publish (runs nightly via [this repo's workflow](.github/workflows/nightly-build.yml)) |
| [`openasn/openasn-ruby`](https://github.com/openasn/openasn-ruby) | the first client: the `openasn` Ruby gem (future: `openasn-js`, `openasn-python`, …) |

The artifact format is public and language-neutral ([FORMAT.md](FORMAT.md)) — clients in any language are welcome.

> [!IMPORTANT]
> **What OpenASN is NOT.** It is not a fraud engine. It cannot prove an IP is safe or that a user is human. **A clean or `residential_isp` verdict is absence of evidence, not proof of innocence.** Residential proxies — malicious traffic exiting through real home IP addresses — are structurally hard to detect offline, and OpenASN does not claim to detect them. `vpn`, `hosting`, and `tor_exit` verdicts are high-confidence; treat everything else as a signal, not a sentence. Never hard-block `relay`, `cgnat`, or `mobile` — those are real people. OpenASN is a first line of defense, not a fraud engine.

## What you get (nightly, from the [`latest` release](https://github.com/openasn/openasn/releases/latest))

| File | What it is |
|---|---|
| `openasn-ipv4.bin` / `openasn-ipv6.bin` | Packed classification artifacts: IP→ASN backbone with category/role/flag bits + VPN/datacenter range overlays. Byte spec: [FORMAT.md](FORMAT.md) |
| `asn-categories.csv` | Human-friendly table: every ASN → org, country, category, network role, OpenASN flags (CC0) |
| `manifest.json` | Build id, per-file SHA-256, and full source provenance (upstream URL, license, license-file hash, fetch time) |
| `fetch-manifest.json` | The Tier B recipe (see "Legal design") that clients execute themselves |
| `ATTRIBUTION.md` / `SHA256SUMS` | Credits and checksums |

Always download via the tag-addressed URL `releases/download/latest/<file>` — assets are replaced nightly. A dated release is cut weekly for pinning (`releases/download/<YYYY-MM-DD>/<file>`). Do NOT use `releases/latest/download/<file>`: it resolves via GitHub's "Latest" badge, not the `latest` tag, and can serve a stale weekly snapshot (see DECISIONS.md D-REL-1).

## Verdict taxonomy

Clients classify with a strict precedence ladder (overlays outrank ASN classification; specials outrank everything):

`residential_isp` · `mobile` · `business` · `hosting` · `vpn` · `tor_exit` · `relay` · `enterprise_gateway` · `education` · `government` · `cgnat` · `private` · `unknown`

Design notes that keep verdicts honest:

- **`relay` and `enterprise_gateway` are first-class, never folded into `vpn`/`hosting`.** iCloud Private Relay egress lives inside Cloudflare/Akamai space and Apple explicitly says to treat it like carrier-grade NAT; Zscaler/iboss egress is entire companies and school districts. Misfiling either blocks real humans.
- **VPN and datacenter signals are independent bits, not a hierarchy** — measured: only ~70% of known-VPN space sits inside datacenter lists. Both overlays are recorded separately.
- **Pure tier-1 backbone space classifies `unknown` on purpose** (Cogent, Lumen, Arelion…): "we can't tell" beats a confident wrong answer. The four consumer giants that also run tier-1 backbones (AT&T, Verizon, Deutsche Telekom, Liberty Global) are eyeball-confirmed by curation. Full reasoning: [DECISIONS.md](DECISIONS.md).
- **`unknown` is a feature.** Mixed-use ASNs (an ISP that also sells VPS) stay `unknown` with the raw category/role exposed, so *you* choose the policy.
- **The enum is a cross-language contract and it is append-only**: verdicts are never removed, renamed, or redefined; additions arrive via client releases (never via data refreshes — artifacts carry ranges and flag bits, clients compile the verdict mapping). Every OpenASN client must document the same guarantee ([details](DECISIONS.md)).

## Architecture: the three tiers

```
Tier A (this repo, in the artifact)      Tier B (your server fetches directly)
─────────────────────────────────       ─────────────────────────────────────
sapics origin-asn   (PDDL)  backbone     Apple Private Relay egress → :relay
ipverse as-metadata (CC0)   categories   Tor Project exits          → :tor_exit
ipverse as-ip-blocks(CC0)   prefixes     AWS/GCP/Azure/OCI/DO/…     → :hosting+provider
X4BNet lists_vpn    (MIT)   vpn/dc       Proton/Mullvad/IVPN/PIA…   → :vpn+provider
bad-asn-list        (MIT)   hosting      Cloudflare ranges          → context flag
data/overrides/     (CC0)   our layer    Zscaler egress             → :enterprise_gateway
                                         Nord/VPN Gate              → opt-in :vpn+provider
```

**Tier A** sources carry explicit redistribution rights and are compiled into the published artifacts. **Tier B** sources are either license-restricted from republishing or too fast-moving for a nightly file (Tor exits change hourly) — so we publish the *recipe* (`fetch-manifest.json`: URL, parser id, cadence, failure policy) and clients pull from the original authorities at runtime. **Tier C** (bring-your-own MaxMind/IP2Location, planned) never touches this pipeline. The catalog of rejected sources and why (PeeringDB's AUP, GPL lists, ShareAlike databases, aggregator repackaging…) lives in the project history — the short version is the next section.

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

The enrichment pass added exact-IP Tier B recipes for Mullvad (also Mozilla/Firefox VPN infrastructure), IVPN, Private Internet Access, AirVPN, Windscribe, PrivadoVPN, RiseupVPN, WLVPN/IPVanish white-label infrastructure, WorldVPN, NordVPN (opt-in heavy), and VPN Gate (opt-in public relays). It also added opt-in DNS-expanded recipes for provider-published hostnames from Surfshark, IPVanish, PrivateVPN, PureVPN, TorGuard, FastestVPN, VPNSecure, TunnelBear, StrongVPN, VPNBook, and FreeVPN.us. Apple Private Relay stays `relay`, and Cloudflare ranges stay context-only. The public source/dossier ledgers also document negative findings for major brands such as Opera VPN, Brave/Guardian VPN, Cloudflare WARP, Hotspot Shield, Touch VPN, Betternet, VPN 360, UltraVPN, Norton VPN, McAfee VPN, Bitdefender, Kaspersky, ESET, F-Secure, Avast/AVG, Urban VPN, Hola VPN, Bright VPN, Mysterium VPN, Planet VPN, Turbo VPN, 1ClickVPN, VeePN, SkyVPN, X-VPN, MEGA VPN, Spaceship/FastVPN, BullVPN, hidemy.name, FineVPN, ZoogVPN, SuperVPN, VPN Super, FreeVPN.org/FreeVPNApp.org, VPNLY, ExpressVPN, CyberGhost, Perfect Privacy, SuperFree VPN, VpnHood, and StarVPN. Those entries are intentional product documentation, not private scratch notes or dead ends; peer/residential/decentralized services are especially important to document because misclassifying real residential nodes as provider-operated `vpn` exits would be worse than missing them. Still-open research candidates include ProtonVPN official alternatives, Kape/Pango white-label brands, Cloudflare WARP-specific egress, and other provider APIs that expose exact IPs without client impersonation. The standard is source quality first, provider coverage second.

## Legal design (load-bearing, do not weaken)

1. **The published artifact contains only data whose exact redistributed form carries explicit rights** — PDDL, CC0, or MIT-explicitly-covering-output. A builder repo's license does not sanitize the third-party data it aggregates; aggregators are excluded no matter how convenient.
2. **Fetching ≠ redistributing.** Anything we may fetch but not republish moves to Tier B: the end user's server fetches it from the original authority, and the data never transits our infrastructure.
3. **ShareAlike never enters the composite** (it would virally relicense everything).
4. **Every upstream license file is SHA-256-pinned** (`data/licenses/`); the nightly build fails loudly if any license text changes. Licenses have changed under projects before (MaxMind, Dec 2019).
5. Our outputs: **pipeline code MIT** ([LICENSE-CODE](LICENSE-CODE)), **data + overrides CC0, forever** ([LICENSE-DATA](LICENSE-DATA)). The open data is the contract: future commercial anything must build *around* it, never by closing it.

## Data quality gates (every nightly build)

- **License pin gate** — any upstream license drift fails the build and opens an issue.
- **Cross-check gate** — ipverse's `category` field is young (added 2026-02) and single-maintainer, so every build measures its hosting coverage against two independent hand-curated reference sets (X4BNet datacenter ASNs ∪ bad-asn-list; 91.3% coverage at floor-setting time, hard floor 60%) and fails on collapse or >30% day-over-day swings.
- **Delta gate** — every artifact layer must stay within ±20% of the previous build's record count.
- **Round-trip gate** — artifacts are reparsed and sample records re-found via the same binary search clients use.
- **Spot panel** — [spotchecks.yml](spotchecks.yml): known IPs (Google, AWS, Cloudflare-via-category, M247, Telefónica residential, T-Mobile, Zscaler, Cogent-stays-unknown, CGNAT boundaries, …) must classify exactly as expected, including *which rule* fired.

## The overrides layer (`data/overrides/`)

Our owned, CC0 curation: the classes upstream metadata lacks (`vpn_provider`, `mobile_carrier`, `enterprise_gateway`, `cdn`), extra hosting coverage, eyeball confirmations, and per-ASN corrections. Ground rules:

- **Every line carries a source comment** (`AS9009  # M247 … src: <url> (date)`) — the build *fails* on unsourced lines.
- Candidates are generated from data (`rake overrides:candidates` in the [pipeline repo](https://github.com/openasn/openasn-pipeline) sweeps X4B seeds, org-name patterns, and the crosscheck gap); humans graduate lines into the files. LLM-assisted drafting is welcome; unreviewed bulk imports are not. Every PR here gets instant format feedback from [`scripts/lint_overrides.rb`](scripts/lint_overrides.rb).
- Prefer false negatives: a missed VPN ASN costs a little recall; a mislabeled eyeball ISP hurts real users. When unsure, leave it out or write a `corrections.yml` entry that yields `unknown`.
- Genuine upstream errors should also be PR'd to [ipverse/as-metadata](https://github.com/ipverse/as-metadata) — fix data at the source.

## What this can and cannot tell you

**Can:** recognize known infrastructure (datacenters, VPN providers, Tor exits, cloud egress) with high confidence; identify the network type behind an IP (residential ISP, mobile carrier, business, education, government); tell you *why* (every verdict is auditable to a source).

**Cannot:** detect residential proxies (real home IPs relaying malicious traffic — that requires behavioral data nobody can ship offline); prove any IP is "safe"; keep up with VPN infrastructure churn faster than its nightly cadence + your Tier B refresh; guarantee IPv6 overlay parity (the VPN/dc range overlays are IPv4-only upstream; v6 leans on ASN-level flags — documented lower confidence).

**Wrong users:** banks, crypto exchanges, KYC flows, high-chargeback marketplaces. You need paid behavioral intelligence (MaxMind Anonymous IP/Residential Proxy, IPQS, …); OpenASN is at most your prefilter.

## Building the dataset yourself

The compiler lives in [`openasn/openasn-pipeline`](https://github.com/openasn/openasn-pipeline) (MIT). Clone both repos side by side:

```bash
git clone https://github.com/openasn/openasn
git clone https://github.com/openasn/openasn-pipeline
cd openasn-pipeline
ruby pipeline/run.rb           # full build into build/dist/ (~100MB downloads, ~2 min)
rake 'lookup[8.8.8.8]'         # classify an IP against your build
```

The nightly build runs from [this repo's workflow](.github/workflows/nightly-build.yml) at 03:17 UTC and publishes to the rolling `latest` release; PRs to this repo get instant data lint (`scripts/lint_overrides.rb`, stdlib-only).

## Related projects

OpenASN stands on excellent shoulders: [sapics/ip-location-db](https://github.com/sapics/ip-location-db) (PDDL IP→ASN), [ipverse/as-metadata](https://github.com/ipverse/as-metadata) (CC0 ASN categories), [X4BNet/lists_vpn](https://github.com/X4BNet/lists_vpn) (MIT VPN/dc ranges), [brianhama/bad-asn-list](https://github.com/brianhama/bad-asn-list) (MIT hosting ASNs). If OpenASN is useful to you, star them too — and send corrections upstream.

## License

Code: [MIT](LICENSE-CODE). Data (artifacts + `data/overrides/`): [CC0 1.0](LICENSE-DATA). Attribution for MIT-licensed inputs ships in every release ([ATTRIBUTION.md](ATTRIBUTION.md)).
