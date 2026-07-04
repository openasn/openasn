# OASN binary artifact format — v1

This is the byte-exact specification for `openasn-ipv4.bin` and
`openasn-ipv6.bin`. Two independent implementations exist and MUST stay in
lockstep with this document:

- writer + reference reader: `pipeline/lib/binary.rb` in [`openasn/openasn-pipeline`](https://github.com/openasn/openasn-pipeline)
- production reader: `lib/openasn/binary_format.rb` in [`openasn/openasn-ruby`](https://github.com/openasn/openasn-ruby)

Any byte-layout change requires bumping `format_version` and coordinating a
gem release that understands both versions. Do not "extend compatibly" —
readers reject unknown versions on purpose (a half-understood artifact is
worse than a failed update, which keeps last-good data).

All integers are **big-endian** (network order). All ranges are inclusive
`[start, end]`. Within every layer, records are sorted ascending by `start`
and are non-overlapping.

## Header — 32 bytes

| offset | size | field | value |
|---|---|---|---|
| 0 | 4 | magic | `"OASN"` (0x4F 0x41 0x53 0x4E) |
| 4 | 1 | format_version | `0x01` |
| 5 | 1 | address_family | `0x04` (IPv4) or `0x06` (IPv6) |
| 6 | 2 | reserved | `0x0000` |
| 8 | 8 | build_unix_ts | u64, seconds since epoch, UTC |
| 16 | 4 | base_record_count | u32 |
| 20 | 4 | vpn_overlay_count | u32 |
| 24 | 4 | dc_overlay_count | u32 |
| 28 | 4 | relay_overlay_count | u32 — always 0 in the canonical artifact (relay data is Tier B, applied client-side); the slot exists so a future edition can ship prebuilt overlays without a format bump |

Layers follow the header immediately, concatenated in header order:
base, vpn, dc, relay.

## Layer 1 — base records

IP-to-ASN backbone with classification flags baked in.

| family | record layout | size |
|---|---|---|
| IPv4 | start u32 · end u32 · asn u32 · flags u16 | 14 bytes |
| IPv6 | start u128 · end u128 · asn u32 · flags u16 | 38 bytes |

### flags (u16) bit layout

| bits | meaning | values |
|---|---|---|
| 0–3 | category | 0=nil 1=isp 2=hosting 3=business 4=education_research 5=government_admin (6–15 reserved) |
| 4–7 | network_role | 0=nil 1=tier1_transit 2=major_transit 3=midsize_transit 4=access_provider 5=content_network 6=stub (7–15 reserved) |
| 8 | bad_asn | membership in brianhama/bad-asn-list |
| 9 | vpn_provider | `data/overrides/vpn_provider.txt` |
| 10 | mobile_carrier | `data/overrides/mobile_carrier.txt` |
| 11 | enterprise_gw | `data/overrides/enterprise_gateway.txt` |
| 12 | cdn | `data/overrides/cdn.txt` |
| 13 | hosting_extra | `data/overrides/hosting_extra.txt` |
| 14–15 | reserved | must be written as 0, must be ignored by readers |

Category/role values come from ipverse as-metadata after applying
`data/overrides/corrections.yml` and `eyeball_confirm.txt` (see
`pipeline/compile.rb` for the exact precedence between those inputs).

## Layers 2–4 — vpn / dc / relay overlays

Anonymous merged ranges (adjacent and overlapping input ranges are
coalesced). Overlap between layers is expected and meaningful — the VPN and
DC overlays are independent signals, never a hierarchy (measured: only
~70% of VPN-listed space is inside the DC list).

| family | record layout | size |
|---|---|---|
| IPv4 | start u32 · end u32 | 8 bytes |
| IPv6 | start u128 · end u128 | 32 bytes |

In v1 canonical artifacts the IPv6 vpn/dc overlay counts are 0 (the
upstream overlay source, X4BNet, is IPv4-only). IPv6 VPN/hosting signal
comes from ASN-level flags instead. Readers must not assume zero, though —
they read whatever the header declares.

## Reading strategy (why this format is fast)

Fixed-size records mean the file needs no index: a binary search over the
raw bytes serves lookups directly. For unsigned big-endian keys, bytewise
string comparison equals numeric comparison, so one search routine handles
IPv4 (4-byte keys) and IPv6 (16-byte keys) identically. Measured on the
proven prototype of this exact strategy: ~19µs/lookup pure Ruby over 433k
records, ~6MB resident. Readers MAY also unpack layers into integer arrays
for ~2µs lookups at ~8x the memory (the gem's `:arrays` mode).

## Sidecar: `openasn-orgs.bin` ("OORG" v1)

ASN → organization name, optional richness (clients work fully without it;
`as_org` is simply nil until it's downloaded). All integers big-endian.

| offset | size | field |
|---|---|---|
| 0 | 4 | magic `"OORG"` |
| 4 | 1 | version `0x01` |
| 5 | 3 | reserved (zeros) |
| 8 | 4 | entry_count u32 |
| 12 | 4 | blob_size u32 |

Then: index of `entry_count × (asn u32 · blob_offset u32)` sorted by asn,
then the UTF-8 name blob. An entry's name length = next entry's offset −
its own (last entry runs to `blob_size`). Names are ipverse as-metadata
descriptions truncated to 96 bytes on valid UTF-8 boundaries.

## Integrity

`manifest.json` in every release carries the SHA-256, byte size, and record
count of each artifact, plus per-source provenance (upstream URL, license,
license-file SHA-256, fetched_at). Clients MUST verify the SHA-256 of a
downloaded artifact against the manifest before atomically swapping it in.
`SHA256SUMS` (sha256sum -c compatible) is provided for humans and shell.
