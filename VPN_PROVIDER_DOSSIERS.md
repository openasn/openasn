# VPN Provider Dossiers

Status date: 2026-07-05

This file is the slow, provider-by-provider dossier ledger. It complements
`PROVIDER_SOURCES.md`, which tracks whether a provider has an
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

## Batch 2 - Implemented / Opt-In VPN Providers

### Windscribe

| Field | Detail |
|---|---|
| Public service URL | `https://windscribe.com/` |
| Legal / privacy URLs | `https://windscribe.com/terms`, `https://windscribe.com/privacy`, `https://windscribe.com/knowledge-base/articles/who-owns-windscribe`, `https://windscribe.com/knowledge-base/articles/where-is-windscribe-located` |
| Legal entity shown by official pages | Windscribe Limited |
| Address / identifier | Windscribe's terms identify Windscribe Limited as owner of Windscribe and say it is registered in Ontario, Canada. The same terms list mail for abuse reports as Windscribe Limited, 555 Richmond St West, Toronto, ON, M5V 3B1, Canada. App-store/developer disclosures also show Windscribe Limited at 9251 Yonge St Unit 8901, Richmond Hill, ON L4C 9T3, Canada. |
| Registry / incorporation evidence | Official pages verify Ontario registration and service inception in 2016. Exact Ontario corporation number and incorporation date were not verified from a registry-grade source in this batch. |
| Who is behind it | Windscribe's official ownership article says the company has been privately owned and operated since inception in 2016, has no outside investors, and that equity is owned by founders Yegor Sak, Alex Paguis, Mark Ulicki, and Windscribe employees. Windscribe's own blog identifies Yegor Sak as a founder and CEO. |
| OpenASN data source | `windscribe_servers` uses `https://assets.windscribe.com/serverlist/mob-v2/1/0`, parser `windscribe_serverlist_json`, provider `Windscribe`. |
| Source quality / status | Implemented as default `vpn_providers`. First-party mobile server list JSON returns active locations, groups, ping IPs, and node IP fields. Parser keeps locations with `status == 1`, then exact `ping_ip` and node `ip`/`ip2`/`ip3`; it intentionally ignores hostnames to avoid DNS-expanded default data. |
| Live smoke | 1023 IPv4 ranges, 0 IPv6 ranges on 2026-07-05 using the OpenASN Ruby parser. |
| Caveats | Data source is first-party and strong. Corporate dossier still needs an Ontario registry extract for exact corporation number/incorporation date. Windscribe publishes a large active-node list; count changes are expected and should be checked with the parser, not by hand-reading the raw JSON. |
| Primary source URLs | `https://windscribe.com/terms`, `https://windscribe.com/privacy`, `https://windscribe.com/knowledge-base/articles/who-owns-windscribe`, `https://windscribe.com/blog/who-is-yegor-sak/`, `https://windscribe.com/vpn-servers`, `https://assets.windscribe.com/serverlist/mob-v2/1/0`, `https://chromewebstore.google.com/publisher/windscribe-limited/u3bed3949c36fcf1f6f59989742bbe4a4`, `https://play.google.com/store/apps/details?id=com.windscribe.vpn` |

### NordVPN

| Field | Detail |
|---|---|
| Public service URL | `https://nordvpn.com/` |
| Legal / privacy URLs | `https://my.nordaccount.com/legal/terms-of-service/`, `https://my.nordaccount.com/legal/privacy-policy/`, `https://support.nordvpn.com/hc/en-us/articles/19441152966161-Where-is-NordVPN-based`, `https://support.nordvpn.com/hc/en-us/articles/20911146148113-The-founders-and-owners-of-NordVPN` |
| Legal entity shown by official pages | nordvpn S.A. |
| Address / identifier | NordVPN support says NordVPN is based and operates under Panama jurisdiction, while Nord Security, the parent company, is based in the Netherlands. The Nord Account privacy page lists postal address for nordvpn S.A. as PH F&F TOWER, 50th Street & 56th Street, Suite #32-D, Floor 32, Panama City, Republic of Panama. |
| Registry / incorporation evidence | Service launch is verified by Nord Security's official timeline: NordVPN launched as a Windows configuration in 2012 and an app in 2013. Panamanian incorporation date/registry number for nordvpn S.A. were not verified from the Panama registry in this batch. Secondary Dutch business-information pages list a Nordvpn S.a. registration/KvK record in 2020, but this must not be treated as proof of the Panama entity's incorporation date. |
| Who is behind it | NordVPN support says Tom Okman and Eimantas Sabaliauskas created NordVPN in 2012. NordVPN is owned and operated by nordvpn S.A.; NordVPN support identifies Nord Security as the parent company based in the Netherlands. Nord Security and Surfshark announced a 2022 merger but stated both companies would keep separate infrastructure and product roadmaps. |
| OpenASN data source | `nordvpn_servers` uses `https://api.nordvpn.com/v2/servers?limit=0`, parser `nordvpn_servers_json`, provider `NordVPN`. |
| Source quality / status | Implemented as opt-in `vpn_heavy`. First-party API returns exact online server records including `station`, `ipv6_station` / `station_ipv6`, and `ips[].ip.ip`; parser keeps online servers only. It is opt-in because the body is large and changes frequently. |
| Live smoke | 9455 IPv4 ranges, 1 IPv6 range on 2026-07-05 using the OpenASN Ruby parser. |
| Caveats | The Nord Account legal pages require JavaScript in no-script clients, so support pages and search snippets are used to preserve the legal entity/address facts. Keep NordVPN and Surfshark provider attribution separate despite the corporate group relationship. |
| Primary source URLs | `https://my.nordaccount.com/legal/terms-of-service/`, `https://my.nordaccount.com/legal/privacy-policy/`, `https://support.nordvpn.com/hc/en-us/articles/19441152966161-Where-is-NordVPN-based`, `https://support.nordvpn.com/hc/en-us/articles/20911146148113-The-founders-and-owners-of-NordVPN`, `https://nordsecurity.com/about-us`, `https://support.nordvpn.com/hc/en-us/articles/19383127694225-Where-can-I-find-the-NordVPN-server-list`, `https://api.nordvpn.com/v2/servers?limit=0`, `https://www.prnewswire.com/news-releases/nord-security-and-surfshark-join-forces-to-strengthen-positions-in-the-cybersecurity-industry-301473286.html` |

### PrivadoVPN

| Field | Detail |
|---|---|
| Public service URL | `https://privadovpn.com/` |
| Legal / privacy URLs | `https://privadovpn.com/terms-of-service/`, `https://privadovpn.com/privacy-policy/`, `https://privadovpn.com/copyright-policy/`, `https://privadovpn.com/imprint/` |
| Legal entity shown by official pages | Privado Networks ehf |
| Address / identifier | Current terms identify Privado Networks ehf as a private limited company organized under Icelandic law, with registered office at 2nd Floor, Sudurhraun 10, Gardabaer, Reykjavik 210, Iceland. Copyright-policy notice uses Privado Networks ehf and the same Icelandic address. |
| Registry / incorporation evidence | Current terms say the Icelandic entity became the contracting entity on 2026-05-01 and assumed rights/obligations from Privado Networks AG. The imprint still documents the Swiss entity Privado Networks AG / SA / Ltd, UID `CHE-203.001.971`, Grafenauweg 8, CH-6300 Zug, Switzerland, company limited by shares, latest articles dated 2020-01-27. Exact Iceland company registry number/incorporation date for Privado Networks ehf were not verified in this batch. |
| Who is behind it | Official pages disclose Privado Networks ehf as current service operator and Privado Networks AG / Privado Networks LLC as affiliated payment processors. Founder/individual ownership was not verified from a primary source in this batch. Secondary reviews commonly describe PrivadoVPN as launched in 2019; treat that as service launch context until confirmed by a primary source. |
| OpenASN data source | `privadovpn` uses `https://privadovpn.com/apps/servers_export.json`, parser `privado_servers_json`, provider `PrivadoVPN`. |
| Source quality / status | Implemented as default `vpn_providers`. First-party app server export returns exact `servers[].ip` values. A PrivadoVPN developer publicly described the endpoint as the official server list, updated hourly, with a stable/versioned schema. |
| Live smoke | 166 IPv4 ranges, 0 IPv6 ranges on 2026-07-05 using the OpenASN Ruby parser. |
| Caveats | Data source is strong. Corporate status recently changed from Swiss AG to Icelandic ehf; keep the current operator, legacy Swiss imprint, and payment processors separated. Do not imply OpenASN can redistribute the fetched IP list; it remains Tier B. |
| Primary source URLs | `https://privadovpn.com/terms-of-service/`, `https://privadovpn.com/privacy-policy/`, `https://privadovpn.com/copyright-policy/`, `https://privadovpn.com/imprint/`, `https://privadovpn.com/apps/servers_export.json`, `https://github.com/passteque/gluetun/issues/3159`, `https://www.moneyhouse.ch/en/company/privado-networks-ag-1627981991` |

### RiseupVPN

| Field | Detail |
|---|---|
| Public service URL | `https://riseup.net/en/vpn` |
| Legal / privacy URLs | `https://riseup.net/tos`, `https://riseup.net/en/privacy-policy`, `https://riseup.net/en/about-us`, `https://riseup.net/donate` |
| Legal entity shown by official pages | Riseup / Riseup Networks |
| Address / identifier | Riseup's donation page says Riseup is a registered nonprofit under IRC section 501(c)(4), donations are not tax deductible, and gives Riseup Networks, PO Box 3027, Lacey, WA 98509, USA. The federal tax-exemption notice URL documents EIN `20-0394008`. |
| Registry / incorporation evidence | Riseup's own pages say the site is run by the autonomous tech collective since 1999. ProPublica/IRS-derived nonprofit records list Riseup Networks, Lacey, WA, EIN `20-0394008`, tax-exempt since March 2007, 501(c)(4). Exact Washington state incorporation date was not verified from the Washington registry in this batch. |
| Who is behind it | Riseup describes itself as an autonomous collective based in Seattle with collective members worldwide, providing communication resources for liberatory social-change movements. It is donation-funded, non-commercial, and not a conventional consumer VPN company. |
| OpenASN data source | `riseup_vpn` uses `https://api.black.riseup.net/3/config/eip-service.json`, parser `leap_eip_service_json`, provider `RiseupVPN`. |
| Source quality / status | Implemented as default `vpn_providers`. First-party LEAP/Bitmask provider API returns exact `gateways[].ip_address` gateway records and capabilities. OONI documents the RiseupVPN provider API shape and gateway-check behavior. |
| Live smoke | 21 IPv4 ranges, 0 IPv6 ranges on 2026-07-05 using the OpenASN Ruby parser. |
| Caveats | Treat RiseupVPN differently from commercial VPN brands in product language: it is a free, donation-funded personal VPN for censorship circumvention/location anonymization. It is still a VPN exit source at IP level, but downstream policy should avoid implying commercial proxy abuse. |
| Primary source URLs | `https://riseup.net/en/about-us`, `https://riseup.net/tos`, `https://riseup.net/en/privacy-policy`, `https://riseup.net/en/vpn`, `https://riseup.net/donate`, `https://riseup.net/donate/img/Riseup-Networks-Federal-Tax-Exemption-Notice.pdf`, `https://projects.propublica.org/nonprofits/organizations/200394008`, `https://github.com/ooni/spec/blob/master/nettests/ts-026-riseupvpn.md`, `https://api.black.riseup.net/3/config/eip-service.json` |

### Surfshark

| Field | Detail |
|---|---|
| Public service URL | `https://surfshark.com/` |
| Legal / privacy URLs | `https://surfshark.com/terms-of-service`, `https://surfshark.com/privacy`, `https://surfshark.com/about-us`, `https://surfshark.com/affiliate-terms-and-conditions` |
| Legal entity shown by official pages | Surfshark B.V. |
| Address / identifier | Surfshark footer/legal pages list Surfshark B.V., KvK number `81967985`, address Kabelweg 57, 1014BA Amsterdam, the Netherlands, VAT number `NL862287339B01`. Surfshark terms also list payment processing by Surfshark Limited in the UK and Surfshark Inc. in Delaware. |
| Registry / incorporation evidence | Official footer verifies the Dutch KvK number. Secondary registry/LEI/Creditsafe-style pages report Surfshark B.V. incorporated/created in 2021, with LEI record creation date 2021-02-22; use that as registry-like context until direct KvK extract is captured. Service/product launch is generally 2018, which is separate from the current Dutch B.V. entity. |
| Who is behind it | The 2022 Nord Security / Surfshark merger announcement quotes Vytautas Kaziukonis as Surfshark founder and says Nord Security and Surfshark finalized a merger while preserving autonomy, separate infrastructure, and separate product roadmaps. Current provider attribution should therefore stay `Surfshark`, not `NordVPN`. |
| OpenASN data source | `surfshark_generic`, `surfshark_static`, and `surfshark_obfuscated` use `https://api.surfshark.com/v4/server/clusters/generic`, `/static`, and `/obfuscated`, parser `surfshark_clusters_json`, provider `Surfshark`. |
| Source quality / status | Implemented as opt-in `vpn_dns`. First-party API returns exact `connectionName` hostnames, not raw IPs. Clients resolve those hostnames locally during Tier B refresh; this is intentionally not default because DNS answers can vary by resolver/vantage. |
| Live smoke | On 2026-07-05: generic 142 hostnames resolving locally to 280 IPv4 addresses, static 36 hostnames to 36 IPv4 addresses, obfuscated 7 hostnames to 7 IPv4 addresses; 0 IPv6 addresses observed. |
| Caveats | Double-hop endpoint returned an error/empty non-array response in this environment and is intentionally not included. Do not widen resolved IPs to neighboring prefixes, and do not merge Surfshark with NordVPN despite group-level corporate relationship. |
| Primary source URLs | `https://surfshark.com/terms-of-service`, `https://surfshark.com/privacy`, `https://surfshark.com/about-us`, `https://surfshark.com/affiliate-terms-and-conditions`, `https://api.surfshark.com/v4/server/clusters/generic`, `https://api.surfshark.com/v4/server/clusters/static`, `https://api.surfshark.com/v4/server/clusters/obfuscated`, `https://www.prnewswire.com/news-releases/nord-security-and-surfshark-join-forces-to-strengthen-positions-in-the-cybersecurity-industry-301473286.html`, `https://www.lei-lookup.com/record/254900STIEA4WRWRNV37/` |

## Batch Queue

Suggested next batches, five-ish services each:

1. Batch 3: IPVanish, PrivateVPN, PureVPN, TorGuard, FastestVPN.
2. Batch 4: VPNSecure, VPN Gate, VPNBook, Apple Private Relay, Mozilla VPN / Firefox VPN.
3. Batch 5: ExpressVPN, CyberGhost, ZenMate, TunnelBear, Perfect Privacy.
4. Batch 6+: remaining not-added/free/peer/Pango/Kape/Nord Security/browser/mobile-app providers from `PROVIDER_SOURCES.md`.
