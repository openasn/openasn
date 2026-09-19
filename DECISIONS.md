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

8. **An acknowledged step change re-anchors its own metric** (added
   2026-09-19 under D-SRC-3, decided by the coordinator under owner
   delegation). Rules 4 and 6 together had a gap. An ack publishes a
   deliberate step change (D-SRC-3: `vpn_ipv4` 6,639 → 4,692). From the
   next night the value sits past the drop line below the best pin, which
   is a WARN(SLIDE) every night. A warned build is not clean, so no weekly
   pin is ever cut again, for any metric, and the pins only age. The fix:
   - An acked evaluation of a metric the operator **names** in
     `OPENASN_ACK_DRIFT_REANCHOR` (the `ack_drift_reanchor` dispatch input)
     stamps a **reviewed baseline** for that metric into `manifest.json`
     (`stats.reviewed_baselines.<metric>` = value, ack reason,
     `reviewed_at`). Each build carries it forward. A bare ack keeps rule 4's
     meaning, one run only, and leaves the pins alone. The name is required
     because the ack covers every metric that fails in the run, while a run
     stops at the first failure, so the operator acks having seen only one.
     Re-anchoring on the ack alone silently re-anchored an unseen second
     failure. It also made a transient move acked as real deadlock when
     upstream snapped back, because the pre-ack pins that rule 2 needs to
     recognise the recovery were gone (adversarial review RX, 2026-09-19;
     `docs/swarm-2026-09-19/RX-REVIEW.md`).
   - For that metric only, pins cut before `reviewed_at` are ignored. The
     reviewed value stands in for them as the recovery reference and as the
     slow-slide anchor. Once clean pins cut after it exist, they are used,
     and the reviewed baseline retires when no consulted pin predates it.
   - Every other metric is gated against the pins exactly as before.
   - **A reviewed baseline is not a pin.** It is never a release, and only
     an ack that names the metric writes it: a human, with a sentence on
     the public record. The
     acked build itself stays unclean and is never pinned. "Pins come from
     clean builds only" is unchanged. What changes is that the next clean
     build is clean, so pinning resumes on schedule.
   - A new drop measured against the reviewed value still fails or warns
     normally. The review sanctions one move, not a direction.
   Tests: `ReviewedBaselineTest` in the pipeline repo (ack → next night
   clean, no perpetual warn, pins resume, un-acked metric gated normally,
   the old pin cannot return as anchor, an unnamed co-failing metric is not
   re-anchored, a bare ack still lets a recovery self-heal).

**The general lesson, binding on every future gate.** A tripwire whose
reference is written *by the thing it guards* can deadlock. Any gate that
compares against previous output must also have a reference that is frozen,
externally dated, and independent of whether the gate passed — and a
documented, recorded way for a human to overrule it once.

## D-SRC-3 — X4B overlays carry only X4B's own data; its third-party feeds are stripped (2026-09-19)

**Status: accepted. Decided by the coordinator on 2026-09-19 under owner delegation.**

**What was wrong.** X4BNet/lists_vpn is Tier A because its MIT grant covers
"the list itself (source files and generated output)". But its build
(`.github/workflows/build-list.yml`) concatenates every file in
`input/<list>/ips/` into `output/<list>/ipv4.txt`, and X4B's own scheduled
workflows fill `input/vpn/ips/` with lists X4B does not own:

| file | written from | first seen |
|---|---|---|
| `apple.txt` | `https://mask-api.icloud.com/egress-ip-ranges.csv` (iCloud Private Relay egress) | 2025-06-29 |
| `mullvadvpn.txt` | `https://api.mullvad.net/www/relays/all` | 2025-04-13 |
| `pia.txt` | `https://raw.githubusercontent.com/Lars-/PIA-servers/refs/heads/master/export.csv` (repo has no licence) | 2025-06-28 |
| `protonvpn.txt` | `https://api.protonmail.ch/vpn/logicals` (workflow disabled 2025-06-29; frozen file still merged) | 2023-02-07 |
| `input/datacenter/ips/protonvpn.txt` | one 2023-02-09 snapshot of the same Proton API | 2023-02-09 |

This project classes every one of those as Tier B ("never republished",
ATTRIBUTION.md). Taking X4B's output whole therefore republished them, which
breaks README "Legal design" rule 1: a builder repo's licence does not
sanitize third-party data it aggregates. It also broke a product rule. Apple
relay egress shipped as `vpn` (for example `104.28.28.0–104.28.28.76`, AS13335,
`core_verdict=vpn`, `core_sources=["x4b_vpn"]`), although README says relay is
never folded into `vpn`.

**Verified, not assumed** (P4-X, against X4B commit `07f9013b`, the one whose
output OpenASN had cached). X4B's build was reproduced offline, and the
reproduction explains every address of the published vpn list. 100% of each
feed's CIDRs are inside it. The four feeds account for 124,207 of its
3,197,515 addresses (3.88%; Apple alone 3.33%). 114,507 of those (3.58%) are
covered only by a feed, not by X4B's own ASN list. Evidence:
`docs/enrichment/research/parts/P4-X-x4b-feeds-2026-09-19.jsonl`.

**The ruling.**

1. X4B's published `output/` files are an **upper bound**, never taken
   whole. A range is kept only where X4B's **first-party** inputs justify it:
   its hand-curated `input/<list>/ASN.txt`, expanded against OpenASN's own
   backbone, and its hand-curated `input/<list>/ips/Manual.txt`. A feed entry
   inside a listed ASN stays, because X4B's own ASN entry covers it (e.g.
   Proton servers inside AS208172, which X4B lists).
2. **vpn is a whitelist**: `kept = published ∩ justified`. This is the
   directory X4B's feed bots write to, so the rule must also exclude a feed
   X4B adds in the future, and a feed file updated between two X4B builds,
   without anyone naming it first. The only cost beyond the feeds is 1,024
   addresses (four /24s) where X4B's expansion database (iptoasn.com) and
   our backbone disagree about the origin ASN.
3. **datacenter subtracts the named feed file**:
   `kept = published − (feeds − justified)`. A whitelist was built and
   measured here, then rejected. X4B's datacenter expansion disagrees with
   our backbone on ~222k addresses, and applying the whitelist would have
   moved real cloud space from `hosting` to `business` (GCP 35.208.0.0/15:
   iptoasn says AS15169, our backbone says AS43515). No X4B workflow writes
   to `input/datacenter/ips/`, so naming its single third-party file is
   precise. If X4B ever adds a file there, it must be named in the pipeline
   (`Sources::X4B_DC_FEEDS`). The pipeline never calls api.github.com, so
   it cannot list the directory for itself.
4. Neither method can add a range X4B did not publish. Feed files are read
   only in order to subtract them. That is D-CUR-1 consultation; their
   contents are never republished.
5. Apple relay, Mullvad, PIA and Proton keep reaching users the way they
   always should have: as `fetch-manifest.json` Tier B recipes, which
   clients fetch from the original authority.

**Blast radius, measured** (offline build, identical inputs, before vs after;
`openasn-ipv6.bin`, `openasn-orgs.bin` and `asn-categories.csv` are
byte-identical apart from the build timestamp):

| layer | ranges | addresses |
|---|---|---|
| vpn (IPv4) | 6,644 → 4,692 (−29.4%) | 3,197,515 → 3,081,984 (−3.61%) |
| datacenter (IPv4) | 30,157 → 30,105 (−0.17%) | −300 |

115,628 IPv4 addresses change verdict. All but 97 of them leave `vpn`:
73,702 go to `hosting` (x4b_dc), 36,288 to `hosting` (category), 4,314 to
`unknown` (feed entries in tier-1 transit space: Cogent AS174 3,165, GTT
AS3257 696), 1,115 to `business`, and 112 to `residential_isp`. The largest ASNs are the Apple
relay hosts: Akamai AS36183 (59,354), Cloudflare AS13335 (19,779), Fastly
AS54113 (15,972) and Akamai AS20940 (11,516). In the core these become
`hosting`, the same answer the rest of Apple's relay space already gets. They
become `relay` wherever a client runs the Tier B recipe, which is the design.

**Gates.** The spot panel is green before and after, and no row changed. The
G4 layer drift gate FAILS once, on `vpn_ipv4`: 6,639 in `latest` → 4,692,
which is −29.3% against a 20% drop line, with no weekly pin within 5%. The
first publish therefore needs a dispatch with
`ack_drift="D-SRC-3: X4B third-party feeds (Apple relay, Mullvad, PIA, Proton) removed from the vpn overlay"`
and `ack_drift_reanchor=vpn_ipv4`. The other layers pass.

**Resolved before first publish: a deliberate step change now re-anchors
its own metric** (D-GATE-1 rule 8). Before this, from the night after the
acked publish, `vpn_ipv4` would have sat about 29% below the best weekly pin
(v2026.09.13, 6,593). Rule 6 would have turned that into a WARN(SLIDE) every
night. A warned build is never clean, so no weekly pin would ever have been
cut again, for any layer. Now the ack, naming `vpn_ipv4`, records a reviewed baseline for
`vpn_ipv4` (4,692, with the ack reason and date). The next clean build is
clean, and weekly pinning resumes. The coordinator ruled this a precondition
for publishing (2026-09-19).

**Policy: anonymity egress that X4B lists by ASN is treated as `vpn` in the
core.** X4B's first-party `input/vpn/ASN.txt` lists AS60729
(`AS60729 # Tor Servers (Tor exit nodes)`), so that ASN's space is kept and
classifies `vpn` (spot panel row 185.220.101.5 already says so). `tor_exit`
is the more precise verdict, but the core cannot carry it honestly:

- FORMAT.md has no Tor flag bit, and bits 14–15 are reserved; using them
  needs a `format_version` bump.
- Its only range layer for this is `relay`, which is Tier B and always 0 in
  the canonical artifact.
- D-FMT-1's frozen export profile rules out `tor_exit` and `relay` as
  `core_verdict` by design.
- An ASN is not an exit list. Exits churn hourly, which is why the Tor
  Project bulk exit list is Tier B.

So no remapping is proposed. Clients that run the Tier B tor recipe already
answer `tor_exit` for actual exits, because it outranks the X4B vpn overlay
in the client ladder. Everything else in that ASN stays `vpn`, the honest
Tier A answer for anonymity-network egress.
