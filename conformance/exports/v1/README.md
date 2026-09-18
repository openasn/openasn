# Export conformance fixtures, v1

Public conformance fixtures for the portable export contract in
[EXPORT_FORMATS.md](../../../EXPORT_FORMATS.md): schema 1, classification
profile `core-v1`, lookup policy 1.

They are tracked here so any implementation, in any language, inside or
outside this project, can vendor the same expectations and be checked against
the same evidence. Producers, readers, and updaters all test against these
files; that is what makes "conforming" mean something across implementations.

| File | What it pins |
|---|---|
| `profile-fixtures.json` | Every core-v1 precedence row, the multi-source hosting ordering, AS0 presence, overlay-only records, and the inputs a canonical writer must reject (reserved category and role codes, reserved flag bits, a null ASN carrying ASN evidence) |
| `projection-fixture.json` | A complete ten-row effective-interval stream: overlay splits inside a base row, an overlay crossing a base boundary, an overlay-only segment in a gap, gaps that are not bridged, and the expected coverage counts |
| `lookup-policy-fixtures.json` | Lookup policy 1: input parsing, IPv4-mapped normalization, every special range's first address, last address, and the addresses immediately before and after it, plus the full invalid-input list |
| `sqlite-v1.sql` | The SQLite v1 schema. `EXPORT_FORMATS.md` embeds this file, and CI fails if the two copies diverge, so there is one schema and not three hand-copied ones |

## Rules

**Expectations are hand-authored. No implementation may regenerate them from
its own output.** A fixture derived from the code under test proves only that
the code agrees with itself, which is precisely the failure these files exist
to catch. When an implementation disagrees with a fixture, the default
assumption is that the implementation is wrong; changing a fixture requires
the reasoning that shows the contract itself was wrong, and the contract
changes with it.

`profile-fixtures.json` encodes evidence as the raw 16-bit flag word from the
native artifact (see [FORMAT.md](../../../FORMAT.md) for the bit layout), so a
fixture case is independent of any particular decoder. `defaults` supplies the
fields a case does not state.

`projection-fixture.json` uses offsets from `1.0.0.0`, so the ranges are
small, synthetic, and in ordinary-address space. Its `flags` values are test
context: the emitted payload must decode them into the named fields, and
`flags` is not a field of any export.

`lookup-policy-fixtures.json` separates what the contract fixes from what the
data decides. A case with `data_dependent: true` leaves `lookup_status`,
`verdict`, and `sources` null, because the answer depends on the records in
the installed generation and pinning a live address here would turn a data
refresh into a test failure. The assertion in those cases is the one the
policy owns: that the address was parsed, assigned to the right family,
normalized correctly, and **not** intercepted by the special table.

These fixtures cover the contract, not a release. They say nothing about
whether any particular asset has been published.
