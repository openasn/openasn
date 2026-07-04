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

Always download via `releases/latest/download/<file>` — assets are replaced nightly. A dated release is cut weekly for pinning.

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
X4BNet lists_vpn    (MIT)   vpn/dc       ProtonVPN first-party      → :vpn+provider
bad-asn-list        (MIT)   hosting      Cloudflare ranges          → context flag
data/overrides/     (CC0)   our layer    Zscaler egress             → :enterprise_gateway
```

**Tier A** sources carry explicit redistribution rights and are compiled into the published artifacts. **Tier B** sources are either license-restricted from republishing or too fast-moving for a nightly file (Tor exits change hourly) — so we publish the *recipe* (`fetch-manifest.json`: URL, parser id, cadence, failure policy) and clients pull from the original authorities at runtime. **Tier C** (bring-your-own MaxMind/IP2Location, planned) never touches this pipeline. The catalog of rejected sources and why (PeeringDB's AUP, GPL lists, ShareAlike databases, aggregator repackaging…) lives in the project history — the short version is the next section.

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
