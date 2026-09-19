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

## D-DATA-1 — Two dataset tiers: the CC0 core and the maximal-information extended dataset (2026-09-05)

**The goal (owner, 2026-09-05).** OpenASN aims to be the biggest and most complete
open-source database of ASNs and everything related to them — rich information
about every ASN and who operates it (organization, ownership chain, brands,
services, customers, related websites and domains, infrastructure footprint,
jurisdiction, contacts, history, reputation). Information completeness and
richness are goals in themselves; extra information is always good. Reading
Wikipedia, Wikidata, registries, PeeringDB, company sites, news and papers to
become more complete and more accurate is encouraged.

**The tension.** The published artifacts are CC0 with strict provenance (README
"Legal design"): nothing enters them without explicit redistribution rights on
the exact data, aggregators never, ShareAlike never. That bar is right for the
core and wrong for maximal information — most rich sources are CC BY-SA
(Wikipedia text), NC (PeeringDB data) or terms-bound.

**The ruling.** Two tiers, permanently separated:

- **Core** — `openasn-ipv4.bin`/`ipv6.bin`/`orgs.bin`, `asn-categories.csv`,
  `data/overrides/`. CC0. Strict provenance. Unchanged; every legal invariant
  stands. Curators may still *consult* anything per record (D-CUR-1); only the
  sourced conclusion line enters.
- **Extended** — the maximal-information dataset (per-ASN dossiers, traits,
  research records). Compiled from every source we may legally consult and
  record, per record, in our own words, with the exact source URL and date on
  every field. Licensed per its inputs — **CC BY-SA 4.0 by default** (Wikidata
  is CC0; Wikipedia text is CC BY-SA; own-words facts from terms-bound sources
  are cited, never copied in bulk). Published as separate files/repo with its
  own LICENSE and ATTRIBUTION; **never compiled into the core artifacts** and
  never used to relicense them. Staged owner-private under `docs/enrichment/`
  until the publication decision.

**Rules that still bind the extended tier:** per-record consultation (no bulk
mirroring of restricted databases), no active scanning, politeness
(identifying User-Agent, rate caps), short attributed quotes only, and a source
URL on every fact — a fact without a URL is not data. Sibling project with the
same ethos: VehiclesDB.
## D-GATE-1 — Drift gates compare against a frozen weekly baseline, fail asymmetrically, and have an operator ack (2026-09-05)

**The incident.** Between 2026-08-25 and 2026-09-05 the nightly build failed
**twelve nights in a row** and published nothing, leaving `latest` frozen on a
2026-08-24 build made from regressed upstream metadata.

**How bad was the published data, measured rather than assumed.** The manifest
metric collapsed — `hosting_asns` 12,393 → 9,342, −24.6% — but that metric
counts hosting-category ASNs across the *whole* upstream table (124,591 ASNs),
and the ASNs it lost turned out to be overwhelmingly ones with no routed IPv4
presence. Classifying one representative IP per ASN through both shipped IPv4
artifacts (85,193 vs 85,311 routed ASNs) gives the real blast radius:

| | published 2026-08-24 | rebuilt 2026-09-05 |
|---|---|---|
| ASNs verdicting `hosting` | 7,702 | 7,919 |
| ASNs verdicting `unknown` via `no_category` | 1,283 | 1,321 |
| ASNs that go `unknown` → `hosting` between the two | — | **34** |

So consumers saw a **~2.8% shortfall in hosting coverage, not 24.6%**, and 34
ASNs (median ASN 202934 — the 32-bit tail) actually flipped verdict for the
worse. That is a real regression and the gate was right to catch it, but it is
nothing like the manifest number, and this decision records the gap on purpose:
**a gate metric is a proxy, and its movement is not a measure of user harm.**
Say what was measured, measure before claiming impact, and never quote the
tripwire's number as if it were the damage.

The mechanism was not an upstream outage. It was the gate's own design:

1. On 2026-08-24 the upstream ipverse as-metadata `as.json` regressed and the
   hosting-ASN count fell 12,393 → 9,342 (**−24.6%**). The drift gate's single
   symmetric threshold pair was warn 5% / fail 30%, so −24.6% sat *inside* the
   fail line: it only WARNED, and **the degraded build was published**.
2. On 2026-08-25 the 03:17 UTC run saw upstream restored to 12,393 (the
   revert was still HEAD; the day's own commit landed 76 minutes after our
   cron). Against the newly-published 9,342 that is **+32.7%** — past the 30%
   line → FAIL.
3. A failed build publishes nothing, so `latest` stayed at 9,342, so the next
   night compared 12,4xx against 9,342 again, and failed identically. **A
   deadlock with no self-heal**, in which the *correct* value is the one that
   fails and the *wrong* value is the one being protected.

Three distinct defects: a fail line loose enough to ship a −24.6% regression,
a reference that only moves when the gate passes, and no way for an operator
to say "I checked, this move is real" short of editing pipeline source.

**The ruling (permanent, project-wide).** Drift gates — `crosscheck.rb`'s
hosting-ASN count and `validate.rb`'s G4 layer counts, which had the same
shape — share one policy module (`pipeline/lib/drift_gate.rb`) with one log
format and one unblock procedure:

1. **A frozen long-run baseline, not just yesterday.** Every run also reads
   the **two most recent weekly dated pins** (`vYYYY.MM.DD` releases) via
   tag-addressed URLs only (D-REL-1; the Latest badge is never load-bearing).
   Dated pins are immutable and are cut on a schedule, so they are the one
   reference a publish outage cannot corrupt.
2. **Recovery beats the day-over-day comparison.** A move that fails against
   the previous build but lands **within ±5% of a weekly pin** is classified
   `drift RECOVERY`: the *previous* build was the anomaly. The gate PASSES,
   logs the reasoning loudly, and stamps `stats.drift_recovery` into
   `manifest.json`. This is what breaks the deadlock automatically.
   A rescuing pin must itself be healthy — within the same band of the best
   pin — and the closest qualifying pin anchors the decision, not the newest.
   Without that test the rule is direction-agnostic and licenses the opposite
   of a recovery: a failing DROP "rescued" by a pin cut from an already
   degraded build (12,400 → 10,001, −19.3%, passed unacked and was stamped as
   a recovery). **And a pin is only ever cut from a CLEAN build** — the pins
   are this rule's only frozen reference, so freezing a build the gates
   warned about poisons the one thing that can break a deadlock.
3. **Asymmetric, evidence-based lines.** Drops fail above **10%**, rises above
   **20%**, both warn above **5%**. Evidence: the weekly pins moved 12,256 →
   12,316 → 12,363 → 12,377 → 12,393 across 2026-07-05…08-23, at most +0.5%
   per week, and the nightly series moves well under 1% per night — so 5% is
   already >10x observed noise and the only larger move ever seen was a defect.
   Drops are stricter because a missing upstream input produces *blanks*, and
   blanks are exactly this project's D8 tripwire scenario: a slice of ASNs
   silently turning `:unknown`. Rises cannot be produced by a missing input
   and are independently guarded by the spot panel.
4. **An auditable operator path.** `OPENASN_ACK_DRIFT="<reason>"` downgrades a
   drift FAIL to a loud WARN **for that one run** and stamps the reason into
   `manifest.json` (`stats.drift_ack`). It is exposed as the `ack_drift`
   input of the `Build & publish data` workflow, so unblocking a verified-real
   upstream move is a dispatch with a sentence of evidence — and the sentence
   is on the public record forever. The ack does **not** touch absolute floors,
   size bounds, or the spot panel.
5. **Absolute floors are not ackable.** `MIN_HOSTING_ASNS` rises 8,000 →
   **10,000**: the 9,342 defect cleared the old floor, and the floor is the
   only guard on a night with neither a previous manifest nor a pin. Moving it
   requires a reviewed PR carrying the measurement that justifies it.
6. **Slow slides are measured against the pins, and warn.** Every
   night-vs-night threshold shares one blind spot: a move small enough to
   clear the warn line each night accumulates without a single night ever
   tripping — 4% a night for a week is the same −25% that, taken in one step,
   *was* this incident. So every evaluation also measures the total distance
   from the best value the weekly pins have seen, and warns loudly when that
   exceeds the drop line. This one deliberately **warns rather than fails**,
   and it is the single place where "the lines lean strict" is knowingly not
   applied: a failure here would publish nothing, publishing nothing cuts no
   new pin, the anchor would never move, and every later night would fail
   against it — a new deadlock of exactly the shape this decision exists to
   forbid. The hard stop for a slide that reaches dangerous territory is the
   absolute floor, which does not move and cannot be acked.
7. **Silence is a bug.** Every evaluation logs exactly one
   `drift <PASS|WARN|FAIL|RECOVERY|ACKED|SKIP> <metric>:` line carrying the
   numbers and the thresholds, so a green log always answers "did this gate
   run, and against what?". A stale `latest` (>48h) is warned about at build
   start with its age in hours, and the failure issue quotes the gate lines
   from the run rather than listing possible causes.

**The general lesson, binding on every future gate.** A tripwire whose
reference is written *by the thing it guards* can deadlock. Any gate that
compares against previous output must also have a reference that is frozen,
externally dated, and independent of whether the gate passed — and a
documented, recorded way for a human to overrule it once.

## D-SRC-2 (backbone) — The IP→ASN backbone is recomputed by OpenASN from RouteViews RIBs; sapics is retired (2026-09-19)

**Status: ACCEPTED by the coordinator under the owner's delegation (pass-4
ruling CD-12, building on CD-5). Pending the owner's own legal read before
merge**, because item 4 amends README "Legal design" rule 1, the project's
founding legal policy. Nothing here is merged or published.

This is the backbone part of D-SRC-2 ("Tier A sources are judged by their
inputs, not their label"; audit P4-L). The org-names part is decided
separately. Evidence, with exact URLs and dates on every record:
`docs/enrichment/research/parts/P4-B-routeviews-terms-2026-09-19.jsonl`
(terms, 9 records), `P4-B-backbone-measurements-2026-09-19.jsonl` (prototype
numbers, 9 records), and the switchover run logs and samples in
`docs/swarm-2026-09-19/BS-work/`.

**Problem.** sapics `origin-asn` is labelled PDDL, but it is an aggregator.
Its routed part is compiled from RouteViews and RIPE RIS BGP archives. Its
unrouted part fills unannounced RIR allocations with the holder's ASN, taken
from RIR delegated stats: 10.8% of its IPv4 space and 59.8% of its IPv6
space, 99.7% holder-matched (measured 2026-09-18/19). An aggregator's relabel
is not a grant from the authority (rule 1), RIPE RIS carries restrictive
terms and the EU database right, and RIR stats are curation-only (D-SRC-1).

**Ruling.**

1. **Input.** The backbone is compiled by `tools/rib2origin` (openasn-pipeline,
   Go, stdlib only, MIT) from RouteViews TABLE_DUMP_V2 RIB dumps: one
   2-hourly slot per night (the newest slot at least 3 h old; 00:00 UTC for
   the 03:17 cron) from 10 collectors chosen for geography: route-views2,
   route-views.eqix, route-views.linx, decix.fra, route-views.napafrica,
   route-views.sg, route-views.sydney, ix-br.gru, route-views.wide,
   route-views6. That is 186 distinct peer ASes and ~850 MB. RIPE RIS is not
   an input. Six more collectors (256 peer ASes, 1.33 GB) moved IPv4
   coverage by +0.02 pt, so they stay out.
2. **What is published: only `(range, origin ASN)` facts our code
   recomputes.** Origin rule:
   - A path's origin is the last AS of its AS_PATH, ignoring confederation
     segments. A path ending in a multi-member AS_SET has no origin.
   - Bogon origins are dropped (AS0, AS_TRANS, documentation, private and
     reserved ASNs). Dropped prefixes: martians, IPv6 outside 2000::/3, IPv4
     outside /8–/24, IPv6 outside /16–/48.
   - An origin must be seen by **at least 2 distinct peer ASes** (not
     sessions). The origin seen by the most peer ASes wins; ties go to the
     lowest ASN.
   - Nested prefixes are flattened by longest-prefix match; adjacent ranges
     with the same origin are merged.
   No RouteViews file, AS path, peer or timestamp is redistributed.
3. **Unannounced space is `unknown`.** Nothing is filled from RIR stats. A
   range nobody announces is not an origin fact, and the data that would
   fill it is curation-only. Override ASNs with no announced space still go
   through compile.rb's ipverse as-ip-blocks gap-fill; measured, it adds
   nothing today (see Measurements).
4. **Legal design rule 1 is amended** (README), exact text:
   > The published artifact contains only data whose exact redistributed form
   > carries explicit rights — PDDL, CC0, or MIT-explicitly-covering-output —
   > **or uncopyrightable facts that our own code recomputes from a primary
   > source whose terms require nothing beyond attribution.** […] It admits
   > facts, never a copy of anyone's files or tables, and never a source whose
   > terms add anything beyond attribution (non-commercial, ShareAlike,
   > no-derivatives, usage caps) or that is protected by a database right we
   > would need permission for: **RIPE RIS stays excluded** (EU sui generis
   > database right plus RIPE NCC's own terms).

   Why this is safe for RouteViews specifically: "RouteViews Data" is CC BY
   4.0 (no NC, SA or ND; selling derivative works is expressly contemplated).
   Every extra request is attribution-type (link, prescribed sentence, logo,
   boilerplate). Revocation is conditional, "if you do not provide the
   attribution called for above, or if you abuse this permission in any way",
   not at will. A table of which prefix is originated by which ASN is facts:
   CC BY 4.0 §8(a) does not restrict uses that need no licence, US law has no
   database right (Feist), and RouteViews is a US (University of Oregon)
   service. We attribute in full anyway, so we comply if CC BY does reach the
   table. The P3 memo line "attribution is fatal for the core" is superseded
   for recomputed facts only; wholesale CC BY data (e.g. DB-IP) stays in the
   extended tier. Residual risks for the owner: "abuse" is undefined, and
   `archive.routeviews.org/robots.txt` is `Disallow: /` (a crawler signal,
   not a licence term; we fetch 10 named files a night with an identifying
   User-Agent and never list directories). A courtesy note to
   help@routeviews.org is drafted, not sent
   (`docs/swarm-2026-09-19/BS-routeviews-email.md`); sending it is a
   merge prerequisite.
5. **Attribution.** ATTRIBUTION.md (shipped in every release, and embedded
   verbatim in the portable exports once EXPORT_FORMATS lands) carries
   RouteViews' prescribed sentence with "[Product/Report]" filled as
   "product", their boilerplate, link, logo, licence link, DOI
   10.7264/1y7v-2d90, a statement of our changes (CC BY §3(a)(1)(B)) and a
   non-endorsement line. README carries the logo and credit.
6. **Licence gate.** The RouteViews terms are pinned from the WordPress JSON
   rendering of `/routeviews/licenses/` (page 45927, `extract:
   wp_json_rendered_text`, tag-stripped so theme churn cannot trip it;
   sha256 `0887cbd21eab…`, page modified 2026-03-04). The sapics pin is
   removed. Both via `rake licenses:pin` in this PR. The receipt
   `data/licenses/sapics-origin-asn.txt` stays for releases built before the
   switchover.
7. **Rollback.** `OPENASN_BACKBONE=sapics` still selects the old path in the
   pipeline, but the sapics pin is gone, so such a build fails the licence
   gate until someone re-pins it in a reviewed PR. Rolling back is therefore
   deliberate and visible (nightly-build.yml sets
   `OPENASN_BACKBONE: routeviews` explicitly). The sapics code is to be
   deleted in a follow-up once a few weekly pins have been cut from the new
   backbone.

**Measurements.**

| | IPv4 | IPv6 |
|---|---|---|
| origin agreement with sapics where both cover (slot 2026-09-18 20:00) | 98.94% | 97.45% |
| RouteViews covers … of sapics space | 89.17% | 40.16% |
| sapics covers … of RouteViews space | 99.99% | 99.94% |
| compiled verdicts identical where both cover | 99.81% | |
| day-over-day origin agreement (09-17 vs 09-18) | 99.987% | |

Almost all disagreement is one ISP's aggregate vs its regional ASNs (Comcast
AS7922 vs 33491/33651/…), which does not change the verdict. sapics also
published 58 ranges with private or documentation origin ASNs.

**Online switchover build, 2026-09-19** (pipeline `sources/routeviews-backbone`,
dataset `sources/routeviews-backbone`, live fetch, cold cache, RIB slot
20260919.0200, not published):
- Licence gate green on the new pin set (routeviews + four unchanged).
- RIB download 10 files / 853 MB in 2 min 46 s (4 streams, from Europe);
  rib2origin 49 s wall, 1.07 GB max RSS; 1,402,993 prefixes → 399,372 v4 +
  93,894 v6 ranges; whole cold build 4 min 52 s. Warm re-run (RIBs 304) 76 s.
- Drift gates against the published `latest` (2026-09-18) and the pins
  v2026.09.13 / v2026.08.23: `hosting_asns` PASS; `base_ipv4` 443,267 →
  399,372 (−9.9%) **WARN**; `vpn_ipv4`, `dc_ipv4` PASS; `base_ipv6` 125,825 →
  93,894 (−25.4%, −25.5% below the best pin) **FAIL**. With an ack the build
  completes: G5 spot panel **green, 20/20**, round-trip and size gates green.
- The eight override ASNs that lose all space (cdn AS133877, AS23903, AS895,
  AS14153; enterprise_gw AS35788, AS43251; mobile AS5079; vpn AS154050) are
  unannounced: RIPEstat routing-status shows 0 announced prefixes for each
  (last seen between 2018-11 and 2026-01, or never), and ipverse as-ip-blocks
  has an empty or missing list for each, so the online gap-fill added 0
  ranges. Every range sapics assigned them is uncovered by RouteViews; the
  announced more-specifics inside those blocks belong to other origins
  (e.g. Edgio AS14210, Cloudflare AS13335, Fastly AS54113), which the
  backbone already carries.
- Lookup impact of unannounced space turning `unknown`: only unannounced
  space changes, and no public traffic can come from space nobody announces.
  Checked three ways: (a) RouteViews' own view: 98.4% of the sapics-only
  IPv4 space is announced by none of 256 peer ASes (16 collectors); (b) an
  address-weighted random sample of 400 addresses from the 380.9 M
  sapics-only IPv4 addresses, checked against RIPE RIS (RIPEstat
  network-info, consulted per record, never an input): **0 of 400 routed**
  (95% upper bound 0.75%); an earlier 400-address sample found 1 (a /20
  seen by 19 of 325 RIS peers, below our floor in RouteViews); (c) APNIC's per-AS user estimates (window to 2026-09-15): the
  ASNs that have users and disappear entirely versus sapics are 68 ASNs with
  0.017% of estimated users, and the RIPEstat spot-checks of the largest of
  them show their sapics ranges unannounced (0 or 1 of 325 RIS peers). The
  residual real risk is prefixes with partial visibility that fall below the
  2-peer floor: RouteViews saw 6.5 M of the sapics-only IPv4 addresses from
  exactly one peer AS (1.7% of that space; one sampled example,
  113.31.240.0/20, is visible to 19 of 325 RIS peers). Those lookups now say
  `unknown` rather than naming the origin; that is the conservative
  direction (AGENTS rule 2).

**First publish (exact dispatch).** Order: merge openasn-pipeline first (the
nightly checks out its `main`, and the Go module lives there), then this
branch, both before the next 03:17 UTC cron. D-SRC-3 (X4B) is expected to
merge and publish first; it brings the `ack_drift_reanchor` input. Then run
`Build & publish data` from the Actions tab with:

- `ack_drift` = `D-SRC-2 (backbone): the IP->ASN backbone is now recomputed from RouteViews RIBs; sapics' RIR-stats fill of unannounced space is gone (IPv4 ranges -9.9%, IPv6 ranges -25.4%). Evidence: DECISIONS.md D-SRC-2 (backbone).`
- `ack_drift_reanchor` = `base_ipv6`

`base_ipv6` is the only metric that FAILs, and it must be named: it sits
25.5% below the best weekly pin, past the 20% drop line, so a bare ack would
leave every later night WARNing as a slow slide and no weekly pin would be
cut (D-GATE-1 rule 8). `base_ipv4` only WARNs (−9.9%, inside the 20% line
and inside the slide line), so it needs no ack and cannot be re-anchored;
the next night passes against the new `latest` (simulated with the rule-8
gate code). If D-SRC-3 has *not* published first and both land in one run,
use `ack_drift_reanchor` = `vpn_ipv4,base_ipv6` and name both changes in the
reason (combined run measured: vpn_ipv4 6,639 → 4,693, base_ipv6 as above,
panel 21/21 green).

**Merge prerequisites.** Owner legal read of item 4; D-SRC-3 merged (for
`ack_drift_reanchor`), and on rebase the X4B integration test's
`sapics_v4`/`sapics_v6` path keys renamed to `backbone_v4`/`backbone_v6`
(the only semantic conflict between the two branches); the RouteViews
courtesy note sent; launch copy saying "origin ASN as seen in BGP
(RouteViews)". The exports branch rebases after both, and must install Go
from both modules.
