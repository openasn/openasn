# Attribution

OpenASN's canonical artifacts are compiled exclusively from sources whose
exact redistributed data carries explicit redistribution rights, plus one
class of input: uncopyrightable facts that OpenASN's own code recomputes from
a primary source whose terms require nothing beyond attribution (the IP→ASN
backbone, below). This file ships inside every release. Full license texts as
fetched and pinned: `data/licenses/` in the repository; the build fails if any
upstream license text changes (SHA-256 pinning).

## RouteViews — the IP→ASN backbone (CC BY 4.0)

[![RouteViews](https://assets.routeviews.org/logos/png/transparent-background/routeviews-powered-by-black_transparent_SMALL.png)](https://www.routeviews.org/)

This product utilizes data provided by RouteViews (www.routeviews.org). Use of
this data is subject to the CC BY 4.0 license.

With contributions from network operators and volunteers all over the world,
RouteViews collects BGP data by direct peering at Internet Exchange Points
(IXPs) or multi-hop peering. Data are archived and made publicly available for
download at archive.routeviews.org, lg.routeviews.org, and api.routeviews.org.

- Website: https://www.routeviews.org/
- Terms: https://www.routeviews.org/routeviews/licenses/ (pinned in
  `data/licenses/routeviews.txt`)
- License: Creative Commons Attribution 4.0 International,
  https://creativecommons.org/licenses/by/4.0/
- Citation DOI: 10.7264/1y7v-2d90
- Logo: https://www.routeviews.org/routeviews/logos/
- What OpenASN takes from it: every night, one BGP RIB dump from each of ten
  RouteViews collectors. OpenASN's own code (`tools/rib2origin` in
  openasn-pipeline, MIT) recomputes from them a table of address range →
  origin ASN, and only that table enters the artifacts. No RouteViews file,
  AS path, peer or timestamp is redistributed. Changes: OpenASN keeps an
  origin only when at least two distinct peer ASes see it, drops bogon
  prefixes and origins, flattens nested prefixes by longest match, and merges
  adjacent ranges; the exact rules are in DECISIONS.md, "D-SRC-2 (backbone)".
- RouteViews does not endorse OpenASN, and OpenASN's classifications are not
  RouteViews data.

## Sources requiring attribution (MIT)

### X4BNet / lists_vpn — VPN & datacenter range overlays, ASN curation seeds
- https://github.com/X4BNet/lists_vpn
- License: MIT — per the project README, the license covers "the scripts,
  automation, and the list itself (source files and generated output)".
- Copyright (c) 2024 X4B (Mathew Heard)

### brianhama / bad-asn-list — curated hosting/cloud/colo ASN list
- https://github.com/brianhama/bad-asn-list
- License: MIT
- Copyright (c) 2025 Brian Hamachek

## Public-domain sources (credited with thanks; attribution not required)

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
- Pipeline code: MIT (see LICENSE-CODE).

## Former sources

- **sapics / ip-location-db (`origin-asn`, PDDL v1.0)** was the IP→ASN backbone
  of every release built before the RouteViews switchover (DECISIONS.md,
  "D-SRC-2 (backbone)"). It was retired because it is itself compiled from
  RouteViews and RIPE RIS BGP archives and from RIR delegated statistics, and
  README "Legal design" rule 1 excludes aggregators. Thank you to sapics for
  years of a well-kept public table. Its pinned terms stay in
  `data/licenses/sapics-origin-asn.txt` as the receipt for those releases.

## Not in these artifacts, by design

Tier B sources (Apple iCloud Private Relay egress, the Tor Project bulk
exit list, cloud provider ranges, first-party VPN provider lists, ...) are
fetched by OpenASN *clients* directly from the original authorities at
runtime, per `fetch-manifest.json`. They are never republished in these
releases — either because their terms don't grant third-party
redistribution, or because they change too fast for a nightly artifact to
be honest. This boundary is deliberate and load-bearing; see README
("Legal design") before moving anything across it.
