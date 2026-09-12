# Contributing to OpenASN

This repository is **data**, not code. Almost every contribution is one of two
things: a **correction** (an IP or ASN classifies wrong) or a **source** (a list
we should be reading). Both are welcome, and both are held to the same bar:
**a claim without a source URL is not data.**

The compiler lives in [`openasn/openasn-pipeline`](https://github.com/openasn/openasn-pipeline);
the clients live in their own repos. If your issue is "the gem/package crashed",
file it there. If your issue is "the verdict is wrong", it belongs here.

---

## The two-tier data model (read this before proposing a source)

OpenASN keeps two permanently separated datasets ([DECISIONS.md](DECISIONS.md), **D-DATA-1**).
The **core** — the published artifacts (`openasn-ipv4.bin`, `openasn-ipv6.bin`,
`asn-categories.csv`) and `data/overrides/` — is **CC0 with strict provenance**:
nothing enters it unless the exact redistributed bytes carry explicit
redistribution rights (PDDL, CC0, or MIT that covers the output), which is why
aggregators and ShareAlike sources are excluded no matter how convenient they
are. The **extended tier** — the richer per-ASN record (organization, ownership
chain, brands, services, infrastructure footprint, jurisdiction, history) — is
compiled from every source we may legally *consult and record in our own words
with the exact URL*, is **licensed per its inputs (CC BY-SA 4.0 by default)**,
and is published separately with its own LICENSE and ATTRIBUTION. The two are
never mixed: extended-tier research may *motivate* a core line, but only an
original, evidenced conclusion line with a URL actually enters `data/overrides/`,
and the extended tier is never compiled into the artifacts or used to relicense
them. Curators may consult anything per record while researching (**D-CUR-1**);
what they may *publish into the core* is the narrow, clean thing.

---

## How a correction flows

Five steps, in this order. Any step you skip is a step a reviewer has to do for
you, which is why PRs that skip them sit.

**1. Get evidence, and get a URL for it.**
A source is a page anyone can open and check: the operator's own site or status
page, RDAP/whois for the ASN, the upstream record we got it wrong from
(`https://raw.githubusercontent.com/ipverse/as-metadata/master/as.json`), a
regulator's licence register, the vendor's published egress list. "I run this
network" and "everybody knows" are not sources — if you *do* run the network,
link something public that shows it. Note the date you checked: sources move.

**2. Write one line in the right file.**
Every entry in `data/overrides/*.txt` is exactly:

```
AS<number>  # <org> — <why this class>. src: <url> (<YYYY-MM-DD>)
```

for example, from `data/overrides/enterprise_gateway.txt`:

```
AS22616   # ZSCALER INC. (US). src: ipverse as-metadata description "ZSCALER INC." (2026-07-04)
```

The `src:` comment is not decoration — it is the file's whole value. A reviewer
must be able to judge the line in seconds: which org, why this class, where it
says so, when you looked. One ASN per line, one topic per PR.

For category/role errors that no flag file fits, use `data/overrides/corrections.yml`
instead (schema in that file's header — `category`, optional `network_role`,
`reason`, `source_url`, `date`, all required except `network_role`).

**3. Run the lint.**

```bash
ruby scripts/lint_overrides.rb
```

Stdlib-only, no bundler, no pipeline checkout, instant. It checks the line
shape, that every line carries a source, that no ASN is in `eyeball_confirm.txt`
*and* an infrastructure list, that `corrections.yml` uses valid vocabulary, and
that `fetch-manifest.json` and `spotchecks.yml` still parse. The same script
runs on every PR ([`.github/workflows/lint.yml`](.github/workflows/lint.yml)),
and the authoritative version of these rules runs again inside every nightly
build — so a line that fails lint would have failed the build.

**4. Open the PR** with the [pull request checklist](.github/PULL_REQUEST_TEMPLATE.md)
filled in. Say what changed and why in the description; the diff shows the rest.

**5. Expect a question.** Curation review is adversarial on purpose — the
reviewer's job is to try to break your line (same-name lookalike? mixed-use
org? is this really *dedicated* mobile?). That is not distrust, it is the
process that keeps the file worth citing.

Not sure enough to write a line? Open a
[data correction issue](.github/ISSUE_TEMPLATE/data-correction.yml) with the
evidence and let a curator decide. A well-evidenced issue is more useful than a
guessed override.

---

## Upstream first

Most category and role data comes from [ipverse/as-metadata](https://github.com/ipverse/as-metadata)
(CC0) and most prefix data from [sapics/ip-location-db](https://github.com/sapics/ip-location-db)
(PDDL). **When the error is genuinely upstream's, fix it upstream** — open the
PR or issue against `ipverse/as-metadata` first, then, if the fix will take time
to land or upstream declines, file the local override here and link the upstream
issue in the `src:` comment or PR description. Fixing data at the source helps
every consumer of that dataset, not just us, and it keeps our override files
small enough to review by hand. `corrections.yml` says the same thing in its own
header: "Where the correction is genuinely upstream's bug, ALSO open a PR/issue
against https://github.com/ipverse/as-metadata — fixing it at the source helps
everyone and keeps this file small."

The override layer is also deliberate insurance: an entry that changes nothing
today still pins the answer if upstream has a bad day. That is a legitimate
reason for a line, as long as it is sourced like any other.

---

## The spot panel is a tripwire, never a target

[`spotchecks.yml`](spotchecks.yml) is the panel of known IPs that must classify
exactly as expected — including *which rule* fired. It is asserted by the
pipeline on every build and by the clients (see [CONFORMANCE.md](CONFORMANCE.md)
for the client-side contract).

**Never bulk-edit rows to make CI green.** A red row means one of two things:
we introduced a bug, or the internet changed. Find out which — classify the IP
(`rake 'lookup[IP]'` in the pipeline repo), read `sources` to see which rule
won — and then either fix the bug the row caught, or change *that one row* in a
PR whose description says **what changed in the world** and how you verified it.
Every changed row needs its own stated reason. A PR that edits several rows with
one blanket "updated spotchecks" will be asked to split.

Adding rows is easier than changing them: a new row that pins a case we care
about (a rule with thin coverage, a country's biggest eyeball network, a
provider that keeps moving) is a welcome contribution on its own.

---

## The curation bar, per file

Each file in `data/overrides/` carries its own bar in its header, and the header
is the spec — read it before adding a line. In short:

**`vpn_provider.txt`** — sets the `vpn_provider` flag; every IP announced by the
ASN becomes `vpn`. The header: *"the ASN must be either (a) hand-curated as VPN
infrastructure by X4BNet (first-party, MIT), or (b) registered to an organization
whose primary business is a consumer VPN/anonymizer product, evidenced by the
ipverse as-metadata description (CC0). Mixed-use hosting providers whose
customers **include** VPNs (e.g. Datacamp/CDN77's parent AS60068) do NOT belong
here — the range overlay handles those selectively."* The file also carries a
standing counter-example: AS27683 "VPN de Mexico S.A. de C.V." is a corporate
connectivity telco, not an anonymizer — *"keyword matches are candidates, never
members."*

**`mobile_carrier.txt`** — sets `mobile_carrier`; the verdict tells apps "one IP
here is hundreds of humans behind carrier NAT". The header, *"deliberately strict
for the seed"*: the ASN must carry *"a carrier's MOBILE subscriber traffic
specifically — not a converged telco ASN mixing fixed broadband on the same AS
(those stay `:residential_isp`…)"*, and *"Fixed-wireless ISPs (WISPs) do NOT
belong here: their subscribers are homes with stable IPs."* Known incompleteness
is fine; *"misclassified entries are the only real bug class for this file."*
(See **D-IMPL-4**.)

**`enterprise_gateway.txt`** — sets `enterprise_gw`; classifies
`enterprise_gateway`, deliberately *above* the hosting rules, because this
traffic is humans-at-work behind Zscaler-style egress. The header: *"ASN
registered to a recognized SWG/SSE vendor whose product proxies customer web
traffic through vendor-operated egress."* Per **D-ENRICH-1** this file is
**SWG/SASE vendor egress only** — a corporation's own ASN, however large, is
`business`, not `enterprise_gateway`.

**`cdn.txt`** — sets the `cdn` flag (contributes to `hosting`, and surfaces in
`sources` so apps can special-case CDN traffic). The header: *"globally
recognized CDN brands only, ASN registered to the brand itself (beware same-name
lookalikes: AS149097 'FASTLY NETWORK SOLUTION COMPANY LIMITED (VN)' is NOT Fastly
Inc; AS13188 'CONTENT DELIVERY NETWORK LTD (UA)' is a Ukrainian access ISP — both
excluded)."* And the standing warning: *"never blanket-BLOCK CDN ranges"* —
Cloudflare space carries iCloud Private Relay and WARP egress, which are real
humans.

**`hosting_extra.txt`** — sets `hosting_extra` for datacenter ASNs upstream does
not categorize as hosting. The header, *"strict — a wrong entry here mislabels
humans as servers"*: *"(a) listed in BOTH X4B datacenter input AND bad-asn-list
(two independent curators agree), or (b) listed in one of them AND the org is
name-evidently a hosting company / verifiable hosting brand."* When unsure, leave
it out — the X4B datacenter *range* overlay still covers those providers'
published ranges.

**`eyeball_confirm.txt`** — forces `category=isp` + `network_role=access_provider`,
which is how the consumer giants that also run tier-1 backbones avoid the honest
`unknown` that pure-transit ambiguity earns. The header: *"major consumer
broadband/mobile ISP, verified against ipverse as-metadata description + public
knowledge of the brand. If an ASN here ever appears in an infrastructure list
(vpn/dc/bad-asn), the build FAILS (overrides sanity check) — resolve via
corrections.yml, not by having it both ways."*

**`corrections.yml`** — per-ASN category/role fixes, applied last (wins over
upstream *and* over `eyeball_confirm.txt`). The header: *"Use this file when
upstream is verifiably wrong about an ASN and the fix doesn't fit a flag list:
e.g. a university mislabeled hosting, an ISP mislabeled government."*

Across all of them, one rule outranks recall: **prefer false negatives.** A
missed VPN ASN costs a little recall; a mislabeled eyeball ISP hurts real people.
When you are unsure, leave it out, or write a `corrections.yml` entry that yields
`unknown` and lets the application decide.

---

## What is not accepted

- **Unsourced lines.** No URL, no date, no line. The lint rejects them and the
  nightly build rejects them. This is not negotiable, including for maintainers.
- **ShareAlike sources, and aggregators.** ShareAlike would virally relicense the
  whole composite, so it never enters the core. Aggregators are excluded no
  matter how convenient: a builder repo's own license does not sanitize the
  third-party data it repackages. Bring the **original authority**, or nothing.
  (If a source is fetchable but not redistributable, it is a **Tier B** recipe in
  [`fetch-manifest.json`](fetch-manifest.json) — the client fetches it directly
  from the authority and the data never transits our infrastructure. That is the
  right home for most provider lists.)
- **Bulk imports.** Scripted dumps of somebody's list into an override file, or
  hundreds of lines in one PR, are not reviewable and will be closed. Candidates
  can absolutely be *generated* (`rake overrides:candidates` in the pipeline repo
  sweeps X4B seeds, org-name patterns, and the crosscheck gap) — a human then
  graduates them one evidenced line at a time. LLM-assisted drafting is welcome
  on the same terms: the model may draft, a human verifies each line against its
  source and signs for it.
- **Bulk-mirrored restricted databases, and active scanning.** Per-record
  consultation of registries, PeeringDB pages, operator sites and the like is
  fine and encouraged (**D-CUR-1**); mirroring them wholesale is not, and we do
  not scan anyone's network. Fetch politely, with an identifying User-Agent.
- **Spot-panel rows edited to go green** — see above.
- **Changes to `data/licenses/pins.json`.** Pins are generated by the pipeline's
  `rake licenses:pin` in a reviewed PR; a hand-edited pin defeats the gate whose
  entire job is to notice when an upstream license text changed.
- **Byte-layout changes without a `format_version` bump**, and any removal or
  renaming in the verdict enum — it is an append-only cross-language contract
  (**D-IMPL-6**).

---

## Reporting something other than a data error

- **A wrong verdict, a missing ASN, a stale provider range** → the
  [data correction issue template](.github/ISSUE_TEMPLATE/data-correction.yml).
- **A security problem** (in the workflows, the lint script, a client, or the
  release/supply chain) → [SECURITY.md](SECURITY.md). Data errors are not
  security vulnerabilities.
- **A client bug** (crash, API behaviour, packaging) → that client's repo.
- **A conformance divergence** — two clients disagreeing on the same bytes → see
  [CONFORMANCE.md](CONFORMANCE.md); that is a bug in whichever client differs
  from the gem, unless it is one of the documented deliberate divergences.

## Licensing of contributions

Data contributions to this repository (override lines, corrections, spot-panel
rows) are released under [CC0 1.0](LICENSE-DATA), like the rest of the core
dataset. Script contributions are [MIT](LICENSE-CODE). By opening a PR you
confirm you have the right to contribute the content under those terms — which,
in practice, means the same thing the source rules already require: your line is
your own conclusion from a public source, not a copy of someone else's database.
