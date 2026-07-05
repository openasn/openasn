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

## Batch 3 - Implemented DNS-Expanded VPN Providers

### IPVanish

| Field | Detail |
|---|---|
| Public service URL | `https://www.ipvanish.com/` |
| Legal / privacy URLs | `https://www.ipvanish.com/terms-of-service/`, `https://www.ipvanish.com/privacy-policy/`, `https://www.ziffdavis.com/brands/security/ipvanish`, `https://www.ziffdavis.com/ziff-davis-inc-entities-self-certified-under-the-data-privacy-framework-dpf` |
| Legal entity shown by official / registry pages | IPVanish, Inc. |
| Address / identifier | Florida Sunbiz lists `IPVANISH, INC.`, document number `P11000097829`, FEI/EIN `45-3808692`, status active, principal and mailing address `360 Park Avenue S, 17th Floor, New York, NY 10010`. Ziff Davis's Data Privacy Framework page lists `IPVanish Inc` among self-certified Ziff Davis entities. Chrome Web Store developer disclosure for IPVanish Secure Browser lists D-U-N-S `078627602` and an older Winter Park, Florida address. |
| Registry / incorporation evidence | Sunbiz lists IPVanish, Inc. as a Florida profit corporation filed/effective `2011-11-10`, with a `2023-03-30` amendment/name-change event and a `2026-02-23` address update. SEC exhibit/search material describes IPVanish, Inc. as formerly known as Mudhook Marketing, Inc.; keep that as historical context, not as the current service contract name unless confirmed from a charter filing. |
| Who is behind it | Current corporate owner is Ziff Davis. Ziff Davis's brand page lists IPVanish in its cybersecurity portfolio. Secondary transaction data says J2 Global acquired IPVanish/StrongVPN/Encrypt.me from StackPath on `2019-04-30`; J2 later became Ziff Davis. Current Sunbiz officer/director entries include Ziff Davis executives, including Nate Simmons as director/president in the 2026 filing snapshot. |
| OpenASN data source | `ipvanish_openvpn` uses `https://configs.ipvanish.com/openvpn/v2.6.0-0/configs.zip`, parser `ovpn_zip_remote_hosts`, provider `IPVanish`. |
| Source quality / status | Implemented as opt-in `vpn_dns`. The source is a first-party `configs.ipvanish.com` OpenVPN archive containing provider-published `remote` hostnames. Clients resolve those hostnames locally; OpenASN does not redistribute the resolved IPs. |
| Live smoke | On 2026-07-05, the parser found 3483 unique hostnames. This resolver returned 3448 IPv4 addresses, 0 IPv6 addresses, and 31 DNS misses; sample resolved IP `199.127.250.216`. |
| Caveats | IPVanish's own legal pages challenged no-script HTTP clients during this batch, so legal-page URLs are recorded but legal entity/address facts are corroborated through Ziff Davis, Sunbiz, app-store disclosure, and current reseller privacy notices. DNS results are not byte-stable and this source must stay opt-in. Do not infer IPVanish from ASNs or neighboring prefixes. |
| Primary source URLs | `https://www.ipvanish.com/terms-of-service/`, `https://www.ipvanish.com/privacy-policy/`, `https://www.ziffdavis.com/brands/security/ipvanish`, `https://www.ziffdavis.com/ziff-davis-inc-entities-self-certified-under-the-data-privacy-framework-dpf`, `https://search.sunbiz.org/Inquiry/CorporationSearch/SearchResults?inquiryType=EntityName&searchTerm=IPVANISH%2C%20INC`, `https://configs.ipvanish.com/openvpn/v2.6.0-0/configs.zip`, `https://chromewebstore.google.com/detail/ipvanish-secure-browser/ekeoaffihmbjndaoglobgjibjgcmjfpo`, `https://www.curryscloudbackup.co.uk/privacy-policy` |

### PrivateVPN

| Field | Detail |
|---|---|
| Public service URL | `https://privatevpn.com/` |
| Legal / privacy URLs | `https://privatevpn.com/terms-of-use/`, `https://privatevpn.com/privacy-policy/` |
| Legal entity shown by official pages | PrivateVPN Global AB |
| Address / identifier | Terms and privacy policy identify `PrivateVPN Global AB`, registration number `559282-2182`. The privacy policy lists `PrivateVPN Global AB, Reg. No. 559282-2182, Box 2128, SE-442 02 Ytterby, Sweden` as data controller. |
| Registry / incorporation evidence | Swedish business-information pages sourced from Bolagsverket/SCB list PrivateVPN Global AB, organization number `559282-2182`, Swedish aktiebolag, registered `2020-11-11`, active, share capital SEK 25,000, postal address Box 2128, 442 02 Ytterby. Allabolag says the company is part of Meralm Bidco AB; Hitta group data places it in the wider Miss Group/PW Realm structure. |
| Who is behind it | Current legal operator is PrivateVPN Global AB. Secondary corporate-data sources say PrivateVPN Global AB was acquired by Miss Group/Miss Group Holdings in June 2022. The older PrivateVPN service is commonly described as launched in 2009; this dossier does not collapse that service history into the 2020 Swedish company registration. Current Swedish registry-like pages list Rolf Jimmie Eriksson as board member. |
| OpenASN data source | `privatevpn_openvpn` uses `https://privatevpn.com/client/PrivateVPN-TUN.zip`, parser `ovpn_zip_remote_hosts`, provider `PrivateVPN`. |
| Source quality / status | Implemented as opt-in `vpn_dns`. PrivateVPN support/guides and historical blog posts point users to the first-party OpenVPN configuration ZIP. Parser extracts exact `remote` hostnames and the one direct IP present in the archive; clients resolve locally. |
| Live smoke | On 2026-07-05, the parser found 100 unique hostnames plus direct IP `193.180.119.2`. This resolver returned 100 IPv4 ranges, 0 IPv6 ranges, and 26 DNS misses; sample resolved/direct IP `193.180.119.2`. |
| Caveats | PrivateVPN terms include a user covenant not to "attempt to compile, utilize, or distribute a list of IP addresses operated by PrivateVPN in conjunction with the Service." OpenASN therefore must not redistribute a PrivateVPN IP list and should keep this source opt-in/legal-reviewed. Publishing the Tier B recipe is materially different from publishing the resolved list, but this is still a real downstream terms caveat. DNS failures are expected because some published hostnames are stale or resolver-dependent. |
| Primary source URLs | `https://privatevpn.com/terms-of-use/`, `https://privatevpn.com/privacy-policy/`, `https://privatevpn.com/client/PrivateVPN-TUN.zip`, `https://privatevpn.com/blog/vpn-app/openvpn-configuration-files-updated/`, `https://privatevpn.com/blog/vpn-service/service-upgrade/`, `https://help.privatevpn.com/en/articles/302354-openvpn-on-mac-os-with-tunnelblick-client`, `https://www.allabolag.se/foretag/privatevpn-global-ab/ytterby/konsulter/2KHTL7QI5YF3I`, `https://krafman.se/privatevpn-global-ab/5592822182/sammanfattning`, `https://www.hitta.se/f%C3%B6retagsinformation/privatevpn%2Bglobal%2Bab/5592822182`, `https://www.preqin.com/data/profile/asset/privatevpn-global-ab/486394` |

### PureVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.purevpn.com/` |
| Legal / privacy URLs | `https://www.purevpn.com/term.php`, `https://www.purevpn.com/privacy-policy.php`, `https://www.purevpn.com/contact`, `https://www.purevpn.com/about.php`, `https://www.purevpn.com/ceo-message` |
| Legal entity shown by official pages | GZ Systems Limited |
| Address / identifier | Terms identify `GZ Systems Limited`, doing business as `PureVPN`, as a British Virgin Islands limited-liability company with principal place of business at `Intershore Chambers, P.O Box 4342, Road Town, Tortola, British Virgin Islands`. Footer/contact/privacy pages list PureVPN as a brand of GZ Systems Limited, address `Intershore Chambers P.O Box 4342, Road Town, Tortola, British Virgin Islands`, company registration number `2039934`. |
| Registry / incorporation evidence | Official pages verify BVI registration number `2039934`, but this batch did not obtain a BVI registry extract or incorporation date. Terms effective date is `2016-10-14`; PureVPN's own about/footer copy says the service launched in 2007. Keep service launch, terms effective date, and company incorporation as separate facts. |
| Who is behind it | PureVPN's about page says PureVPN launched in 2007 and names Uzair, Umair, and Aqib as the newly graduated founders. PureVPN's CEO message and transparency pages identify Uzair Gadit as CEO/co-founder. Disrupt's official site lists PureSquare/PureVPN in its portfolio and names Aaqib Gadit, Uzair Gadit, and Umair Gadit. |
| OpenASN data source | `purevpn_openvpn` uses `https://d11a57lttb2ffq.cloudfront.net/heartbleed/router/Recommended-CA2.zip`, parser `ovpn_zip_remote_hosts`, provider `PureVPN`. |
| Source quality / status | Implemented as opt-in `vpn_dns`. PureVPN support articles instruct users to download the same CloudFront OpenVPN ZIP for Linux/Raspberry Pi/manual configuration. Parser extracts provider-published `remote` hostnames; clients resolve locally. |
| Live smoke | On 2026-07-05, the parser found 166 unique hostnames. This resolver returned 129 IPv4 ranges and 0 IPv6 ranges; sample resolved IP `172.111.238.9`. |
| Caveats | PureVPN pages are internally inconsistent: privacy-policy body says `GZ Systems Private Ltd` in one place while footer/terms say `GZ Systems Limited`. Treat `GZ Systems Limited` and BVI registration number `2039934` as the stronger official footer/terms fact and preserve the inconsistency in this dossier. The source is first-party but DNS-expanded, so counts are resolver-specific. |
| Primary source URLs | `https://www.purevpn.com/term.php`, `https://www.purevpn.com/privacy-policy.php`, `https://www.purevpn.com/contact`, `https://www.purevpn.com/about.php`, `https://www.purevpn.com/ceo-message`, `https://www.purevpn.com/vpn-transparency-report`, `https://www.disrupt.com/`, `https://support.purevpn.com/en_US/manual-connection-setup/how-to-setup-command-line-openvpn-on-linux`, `https://support.purevpn.com/en_US/other-devices-guides/openvpn-command-line-interface-cli-setup-guide-for-raspberry-pi-debian`, `https://d11a57lttb2ffq.cloudfront.net/heartbleed/router/Recommended-CA2.zip` |

### TorGuard

| Field | Detail |
|---|---|
| Public service URL | `https://torguard.net/` |
| Legal / privacy URLs | `https://torguard.net/terms/`, `https://torguard.net/privacy/`, `https://torguard.net/dmca.php`, `https://torguard.net/downloads.php` |
| Legal entity shown by official pages | VPNetworks LLC / VPNETWORKS, LLC |
| Address / identifier | TorGuard privacy policy lists data-controller mailing address `VPNetworks LLC, 618 E. SOUTH STREET, STE. 500, ORLANDO, FL 32801`. Apple App Store trader disclosure lists `VPNETWORKS LLC`, D-U-N-S `032953620`, same 618 E South Ste 500 address, phone `+1 4073734949`, email `admin@torguard.net`. |
| Registry / incorporation evidence | Florida Sunbiz lists `VPNETWORKS, LLC`, document number `L12000154089`, FEI/EIN `45-1687395`, filed/effective `2012-12-10`, state FL, status active, principal address `618 E. SOUTH STREET, STE. 500, ORLANDO, FL 32801`, mailing address `1420 EDGEWATER DRIVE, Orlando, FL 32804`. |
| Who is behind it | TorGuard's 2019 federal complaint identifies `VPNetworks, LLC d/b/a TorGuard` as a Florida LLC with principal place of business in Orange County, Florida; it also says the sole member was Data Protection Services, whose sole member was Benjamin Van Pelt. Treat this as litigation-snapshot ownership evidence, not necessarily current ownership. |
| OpenASN data source | `torguard_openvpn_tcp` and `torguard_openvpn_udp` use `https://torguard.net/downloads/OpenVPN-TCP-Linux.zip` and `https://torguard.net/downloads/OpenVPN-UDP-Linux.zip`, parser `ovpn_zip_remote_hosts`, provider `TorGuard`. |
| Source quality / status | Implemented as opt-in `vpn_dns`. Public first-party OpenVPN archives fetch cleanly and contain provider-published `remote` hostnames. Parser extracts the hostnames and clients resolve them locally. |
| Live smoke | On 2026-07-05, each archive contained 52 unique hostnames after parser de-duplication. This resolver returned 430 IPv4 ranges and 0 IPv6 ranges for TCP, and 430 IPv4 ranges and 0 IPv6 ranges for UDP; sample resolved IP `93.115.35.114`. |
| Caveats | TorGuard legal pages are Cloudflare-challenged for bare curl but accessible via browser fetch; the config ZIPs fetched cleanly. TCP and UDP sources overlap heavily but are kept separate so protocol-specific omissions do not hide. DNS fanout is high: 52 hostnames yielded hundreds of A records from this resolver. |
| Primary source URLs | `https://torguard.net/terms/`, `https://torguard.net/privacy/`, `https://torguard.net/dmca.php`, `https://torguard.net/downloads.php`, `https://torguard.net/downloads/OpenVPN-TCP-Linux.zip`, `https://torguard.net/downloads/OpenVPN-UDP-Linux.zip`, `https://search.sunbiz.org/Inquiry/CorporationSearch/SearchResults?inquiryType=EntityName&searchTerm=VPNETWORKS%2C%20LLC`, `https://torguard.net/downloads/1.6-26-2019-Complaint.pdf`, `https://apps.apple.com/fr/app/private-secure-vpn-torguard/id988743799?l=en-GB` |

### FastestVPN

| Field | Detail |
|---|---|
| Public service URL | `https://fastestvpn.com/` |
| Legal / privacy URLs | `https://fastestvpn.com/terms-of-service`, `https://fastestvpn.com/privacy-policy`, `https://support.fastestvpn.com/vpn-servers/` |
| Legal entity shown by official pages | Not cleanly named on FastestVPN's own legal pages in this batch |
| Address / identifier | FastestVPN's privacy policy says the service is based in the Cayman Islands, but the page text does not name a legal entity or registration number. Apple App Store trader disclosure for FastestVPN apps names `FASTEST TECHNOLOGY PTY LTD`, D-U-N-S `750554679`, address `43 CLAREMONT AVENUE, GREENACRE New South Wales 2190, Australia`, email `tech.support@fasttechnologylimited.com`, and copyright strings such as `Fast Technology Limited`. Google Play metadata for related FastestVPN/FastestPass apps uses `Fastest Technology LLC` and a Houston, Texas address. |
| Registry / incorporation evidence | ASIC published a proposed deregistration notice for `FASTEST TECHNOLOGY PTY LTD`, ACN `658 034 336`, on `2024-12-10`; this notice explicitly says it does not itself prove deregistration. No Cayman company registry extract for `Fast Technology Limited` was obtained in this batch. Secondary reviews/affiliate pages claim Fast Technology Ltd / Cayman Islands and a 2016 launch/incorporation, but those remain secondary until registry-grade proof is captured. |
| Who is behind it | Secondary VPN-review sources name Azneem Bilwani as founder/owner of Fast Technology Ltd. A USPTO FASTESTVPN trademark application record names Azneem Bilwani as applicant/owner for serial `98181332`, but that is trademark ownership evidence, not clean corporate ownership proof. OpenASN should not overstate this dossier beyond those facts. |
| OpenASN data source | `fastestvpn_tcp` and `fastestvpn_udp` POST to `https://support.fastestvpn.com/wp-admin/admin-ajax.php` with `action=vpn_servers` and `protocol=tcp` or `protocol=udp`, parser `html_table_hostnames`, provider `FastestVPN`. |
| Source quality / status | Implemented as opt-in `vpn_dns`. The first-party support page `https://support.fastestvpn.com/vpn-servers/` publishes a server/host-name table and uses the same WordPress AJAX endpoint. Parser reads hostnames from the returned HTML table; clients resolve locally. |
| Live smoke | On 2026-07-05, TCP returned 68 hostnames resolving to 55 IPv4 ranges and 0 IPv6 ranges; sample `46.102.153.134`. UDP returned 68 hostnames resolving to 55 IPv4 ranges and 0 IPv6 ranges; sample `193.9.114.210`. |
| Caveats | This is a good technical source but a weak corporate dossier. The legal operator is not clearly named on FastestVPN's own terms/privacy pages; app-store and review metadata point at several similarly named entities across Cayman Islands, Australia, and the United States. Keep the provider label as `FastestVPN`, keep the source opt-in, and do not make strong company/founder claims without a registry extract or official legal-page update. |
| Primary source URLs | `https://fastestvpn.com/terms-of-service`, `https://fastestvpn.com/privacy-policy`, `https://support.fastestvpn.com/vpn-servers/`, `https://support.fastestvpn.com/wp-admin/admin-ajax.php`, `https://apps.apple.com/dk/app/fastestvpn-secures-privacy/id1643144565?mt=12`, `https://play.google.com/store/apps/details?id=com.vpn.fastestvpnservice`, `https://publishednotices.asic.gov.au/browsesearch-notices/notice-details/FASTEST-TECHNOLOGY-PTY-LTD-658034336/6b27be62-7e93-4214-8030-03c4336123f0`, `https://uspto.report/TM/98181332` |

## Batch 4 - Public Relays, Relay Semantics, And Mozilla Coverage

### VPNSecure

| Field | Detail |
|---|---|
| Public service URL | `https://www.vpnsecure.me/` |
| Legal / privacy URLs | `https://www.vpnsecure.me/privacy-policy/`, `https://www.vpnsecure.me/terms-of-service/`, `https://www.vpnsecure.me/vpn-locations/` |
| Legal entity shown by official pages | InfiniteQuant Ltd |
| Address / identifier | VPNSecure's privacy policy names `InfiniteQuant Ltd` and lists `Suite 219, Lagoon Court - Sandyport, Nassau - New Providence - The Bahamas`, contact `support@vpnsecure.me`. The terms page footer and company block use the same InfiniteQuant Ltd Bahamas address. |
| Registry / incorporation evidence | Official pages verify the current operator name and Bahamas address, but no Bahamas registry extract, company number, or incorporation date was verified in this batch. Bahamas company-file access appears to require the Registrar General company-search service rather than a public unauthenticated extract. |
| Who is behind it | Current official pages disclose InfiniteQuant Ltd only. VPNSecure has messy historical ownership: older terms text still says `VPNSecure Trust`, while 2019 user-visible material reported a move from Australia to Hong Kong under Lucro Corp Limited, and 2025 reporting/user records discuss InfiniteQuant's acquisition of VPNSecure assets. Treat those as history, not current legal-page facts. |
| OpenASN data source | `vpnsecure_locations` uses `https://www.vpnsecure.me/vpn-locations/`, parser `vpnsecure_locations_html`, provider `VPNSecure`. |
| Source quality / status | Implemented as opt-in `vpn_dns`. The first-party locations page publishes short server labels and status. The parser keeps labels marked `up` and expands them to `*.isponeder.com` hostnames for local DNS resolution. |
| Live smoke | On 2026-07-05, the parser found 60 active host labels. This resolver returned 60 IPv4 addresses, 0 IPv6 addresses, and 0 DNS misses; sample resolved IP `103.106.228.223`. |
| Caveats | This is useful but fragile: the locations page does not publish raw IPs, the hostname suffix is parser knowledge, and DNS answers are resolver-specific. Keep it opt-in. The corporate dossier is not registry-grade until a Bahamas extract is obtained. |
| Primary source URLs | `https://www.vpnsecure.me/privacy-policy/`, `https://www.vpnsecure.me/terms-of-service/`, `https://www.vpnsecure.me/vpn-locations/`, `https://www.bahamas.gov.bs/service/company-search`, `https://www.reddit.com/r/privacytoolsIO/comments/aqix0z/vpnsecure_moves_company_from_australia_to_hong/`, `https://arstechnica.com/gadgets/2025/05/vpnsecure-owner-says-it-had-to-cancel-unsustainable-lifetime-subscriptions/` |

### VPN Gate

| Field | Detail |
|---|---|
| Public service URL | `https://www.vpngate.net/` |
| Legal / privacy URLs | `https://www.vpngate.net/en/about_us.aspx`, `https://www.vpngate.net/en/about_faq.aspx`, `https://www.vpngate.net/en/`, `http://www.vpngate.net/api/iphone/` |
| Legal entity shown by official pages | VPN Gate Academic Experiment Project at National University of Tsukuba, Japan |
| Address / identifier | Official footer says the project is at National University of Tsukuba, Japan and is joint research with SoftEther Corporation. The FAQ says VPN Gate is not a commercial corporation and is an online academic research service at the Graduate School of University of Tsukuba. |
| Registry / incorporation evidence | Not a corporation. Official site states VPN Gate launched on 2013-03-08. The NSDI 2014 paper by Daiyuu Nobori and Yasushi Shinjo also says VPN Gate launched on 2013-03-08. |
| Who is behind it | The public service identifies Daiyuu Nobori on many relay rows and official FAQ material names him as responsible person, with redundant maintenance staff at University of Tsukuba. VPN Gate is a child project of SoftEther VPN Project. |
| OpenASN data source | `vpngate` uses `http://www.vpngate.net/api/iphone/`, parser `vpngate_csv`, provider `VPN Gate`. |
| Source quality / status | Implemented as opt-in `public_relays`. The API is a first-party plain-text CSV whose second column is the current relay IP. Parser ignores the embedded base64 OpenVPN configs and keeps exact IPs only. |
| Live smoke | On 2026-07-05, the parser returned 98 IPv4 relay IPs and 0 IPv6 addresses; sample IP `1.244.51.251`. The web page count is much larger because it lists many rows, mirrors, and dynamic volunteer information; the API is the exact source OpenASN consumes. |
| Caveats | VPN Gate is not provider-operated commercial VPN infrastructure. It is a volunteer public relay network, often on residential or ordinary ISP addresses while actively serving VPN traffic. Keep it opt-in to avoid surprising downstream users who treat `vpn` as provider-owned datacenter egress. |
| Primary source URLs | `https://www.vpngate.net/`, `https://www.vpngate.net/en/about_us.aspx`, `https://www.vpngate.net/en/about_faq.aspx`, `http://www.vpngate.net/api/iphone/`, `https://www.usenix.org/conference/nsdi14/technical-sessions/presentation/nobori`, `https://www.softether.org/9-about` |

### VPNBook

| Field | Detail |
|---|---|
| Public service URL | `https://www.vpnbook.com/` |
| Legal / privacy URLs | `https://www.vpnbook.com/contact`, `https://www.vpnbook.com/freevpn/openvpn` |
| Legal entity shown by official pages | No legal entity name found on official pages in this batch |
| Address / identifier | The contact/privacy page lists email `contact@vpnbook.com`, abuse contact `abuse@vpnbook.com`, and location `Zurich, Switzerland`. The footer says copyright 2026 VPNBook and "Located in Zurich, Switzerland", but no company name, registration number, or formal legal address is provided. |
| Registry / incorporation evidence | No registry-grade entity or incorporation date verified. Treat VPNBook as a service/brand with Zurich location disclosure, not as a verified Swiss company record. |
| Who is behind it | Official pages do not identify founders, officers, or a legal operator. The service says it is financially supported by website advertisements and donations. |
| OpenASN data source | `vpnbook_openvpn` uses `https://www.vpnbook.com/freevpn/openvpn`, parser `vpnbook_html_hosts`, provider `VPNBook`. |
| Source quality / status | Implemented as opt-in `public_relays`. VPNBook publishes current OpenVPN server hostnames on a public first-party page. Parser extracts `*.vpnbook.com` server names except `www.vpnbook.com`; clients resolve hostnames locally. |
| Live smoke | On 2026-07-05, the parser found 10 hostnames. This resolver returned 9 IPv4 addresses, 0 IPv6 addresses, and 1 DNS miss; sample resolved IP `142.4.216.196`. |
| Caveats | The corporate/legal identity is weak. VPNBook also logs connection IP and time for abuse mitigation and says those logs are deleted every week. Keep the source opt-in because it is a free public VPN service, high-churn, DNS-expanded, and not backed by a robust legal-entity dossier. |
| Primary source URLs | `https://www.vpnbook.com/contact`, `https://www.vpnbook.com/freevpn/openvpn`, `https://www.vpnbook.com/` |

### Apple iCloud Private Relay

| Field | Detail |
|---|---|
| Public service URL | `https://www.icloud.com/` |
| Legal / privacy URLs | `https://developer.apple.com/icloud/prepare-your-network-for-icloud-private-relay/`, `https://mask-api.icloud.com/egress-ip-ranges.csv`, `https://www.apple.com/icloud/docs/iCloud_Private_Relay_Overview_Dec2021.pdf`, `https://www.apple.com/legal/privacy/en-ww/`, `https://www.apple.com/legal/internet-services/icloud/` |
| Legal entity shown by official pages | Apple Inc. |
| Address / identifier | Apple contact/legal pages list Apple Inc. / Apple at One Apple Park Way, Cupertino, CA 95014, U.S.A. |
| Registry / incorporation evidence | Apple SEC Form 10-K filings describe Apple Inc. as a California corporation established in 1977. That is corporate context; Private Relay itself launched much later as an iCloud+ privacy service. |
| Who is behind it | Apple operates the Private Relay service design and publishes the egress geolocation/IP feed. Apple's overview says Private Relay uses two separate internet relays operated by different entities; the second relay assigns the egress relay IP. |
| OpenASN data source | `apple_private_relay` uses `https://mask-api.icloud.com/egress-ip-ranges.csv`, parser `csv_cidr_first_column`, provider `iCloud Private Relay`, and maps to `relay`, not `vpn`. |
| Source quality / status | Implemented as default Tier B relay data. The source is first-party CSV with CIDR and geolocation columns. It is large and must be aggregated by the pipeline. |
| Live smoke | On 2026-07-05, the CSV fetched successfully with 286946 rows and 12129191 bytes. First row observed: `172.224.226.0/27,GB,GB-EN,London,`. |
| Caveats | This must remain `relay`, not `vpn` or hostile `hosting`. Apple explicitly tells operators to recognize these addresses and consider treating them like carrier-grade NAT or enterprise IPs because many real users may share one relay IP. Relay precedence must outrank cloud/hosting because egress IPs can sit inside Cloudflare/Akamai-style infrastructure. |
| Primary source URLs | `https://developer.apple.com/icloud/prepare-your-network-for-icloud-private-relay/`, `https://mask-api.icloud.com/egress-ip-ranges.csv`, `https://www.apple.com/icloud/docs/iCloud_Private_Relay_Overview_Dec2021.pdf`, `https://www.apple.com/contact/`, `https://www.apple.com/legal/warranty/warranty-obligor/en/`, `https://www.sec.gov/Archives/edgar/data/320193/000032019318000145/a10-k20189292018.htm` |

### Mozilla VPN / Firefox Built-In VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.mozilla.org/en-US/products/vpn/` |
| Legal / privacy URLs | `https://www.mozilla.org/en-US/about/legal/terms/subscription-services/`, `https://www.mozilla.org/en-US/privacy/subscription-services/`, `https://www.mozilla.org/en-US/privacy/firefox/`, `https://support.mozilla.org/en-US/kb/built-in-vpn` |
| Legal entity shown by official pages | Mozilla Corporation |
| Address / identifier | Mozilla subscription terms name Mozilla Corporation as the service provider. Mozilla website legal notices list `Mozilla, Attn: Mozilla - Legal Notices, 1875 Mission Street, Suite 103, San Francisco, CA 94103, USA`, telephone `650-903-0800`, fax `650-903-0875`. |
| Registry / incorporation evidence | Mozilla's own corporation page says Mozilla Corporation was established in August 2005 as a wholly owned taxable subsidiary serving the non-profit public-benefit goals of its parent. No California/Delaware registry extract was captured in this batch. |
| Who is behind it | Mozilla Corporation operates Mozilla VPN as a subscription privacy product. Mozilla's terms say Mozilla VPN is in partnership with Mullvad and routes traffic through the partner's networks. Mullvad's own 2019 partnership post says Mozilla partnered with Mullvad to use Mullvad's global network of VPN servers for Mozilla's VPN application. |
| OpenASN data source | Paid Mozilla VPN is covered by `mullvad_relays`, parser `mullvad_relays_json`, provider `Mullvad`. Firefox built-in/browser-only VPN is not added separately because no verified exact egress source was found. |
| Source quality / status | Mozilla's server page explicitly says Mozilla VPN is built on top of Mullvad infrastructure and uses the same servers. OpenASN therefore does not create a separate Mozilla provider label for those IPs; the network operator remains `Mullvad`. |
| Live smoke | On 2026-07-05, Mullvad's first-party relay API returned 539 active IPv4 relay entry addresses and 532 IPv6 relay entry addresses. Firefox built-in VPN had no source smoke because Mozilla does not publish a separate exact egress list in the official pages checked. |
| Caveats | Do not conflate three things: paid Mozilla VPN, Firefox built-in VPN, and Firefox Relay email/phone masking. Paid Mozilla VPN is device-level and Mullvad-backed. Firefox built-in VPN is browser-only, free, requires a Mozilla account, has a 50 GB monthly data limit, and only masks Firefox traffic; without an official egress feed it should stay documented but not shipped as data. |
| Primary source URLs | `https://www.mozilla.org/en-US/about/legal/terms/subscription-services/`, `https://www.mozilla.org/en-US/products/vpn/resource-center/vpn-servers-around-the-world/`, `https://support.mozilla.org/en-US/kb/built-in-vpn`, `https://www.mozilla.org/en-US/privacy/firefox/`, `https://mullvad.net/en/blog/mullvad-partnerships-page-has-been-updated-mozilla`, `https://www.mozilla.org/en-US/foundation/moco/`, `https://api.mullvad.net/www/relays/all/` |

## Batch 5 - Kape Family, TunnelBear, And Perfect Privacy Research

### ExpressVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.expressvpn.com/` |
| Legal / privacy URLs | `https://www.expressvpn.com/tos`, `https://www.expressvpn.com/privacy-policy`, `https://www.expressvpn.com/about-us`, `https://www.expressvpn.com/blog/expressvpn-officially-joins-kape/` |
| Legal entity shown by official pages | Express Technologies Ltd. |
| Address / identifier | ExpressVPN's privacy policy says ExpressVPN's headquarters and registered place of business is in the British Virgin Islands, and that Express Technologies Ltd. operates under BVI jurisdiction and laws. A registry number or formal street address was not verified from official pages in this batch. |
| Registry / incorporation evidence | No BVI registry extract, company number, or incorporation date was obtained. Official ExpressVPN material verifies the service has been built since 2009 and that ExpressVPN joined Kape Technologies on 2021-12-16. |
| Who is behind it | ExpressVPN identifies itself as a Kape Technologies family product after the 2021 acquisition. Official ExpressVPN copy does not name founders on the legal pages checked; secondary and founder-controlled pages identify Peter Burchhardt and Dan Pomerantz as co-founders and 2009 as the service founding year. Keep those as secondary/founder-page context, not registry-grade corporate proof. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Public ExpressVPN pages list countries, virtual locations, products, audits, and legal/privacy posture, but no first-party exact IP, CIDR, or unauthenticated hostname catalog was found. Gluetun carries hardcoded `expressnetw.com` hostnames and sample DNS resolution works, but that is a third-party hardcoded inventory, not an original provider source. |
| Live smoke | On 2026-07-05, sample Gluetun-style hostnames such as `usa-newyork-ca-version-2.expressnetw.com` resolved from this network, proving the hostname pattern exists. It still was not shipped because source provenance failed. |
| Caveats | ExpressVPN is high-value coverage, but adding inferred or hardcoded hostnames would make OpenASN worse: stale third-party inventories create false positives and cannot be defended legally or operationally. Revisit only if ExpressVPN publishes a config archive, app server API, DNS zone-style inventory, or licensed exact feed. |
| Primary source URLs | `https://www.expressvpn.com/privacy-policy`, `https://www.expressvpn.com/tos`, `https://www.expressvpn.com/about-us`, `https://www.expressvpn.com/blog/expressvpn-officially-joins-kape/`, `https://www.kape.com/about-us/`, `https://www.peterburchhardt.com/`, `https://sg.linkedin.com/in/dan-pomerantz-4679a52a9`, `https://github.com/qdm12/gluetun/blob/master/internal/provider/expressvpn/updater/hardcoded.go` |

### CyberGhost

| Field | Detail |
|---|---|
| Public service URL | `https://www.cyberghostvpn.com/` |
| Legal / privacy URLs | `https://www.cyberghostvpn.com/imprint`, `https://www.cyberghostvpn.com/privacypolicy`, `https://www.cyberghostvpn.com/terms`, `https://www.cyberghostvpn.com/features/nospy` |
| Legal entity shown by official pages | CyberGhost S.R.L. |
| Address / identifier | CyberGhost's imprint lists CyberGhost S.R.L., 70-72 Dionisie Lupu street, 1st, 2nd and 3rd floor, District 1, 010458, Bucharest, Romania; email `office@cyberghost.ro`; Trade Register No. `J40/1278/2011`; VAT ID `RO28003392`; EUID `ROONRC.J40/1278/2011`. Its privacy policy also names CyberGhost S.R.L. and uses a Polona Street Bucharest office address. |
| Registry / incorporation evidence | Official imprint provides Romanian register number `J40/1278/2011`. Exact incorporation date was not independently pulled from the Romanian registry in this batch. The register number and public company history indicate 2011 as the relevant registration/service era, but OpenASN should cite the official imprint for the hard identifier. |
| Who is behind it | CyberGhost is part of the Kape Technologies group. Secondary conference/profile material identifies Robert Knapp as co-founder and CEO in earlier CyberGhost history; current official pages only need the CyberGhost S.R.L. legal identity for OpenASN provenance. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Public CyberGhost pages list countries, server counts, NoSpy positioning, and virtual-location concepts. Gluetun derives `cg-dialup.net` names from country and group-number patterns, and sample generated names resolve, but this is generated DNS probing rather than a provider-published exact list. |
| Live smoke | On 2026-07-05, sample generated names like `1-ro.cg-dialup.net`, `1-us.cg-dialup.net`, and `1-de.cg-dialup.net` returned A records while other group numbers did not. That confirms partial pattern behavior, not source validity. |
| Caveats | CyberGhost is a major missing provider. Do not ship generated `cg-dialup.net` sweeps unless CyberGhost documents the namespace as an authoritative inventory or exposes a client server-list API/config archive with exact hosts/IPs. Pattern enumeration would be incomplete, noisy, and hard to audit. |
| Primary source URLs | `https://www.cyberghostvpn.com/imprint`, `https://www.cyberghostvpn.com/privacypolicy`, `https://www.cyberghostvpn.com/terms`, `https://www.cyberghostvpn.com/features/nospy`, `https://www.kape.com/about-us/`, `https://github.com/qdm12/gluetun/blob/master/internal/provider/cyberghost/updater/hosttoserver.go` |

### ZenMate

| Field | Detail |
|---|---|
| Public service URL | `https://zenmate.com/` |
| Legal / privacy URLs | `https://zenmate.com/tos`, `https://zenmate.com/privacy-policy`, `https://zenmate.com/blog/zenmate-changes` |
| Legal entity shown by official pages | ZenGuard GmbH / ZenMate service under CyberGhost partnership |
| Address / identifier | Current ZenMate legal pages reference ZenGuard in their terms/privacy stack. The service pages now position ZenMate as a gateway to CyberGhost VPN rather than an independent VPN infrastructure product. |
| Registry / incorporation evidence | Registry-grade ZenGuard GmbH incorporation data was not captured in this batch. Public acquisition material says Kape acquired ZenGuard GmbH, a Berlin company, in 2018; secondary/startup material reports ZenMate launched in 2013 in Berlin. |
| Who is behind it | ZenMate was acquired by Kape Technologies in 2018. ZenMate's own 2023 migration notice says the VPN service for subscribers would be provided by CyberGhost VPN apps from 2023-03-16, ZenMate VPN apps would be supported until 2023-05-01, and paying subscribers would then use CyberGhost VPN apps. |
| OpenASN data source | Not added as a separate provider. Potential ZenMate paid-app traffic should be considered CyberGhost-family infrastructure unless an independent ZenMate exact source reappears. |
| Source quality / status | No independent first-party exact IP, CIDR, hostname, OpenVPN archive, or public app server-list source was verified. Current product state points to CyberGhost for the VPN backend. |
| Live smoke | No source smoke. ZenMate's own migration page is the key evidence, not a server inventory. |
| Caveats | Do not create a `ZenMate` provider label from CyberGhost-derived infrastructure unless a source can distinguish ZenMate egress from CyberGhost egress. A separate brand label would imply attribution precision OpenASN does not have. |
| Primary source URLs | `https://zenmate.com/`, `https://zenmate.com/tos`, `https://zenmate.com/privacy-policy`, `https://zenmate.com/blog/zenmate-changes`, `https://www.prnewswire.com/news-releases/zenmate-acquired-by-kape-technologies-300731900.html`, `https://www.winheller.com/en/news/press-releases/detail/acquisition-zenguard-kape-technologies.html` |

### TunnelBear

| Field | Detail |
|---|---|
| Public service URL | `https://www.tunnelbear.com/` |
| Legal / privacy URLs | `https://www.tunnelbear.com/privacy-policy/`, `https://www.tunnelbear.com/terms-of-service/`, `https://www.tunnelbear.com/blog/tunnelbear-transparency-report/`, `https://www.tunnelbear.com/blog/trust/`, `https://help.tunnelbear.com/hc/en-us/articles/360007004351-Where-can-I-tunnel-to-and-from` |
| Legal entity shown by official pages | TunnelBear LLC |
| Address / identifier | TunnelBear's privacy policy identifies TunnelBear LLC and says TunnelBear stores personal data inside Canada's physical borders. Public trust/transparency pages say TunnelBear LLC is incorporated in Delaware, has offices in Toronto, and is wholly owned by McAfee. |
| Registry / incorporation evidence | Official pages verify the Delaware LLC claim and the McAfee acquisition context. Exact Delaware file number and formation date were not verified from the Delaware registry in this batch. |
| Who is behind it | TunnelBear's transparency report says McAfee acquired TunnelBear in April 2018 and transitioned the prior Canadian TunnelBear Inc. to TunnelBear LLC; the business remained office-based in Toronto. Current pages identify McAfee ownership while asserting operational privacy separation. |
| OpenASN data source | `tunnelbear_openvpn` uses `https://tunnelbear.s3.amazonaws.com/support/linux/openvpn.zip`, parser `ovpn_zip_remote_hosts`, provider `TunnelBear`. |
| Source quality / status | Implemented as opt-in `vpn_dns`. TunnelBear's first-party Linux setup article links the public OpenVPN configuration archive. Parser extracts exact `remote` hostnames and accepts both `.ovpn` and `.ovpn.txt`, because the live archive currently suffixes several valid OpenVPN configs as `.ovpn.txt`. Clients resolve the hostnames locally. |
| Live smoke | On 2026-07-05, the archive fetched with HTTP 200, `Content-Length: 60247`, and `Last-Modified: Mon, 25 Aug 2025 18:58:11 GMT`. Parser found 47 hostnames. The OpenASN Tier B executor resolved 925 IPv4 addresses, 0 IPv6 addresses, and 0 DNS misses, merged them to 571 IPv4 overlay ranges, and classified sample IP `5.253.206.35` as `vpn`, provider `TunnelBear`, source `tunnelbear_openvpn`. |
| Caveats | Keep this opt-in. TunnelBear advertises more than 8000 servers in over 45 countries, while the Linux OpenVPN archive exposes country-level hostnames that fan out heavily through DNS. The resolved IP set is resolver-vantage-specific and may undercount or overcount compared with TunnelBear apps' internal server selection. |
| Primary source URLs | `https://www.tunnelbear.com/privacy-policy/`, `https://www.tunnelbear.com/terms-of-service/`, `https://www.tunnelbear.com/blog/linux_support/`, `https://tunnelbear.s3.amazonaws.com/support/linux/openvpn.zip`, `https://www.tunnelbear.com/blog/tunnelbear-transparency-report/`, `https://www.tunnelbear.com/blog/trust/`, `https://help.tunnelbear.com/hc/en-us/articles/360007004351-Where-can-I-tunnel-to-and-from` |

### Perfect Privacy

| Field | Detail |
|---|---|
| Public service URL | `https://www.perfect-privacy.com/` |
| Legal / privacy URLs | `https://www.perfect-privacy.com/en/terms`, `https://www.perfect-privacy.com/en/privacy-policy`, `https://www.perfect-privacy.com/downloads/openvpn/get?system=linux&scope=server&filetype=zip&protocol=udp` |
| Legal entity shown by official pages | Not verified from live official pages in this batch |
| Address / identifier | Not verified. Secondary/current-review material conflicts: some pages identify Swiss `Vectura Datamanagement LTD`; other historical/legal references point to German `CyberDock IT Solutions GmbH`. Treat the operator as unresolved until the official legal pages are fetched directly. |
| Registry / incorporation evidence | None obtained. No company number, incorporation date, or registry extract was verified. |
| Who is behind it | Secondary sources generally describe Perfect Privacy as an older privacy VPN service dating to around 2008, but OpenASN has no primary-source founder/operator proof in this batch. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Promising but blocked. Gluetun points to a first-party OpenVPN ZIP endpoint under `www.perfect-privacy.com`, which would be a good `ovpn_zip_remote_hosts` candidate if it fetches cleanly. From this environment, `www.perfect-privacy.com` failed DNS resolution on 2026-07-05, so no body, parser output, or legal-page smoke could be verified. |
| Live smoke | Failed. `curl` could not resolve `www.perfect-privacy.com` for the candidate ZIP URL during this batch. |
| Caveats | This should be retried from another network/resolver before being abandoned. If the ZIP fetches, verify license/legal identity and run the parser/resolver smoke before adding. Do not add Gluetun-derived Perfect Privacy data without a successful first-party fetch. |
| Primary source URLs | `https://www.perfect-privacy.com/`, `https://www.perfect-privacy.com/en/terms`, `https://www.perfect-privacy.com/en/privacy-policy`, `https://www.perfect-privacy.com/downloads/openvpn/get?system=linux&scope=server&filetype=zip&protocol=udp`, `https://github.com/qdm12/gluetun/tree/master/internal/provider/perfectprivacy` |

## Batch 6 - Browser VPNs, Cloudflare WARP, And Pango/Guardian Brands

This batch is intentionally published even though it did not add new OpenASN
data. Negative provenance matters: downstream developers should be able to see
that major brands were checked, what evidence was found, and why OpenASN did
not inflate weak marketing/location data into exact VPN-exit classifications.

### Opera VPN / Opera VPN Pro

| Field | Detail |
|---|---|
| Public service URL | `https://www.opera.com/features/free-vpn`, `https://www.opera.com/features/vpn-pro` |
| Legal / privacy URLs | `https://legal.opera.com/privacy/`, `https://blogs.opera.com/security/2024/09/opera-free-browser-vpn-no-log-audit-deloitte/` |
| Legal entity shown by official pages | Opera Norway AS |
| Address / identifier | Opera's privacy statement identifies Opera Norway AS as part of the Opera Group and gives postal contact as Opera Norway AS, P.O. Box 4214, Nydalen 0401, Oslo, Norway. Footer copyright on the privacy page says Opera Norway. |
| Registry / incorporation evidence | Official pages verify the current Norwegian operator and address. Registry-grade Norwegian organization number/incorporation date was not pulled in this batch. Treat older Opera Software ASA / Opera Software AS history separately from current Opera Norway AS legal-page evidence. |
| Who is behind it | Opera develops and publishes the Opera browsers. Opera says the free browser VPN is built into Opera for desktop and mobile. Opera's 2024 no-log audit post says the free browser VPN uses Opera's own server infrastructure, while VPN Pro servers are provided in collaboration with Nord. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Public Opera pages publish product claims, no-log audit evidence, and server-count/location marketing, but no exact IP, CIDR, or unauthenticated server-hostname inventory. The historical SurfEasy/Opera proxy reverse-engineering path uses app-like subscriber/device registration and client keys, which fails OpenASN's no-impersonation/no-private-client-state rule. |
| Live smoke | On 2026-07-05, `de.opera-proxy.net`, `us.opera-proxy.net`, `ca.opera-proxy.net`, and numbered variants `de0`, `us0`, `ca0` under `opera-proxy.net` did not resolve from this environment. That does not prove Opera has no exits; it proves those reverse-engineered hostnames are not a usable public source. |
| Caveats | Opera VPN Pro may overlap Nord infrastructure at the network layer, but OpenASN should not label Nord IPs as Opera unless Opera or Nord publishes a source that distinguishes Opera-branded egress. The free browser VPN may be a browser proxy rather than a full device VPN in some product modes; OpenASN only cares about exact observed egress IPs, and none were published. |
| Primary source URLs | `https://www.opera.com/features/free-vpn`, `https://www.opera.com/features/vpn-pro`, `https://legal.opera.com/privacy/`, `https://blogs.opera.com/security/2024/09/opera-free-browser-vpn-no-log-audit-deloitte/`, `https://github.com/spaze/oprah-proxy`, `https://www.michalspacek.com/opera-browsers-vpn-is-just-a-proxy` |

### Brave Firewall + VPN / Guardian Firewall

| Field | Detail |
|---|---|
| Public service URL | `https://brave.com/firewall-vpn/`, `https://guardianapp.com/`, `https://guardianapp.com/company/partners/brave/` |
| Legal / privacy URLs | `https://brave.com/terms-of-use/`, `https://brave.com/privacy/browser/`, `https://guardianapp.com/privacy-policy/`, `https://guardianapp.com/newsroom/dnsfilter-acquistion-release/` |
| Legal entity shown by official pages | Brave Software, Inc. for Brave services; Guardian Firewall is part of DNSFilter, Inc. |
| Address / identifier | Brave's terms and footer list Brave, Inc. / Brave Software, Inc. at 580 Howard St. Unit 402, San Francisco, CA 94105. Guardian's privacy policy says Guardian Firewall is part of DNSFilter, Inc. and operates under its own privacy policy, infrastructure, and separate data-retention systems. |
| Registry / incorporation evidence | Official Brave pages verify the San Francisco address and current service terms. Brave says the company dates from 2015 in its footer/copyright and public materials, but no California/Delaware registry extract was captured here. Guardian official launch material says Guardian Firewall's public release happened in 2019; DNSFilter announced the Guardian acquisition on 2022-08-10. |
| Who is behind it | Brave was founded by Brendan Eich and Brian Bondy. Guardian launch material identifies co-founders Will Strafach and Joshua Hill. Guardian was acquired by DNSFilter in 2022 and remains the backend technology partner called out in Brave's VPN materials. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Brave and Guardian public pages establish the relationship, but not exit addresses. A public Guardian endpoint, `https://connect-api.guardianapp.com/api/v1.3/servers/all-server-regions/city-by-country`, returned country/city metadata and server counts on 2026-07-05, but no IPs, CIDRs, or provider hostnames. Public Brave issues reference Guardian connection/credential APIs and server-status endpoints; those are product control-plane APIs, not redistributable OpenASN data. |
| Live smoke | On 2026-07-05, the Guardian regions endpoint returned HTTP 200 with 41 country rows, 57 city rows, and `server-count` totals summing to 615. Observed keys were location/region fields plus count/status fields; there were no exact egress addresses. The documented `/api/v1.3/server-status` candidate returned 404 without the app flow. |
| Caveats | This is high-value future coverage because Brave is mainstream and Guardian appears to expose structured control-plane data. Do not infer IPs from city names or server counts. Revisit if Guardian publishes a public exit list, a config archive, or an endpoint that returns exact egress hostnames/IPs without credentials or client impersonation. |
| Primary source URLs | `https://brave.com/firewall-vpn/`, `https://support.brave.com/hc/en-us/articles/4410838268429-How-do-I-use-the-Built-in-VPN-Firewall-Android`, `https://brave.com/blog/brave-and-guardian/`, `https://brave.com/blog/android-vpn/`, `https://brave.com/blog/desktop-vpn/`, `https://brave.com/terms-of-use/`, `https://brave.com/about/`, `https://guardianapp.com/privacy-policy/`, `https://guardianapp.com/newsroom/launch-press-release/`, `https://guardianapp.com/newsroom/dnsfilter-acquistion-release/`, `https://connect-api.guardianapp.com/api/v1.3/servers/all-server-regions/city-by-country`, `https://github.com/brave/brave-browser/issues/36277`, `https://github.com/brave/brave-browser/issues/55678` |

### Cloudflare WARP / 1.1.1.1

| Field | Detail |
|---|---|
| Public service URL | `https://1.1.1.1/`, `https://developers.cloudflare.com/1.1.1.1/`, `https://developers.cloudflare.com/warp-client/` |
| Legal / privacy URLs | `https://www.cloudflare.com/privacypolicy/`, `https://www.cloudflare.com/website-terms/`, `https://developers.cloudflare.com/1.1.1.1/privacy/`, `https://www.cloudflare.com/ips/` |
| Legal entity shown by official pages | Cloudflare, Inc. |
| Address / identifier | Cloudflare privacy and terms pages list Cloudflare, Inc., 101 Townsend St, San Francisco, CA 94107, USA. Cloudflare's about page also lists 101 Townsend St as the San Francisco headquarters. |
| Registry / incorporation evidence | Official pages verify the current legal entity and headquarters. No Delaware/SEC incorporation extract was added in this batch. Cloudflare is a public company, but that corporate history is not needed for the OpenASN source decision. |
| Who is behind it | Cloudflare operates the 1.1.1.1 resolver, WARP client, and Cloudflare One/Gateway products. These services can create egress traffic from Cloudflare infrastructure, but the semantics differ from a commercial consumer VPN: WARP, Zero Trust Gateway, dedicated egress IPs, and ordinary Cloudflare reverse-proxy traffic are distinct products. |
| OpenASN data source | Existing `cloudflare_ranges` source uses `https://www.cloudflare.com/ips-v4` and `https://www.cloudflare.com/ips-v6`, maps to context flag `cloudflare_range`, not `vpn`. |
| Source quality / status | Context-only. Cloudflare's public IP ranges are authoritative for Cloudflare proxy/source infrastructure, but Cloudflare's own Cloudflare One egress-policy docs say Cloudflare does not publish Cloudflare One Client egress IP ranges and that those egress IPs are not listed at the Cloudflare IP Ranges page. Therefore the public range list is too broad for a `vpn` verdict and incomplete/misaligned for WARP-specific egress. |
| Live smoke | On 2026-07-05, `https://www.cloudflare.com/ips-v4` returned 14 IPv4 CIDRs and `https://www.cloudflare.com/ips-v6` returned 6 IPv6 CIDRs. Those are already represented by `cloudflare_ranges` as context, not blocking classification. |
| Caveats | Never map all Cloudflare ranges to `vpn` or `hosting`. Doing so would label ordinary Cloudflare-fronted websites, Apple Private Relay overlap, CDN traffic, and Zero Trust traffic as a VPN signal. If Cloudflare ever publishes consumer WARP exit ranges, add a separate exact source id and keep `cloudflare_ranges` context-only. |
| Primary source URLs | `https://www.cloudflare.com/privacypolicy/`, `https://www.cloudflare.com/website-terms/`, `https://www.cloudflare.com/about-overview/`, `https://developers.cloudflare.com/1.1.1.1/privacy/`, `https://www.cloudflare.com/ips/`, `https://www.cloudflare.com/ips-v4`, `https://www.cloudflare.com/ips-v6`, `https://developers.cloudflare.com/cloudflare-one/traffic-policies/egress-policies/`, `https://developers.cloudflare.com/cloudflare-one/traffic-policies/egress-policies/dedicated-egress-ips/`, `https://developers.cloudflare.com/fundamentals/concepts/cloudflare-ip-addresses/` |

### Hotspot Shield

| Field | Detail |
|---|---|
| Public service URL | `https://www.hotspotshield.com/` |
| Legal / privacy URLs | `https://www.hotspotshield.com/terms/`, `https://www.hotspotshield.com/pp/`, `https://www.hotspotshield.com/legal/dmca/`, `https://blog.hotspotshield.com/hotspot-shield-is-now-part-of-aura/` |
| Legal entity shown by official pages | Anchorfree, LLC or Pango GmbH, depending on purchase context |
| Address / identifier | Hotspot Shield terms list Anchorfree, LLC with offices at 250 Northern Ave, 3rd Floor, Boston, MA 02210, United States, or Pango GmbH depending on purchase. Privacy contact lists Anchorfree LLC - Hotspot Shield, 250 Northern Ave, Floor 3, Boston, MA 02210, and Pango GmbH, Hansmatt 32, 6370 Stans, Switzerland. |
| Registry / incorporation evidence | Official pages verify the operator names and addresses. No Delaware/Massachusetts/Swiss registry extract was added in this batch. Hotspot Shield historical material identifies AnchorFree as the company behind the product; current Point Wild/Pango material should be treated as corporate-group context rather than a source of IP data. |
| Who is behind it | Hotspot Shield was historically the flagship AnchorFree VPN product. Aura acquired Pango in 2020; Point Wild says Aura later split into Aura and Pango Group in 2024, then Pango Group and Total Security merged and rebranded as Point Wild in December 2024. Pango/Point Wild portfolio material includes Hotspot Shield. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Product pages publish country/location counts, speed claims, and privacy/legal language, but no public exact egress IPs, CIDRs, or server hostnames. Public support articles list virtual locations by platform, not exit addresses. Gluetun has no Hotspot Shield provider; its provider-request template requires a public config ZIP, structured server list, or public server list plus sample configs, none of which were verified here. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official pages fetched successfully on 2026-07-05 and confirmed operator/legal facts. |
| Caveats | Hotspot Shield's Catapult Hydra/partner technology is widely white-labeled, so exact attribution may be difficult even with future IP observations. Do not import Netify/commercial/aggregator claims unless a license-clean exact feed is obtained. Revisit router/manual-setup pages only if they expose unauthenticated OpenVPN/WireGuard configs with redistribution-safe provenance. |
| Primary source URLs | `https://www.hotspotshield.com/`, `https://www.hotspotshield.com/terms/`, `https://www.hotspotshield.com/pp/`, `https://www.hotspotshield.com/legal/dmca/`, `https://support.hotspotshield.com/hc/en-us/articles/360040214211-What-are-the-current-Virtual-locations-on-Windows`, `https://blog.hotspotshield.com/hotspot-shield-is-now-part-of-aura/`, `https://www.pointwild.com/news/aura-splits-into-two-world-class-online-safety-companies/`, `https://www.pointwild.com/news/pango-group-merges-with-total-security-combined-company-rebranded-point-wild/`, `https://github.com/passteque/gluetun/issues/2055`, `https://github.com/qdm12/gluetun/discussions/2666` |

### Touch VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.touchvpn.net/` |
| Legal / privacy URLs | `https://www.touchvpn.net/privacy-policy.html`, `https://www.touchvpn.net/general-terms-and-conditions.html`, `https://www.touchvpn.net/legal-dmca.html` |
| Legal entity shown by official pages | VPN Proxy Pro, LLC, a Pango Group company; affiliates include TouchVPN LLC |
| Address / identifier | Touch VPN terms and privacy policy identify VPN Proxy Pro, LLC, 250 Northern Ave, 3rd Floor / Floor 3, Boston, MA 02210, United States. Terms say VPN Proxy Pro, LLC is a division of Pango Group and references affiliates including TouchVPN LLC. DMCA/contact pages use the same Boston address and `legalnotices@pango.co` / `support@pango.co` contact flow. |
| Registry / incorporation evidence | Official pages verify the operator names, Pango group relationship, and address. No state registry extracts for VPN Proxy Pro, LLC or TouchVPN LLC were obtained in this batch. |
| Who is behind it | Touch VPN is part of the Pango/Point Wild portfolio. The Android package observed from official links is `com.northghost.touchvpn`, preserving historical NorthGhost/TouchVPN app lineage, but current legal pages control OpenASN's operator dossier. Point Wild's 2024 portfolio material lists Touch VPN alongside Hotspot Shield, Betternet, VPN 360, and Ultra VPN. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Touch VPN pages publish product/platform links and marketing counts such as servers/countries, but no exact IP, CIDR, hostname, public config archive, or documented server-list API. Privacy policy references connecting to nearest/fastest VPN server and identifying server locations for diagnostics, but that is not a public inventory. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official privacy/terms pages fetched successfully on 2026-07-05 and confirmed legal/operator details. |
| Caveats | This provider is likely entangled with Pango/AnchorFree infrastructure. Do not label Touch VPN by borrowing Hotspot Shield/Pango ranges unless a source can distinguish Touch-branded exits. App-store packages, Firebase installer URLs, and browser-extension links are product distribution endpoints, not exit inventories. |
| Primary source URLs | `https://www.touchvpn.net/`, `https://www.touchvpn.net/privacy-policy.html`, `https://www.touchvpn.net/general-terms-and-conditions.html`, `https://www.touchvpn.net/legal-dmca.html`, `https://play.google.com/store/apps/details?id=com.northghost.touchvpn`, `https://apps.apple.com/us/app/touch-vpn-secure-hotspot-proxy/id991744383`, `https://www.pointwild.com/news/aura-splits-into-two-world-class-online-safety-companies/`, `https://www.pointwild.com/news/pango-group-merges-with-total-security-combined-company-rebranded-point-wild/` |

## Batch Queue

Suggested next batches, five-ish services each:

1. Batch 7: Bitdefender VPN, Kaspersky VPN, ESET VPN, F-Secure VPN / Freedome, Avast SecureLine / AVG VPN.
2. Batch 8: Betternet, VPN 360, UltraVPN, Norton Secure VPN, McAfee VPN.
3. Batch 9+: remaining not-added/free/peer/Pango/Kape/Nord Security/browser/mobile-app providers from `PROVIDER_SOURCES.md`.
