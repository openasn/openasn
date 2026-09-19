# Attribution

OpenASN's canonical artifacts are compiled exclusively from sources whose
exact redistributed data carries explicit redistribution rights. This file
ships inside every release. Full license texts as fetched and pinned:
`data/licenses/` in the repository; the build fails if any upstream license
text changes (SHA-256 pinning).

## Sources requiring attribution (MIT)

### X4BNet / lists_vpn — VPN & datacenter range overlays, ASN curation seeds
- https://github.com/X4BNet/lists_vpn
- License: MIT — per the project README, the license covers "the scripts,
  automation, and the list itself (source files and generated output)".
- Copyright (c) 2024 X4B (Mathew Heard)
- What OpenASN takes: only X4B's own work. That is its hand-curated ASN lists
  (`input/*/ASN.txt`, expanded against the backbone below) and its manual
  netblocks (`input/*/ips/Manual.txt`), used to keep the matching ranges of
  X4B's published lists. X4B's generated lists also merge third-party feeds
  (Apple iCloud Private Relay egress, Mullvad, Private Internet Access,
  Proton VPN). Those feeds are not X4B's to license, so OpenASN strips them
  and does not republish them. They are Tier B (see below). Decision:
  DECISIONS.md D-SRC-3.

### brianhama / bad-asn-list — curated hosting/cloud/colo ASN list
- https://github.com/brianhama/bad-asn-list
- License: MIT
- Copyright (c) 2025 Brian Hamachek

## Public-domain sources (credited with thanks; attribution not required)

### sapics / ip-location-db (`origin-asn`) — the IP→ASN backbone
- https://github.com/sapics/ip-location-db
- License: PDDL v1.0 ("free use without attribution")
- Compiled by sapics from RIR delegated statistics and Route Views / RIPE
  RIS BGP archives. Thank you for maintaining the cleanest-licensed
  IP→ASN dataset on the internet.

### ipverse / as-metadata — ASN descriptions, countries, categories, roles
- https://github.com/ipverse/as-metadata
- License: CC0 1.0

### ipverse / as-ip-blocks — per-ASN announced prefixes
- https://github.com/ipverse/as-ip-blocks
- License: CC0 1.0

## OpenASN's own layer

- `data/overrides/` (curated ASN classifications and corrections):
  released under CC0 1.0 — public domain, forever.
- Compiled artifacts (`openasn-ipv4.bin`, `openasn-ipv6.bin`,
  `asn-categories.csv`): CC0 1.0.
- The organization-name sidecar `openasn-orgs.bin`, and the portable
  representations of the same core specified in EXPORT_FORMATS.md
  (`openasn.sqlite.gz`, `openasn.csv.gz`, `openasn.mmdb`): CC0 1.0. They are
  projections of the artifacts above, compiled from the same build and the
  same sources, so every notice in this file applies to them unchanged. This
  text is embedded verbatim in the SQLite metadata and in the MMDB
  description, so an export carries its attribution even when separated from
  the release.
- Pipeline code: MIT (see LICENSE-CODE).

## Not in these artifacts, by design

Tier B sources (Apple iCloud Private Relay egress, the Tor Project bulk
exit list, cloud provider ranges, first-party VPN provider lists, ...) are
fetched by OpenASN *clients* directly from the original authorities at
runtime, per `fetch-manifest.json`. They are never republished in these
releases — either because their terms don't grant third-party
redistribution, or because they change too fast for a nightly artifact to
be honest. This boundary is deliberate and load-bearing; see README
("Legal design") before moving anything across it.
