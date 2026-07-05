# VPN Provider Dossiers

Status date: 2026-07-05

This file is the slow, provider-by-provider dossier ledger. It complements
`docs/provider-source-research.md`, which tracks whether a provider has an
OpenASN-compatible source. Each dossier should answer: who operates the service,
where the legal entity is, what the official/legal URLs are, what registry or
founding facts are verified, where OpenASN gets data, and what still needs
verification.

Ground rules:

1. Prefer provider legal pages, official registries, and primary source
   announcements.
2. Separate "service launched/founded" from "legal entity incorporated"; do not
   collapse them unless the source proves they are the same event.
3. If incorporation year cannot be verified from a registry-grade source, say
   so plainly.
4. Source URLs are part of the dossier and must be exact.
5. These dossiers do not create permission to redistribute provider data. They
   document identity and source quality; Tier B legal posture still controls.

## Batch 1 - Implemented Core Providers

### Proton VPN

| Field | Detail |
|---|---|
| Public service URL | `https://protonvpn.com/` |
| Legal / privacy URLs | `https://proton.me/legal/terms`, `https://proton.me/legal/privacy`, `https://proton.me/legal/dpa` |
| Legal entity shown by official pages | Proton AG |
| Address / identifier | Proton AG, Route de la Galaise 32, 1228 Plan-les-Ouates, Switzerland; company identification number `CHE-354.686.492` is stated in Proton's DPA. |
| Registry / incorporation evidence | Geneva commercial-register extract for UID `CHE-354.686.492`; secondary registry pages report commercial register entry/founding date `2014-07-18`, legal form AG / company limited by shares, and commercial register number `CH-660.1.995.014-1`. |
| Who is behind it | Proton says it was born in Switzerland in 2014 by scientists who met at CERN. Proton's public company metadata names Andy Yen as CEO. Proton announced a transition toward the non-profit Proton Foundation structure; treat this as control/ownership context, not a separate source of VPN IP data. |
| OpenASN data source | `protonvpn` uses `https://raw.githubusercontent.com/tn3w/ProtonVPN-IPs/master/protonvpn_ips.txt`, parser `plain_ip_per_line`, provider `ProtonVPN`. |
| Source quality / status | Implemented as default `vpn_providers`, but not first-party. The GitHub repository API reports Apache-2.0 license, so it is a licensed exact feed used because Proton's official VPN logicals API requires app/session auth for anonymous callers. |
| Live smoke | 823 IPv4 ranges, 0 IPv6 ranges on 2026-07-05. |
| Caveats | This is the least ideal source in batch 1 because it is licensed third-party, not Proton-operated. Keep watching for a Proton-published unauthenticated exact IP list or a documented public API that does not require client/session impersonation. |
| Primary source URLs | `https://proton.me/legal/dpa`, `https://proton.me/about`, `https://proton.me/foundation`, `https://proton.me/blog/proton-non-profit-foundation`, `https://app2.ge.ch/ecohrcinternet/extract?companyOfsUid=CHE-354.686.492&lang=en`, `https://www.uid.admin.ch/Detail.aspx?lang=en&uid_id=CHE354686492`, `https://github.com/tn3w/ProtonVPN-IPs` |

### Mullvad VPN

| Field | Detail |
|---|---|
| Public service URL | `https://mullvad.net/en` |
| Legal / privacy URLs | `https://mullvad.net/en/help/terms-service`, `https://mullvad.net/en/help/privacy-policy` |
| Legal entity shown by official pages | Mullvad VPN AB |
| Address / identifier | Mullvad's terms list Mullvad VPN AB, registration number `559238-4001`, PO Box 53049, 40014 Gothenburg, Sweden. |
| Registry / incorporation evidence | Official terms verify the Swedish registration number. Mullvad's own February 2020 corporate-shuffle post says operations were moved into a newly created subsidiary named Mullvad VPN AB. Service launch is older: Mullvad's about page says the service launched in March 2009. |
| Who is behind it | Mullvad says Mullvad VPN AB is owned by parent company Amagicom AB, and both Mullvad VPN AB and Amagicom AB are 100% owned by founders Fredrik Stromberg and Daniel Berntsson, who are actively involved. |
| OpenASN data source | `mullvad_relays` uses `https://api.mullvad.net/www/relays/all/`, parser `mullvad_relays_json`, provider `Mullvad`. |
| Source quality / status | Implemented as default `vpn_providers`. First-party JSON returns exact relay records including hostname, activity state, ownership/provider metadata, and IPv4/IPv6 entry addresses. Parser keeps active relays and exact `ipv4_addr_in` / `ipv6_addr_in`. |
| Live smoke | 496 IPv4 ranges, 532 IPv6 ranges on 2026-07-05. |
| Caveats | Mozilla VPN / paid Firefox VPN uses Mullvad infrastructure, so the IPs are covered by Mullvad attribution. OpenASN cannot distinguish Mullvad retail traffic from Mozilla-branded traffic at IP level. |
| Primary source URLs | `https://mullvad.net/en/about`, `https://mullvad.net/en/help/terms-service`, `https://mullvad.net/en/help/privacy-policy`, `https://mullvad.net/en/blog/doing-corporate-shuffle`, `https://mullvad.net/en/vpn/trustworthy-vpn`, `https://api.mullvad.net/www/relays/all/` |

### IVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.ivpn.net/` |
| Legal / privacy URLs | `https://www.ivpn.net/en/tos-mobile-app/`, `https://www.ivpn.net/en/privacy-mobile-app/`, `https://www.ivpn.net/en/legal-process-guidelines/` |
| Legal entity shown by official pages | IVPN Limited |
| Address / identifier | IVPN's legal-process guidelines list IVPN Limited, 5 Secretary's Lane, GX11 1AA, Gibraltar. IVPN's privacy page says the company is incorporated in Gibraltar. |
| Registry / incorporation evidence | Official pages verify Gibraltar incorporation and legal address. IVPN's August 2023 post says the operator changed name from Privatus Limited to IVPN Limited while ownership structure, jurisdiction, address, and administrative registration details stayed unchanged. The exact incorporation date/registration number is not yet verified from Gibraltar registry in this batch. |
| Who is behind it | IVPN presents itself as an independent privacy-focused provider. Official ethics page says ownership, company structure, and team are public; secondary/app-store listings say IVPN was founded in 2009, but this dossier treats 2009 as service founding until registry-grade incorporation evidence is added. |
| OpenASN data source | `ivpn_servers` uses `https://api.ivpn.net/v4/servers.json`, parser `ivpn_servers_json`, provider `IVPN`. |
| Source quality / status | Implemented as default `vpn_providers`. First-party JSON returns WireGuard host IPs and OpenVPN `ip_addresses`; parser uses exact values. |
| Live smoke | 169 IPv4 ranges, 0 IPv6 ranges on 2026-07-05. |
| Caveats | The current source is strong. The company dossier still needs a Gibraltar registry extract or equivalent registry-grade confirmation for exact incorporation/registration number. |
| Primary source URLs | `https://www.ivpn.net/en/tos-mobile-app/`, `https://www.ivpn.net/en/privacy-mobile-app/`, `https://www.ivpn.net/en/legal-process-guidelines/`, `https://www.ivpn.net/blog/change-company-name-privatus-ivpn-limited/`, `https://www.ivpn.net/en/ethics/`, `https://api.ivpn.net/v4/servers.json` |

### Private Internet Access

| Field | Detail |
|---|---|
| Public service URL | `https://www.privateinternetaccess.com/` |
| Legal / privacy URLs | `https://www.privateinternetaccess.com/terms-of-service`, `https://www.privateinternetaccess.com/privacy-policy` |
| Legal entity shown by official pages | PIA Private Internet Access, Inc. |
| Address / identifier | PIA's site footer and privacy policy identify `PIA Private Internet Access, Inc.`. Chrome Web Store developer disclosure lists PIA Private Internet Access, Inc., 2590 Welton Street Suite 200, Denver, CO 80205 US, and D-U-N-S `119274687`. |
| Registry / incorporation evidence | Colorado public business-entities dataset lists `PIA Private Internet Access, Inc.`, entity ID `20231899852`, status Good Standing, jurisdiction of formation Delaware, entity type foreign profit corporation, principal address 2590 Welton St Ste 200, Denver, and Colorado entity form/registration date `2023-08-27`. The same Colorado dataset shows an older `Private Internet Access, Inc.` foreign corporation from Indiana registered `2016-11-13`, now delinquent. Delaware incorporation date for the current PIA Private Internet Access, Inc. was not verified in this batch. |
| Who is behind it | Kape's official brand page lists Private Internet Access as a Kape brand. Kape's about page timeline says it acquired PIA in December 2019. PIA is described by Kape as a US-based VPN provider with over 10 years in business. |
| OpenASN data source | `pia_servers` uses `https://serverlist.piaservers.net/vpninfo/servers/v7`, parser `pia_servers_json`, provider `Private Internet Access`. |
| Source quality / status | Implemented as default `vpn_providers`. First-party client server list; body is JSON followed by detached/signature material. Parser reads exact server IPs from online regions across server groups. |
| Live smoke | 1310 IPv4 ranges, 0 IPv6 ranges on 2026-07-05. |
| Caveats | Data source is strong. Corporate history is messy: old PIA/London Trust Media entities, Kape acquisition, and current PIA Private Internet Access, Inc. should remain separated. Do not cite Colorado foreign-registration date as Delaware incorporation date. |
| Primary source URLs | `https://www.privateinternetaccess.com/`, `https://www.privateinternetaccess.com/privacy-policy`, `https://www.privateinternetaccess.com/terms-of-service`, `https://chromewebstore.google.com/detail/private-internet-access-%E2%80%93/jplnlifepflhkbkgonidnobkakhmpnmh`, `https://data.colorado.gov/resource/4ykn-tg5h.json`, `https://www.kape.com/our-brands/`, `https://www.kape.com/about-us/`, `https://serverlist.piaservers.net/vpninfo/servers/v7` |

### AirVPN

| Field | Detail |
|---|---|
| Public service URL | `https://airvpn.org/` |
| Legal / privacy URLs | `https://airvpn.org/tos/`, `https://airvpn.org/terms/`, `https://airvpn.org/privacy/`, `https://airvpn.org/aboutus/` |
| Legal entity shown by official pages | AirVPN di Paolo Brini / Air di Paolo Brini |
| Address / identifier | AirVPN footer states VAT ID `IT03297800546` and REA `PG - 279011`. AirVPN terms state the service is operated by `AirVPN di Paolo Brini` at Via Sagittario 4. AirVPN privacy notice references `Air di Paolo Brini c.a. Paolo Brini`. |
| Registry / incorporation evidence | Italian business-information pages for VAT `IT03297800546` list `AIRVPN DI PAOLO BRINI`, address Via del Sagittario 4, 06131 Perugia, REA `279011`, legal form `IMPRESA INDIVIDUALE`, and registration date `2012-11-19`. This is not a corporation; document it as an individual enterprise/sole proprietorship. |
| Who is behind it | Official about page says AirVPN started in 2010 as a project by a small group of activists, hacktivists, and hackers, with help from lawyers and financing from a company interested in the project. Current legal operator is tied to Paolo Brini. |
| OpenASN data source | `airvpn_status` uses `https://airvpn.org/api/status/`, parser `airvpn_status_json`, provider `AirVPN`. |
| Source quality / status | Implemented as default `vpn_providers`. First-party public status API returns exact server entry IP fields (`ip_v4_in1`, `ip_v4_in2`, `ip_v6_in1`, etc.). Parser uses exact entry IPs. |
| Live smoke | 445 IPv4 ranges, 1004 IPv6 ranges on 2026-07-05. |
| Caveats | AirVPN currently blocks Italian residents from using the service, per footer/banner language. Treat AirVPN's 2010 history as project/service start and 2012-11-19 as the verified registration date for the current listed individual enterprise. The business-information page is not a direct chamber-of-commerce extract; replace it with an official visura/camera extract if one is obtained. |
| Primary source URLs | `https://airvpn.org/tos/`, `https://airvpn.org/privacy/`, `https://airvpn.org/aboutus/`, `https://airvpn.org/api/status/`, `https://www.ufficiocamerale.it/3460/airvpn-di-paolo-brini` |

## Batch Queue

Suggested next batches, five-ish services each:

1. Batch 2: Windscribe, NordVPN, PrivadoVPN, RiseupVPN, Surfshark.
2. Batch 3: IPVanish, PrivateVPN, PureVPN, TorGuard, FastestVPN.
3. Batch 4: VPNSecure, VPN Gate, VPNBook, Apple Private Relay, Mozilla VPN / Firefox VPN.
4. Batch 5: ExpressVPN, CyberGhost, ZenMate, TunnelBear, Perfect Privacy.
5. Batch 6+: remaining not-added/free/peer/Pango/Kape/Nord Security/browser/mobile-app providers from `provider-source-research.md`.
