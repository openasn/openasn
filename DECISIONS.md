# Implementation decisions log

Decisions made at implementation time (2026-07-04) that refine or deviate
from the founding spec, with the evidence that forced them. Read this
before "fixing" any of these back.

## D-IMPL-1 — Transit-role eyeballs stay `:residential_isp`; only `tier1_transit` is ambiguous

**The problem.** The founding spec's precedence had `category==isp AND
role∈{tier1,major,midsize}_transit → :unknown` ("ISP+transit ambiguity"),
while its own acceptance panel required Telefónica ES → `:residential_isp`.
Live ipverse data (2026-07-04) breaks the tie: ipverse assigns networkRole
by routing-graph position, so essentially EVERY national consumer telco
carries a transit role — Comcast/Telefónica/Vodafone DE/Orange/BT/TIM are
`major_transit`; AT&T/Verizon/DT are `tier1_transit`. Measured impact of
the rule as originally written: **40.2% of routed IPv4 space would classify
`:unknown`** (isp+tier1 6.6% + isp+major 24.7% + isp+midsize 8.9%),
including virtually all of Europe's and North America's home users. That
contradicts the panel, the validated prototype behavior, and the product's
first-boot usefulness requirement.

**The resolution.**
- `category==isp` + any role except `tier1_transit` → `:residential_isp`.
- `category==isp` + `tier1_transit` → `:unknown` (rule `isp_transit_ambiguous`).
- The tier1 set is tiny and hand-reviewable: **19 ASNs worldwide**
  (measured 2026-07-04). Exactly four are consumer-heavy — AT&T AS7018
  (89M IPs), Verizon AS701 (41M), Deutsche Telekom AS3320 (34M), Liberty
  Global AS6830 — and are confirmed as eyeballs in
  `data/overrides/eyeball_confirm.txt`. The rest (Lumen AS3356, Cogent
  AS174, GTT AS3257, NTT AS2914, Zayo AS6461, PCCW AS3491, Tata AS6453,
  Arelion AS1299, Orange OpenTransit AS5511, Sparkle AS6762, Telefónica
  Global AS12956, two IXPs, …) are genuine backbone space and stay
  honestly `:unknown` (~60M IPs).

**Why this is the right trade.** International backbone arms are usually
separate ASNs from consumer arms (AS5511 vs AS3215; AS6762 vs AS3269;
AS12956 vs AS3352), so ASN granularity already encodes the distinction —
except for the four confirmed giants. Sophisticated consumers can still
read `network_role` from the result and apply their own transit policy.

## D-IMPL-2 — Panel row 81.9.5.10 expects `:business` (was `:unknown`)

The founding panel expected `:unknown` based on the February-2026
prototype, whose simplified classifier had no `:business` verdict (its
`:other` bucket was relabeled). Live data: 81.9.5.10 belongs to AS20597
(PJSC Vimpelcom), which ipverse now categorizes `business`/`stub` — the
production precedence correctly yields `:business` via the category rule.
Updated in `spotchecks.yml` with a history note.

## D-IMPL-3 — License pins target what actually declares the license

Planned pins assumed each upstream has a LICENSE file. Reality
(2026-07-04): sapics/ip-location-db has none — the PDDL declaration for
origin-asn lives in `origin-asn/SOURCES.md` (pinned whole). X4BNet has none
— MIT lives in README.md under "# License" including the load-bearing
"source files **and generated output**" sentence; we pin that extracted
section only, so unrelated README churn can't trip the gate but any edit
to the grant does (`pipeline/lib/license_gate.rb`).

## D-IMPL-4 — `mobile_carrier.txt` seeds dedicated-mobile ASNs only

Keyword sweeps surface converged telcos (fixed+mobile on one ASN: KDDI,
SoftBank, SFR, Vodafone national ASNs…) and fixed-wireless WISPs. Both are
deliberately excluded: converged ASNs stay `:residential_isp` (equally
likely_human — a miss costs nothing), and WISP subscribers are homes, not
carrier NAT. The seed carries only unambiguous cellular networks; recall
grows via PRs under the same rule.

## D-IMPL-5 — Repo topology: dataset / pipeline / clients (2026-07-04)

The project split into three repos, and the naming convention changed:

- **`openasn/openasn`** (this repo) — the dataset: curation, license
  receipts, public specs, releases. The flagship; stars, PRs, and the
  download URL all concentrate here. Nothing here requires running code
  beyond a stdlib lint script.
- **`openasn/openasn-pipeline`** — the compiler. Separated so data
  contributions and pipeline engineering have distinct issue trackers,
  reviewers, and cadence. The nightly workflow deliberately stays in THIS
  repo: it publishes releases here with the repo's own token, and once the
  pipeline repo is public the nightly needs zero secrets.
- **`openasn/openasn-ruby`** (renamed from `openasn/ruby`) — clients carry
  the `openasn-<language>` pattern so future `openasn-js`/`openasn-python`
  fit, and each repo name means something standalone. Gem name on RubyGems
  remains `openasn`.

**On keeping the pipeline closed as "the moat" — considered and rejected.**
The pipeline is a few thousand lines of fetch/merge/pack that anyone could
reimplement from FORMAT.md and the public source list; secrecy buys ~zero
defense. The durable moats are (a) the curation flywheel in this repo,
(b) the trust position — auditable compilation is what makes "legally
clean, CC0" credible, and the public license gate is the receipts — and
(c) the operational track record. The open-core contract stands: pipeline
MIT, data CC0 forever; commercial editions (Pro DB, hosted API, SLAs) are
future SEPARATE products, never a closing of the core. The pipeline repo
may sit private during pre-launch incubation like everything else, but the
plan of record is public-at-launch.

## D-IMPL-6 — The verdict enum is an append-only, cross-language contract (2026-07-04)

Adopted from the sibling VehiclesDB project's stable-ID discipline (their
slugs-never-change rule), because downstream code will `case` on verdicts
and parse `to_h` shadow logs — those are API surface:

- The 13-verdict enum is **append-only**: entries are never removed,
  renamed, or semantically redefined (that would be a major version of
  every client). New verdicts may be added in client minor versions with
  prominent CHANGELOG notice; consumers are told to keep an `else` branch.
- **Verdicts are code, not data.** Artifacts carry ranges + flag bits;
  clients compile the bit→verdict mapping. Therefore a nightly data
  refresh can never surface a verdict a deployed client doesn't know —
  auto-applying data updates is always safe. Introducing a verdict that
  needs a NEW flag bit also requires a FORMAT.md reserved-bit allocation,
  which is already version-gated.
- Result/`to_h` keys are append-only; `sources`/`context_flags` symbols
  are explicitly informational (may grow without notice).
- Every client in every language (openasn-ruby today; openasn-js et al.
  later) implements the same enum and documents this same contract — the
  Ruby gem's README "API stability contract" section is the reference text.

## D-REL-1 — Release URLs are tag-addressed; the "Latest" badge is never load-bearing (2026-07-05)

**The incident.** GitHub exposes two asset-URL shapes that look
interchangeable and are not: `releases/download/<tag>/<file>` resolves by
TAG; `releases/latest/download/<file>` resolves by the "Latest" BADGE —
whichever non-draft, non-prerelease release was CREATED last, because the
REST param `make_latest` defaults to `"true"` for every new release.
Badge/link semantics: https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases
· make_latest default: https://docs.github.com/en/rest/releases/releases#create-a-release
On 2026-07-05 the first weekly dated snapshot was cut without
`--latest=false`, took the badge from the rolling `latest` release, and
every badge-form consumer — the gem's default `release_url`, the release
notes' own documented fetch URL, and the pipeline's previous-manifest
fetch feeding the ±20% delta gates — began resolving to a frozen snapshot
that would have served up to 6-day-stale data between Sundays.

**The rules** (enforced in openasn-pipeline `pipeline/publish.rb`, pinned
by its `test/publish_test.rb`; gem side pinned in `test/updater_test.rb`):

- Docs and consumers use ONLY the tag-addressed form
  `releases/download/latest/<file>`. The badge form may appear in docs
  solely inside a same-line "do not use" warning.
- Dated releases are ALWAYS created with `--latest=false`
  (https://cli.github.com/manual/gh_release_create — boolean negation must
  be the single-token `=false` form).
- Every nightly re-asserts `--latest` on the rolling release after asset
  upload (self-heals if a manual release ever steals the badge) and
  re-stamps the release body with the current `build_id` + layer counts.
  Release bodies are human convenience; machines read `manifest.json`.
- Net effect: the UI badge always sits on the rolling release, but that is
  cosmetic alignment — nothing may DEPEND on the badge.

## D-IMPL-NAMING — Release tags: v-prefixed, dot-separated, hyphen-free (2026-07-05)

Cross-project standard shared with VehiclesDB: dated pins are `vYYYY.MM.DD`
(this project, nightly cadence — the date IS the version); monthly-cadence
datasets use `vYYYY.MM.P` (VehiclesDB, where the patch auto-increments).
Rationale: one recognizable family format, no hyphens, `v` prefix matches
ecosystem conventions, lexicographic order == chronological order. The
rolling `latest` release is a service pointer, not a version, and is
unchanged. `pin_version` is a free string so no client change is needed.
The one pre-standard tag, `2026-07-05`, was renamed to `v2026.07.05` on
2026-07-07 for coherence (same snapshot commit; old URL now 404s); no
other pre-standard tags exist.

Release **titles** share the same family: `<Project> <dotted-version>`
(`OpenASN 2026.07.05`, mirroring `VehiclesDB 2026.07.3` — the title drops
the tag's `v`). OpenASN appends ` · Nightly rolling` / ` · Weekly snapshot`
to disambiguate its two streams (VehiclesDB has one, so needs no suffix);
dates are dotted, never hyphenated, and the short `OpenASN ` lead keeps the
date inside GitHub's ~25-char sidebar truncation.

## D-CUR-1 — Curation inputs are consult-with-care; only published data must be redistribution-clean (2026-07-06)

The legal invariant (README "Legal design") governs what OpenASN
**publishes**: no byte enters the artifacts without explicit redistribution
rights on the exact redistributed data. It does not govern what a curator may
**read** while deciding a label: consulting a source and writing an original,
evidenced conclusion is ordinary curation — the same act as a human reading
PeeringDB before writing a sourced override line. This applies equally when
the reading is done by an LLM-assisted drafting tool (the pipeline repo's
`pipeline/enrich/` curation aids).

Four rules bind all curation-time consultation:

1. **Per-record, never bulk.** Look up one ASN as evidence; never mirror a
   restricted database (no dump downloads, no reconstructed copies).
2. **Never republish fetched text.** External evidence lives in prompts and
   gitignored build caches only. The only thing that reaches this repo is a
   human-reviewed override/correction line whose comment cites a URL any
   reviewer can check.
3. **No active scanning.** PTR lookups and homepage GETs are ordinary client
   behavior; port scans and banner grabs are not, and would need their own
   documented decision.
4. **Politeness.** Per-host rate caps, an identifying User-Agent, and
   keep-partial-on-failure semantics.

Tier A compilation inputs are untouched by this decision — the artifact
source rules (explicit redistribution rights only; aggregators never qualify)
stand unchanged. Drafted candidates carry no upstream text into this repo, so
published data stays CC0-clean regardless of what was consulted during
drafting.

## D-ENRICH-1 — `enterprise_gateway` is SWG/SASE vendor egress ONLY; a company's own ASN is `business` (2026-07-07)

**The ambiguity.** An enrichment swarm classifying corporate ASNs (Intel
AS4983, Bank of America AS10794, Cleveland Clinic AS22093, Adhesives Research
AS2020) kept proposing the `enterprise_gateway` verdict, reasoning "these are
humans-at-work, don't block them." That is a defensible reading of the words
but it is NOT how this project uses the class, and left unresolved it makes the
verdict axis inconsistent across the dataset.

**The ruling (one decision, permanent, project-wide).** The `enterprise_gateway`
verdict (flags bit 11, classifier precedence rule 7, membership via
`data/overrides/enterprise_gateway.txt`) is reserved for ASNs registered to a
recognized **Secure Web Gateway / SSE / SASE vendor** whose product proxies
**other organizations'** employee web traffic through vendor-operated egress
(Zscaler, Netskope, Forcepoint, Menlo, iboss, Cloudflare WARP/Gateway, Check
Point Harmony SASE / Perimeter 81). A company that runs **its own** ASN for
**its own** corporate traffic — bank, hospital, manufacturer, tech firm,
retailer — is `business` (ipverse `category==business` → `:business`), **never**
`enterprise_gateway`, even though its users are employees.

**Why.** The class exists solely to prevent the documented false positive of
blocking an entire *third-party* company/school hidden behind a *shared* vendor
gateway (the iboss/Zscaler case, `enterprise_gateway.txt` header). A single
company's own ASN is already handled correctly and safely as `business`; adding
it to the gateway class buys nothing and dilutes the class's meaning.

**Binding on all enrichment.** Swarms map corporate own-ASNs to `business` on
the OpenASN verdict axis. The Linnaeus org axis still labels them richly
(`Enterprise > Technology`, `Financial > Bank`, `Health > Hospitals`, …) — the
two axes are orthogonal (org identity vs. security action). `enterprise_gateway.txt`
membership remains the ONLY path to the `enterprise_gateway` verdict, curated to
the SWG/SASE-vendor bar above. Full enrichment spec: `docs/enrichment/PRD.md`.
