# AGENTS.md

Guidance for AI agents (and humans) working in this repository.

Read, in order: `README.md` (what OpenASN is + the legal design),
`FORMAT.md` (byte-exact artifact spec — never change bytes without a
format_version bump), `DECISIONS.md` (implementation-time decisions and the
evidence behind them; do not revert these without new evidence).

Hard rules that override convenience:

1. **Legal invariants** (README "Legal design"): no source enters the
   published artifact without explicit redistribution rights on the exact
   redistributed data. Aggregators never qualify. ShareAlike never enters.
   When in doubt, exclude — Tier B (fetch-manifest.json) exists for a reason.
2. **Every `data/overrides/` line needs a source comment** — the build
   fails otherwise. Prefer false negatives over false positives.
3. **The spot panel (`spotchecks.yml`) is a tripwire**: never bulk-update
   expectations to make CI green; each row change needs a reason in the PR.
4. **Data cadence lives in GitHub Releases**, never in gem version bumps.

Dev loop: `ruby pipeline/run.rb` (full build), `OFFLINE=1` to iterate from
cache, `rake test` for unit tests, `rake 'lookup[IP]'` to debug a verdict.
