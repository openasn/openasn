# AGENTS.md

Guidance for AI agents (and humans) working in this repository.

This is the OpenASN **dataset** repo: curated overrides, pinned upstream
license receipts, the public specs (FORMAT.md, spotchecks.yml,
fetch-manifest.json), and the nightly releases. The compiler lives in
[openasn/openasn-pipeline](https://github.com/openasn/openasn-pipeline)
(checked out by `.github/workflows/nightly-build.yml`, or as a sibling dir
for local work); the Ruby client lives in
[openasn/openasn-ruby](https://github.com/openasn/openasn-ruby).

Read, in order: `README.md` (what OpenASN is + the legal design),
`FORMAT.md` (byte-exact artifact spec — never change bytes without a
format_version bump), `DECISIONS.md` (implementation decisions and the
evidence behind them; do not revert these without new evidence).

Hard rules that override convenience:

1. **Legal invariants** (README "Legal design"): no source enters the
   published artifact without explicit redistribution rights on the exact
   redistributed data. Aggregators never qualify. ShareAlike never enters.
   When in doubt, exclude — Tier B (fetch-manifest.json) exists for a reason.
2. **Every `data/overrides/` line needs a source comment** — PRs are
   linted (`ruby scripts/lint_overrides.rb`) and the nightly build
   re-validates. Prefer false negatives over false positives.
3. **The spot panel (`spotchecks.yml`) is a tripwire**: never bulk-update
   expectations to make CI green; each row change needs a reason in the PR.
4. **Data cadence lives in GitHub Releases**, never in gem version bumps.
5. **`data/licenses/pins.json` changes only via `rake licenses:pin`** (in
   the pipeline repo) inside a reviewed PR explaining what changed upstream.
6. **Research and enrichment passes save everything they learn.** A
   curation line is the tip; the research record is the asset. Every
   research or enrichment pass persists its full findings (identity,
   brands, parent, jurisdiction, infrastructure facts, negative findings)
   as structured records with the exact source URL and date on every
   field — never just the conclusion. Public files carry the sourced
   conclusion; the rich record lives in the enrichment layer
   (`docs/enrichment/` until published as CC0 traits/dossiers). If you
   looked it up, write it down.
7. **Power laws decide the order of work.** The top ~20% of entities (by
   eyeball population, address space, customer cone, traffic, or provider
   size) produce 80%+ of the value of any pass. Rank targets by impact
   before spending effort, finish the head of the distribution to full
   depth before touching the tail, and say what was skipped and why.
