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
| Who is behind it | Opera develops and publishes the Opera browsers. Opera says the free browser VPN is built into Opera for desktop and mobile. Opera's 2024 no-log audit post said the free browser VPN used Opera's own server infrastructure while VPN Pro servers were provided in collaboration with Nord; the Batch 18 recheck records the later 2025/2026 revamped VPN Pro pages, which emphasize Lightway and location/server counts but still publish no exact exits. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Public Opera pages publish product claims, no-log audit evidence, and server-count/location marketing, but no exact IP, CIDR, or unauthenticated server-hostname inventory. The historical SurfEasy/Opera proxy reverse-engineering path uses app-like subscriber/device registration and client keys, which fails OpenASN's no-impersonation/no-private-client-state rule. |
| Live smoke | On 2026-07-05, `de.opera-proxy.net`, `us.opera-proxy.net`, `ca.opera-proxy.net`, and numbered variants `de0`, `us0`, `ca0` under `opera-proxy.net` did not resolve from this environment. That does not prove Opera has no exits; it proves those reverse-engineered hostnames are not a usable public source. |
| Caveats | Opera VPN Pro may overlap third-party VPN infrastructure at the network layer, but OpenASN should not label Nord/Lightway-capable/other provider IPs as Opera unless Opera or its infrastructure partner publishes a source that distinguishes Opera-branded egress. The free browser VPN may be a browser proxy rather than a full device VPN in some product modes; OpenASN only cares about exact observed egress IPs, and none were published. |
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

## Batch 7 - Antivirus-Suite VPNs And White-Label Infrastructure

This batch did not add OpenASN sources. That is still useful product data:
antivirus-suite VPNs are large enough to matter, but many are white-label,
account-gated, or app-only. OpenASN should document that boundary publicly
instead of letting downstream users guess whether these brands were missed.

### Bitdefender VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.bitdefender.com/en-us/consumer/vpn`, `https://www.bitdefender.com/consumer/support/answer/7126/` |
| Legal / privacy URLs | `https://www.bitdefender.com/en-us/site/view/legal-privacy-policy-for-home-users-solutions`, `https://www.bitdefender.com/consumer/support/answer/116380/` |
| Legal entity shown by official pages | BITDEFENDER S.R.L. |
| Address / identifier | Bitdefender's home-user privacy policy lists BITDEFENDER S.R.L., 15A Sos. Orhideelor, Orhideea Towers Building, 10-12 floors, 6th District, Bucharest, Romania, Bucharest Trade Register number `J40/20427/2005`, fiscal code `RO18189442`, email `privacy@bitdefender.com`, and DPO contact `dpo@bitdefender.com`. |
| Registry / incorporation evidence | Official legal pages verify the Romanian trade-register number and fiscal code. No direct Romanian registry extract was captured in this batch; do not treat the trade-register number alone as a complete incorporation record. |
| Who is behind it | Bitdefender is a Romanian cybersecurity company. Official contest/legal material identifies Florin Talpes as CEO/legal representative of BITDEFENDER SRL. The VPN product is Bitdefender-branded, but infrastructure responsibility is split: Bitdefender's privacy policy says IPVanish is used as data processor for VPN service delivery. |
| OpenASN data source | Not added as a separate provider. Existing `ipvanish_openvpn` may classify some shared infrastructure as `IPVanish`, but OpenASN has no exact source that maps individual exits to the Bitdefender brand. |
| Source quality / status | Official FAQ publishes a country/city location list and explicitly says Bitdefender VPN does not support router installation and does not provide `.ovpn` / `.conf` files or authentication details for direct integration. Official privacy policy says VPN connection establishment uses user/device IDs, IP addresses, and tokens, with IPVanish processing data on Bitdefender's behalf. None of those pages publish exact exits. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official support/legal pages fetched successfully on 2026-07-05 and confirmed 110 country-level locations, city-level marketing locations, and the no-router/no-config-file limitation. |
| Caveats | Do not relabel IPVanish ranges as Bitdefender. Bitdefender users may appear on IPVanish-operated infrastructure, but provider attribution requires an exact Bitdefender-specific mapping. A third-party review or commercial VPN database is not a substitute for first-party/legal-source evidence. |
| Primary source URLs | `https://www.bitdefender.com/en-us/consumer/vpn`, `https://www.bitdefender.com/consumer/support/answer/7126/`, `https://www.bitdefender.com/en-us/site/view/legal-privacy-policy-for-home-users-solutions`, `https://www.bitdefender.com/consumer/support/answer/116380/`, `https://www.bitdefender.com/en-us/site/view/bitdefender-ambassador-contest-terms` |

### Kaspersky VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.kaspersky.com/vpn-secure-connection`, `https://usa.kaspersky.com/vpn-secure-connection` |
| Legal / privacy URLs | `https://www.kaspersky.com/products-and-services-privacy-policy`, `https://www.kaspersky.com/end-user-license-agreement`, `https://support.kaspersky.com/kpc/1.0/en-us/227551.htm`, `https://support.kaspersky.com/ksec-for-windows/5.24/127345` |
| Legal entity shown by official pages | AO Kaspersky Lab |
| Address / identifier | Kaspersky's products-and-services privacy policy lists AO Kaspersky Lab, bldg. 3, 39A Leningradskoe Shosse, Moscow, 125212, Russian Federation. It also lists Kaspersky Labs GmbH, Schlosslaende 26, 85049 Ingolstadt, Germany as EU data-protection representative. |
| Registry / incorporation evidence | Official pages verify the current legal name and address. Kaspersky's own history material says the company was established on 1997-06-26; no Russian corporate-register extract was captured in this batch. |
| Who is behind it | Official Kaspersky pages identify Eugene Kaspersky as founder and CEO. Kaspersky describes itself as a privately owned cybersecurity company. U.S. consumer-product availability is materially affected by the 2024 U.S. ban and transition to UltraAV/Pango for U.S. antivirus customers; that transition does not establish a VPN exit source. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official product pages advertise 6000+ servers in 120+ locations globally, or 2000+ servers in 100+ locations on the U.S. product page, and support pages document account-generated OpenVPN/WireGuard router configuration export from My Kaspersky. Those config files require a subscription/account flow and are generated per user/location, so they fail OpenASN's public-source/no-private-client-state rule. No public exact IP/CIDR/hostname feed was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official product/support pages fetched successfully on 2026-07-05 and confirmed router/third-party-client support is account-gated through My Kaspersky. |
| Caveats | Kaspersky's router support is tempting, but it is not a public list. Do not script My Kaspersky login flows, reuse exported customer configs, or import forum screenshots. UltraAV/Pango migration evidence is relevant corporate/product context for U.S. customers, not Kaspersky VPN egress provenance. |
| Primary source URLs | `https://www.kaspersky.com/vpn-secure-connection`, `https://usa.kaspersky.com/vpn-secure-connection`, `https://www.kaspersky.com/products-and-services-privacy-policy`, `https://www.kaspersky.com/end-user-license-agreement`, `https://support.kaspersky.com/kpc/1.0/en-us/227551.htm`, `https://support.kaspersky.com/ksec-for-windows/5.24/127345`, `https://www.kaspersky.com/about/team/eugene-kaspersky`, `https://esg.kaspersky.com/en/about-company/brief-history`, `https://www.pointwild.com/news/statement-on-kaspersky-u-s-customers-transition-to-ultraav/` |

### ESET VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.eset.com/us/home/eset-vpn/` |
| Legal / privacy URLs | `https://help.eset.com/evpn/1/en-US/eula.html`, `https://help.eset.com/home_eset/en-US/privacy_policy.html`, `https://help.eset.com/home_eset/en-US/terms_of_use.html`, `https://help.eset.com/evpn/1/en-US/router_download_config.html` |
| Legal entity shown by official pages | ESET, spol. s r. o. |
| Address / identifier | ESET VPN EULA identifies ESET, spol. s r. o., Einsteinova 24, 85101 Bratislava, Slovak Republic, Business Registration Number `31333532`. ESET HOME terms/privacy also list Commercial Register administration by the Bratislava court, Section Sro, Entry No `3586/B`. |
| Registry / incorporation evidence | Official EULA, HOME terms, and privacy pages verify the Slovak legal entity, address, business registration number, and Commercial Register section/entry. A direct Slovak registry extract was not captured in this batch. |
| Who is behind it | ESET is a Slovak cybersecurity company. This batch did not re-verify founder/shareholder history from official ESET pages; keep the dossier scoped to the current legal operator unless a primary company-history source is added later. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official product pages advertise 70+ countries and protocol options including WireGuard and OpenVPN. Official router documentation explains how a user downloads WireGuard or OpenVPN router configuration after logging into ESET HOME, selecting a subscription/profile, choosing protocol/location/port, and saving credentials. That is account-gated, not a public exact inventory. A product-page screenshot showing an example IP is illustrative UI, not source data. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official ESET VPN, EULA, HOME, and router-config pages fetched successfully on 2026-07-05 and confirmed the account-gated configuration path. |
| Caveats | Do not use user-exported ESET router configs, screenshots, or third-party guesses. If ESET later publishes an unauthenticated server manifest or config archive, it may be a strong candidate because the OpenASN parser stack already supports WireGuard/OpenVPN-style host extraction elsewhere. |
| Primary source URLs | `https://www.eset.com/us/home/eset-vpn/`, `https://help.eset.com/evpn/1/en-US/eula.html`, `https://help.eset.com/home_eset/en-US/privacy_policy.html`, `https://help.eset.com/home_eset/en-US/terms_of_use.html`, `https://help.eset.com/evpn/1/en-US/router_download_config.html`, `https://support.eset.com/en/kb8892-eset-vpn-for-router`, `https://help.eset.com/evpn/1/en-US/connection.html` |

### F-Secure VPN / Freedome

| Field | Detail |
|---|---|
| Public service URL | `https://www.f-secure.com/en/vpn` |
| Legal / privacy URLs | `https://www.f-secure.com/en/legal/privacy/statement`, `https://www.f-secure.com/en/legal/privacy/total`, `https://www.f-secure.com/en/legal/terms/vpn`, `https://help.f-secure.com/product.html?home%2Ffreedome%2Flatest%2Fen%2Fid_55701-freedome-latest-en=` |
| Legal entity shown by official pages | F-Secure Corporation |
| Address / identifier | F-Secure privacy statement identifies F-Secure Corporation as a Finnish publicly listed corporation with Business ID `3269349-7`. Contact address: F-Secure Corporation, Tammasaarenkatu 7, PL 24, 00180 Helsinki, Finland. |
| Registry / incorporation evidence | Official privacy statement verifies the current Finnish public-company identity and Business ID. No Finnish registry extract was captured in this batch. Historical Freedome/product-history details are separate from the current post-demerger F-Secure Corporation identity. |
| Who is behind it | F-Secure Corporation operates the current consumer security suite. Its Total privacy notice says the service can include a VPN component, and the VPN privacy section distinguishes old VPN protocols from the new VPN feature. The same notice says the new VPN feature uses a third-party provider and links that provider to Pango's privacy policy. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official documentation publishes protocols/ports and product privacy details, not exits. F-Secure help says Android/macOS/Windows use OpenVPN on TCP/UDP ports 2700-2800 and TCP 443. The Total privacy notice says the old VPN version has OpenVPN and IPSec/IKEv2, while the new VPN version has Hydra, WireGuard, and IPSec, and that F-Secure engages Pango for the new VPN feature. Official/community support material says router-level OpenVPN configuration is not supported. No public exact IP/CIDR/hostname feed was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official legal/privacy/help pages fetched successfully on 2026-07-05 and confirmed protocol/port details plus Pango as third-party provider for the new VPN feature. |
| Caveats | Pango involvement is infrastructure context, not attribution. Do not label Pango/Hotspot Shield/UltraVPN ranges as F-Secure without a brand-specific exact mapping. Old Freedome and new F-Secure VPN may have different backends, so any future source must say which product generation it covers. |
| Primary source URLs | `https://www.f-secure.com/en/vpn`, `https://www.f-secure.com/en/legal/privacy/statement`, `https://www.f-secure.com/en/legal/privacy/total`, `https://www.f-secure.com/en/legal/terms/vpn`, `https://help.f-secure.com/product.html?home%2Ffreedome%2Flatest%2Fen%2Fid_55701-freedome-latest-en=`, `https://community.f-secure.com/en/discussion/129278/does-f-secure-vpn-server-support-by-example-openvpn-client-on-my-asus-router`, `https://www.pango.co/legal/privacy-policy` |

### Avast SecureLine VPN / AVG Secure VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.avast.com/en-us/secureline-vpn`, `https://www.avg.com/en-us/avg-secure-vpn` |
| Legal / privacy URLs | `https://www.avast.com/en-us/vpn-policy`, `https://www.avg.com/en-us/vpn-policy`, `https://www.avast.com/ko-kr/eula-avast-secureline-vpn-standalone`, `https://www.avg.com/en-us/eula`, `https://www.avast.com/en-us/consent-policy`, `https://www.avg.com/en-us/secure-vpn-acceptable-use` |
| Legal entity shown by official pages | Avast Software s.r.o. for the SecureLine standalone EULA and EMEA AVG vendor; Gen Digital Inc. for North/Central/South America AVG EULA vendor. |
| Address / identifier | Avast SecureLine standalone EULA identifies Avast Software s.r.o., registered in the Commercial Register maintained by the Municipal Court in Prague, Section C, Insert No. `216540`, Identification No. `021 764 75`. Avast/AVG consent and EULA pages list Avast Software s.r.o., Pikrtova 1737/1a, Nusle / Prague 4, 140 00 Praha 4, Czech Republic. AVG EULA lists Gen Digital Inc., 60 E. Rio Salado Parkway, Suite 1000, Tempe, AZ 85281, USA for the Americas. |
| Registry / incorporation evidence | Official EULA pages verify the Czech registration identifiers and regional vendor mapping. No Czech or U.S. registry extract was captured in this batch. |
| Who is behind it | Avast and AVG are Gen Digital brands. Avast's about page says Avast is part of Gen; AVG and Avast VPN policies use the same Gen/Avast legal stack and very similar VPN-policy language. AVG was acquired by Avast in 2016, and both now sit under Gen Digital. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official support pages publish app-level server-location workflows, OpenVPN/WireGuard/Mimic/IPsec protocol choices, IP Rotation, Double VPN, and product behavior. Avast and AVG VPN policies say they process selected/assigned VPN location, VPN protocol, and VPN server IP as server/network metadata, but they do not publish the actual server inventory. Community support says Avast/AVG SecureLine/Secure VPN do not officially support router configuration and do not expose a public `.ovpn` list like HMA. No exact public IP/CIDR/hostname feed was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official Avast and AVG VPN policy pages fetched successfully on 2026-07-05; Avast policy was last updated 2026-05-07, AVG policy 2026-01-10. Official Avast support showed app-only location selection and protocol options but no exact exits. |
| Caveats | Avast and AVG likely share infrastructure, but OpenASN needs exact source evidence before adding either label. Avoid Netify/commercial IP pages and user-extracted client credentials: they are aggregator/private-client data and fail the repo's legal/source rules. HMA is a sibling Gen/Avast VPN brand, but its historical OpenVPN source issues should not be copied onto Avast/AVG without a clean current source. |
| Primary source URLs | `https://www.avast.com/en-us/secureline-vpn`, `https://support.avast.com/en-us/article/secureline-vpn-faq/`, `https://www.avast.com/en-us/vpn-policy`, `https://www.avg.com/en-us/avg-secure-vpn`, `https://www.avg.com/en-us/vpn-policy`, `https://www.avast.com/ko-kr/eula-avast-secureline-vpn-standalone`, `https://www.avg.com/en-us/eula`, `https://www.avast.com/en-us/consent-policy`, `https://www.avg.com/en-us/secure-vpn-acceptable-use`, `https://community.avast.com/t/setting-avast-secureline-in-my-router/755208`, `https://community.avg.com/t/avg-secure-vpn-is-there-a-way-to-get-a-ovpn-file-for-router/277263`, `https://newsroom.gendigital.com/2016-07-07-avast-announces-agreement-to-acquire-avg-for-1-3b` |

## Batch 8 - Pango / Point Wild And Consumer-Suite VPNs

This batch added no sources. Three Pango/Point Wild brands expose useful
operator and legal evidence but explicitly do not publish usable exit
inventories. Norton and McAfee expose product/location material only. Keeping
the negative result public prevents future agents from redoing the same weak
scrape/probe paths.

### Betternet

| Field | Detail |
|---|---|
| Public service URL | `https://www.betternet.co/` |
| Legal / privacy URLs | `https://www.betternet.co/terms/`, `https://www.betternet.co/privacy-policy/vpn/`, `https://www.pango.co/legal/privacy-policy` |
| Legal entity shown by official pages | Betternet LLC for the Betternet terms; Intersections, LLC d/b/a Pango Group for the current Pango privacy policy. |
| Address / identifier | Betternet terms list Betternet LLC, 250 Northern Ave, 3rd Floor, Boston, MA 02210, United States. Pango privacy lists Intersections, LLC d/b/a Pango Group, 250 Northern Ave, Floor 3, Boston, Massachusetts, 02210. Google Play currently lists BetterNet LLC with a Burlington, MA developer address. |
| Registry / incorporation evidence | Official terms/app-store pages verify the current operator names and addresses. No Delaware/Massachusetts registry extract or formation date for Betternet LLC was captured in this batch. |
| Who is behind it | Betternet is a Pango/Point Wild portfolio VPN. Point Wild's 2024 separation and merger announcements place Betternet alongside Hotspot Shield, Touch VPN, Ultra VPN, Ultra AV, and VPN 360 in the Pango/Point Wild portfolio. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Public pages publish marketing claims, platform links, and app-store counts only. The Android app page advertises 1000+ fast VPN proxy server options for premium users, but not IPs/CIDRs/hostnames. Betternet's terms explicitly prohibit attempting to compile, use, or distribute a list of IP addresses operated with the service. Public-site asset scans found app/support/account links and WordPress metadata, not server manifests, config archives, or exact host lists. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official Betternet legal/privacy/product pages fetched successfully on 2026-07-05. Gluetun had no Betternet provider/source match in the current clone checked that day. |
| Caveats | Do not probe Betternet clients or DNS into an IP list. Its terms make that path legally hostile, and OpenASN's legal invariant is stricter than technical feasibility. Do not borrow Hotspot Shield/Pango ranges unless a source distinguishes Betternet-branded exits. |
| Primary source URLs | `https://www.betternet.co/`, `https://www.betternet.co/terms/`, `https://www.betternet.co/privacy-policy/vpn/`, `https://www.pango.co/legal/privacy-policy`, `https://play.google.com/store/apps/details?id=com.freevpnintouch`, `https://www.pointwild.com/news/aura-splits-into-two-world-class-online-safety-companies/`, `https://www.pointwild.com/news/pango-group-merges-with-total-security-combined-company-rebranded-point-wild/` |

### VPN 360

| Field | Detail |
|---|---|
| Public service URL | `https://www.vpn360.com/` |
| Legal / privacy URLs | `https://www.vpn360.com/legal/software-license-and-terms-of-service/`, `https://www.vpn360.com/privacy-notice/`, `https://www.vpn360.com/legal/privacy-policy/`, `https://legal.vpn360.com/documents/terms_of_service`, `https://legal.vpn360.com/documents/privacy_policy` |
| Legal entity shown by official pages | Pango GmbH and Anchorfree LLC in the VPN 360 terms; Anchorfree LLC in the site footer; Pango, LLC in Google Play developer metadata. |
| Address / identifier | VPN 360 terms list Pango GmbH, Hansmatt 32, 6370 Stans, Switzerland, and Anchorfree LLC, 250 Northern Ave, 3rd Floor, Boston, MA 02210, United States. Google Play lists Pango, LLC at 250 Northern Ave Ste 300, Boston, MA 02210. |
| Registry / incorporation evidence | Official terms verify the Swiss and U.S. operator names/addresses. Third-party Swiss registry mirrors identify Pango GmbH as CHE-183.861.773 and indicate registration on 2012-01-06, but no primary Swiss registry extract was captured in this batch. |
| Who is behind it | VPN 360 is part of the Pango/Point Wild family. Point Wild's 2024 separation announcement names VPN 360 in the Pango Group brand portfolio, and VPN 360's own support/help center runs under the Pango Zendesk account. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Public pages give inconsistent marketing counts: the home page says 800+ servers, 85 countries, and 110+ city-level servers; the Apple App Store text observed in this batch says 1800+ servers across 125+ locations. VPN 360 support says each server has a pool of shared IP addresses and users may receive different IPs on repeated connections. The terms prohibit attempting to compile, use, or distribute a service IP-address list. No public exact IP/CIDR/hostname list, OpenVPN ZIP, WireGuard config, or API manifest was found. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official product, privacy, terms, Google Play, and the "different IP every-time" support article fetched successfully on 2026-07-05. Public-site/sitemap/support scans found app/support/legal links only. Gluetun had no VPN 360 provider/source match in the current clone. |
| Caveats | Treat marketing server counts as non-data. The support article proves shared IP pools exist, not what those IPs are. Do not turn client observation, account flows, or the Hotspot Shield/Pango shared backend into provider attribution. |
| Primary source URLs | `https://www.vpn360.com/`, `https://www.vpn360.com/legal/software-license-and-terms-of-service/`, `https://www.vpn360.com/privacy-notice/`, `https://www.vpn360.com/legal/privacy-policy/`, `https://support.vpn360.com/hc/en-us/articles/8528302092948-Will-I-get-a-different-IP-every-time`, `https://play.google.com/store/apps/details?id=co.infinitysoft.vpn360`, `https://apps.apple.com/us/app/vpn-360-fast-total-vpn-proxy/id1193154948`, `https://www.pointwild.com/news/aura-splits-into-two-world-class-online-safety-companies/` |

### UltraVPN

| Field | Detail |
|---|---|
| Public service URL | `https://ultravpn.com/`, `https://ultravpn.com/locations/` |
| Legal / privacy URLs | `https://ultravpn.com/terms/`, `https://ultravpn.com/privacy/`, `https://ultravpn.com/privacy-notice/`, `https://ultravpn.com/additional-terms/` |
| Legal entity shown by official pages | Fast VPN Pro, S. de R.L.; Anchorfree LLC as trademark owner for UltraVPN / UltraAV marks. |
| Address / identifier | UltraVPN terms and privacy pages identify Fast VPN Pro, S. de R.L., Office 1705, 17th Floor, PH Midtown SF 74, 74 E Street, San Francisco, Panama City, Republic of Panama. The terms say UltraVPN and UltraAV are registered trademarks of Anchorfree, LLC. |
| Registry / incorporation evidence | Official UltraVPN legal pages verify the Panamanian entity and address. A third-party Panama company profile for Fast VPN Pro exists, but no official Panama registry extract or exact incorporation date was captured in this batch. |
| Who is behind it | UltraVPN is in the Pango/Point Wild portfolio. Point Wild's 2024 separation announcement names Ultra VPN and Ultra AV in the Pango Group portfolio; the later Point Wild merger announcement names UltraAV, Hotspot Shield, Betternet, and related brands in the combined company. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | UltraVPN publishes virtual-location and capacity marketing, including over 125 global locations and a locations-page FAQ claiming 1300 bare-metal servers. It also describes the proprietary Catapult Hydra protocol. The terms prohibit attempting to compile, use, or distribute a list of service IP addresses. Public-site scans found WordPress pages/assets and account/support links, not config archives or exact server feeds. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official UltraVPN terms, privacy, product, locations, and support landing pages fetched successfully on 2026-07-05. Gluetun had no UltraVPN provider/source match in the current clone. |
| Caveats | Do not reverse engineer Hydra/client behavior or use app captures to build an IP list. Do not assume UltraVPN equals all Anchorfree/Pango/Hotspot Shield infrastructure; brand-level attribution still needs a brand-level exact source. |
| Primary source URLs | `https://ultravpn.com/`, `https://ultravpn.com/locations/`, `https://ultravpn.com/terms/`, `https://ultravpn.com/privacy/`, `https://ultravpn.com/privacy-notice/`, `https://ultravpn.com/additional-terms/`, `https://play.google.com/store/apps/details?id=tech.hexa`, `https://apps.apple.com/us/developer/fast-vpn-pro-s-de-r-l/id1693337853`, `https://www.pointwild.com/news/aura-splits-into-two-world-class-online-safety-companies/`, `https://www.pointwild.com/news/pango-group-merges-with-total-security-combined-company-rebranded-point-wild/` |

### Norton Secure VPN / Norton VPN

| Field | Detail |
|---|---|
| Public service URL | `https://us.norton.com/products/norton-vpn`, `https://us.norton.com/feature/vpn-server-locations` |
| Legal / privacy URLs | `https://us.norton.com/legal/lsa`, `https://us.norton.com/privacy/products-privacy-notice`, `https://us.norton.com/privacy/general-privacy-notice` |
| Legal entity shown by official pages | Gen Digital Inc. |
| Address / identifier | Norton License and Services Agreement says the software and services are licensed by Gen Digital Inc., ATTN: Legal Department, 60 E. Rio Salado Pkwy, Ste 1000, Tempe, AZ 85281. |
| Registry / incorporation evidence | Official Norton legal pages verify the current licensing entity and address. Gen's own investor/press material documents the 2022 NortonLifeLock/Avast combination and Gen brand launch; a direct corporate registry extract was not captured in this batch. |
| Who is behind it | Norton is a Gen Digital brand. Gen Digital operates Norton, Avast, LifeLock, Avira, AVG, ReputationDefender, CCleaner, and related consumer cybersecurity brands after the NortonLifeLock/Avast combination. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Norton publishes product, privacy, and location information, not exact exits. The product page still contains a plan block saying 2800 servers in 28 countries, while a 2026 Norton blog post says Norton VPN expanded to 130+ server locations in over 90 countries. The server-location page is a country/city list, not IP/CIDR/hostname data. Norton support documents Double VPN, IP Rotation, Manual IP Refresh, kill switch, and related behavior; privacy pages say Norton records the day of a VPN connection and which VPN location is used, but not device IPs, DNS queries, or browsing history. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Norton product, legal, privacy, support, and server-location pages fetched successfully on 2026-07-05. A third-party GitHub search result mentioning a `nortonvpn.io` hostname pattern was rejected as non-authoritative; sampled `nortonvpn.io` hostnames did not resolve from this environment. Gluetun had no Norton provider/source match in the current clone. |
| Caveats | Norton location/count pages are useful product context but cannot classify IPs. Do not import third-party hostname dumps, generated patterns, app captures, or commercial VPN databases. Norton/Avast/AVG share a parent company, but that does not imply shared egress attribution. |
| Primary source URLs | `https://us.norton.com/products/norton-vpn`, `https://us.norton.com/feature/vpn-server-locations`, `https://us.norton.com/blog/vpn/norton-vpn-expands-to-130-locations`, `https://support.norton.com/sp/en/us/home/current/solutions/v117552006`, `https://us.norton.com/privacy/products-privacy-notice`, `https://us.norton.com/legal/lsa`, `https://investor.gendigital.com/news/news-details/2022/Introducing-Gen-The-Company-to-Power-Digital-Freedom/default.aspx` |

### McAfee VPN / McAfee Safe Connect

| Field | Detail |
|---|---|
| Public service URL | `https://www.mcafee.com/en-us/vpn.html` |
| Legal / privacy URLs | `https://www.mcafee.com/en-us/consumer-support/policy/legal.html`, `https://www.mcafee.com/en-us/consumer-corporate/about.html`, `https://www.mcafee.com/en-us/consumer-corporate/investors.html` |
| Legal entity shown by official pages | McAfee LLC for U.S./Americas downloads; McAfee Ireland Limited and McAfee Co., Ltd. for other regions. |
| Address / identifier | McAfee legal terms list McAfee, LLC, a Delaware limited liability company, 6220 America Center Drive, San Jose, California 95002, USA; McAfee Ireland Limited, Building 2000 City Gate, Mahon, Cork, Ireland; and McAfee Co., Ltd., Dai-ichi Life Hibiya First, 1-13-2 Yurakucho, Chiyoda-ku, Tokyo 100-0006, Japan. McAfee's about page lists headquarters at 6220 America Center Drive, San Jose, CA 95002, USA. |
| Registry / incorporation evidence | Official McAfee legal pages verify the Delaware LLC statement and regional contracting entities. No Delaware, Irish, or Japanese registry extract or formation date was captured in this batch. McAfee's investor page links the 2022 investor-group acquisition press release; separate SEC material documents the 2021 enterprise-business sale to STG. |
| Who is behind it | McAfee is currently a consumer online-protection company. The enterprise business was divested to STG in 2021, and McAfee's investor page links the 2022 acquisition by an investor group led by Advent International and Permira. TunnelBear is McAfee-owned but remains a separate VPN dossier/source decision. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official support/search material found in this batch documents virtual locations and Secure VPN FAQ/product behavior, not exact IP/CIDR/hostname exits. McAfee pages were WAF-sensitive from this environment: legal/about/investor content was captured during research, while direct curl probes later returned 403/transport failures for some URLs. No public OpenVPN/WireGuard config archive, server API, or exact egress feed was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. McAfee legal/about/investor content and official support snippets were captured on 2026-07-05; direct curl access to McAfee VPN product/support/legal URLs was intermittently blocked from this environment. Gluetun had no McAfee provider/source match in the current clone. |
| Caveats | Do not label McAfee VPN exits from TunnelBear data; TunnelBear is a separate McAfee-owned service with its own source and semantics. Avoid user screenshots, paid-account captures, and third-party review claims. A future accepted source needs exact public exits and clear rights from McAfee or a license-clean authority. |
| Primary source URLs | `https://www.mcafee.com/en-us/vpn.html`, `https://mcafee.com/support/s/article/000001789?language=en_US`, `https://www.mcafee.com/support/s/article/000001911?language=en_US`, `https://www.mcafee.com/en-us/consumer-support/policy/legal.html`, `https://www.mcafee.com/en-us/consumer-corporate/about.html`, `https://www.mcafee.com/en-us/consumer-corporate/investors.html`, `https://www.sec.gov/Archives/edgar/data/1783317/000119312521072222/d101914dex991.htm`, `https://www.permira.com/news-and-insights/announcements/mcafee-to-be-acquired-by-an-investor-group-for-over-14-billion/` |

## Batch 9 - Peer, Residential, And Decentralized VPNs

This batch added no OpenASN sources. The negative result is important:
these products often market "VPN" but their infrastructure model includes
peer, residential, decentralized, or account-gated exits. For OpenASN that is
a higher-risk area than ordinary hosted VPNs. A false positive here could mark
real household, mobile, or business IPs as provider-operated VPN exits.

### Urban VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.urban-vpn.com/`, `https://www.urban-vpn.com/faq/` |
| Legal / privacy URLs | `https://www.urban-vpn.com/about-us/terms-of-service/`, `https://www.urban-vpn.com/about-us/privacy/`, `https://www.urban-vpn.com/about-us/ccpa-notice/` |
| Legal entity shown by official pages | Urban Cyber Security Inc. |
| Address / identifier | Urban's privacy and CCPA pages list Urban Cyber Security Inc., 501 Fifth Avenue, New York, NY, 10036, and privacy contact `privacy@urban-vpn.com`. |
| Registry / incorporation evidence | Official Urban pages verify the current legal name and contact address. No New York/Delaware registry extract or incorporation date was captured in this batch. |
| Who is behind it | Urban's terms name Urban Cyber Security Inc. as operator. Its privacy page says Urban shares Web Browsing Data with affiliated company B.I Science (2009) Ltd. to create commercial marketing insights. Its FAQ describes two networks: "UrbanVPN Network" with servers in 80+ countries and 632 global server locations, and "UrbanVPN Premium" with dedicated high-speed VPN servers for Mac, iOS, and Android. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages publish location marketing, operator/legal text, and network descriptions, not exact IPs/CIDRs/hostnames. Sitemap probes found page/location sitemaps only (`page-sitemap.xml`, `locations-sitemap.xml`, etc.). No public OpenVPN/WireGuard ZIP, server API, PAC/proxy manifest, or exact egress list was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official terms/privacy/FAQ pages fetched successfully on 2026-07-05. The current Gluetun clone checked in `/tmp/gluetun-openasn` had no Urban VPN provider/source match. |
| Caveats | Do not infer VPN exits from Urban location pages, browser-extension behavior, user observations, or the B.I Science relationship. Data-broker/affiliate evidence is operator context, not egress provenance. If Urban later publishes an exact public server manifest, premium and free-network semantics need to be distinguished before provider labels are emitted. |
| Primary source URLs | `https://www.urban-vpn.com/`, `https://www.urban-vpn.com/faq/`, `https://www.urban-vpn.com/about-us/terms-of-service/`, `https://www.urban-vpn.com/about-us/privacy/`, `https://www.urban-vpn.com/about-us/ccpa-notice/`, `https://www.urban-vpn.com/sitemap.xml`, `https://www.urban-vpn.com/locations-sitemap.xml` |

### Hola VPN

| Field | Detail |
|---|---|
| Public service URL | `https://hola.org/`, `https://hola.org/faq`, `https://hola.org/locations` |
| Legal / privacy URLs | `https://hola.org/legal/sla`, `https://hola.org/legal/privacy`, `https://hola.org/legal/sdk`, `https://hola.org/dna/dict` |
| Legal entity shown by official pages | Hola VPN Ltd. |
| Address / identifier | Hola's EULA and privacy pages identify Hola VPN Ltd. as the service operator. The EULA gives `info@hola.org` as contact. No official street address was found in the official legal pages checked in this batch. |
| Registry / incorporation evidence | Official legal pages verify the current legal name. Official FAQ/DNA pages say Hola was founded in 2008; no corporate-registry extract, incorporation number, or primary founder record was captured in this batch. |
| Who is behind it | Hola describes itself as a collaborative P2P/value-exchange internet service. The FAQ says Hola free works by sharing contributed user resources, recommends Bright Data for commercial proxy use, and says Hola Premium uses a dedicated network of high-performance servers. The EULA says free use may allow other Hola devices to reroute through the user's device, and separately says free use may make the user a peer on the Bright Data network. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Hola publishes extensive country/location marketing (`sitemap_vpn.xml`) and legal explanations of P2P / Bright Data resource sharing, but no exact IP/CIDR/hostname inventory. Location pages prove product coverage, not current exits. Premium's dedicated-server claim is not enough without exact public host/IP data. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official FAQ, EULA, privacy, SDK, and VPN-location sitemap pages fetched successfully on 2026-07-05. The current Gluetun clone had no Hola provider/source match. |
| Caveats | Do not label arbitrary Hola peers as `vpn`; they may be residential or mobile customers. Do not import Bright Data proxy network claims as Hola VPN exits. Do not scrape client traffic, user devices, browser extension internals, or paid-account state. A future source needs exact public exits and must separate free P2P, Premium dedicated servers, and Bright Data business/proxy flows. |
| Primary source URLs | `https://hola.org/faq`, `https://hola.org/legal/sla`, `https://hola.org/legal/privacy`, `https://hola.org/legal/sdk`, `https://hola.org/dna/dict`, `https://hola.org/locations`, `https://hola.org/sitemap_vpn.xml` |

### Bright VPN

| Field | Detail |
|---|---|
| Public service URL | `https://brightvpn.com/`, `https://brightvpn.com/vpn-servers-list` |
| Legal / privacy URLs | `https://brightvpn.com/legal/sla`, `https://brightvpn.com/legal/privacy`, `https://brightvpn.com/service-terms-simplified`, `https://brightvpn.com/service-privacy-simplified`, `https://brightdata.com/privacy`, `https://brightdata.com/contact`, `https://brightdata.com/luminati`, `https://bright-sdk.com/privacy-policy` |
| Legal entity shown by official pages | Bright Data Ltd. |
| Address / identifier | Bright Data's official contact/privacy pages list Bright Data Ltd. headquarters at 4 Hamahshev St., Netanya 4250714, Israel (POB 8025), plus U.S. Bright Data, Inc. offices in San Francisco and New York. |
| Registry / incorporation evidence | Official Bright Data pages verify the legal name and headquarters. Bright Data's own Luminati page says Luminati Networks was founded in 2014 and later became Bright Data. No Israeli registry extract or BrightVPN-specific incorporation record was captured in this batch. |
| Who is behind it | BrightVPN's EULA names Bright Data Ltd. as operator. The EULA says BrightVPN is a full VPN app and is free in return for allowing use of the user's internet connection when available. BrightVPN's simplified terms say Bright Data is BrightVPN's parent company and accesses the web from the user's IP address. Bright SDK's privacy policy describes Bright Data customers routing traffic through peers' available resources and treating peer devices as nodes in the Bright Data network. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | The public `vpn-servers-list` page is location/product marketing only. Sitemap and asset probes found translated pages, extension-store links, WordPress AJAX metadata, and a stale `zs-www-brightvpn-b.luminati.io` reference that did not resolve from this environment. `https://brightvpn.com/default.json` and likely theme JSON paths returned 404. No exact IP/CIDR/hostname feed, config archive, or unauthenticated server API was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official BrightVPN legal/privacy/product pages, Bright Data contact/privacy/Luminati pages, and Bright SDK privacy pages fetched successfully on 2026-07-05. The current Gluetun clone had no BrightVPN provider/source match. |
| Caveats | BrightVPN is a consumer VPN wrapped around Bright Data peer/proxy economics. Do not classify Bright Data residential/proxy peers as BrightVPN exits. Do not use browser-extension packages, client traffic, or partner/customer APIs as source material. If a future source appears, OpenASN may need a separate residential-proxy/decentralized-peer model rather than a normal `vpn` provider label. |
| Primary source URLs | `https://brightvpn.com/`, `https://brightvpn.com/vpn-servers-list`, `https://brightvpn.com/legal/sla`, `https://brightvpn.com/legal/privacy`, `https://brightvpn.com/service-terms-simplified`, `https://brightvpn.com/service-privacy-simplified`, `https://brightdata.com/privacy`, `https://brightdata.com/contact`, `https://brightdata.com/luminati`, `https://bright-sdk.com/privacy-policy` |

### Mysterium VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.mysteriumvpn.com/`, `https://www.mysterium.network/mysteriumvpn`, `https://docs.mysterium.network/about-mysterium` |
| Legal / privacy URLs | `https://www.mysteriumvpn.com/privacy-policy-vpn`, `https://www.mysteriumvpn.com/terms-conditions-vpn`, `https://www.mysterium.network/privacypolicy` |
| Legal entity shown by official pages | UAB MN Intelligence for the Mysterium VPN product terms; UAB "MN Intelligence" in the Mysterium VPN footer; BlockDev AG for Mysterium Network docs/site footer. |
| Address / identifier | Mysterium VPN terms identify UAB MN Intelligence as VPN service/software provider and `help@mysteriumvpn.com` as contact. Mysterium Network docs list BlockDev AG, Alpenstrasse 14, 6300 Zug, Switzerland, and say discovery services within Mysterium Network are run by NetSys Inc. |
| Registry / incorporation evidence | Official pages verify the current product operator and network developer names. No Lithuanian, Swiss, or NetSys registry extract or incorporation date was captured in this batch. Mysterium docs say Mysterium Network was founded in 2017 and launched mainnet in 2021. |
| Who is behind it | Mysterium VPN is built on the Mysterium decentralized node network. Official pages describe it as a hybrid of residential and regular VPN, where users pay peers in the distributed network to connect to residential IP addresses. The protocol/network documentation says Mysterium is an open-source ecosystem with a permissionless P2P marketplace, WireGuard-based connectivity, and APIs/SDKs for builders. |
| OpenASN data source | Not added. Candidate research endpoint: `https://discovery.mysterium.network/api/v3/proposals?include_monitoring_failed=true`. |
| Source quality / status | The discovery API is public and structured, but it did not expose exact exit IPs in live smoke. It returned proposal ids, provider ids, service type, location metadata (`country`, `region`, `city`, `asn`, `isp`, `ip_type`), quality metrics, and `nats/p2p/v1` broker contacts. Broker addresses are infrastructure contacts, not the node's exit IP. Without an exact exit IP/CIDR/hostname field, OpenASN cannot map lookups to Mysterium providers. |
| Live smoke | Live API smoke on 2026-07-05 fetched 12,251 proposals with contact type `nats/p2p/v1` and no exact exit-IP field. `ip_type` counts included 6,727 residential, 4,630 hosting, 457 cellular, 225 business, 192 content-delivery-network, 6 education, 5 government, 4 organization, 4 search-engine-spider, and 1 datacenter. Official VPN/legal/network/doc pages fetched successfully except the Mysterium VPN home page returned 403 to direct curl from this environment. The current Gluetun clone had no Mysterium provider/source match. |
| Caveats | This is not a normal hosted VPN source. Even if exact node IPs become available later, default ingestion would be risky because the network deliberately includes residential and cellular peers. A future implementation probably needs an opt-in decentralized/residential-peer source group, very explicit provider semantics, high churn handling, and a warning that "Mysterium node" is not the same as "commercial datacenter VPN exit." |
| Primary source URLs | `https://www.mysteriumvpn.com/privacy-policy-vpn`, `https://www.mysteriumvpn.com/terms-conditions-vpn`, `https://www.mysterium.network/mysteriumvpn`, `https://docs.mysterium.network/about-mysterium`, `https://docs.mysterium.network/faq`, `https://github.com/mysteriumnetwork/node`, `https://github.com/mysteriumnetwork/discovery`, `https://discovery.mysterium.network/api/v3/proposals?include_monitoring_failed=true` |

### Planet VPN

| Field | Detail |
|---|---|
| Public service URL | `https://freevpnplanet.com/`, `https://freevpnplanet.com/servers/`, `https://freevpnplanet.com/openvpn/`, `https://freevpnplanet.com/router/` |
| Legal / privacy URLs | `https://freevpnplanet.com/terms/`, `https://freevpnplanet.com/policy/` |
| Legal entity shown by official pages | FREE VPN PLANET S.R.L. in terms/footer; FREE PLANET VPN S.R.L. appears in the privacy-policy body while the footer keeps FREE VPN PLANET S.R.L. |
| Address / identifier | Official footer/legal text lists FREE VPN PLANET S.R.L., Hermes Business Campus, Sectorul 2, Bulevardul Dimitrie Pompeiu 5-7, Bucharest, Romania, 020335, Reg.N `44667783`. Google Play snippets observed in search results list the same CUI/reg number and a more specific office address at Hermes Business Campus, Building B, Office 211, 2nd floor. |
| Registry / incorporation evidence | Official pages verify the Romanian entity name, address, and registration number. Third-party Romanian registry mirrors found during research identify CUI `44667783` and indicate formation in July 2021, but no primary ONRC/official Romanian registry extract was captured in this batch. |
| Who is behind it | Planet VPN is operated by FREE VPN PLANET S.R.L. The public pages market a free tier with 5 or 6 locations depending on page/context, premium access to 60+ countries and 1,260+ servers, and protocols including OpenVPN, IKEv2, PlanetX, and StarGuard. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Planet publishes useful product/legal pages and country landing pages, but exact configs are account/premium gated. The router page says users must sign in to a Planet VPN account to select a country and get the L2TP server name or IP address. The OpenVPN page says OpenVPN configuration is available in Premium only and instructs users to download selected-country `.ovpn` files from the Planet VPN website. Public link probes exposed `https://freevpnplanet.com/cabinet/configuration`, which returned 404 without account context, and support article attachments were PNG/JPEG screenshots, not `.ovpn` files. No unauthenticated exact IP/CIDR/hostname feed was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, terms, privacy, servers, router, OpenVPN, and OpenVPN Connect help pages fetched successfully on 2026-07-05. Support attachments referenced by the help page were confirmed to be images. The current Gluetun clone had no Planet VPN provider/source match. |
| Caveats | Do not script the account cabinet, scrape paid configs, or import user-exported `.ovpn` files. The public country pages are not an inventory. If Planet later publishes an unauthenticated config archive, it may be a good opt-in DNS/IP source, but the current public flow is account/premium gated. |
| Primary source URLs | `https://freevpnplanet.com/`, `https://freevpnplanet.com/servers/`, `https://freevpnplanet.com/openvpn/`, `https://freevpnplanet.com/router/`, `https://freevpnplanet.com/help/how-to-set-up-planetvpn-with-openvpn-connect/`, `https://freevpnplanet.com/terms/`, `https://freevpnplanet.com/policy/`, `https://freevpnplanet.com/wp-sitemap-posts-page-1.xml`, `https://freevpnplanet.com/cabinet/configuration` |

## Batch 10 - Free, Browser, And Mobile-First VPNs

This batch added no OpenASN sources. All five products expose location,
marketing, app, support, or account-gated configuration pages, but none
published an unauthenticated exact IP/CIDR list or a provider-authored exact
hostname inventory suitable for OpenASN.

### Turbo VPN

| Field | Detail |
|---|---|
| Public service URL | `https://turbovpn.com/`, `https://turbovpn.com/servers`, `https://turbovpn.com/vpn-server` |
| Legal / privacy URLs | `https://turbovpn.com/policy`, `https://turbovpn.com/terms-of-service`, `https://turbovpn.com/aboutus` |
| Legal entity shown by official pages | Innovative Connecting Pte. Limited / INNOVATIVE CONNECTING PTE. LIMITED. |
| Address / identifier | Turbo VPN's policy and terms list Innovative Connecting Pte. Limited, 8 Marina View #43-052A Asia Square Tower 1, Singapore 018960, UEN `201812738K`. The footer on public pages repeats the same Singapore address. |
| Registry / incorporation evidence | Official pages verify the Singapore UEN and the about page says Turbo VPN was established in Singapore in 2018. No primary ACRA business-profile extract was captured in this batch. Third-party Singapore registry mirrors at RecordOwl, SGPBusiness, and sg.ltddir tie UEN `201812738K` to Innovative Connecting Pte. Limited and an April 16, 2018 incorporation date, but those mirrors are not source authority for OpenASN data. |
| Who is behind it | Turbo VPN is operated by Innovative Connecting Pte. Limited. Public pages market a cross-platform consumer VPN with mobile apps, desktop apps, browser extension links, support at `support.turbovpn.com`, and global server/location coverage. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages expose legal text, app links, SEO country/location pages, and a server-page shell. Live probes found `/servers`, `/server-list`, `/vpn-server/*` location pages, `asserts.turbovpn.co` static assets, app-store links, and support pages, but no exact IP/CIDR/hostname inventory, OpenVPN/WireGuard config archive, unauthenticated server API, or redistributable egress feed. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, about, policy, terms, servers, sitemap, and support-link pages fetched successfully on 2026-07-05. The current Gluetun clone checked in `/tmp/gluetun-openasn` had no Turbo VPN provider/source match. |
| Caveats | Do not treat Turbo's country pages or "111 locations" style marketing as evidence of current exits. Do not use app traffic, account state, or user-exported configs. A future accepted source needs exact public exits and clear redistribution/fetch semantics from Innovative Connecting or another license-clean authority. |
| Primary source URLs | `https://turbovpn.com/`, `https://turbovpn.com/aboutus`, `https://turbovpn.com/policy`, `https://turbovpn.com/terms-of-service`, `https://turbovpn.com/servers`, `https://turbovpn.com/server-list`, `https://turbovpn.com/vpn-server`, `https://turbovpn.com/sitemap.xml`, `https://support.turbovpn.com/hc/en-sg`, `https://recordowl.com/company/innovative-connecting-pte-limited`, `https://www.sgpbusiness.com/company/Innovative-Connecting-Pte-Limited`, `https://sg.ltddir.com/companies/innovative-connecting-pte-limited/` |

### 1ClickVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.1clickvpn.com/`, `https://www.1clickvpn.com/vpn-locations/`, `https://1clickvpn.net/` |
| Legal / privacy URLs | `https://www.1clickvpn.com/terms-of-service/`, `https://www.1clickvpn.com/privacy-policy/`, `https://www.1clickvpn.com/about/faq/`, `https://1clickvpn.net/terms-of-service`, `https://1clickvpn.net/privacy` |
| Legal entity shown by official pages | The verified `www.1clickvpn.com` pages did not expose a clear legal-entity name in this batch. The separate `1clickvpn.net` terms name Kodice LLC as the owner of 1clickVPN Services. |
| Address / identifier | No street address, registration number, or jurisdiction was captured from the verified `www.1clickvpn.com` legal pages. The `.com` privacy page gives `privacy@1Clickvpn.com` as privacy contact. The `.net` terms name Kodice LLC but did not expose an address or registry identifier in the text captured here. |
| Registry / incorporation evidence | No primary corporate-registry extract or incorporation date was captured for either the `.com` operator or Kodice LLC. The `.net` terms were last modified `28.10.2021`; the `.com` privacy page says last updated August 07, 2025. |
| Who is behind it | Treat the two domains separately until proven otherwise. The `.com` site presents a browser/mobile VPN with Chrome, Edge, and Android support, 531+ free VPN servers, and a privacy policy describing sharing with an affiliated company that processes raw data into commercial "Insights." The `.net` site presents a broader multi-platform VPN and its terms identify Kodice LLC as owner. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages publish location pages, browser-extension/app links, marketing counts, and legal/privacy text, not exact exits. The `.com` sitemap exposed WordPress page and country sitemaps; the `.net` sitemap exposed product and promo/location pages. Neither domain exposed a public `.ovpn`, `.conf`, ZIP, JSON server feed, CIDR list, or provider-published exact hostname catalog. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official `.com` home, FAQ, privacy, terms, sitemap, and location pages fetched successfully on 2026-07-05; official `.net` home, sitemap, and terms fetched successfully. The current Gluetun clone had no 1ClickVPN provider/source match. |
| Caveats | Do not merge `.com` and `.net` identities without stronger evidence. Do not infer egress from browser-extension location pages, affiliate/privacy language, Chrome Web Store metadata, or third-party articles. Browser-extension VPNs can also have different traffic scope than device-wide VPN apps, so future source semantics need to record product surface as well as provider. |
| Primary source URLs | `https://www.1clickvpn.com/`, `https://www.1clickvpn.com/about/faq/`, `https://www.1clickvpn.com/privacy-policy/`, `https://www.1clickvpn.com/terms-of-service/`, `https://www.1clickvpn.com/vpn-locations/`, `https://www.1clickvpn.com/sitemap.xml`, `https://1clickvpn.net/`, `https://1clickvpn.net/terms-of-service`, `https://1clickvpn.net/sitemap.xml` |

### VeePN

| Field | Detail |
|---|---|
| Public service URL | `https://veepn.com/`, `https://veepn.com/vpn-servers/`, `https://veepn.com/vpn-apps/vpn-for-chrome/` |
| Legal / privacy URLs | `https://veepn.com/privacy-policy/`, `https://veepn.com/terms-of-service/` |
| Legal entity shown by official pages | VeePN Corp. / VEEPN, Corp. |
| Address / identifier | VeePN's privacy policy lists VeePN Corp. with registered office at Samuel Lewis Ave & 55th Street, PH SL55 Building, 21st Floor, Panama, Republic of Panama. It also names Laraun Limited (Cyprus) and IT Research LLC (USA) as payment-processing partners. The footer identifies Laraun Limited as an authorized reseller at Evropis, 4, Flat/Office 3, Strovolos 2064, Nicosia, Cyprus. |
| Registry / incorporation evidence | Official VeePN pages verify the Panama operator name and registered office. A Panama Official Gazette PDF URL for issue `29575_A` appeared during research with VEEPN CORP. / folio-style evidence, but direct curl to that PDF returned an Incapsula HTML block from this environment, so no durable primary registry receipt was captured in this batch. No Panama registry extract or incorporation date is accepted here as verified. |
| Who is behind it | VeePN is operated by VeePN Corp., with payment and reseller relationships disclosed for Laraun Limited and IT Research LLC. Public pages market 2,600+ servers, 109 locations, 85 countries, and apps/extensions across major platforms. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages expose country/location marketing and legal/payment disclosures, but not exact exits. Live probes of `/vpn-servers`, terms, privacy, app pages, sitemaps, and common config paths found country pages, pricing links, app-store links, and static assets only. No unauthenticated server API, CIDR/IP list, OpenVPN/WireGuard config archive, or exact hostname inventory was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, servers, privacy, terms, and app/extension pages fetched successfully on 2026-07-05. The current Gluetun clone had no VeePN provider/source match. |
| Caveats | Do not treat the country list or server-count claims as an inventory. Do not use authenticated app state or user-exported configs. If VeePN publishes router configs or a server manifest later, it should probably enter as opt-in DNS/IP Tier B until cadence and churn are measured. |
| Primary source URLs | `https://veepn.com/`, `https://veepn.com/vpn-servers/`, `https://veepn.com/privacy-policy/`, `https://veepn.com/terms-of-service/`, `https://veepn.com/vpn-apps/vpn-for-chrome/`, `https://www.gacetaoficial.gob.pa/pdfTemp/29575_A/92402.pdf` |

### SkyVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.skyvpn.net/`, `https://www.skyvpn.net/vpn-download`, `https://www.skyvpn.net/support` |
| Legal / privacy URLs | `https://www.skyvpn.net/terms`, `https://www.skyvpn.net/privacy-policy`, `https://www.skyvpn.net/contactus` |
| Legal entity shown by official pages | SkyVPN, Inc. |
| Address / identifier | SkyVPN terms say the website, software, and VPN proxy service are owned and operated by SkyVPN, Inc. The same terms say the website and software are controlled by SkyVPN, Inc. from offices in Hong Kong. The contact page exposes `contact@skyvpn.net`. No registration number or street address was captured. |
| Registry / incorporation evidence | Official terms verify SkyVPN, Inc. and Hong Kong office control language. The terms say the agreement is in effect as of October 9, 2016, and the privacy policy was last modified February 2019. No Hong Kong Companies Registry extract or incorporation date was captured in this batch. |
| Who is behind it | SkyVPN is operated by SkyVPN, Inc. Public pages market a free/premium consumer VPN for Windows, macOS, iOS, and Android, 3000+ VPN servers, no data cap, and 30 million users. Terms explicitly prohibit P2P/torrents on US, UK, CA, and FR servers, which is useful product context but not egress provenance. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages publish product claims, terms, privacy, support/blog material, and app download pages only. Sitemap and support probes found static media, blog links, app pages, and marketing pages. No exact IP/CIDR list, OpenVPN/WireGuard archive, unauthenticated server API, or exact hostname catalog was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, terms, privacy, support, contact, sitemap, and blog/support pages fetched successfully on 2026-07-05. The current Gluetun clone had no SkyVPN provider/source match. |
| Caveats | Do not use user-observed endpoints, app traffic, or store metadata as an egress list. SkyVPN's "3000+ servers" and "30 million users" claims are marketing context only. A future source needs exact public exits and rights from SkyVPN, Inc. or another license-clean authority. |
| Primary source URLs | `https://www.skyvpn.net/`, `https://www.skyvpn.net/terms`, `https://www.skyvpn.net/privacy-policy`, `https://www.skyvpn.net/support`, `https://www.skyvpn.net/contactus`, `https://www.skyvpn.net/sitemap.xml`, `https://www.skyvpn.net/blog/how-to-choose-best-vpn-server-location/` |

### X-VPN

| Field | Detail |
|---|---|
| Public service URL | `https://xvpn.io/`, `https://xvpn.io/vpn-server`, `https://xvpn.io/download` |
| Legal / privacy URLs | `https://xvpn.io/policy`, `https://xvpn.io/terms-service`, `https://xvpn.io/about-us`, `https://xvpn.io/help-center/how-to-set-up-x-vpn-on-asus-routers-openvpn` |
| Legal entity shown by official pages | LIGHTNINGLINK NETWORKS PTE. LTD. |
| Address / identifier | X-VPN's privacy policy says X-VPN is operated by LIGHTNINGLINK NETWORKS PTE. LTD., a company based in Singapore. Its about page says X-VPN operates from 8 Marina View, Asia Square Tower 1, Singapore, and its FAQ says the company is headquartered in Singapore. |
| Registry / incorporation evidence | Official pages verify the operator name and Singapore base/address. Third-party Singapore registry mirrors at CompaniesHouse.sg, RecordOwl, SGPBusiness, and sg.ltddir list LIGHTNINGLINK NETWORKS PTE. LTD., UEN `202530186D`, and a July 11, 2025 incorporation date, but no primary ACRA business-profile extract was captured in this batch. X-VPN's own about page says the product has been trusted since 2017 and its 2025 timeline describes expansion, so company-formation timing and product-history timing should not be conflated. |
| Who is behind it | X-VPN is operated by LIGHTNINGLINK NETWORKS PTE. LTD. Public pages market a consumer VPN with 10,000+ servers, 80+ countries, 250+ global locations, proprietary Everest protocol, OpenVPN, WireGuard rollout, QUIC/V2Ray support, and apps/extensions across major platforms. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages expose legal/operator text, location pages, protocol/product documentation, and router setup instructions. The router OpenVPN instructions require signing in and explicitly mark advanced router configuration as premium-only before downloading credentials and location configuration. Sitemap and config probes found country pages, static assets, app-store links, login/account routes, and the router help page, but no public exact IP/CIDR/hostname feed. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, about, policy, terms, VPN-server, sitemap, and router OpenVPN help pages fetched successfully on 2026-07-05. The current Gluetun clone had no X-VPN provider/source match. |
| Caveats | Do not use account-gated router configs, user-exported `.ovpn` files, app traffic, or generated guesses from country pages. X-VPN's 2026 privacy-policy text is current and useful for operator identity, but it is not a source of egress addresses. |
| Primary source URLs | `https://xvpn.io/`, `https://xvpn.io/about-us`, `https://xvpn.io/policy`, `https://xvpn.io/terms-service`, `https://xvpn.io/vpn-server`, `https://xvpn.io/sitemap.xml`, `https://xvpn.io/help-center/how-to-set-up-x-vpn-on-asus-routers-openvpn`, `https://companieshouse.sg/lightninglink-networks-pte-ltd-202530186D`, `https://recordowl.com/company/lightninglink-networks-pte-ltd`, `https://www.sgpbusiness.com/company/Lightninglink-Networks-Pte-Ltd`, `https://sg.ltddir.com/companies/lightninglink-networks-pte-ltd/` |

## Batch 11 - Mixed Commercial And Extension VPNs

This batch added one OpenASN source. StrongVPN's legacy/current StrongTech
locations page publishes exact provider hostnames and fits the existing
opt-in `vpn_dns` model. The other four services were researched and
documented, but did not publish an unauthenticated exact egress inventory.

### StrongVPN

| Field | Detail |
|---|---|
| Public service URL | `https://strongvpn.com/`, `https://strongvpn.com/aboutus/`, `https://strongtech.org/locations/` |
| Legal / privacy URLs | `https://strongvpn.com/privacy-policy/`, `https://strongtech.org/privacy-policy/` |
| Legal entity shown by official pages | Strong Technology LLC, a Ziff Davis company. |
| Address / identifier | StrongVPN privacy/contact/footer pages list Strong Technology LLC, 114 5th Ave, New York, NY 10011, USA. The same pages also list Ziff Davis, Inc. at 114 5th Ave, New York, NY 10011, and identify StrongVPN as a registered trademark of Strong Technology, LLC. |
| Registry / incorporation evidence | Official pages verify the current legal operator and address. No Delaware/New York/other state registry extract or incorporation date for Strong Technology LLC was captured in this batch. Existing OpenASN IPVanish research documents the Ziff Davis / J2 Global acquisition context for the StackPath VPN brands, but provider attribution stays `StrongVPN`. |
| Who is behind it | StrongVPN is operated by Strong Technology LLC and presented as a Ziff Davis company. Its about page describes a service history beginning from California.net / ReliableHosting roots and says the network has expanded to 950+ servers in 30+ countries. |
| OpenASN data source | Added `strongvpn_locations`: `https://strongtech.org/locations/`, parser `strongvpn_locations_html`, provider `StrongVPN`, source group `vpn_dns`, enabled by `config.tier_b[:vpn_dns]`. |
| Source quality / status | Accepted as opt-in DNS-expanded Tier B. The first-party StrongTech locations page publishes exact `vpn-*.reliablehosting.com` speedtest/server hostnames. OpenASN resolves those hostnames locally and publishes no resolved IP list. This matches the Surfshark/IPVanish/TunnelBear DNS-expanded model rather than the default exact-IP provider model. |
| Live smoke | Live parser smoke on 2026-07-05 found 145 unique hostnames. The Ruby client path resolved 74 IPv4 addresses, 0 IPv6 addresses, and packed them into 59 IPv4 ranges; 71 hostnames did not resolve from this resolver. End-to-end lookup smoke: `176.67.81.250` returned `verdict: :vpn`, `category: "hosting"`, `provider: "StrongVPN"`, `sources: [:strongvpn_locations]`. |
| Caveats | Keep this source opt-in. The page includes stale DNS names, publishes hostnames rather than raw IPs, and uses ReliableHosting naming that reflects StrongVPN's infrastructure history. Do not widen to neighboring prefixes and do not infer StrongVPN from Ziff Davis, IPVanish, ReliableHosting, or surrounding ASNs. |
| Primary source URLs | `https://strongvpn.com/`, `https://strongvpn.com/aboutus/`, `https://strongvpn.com/privacy-policy/`, `https://strongtech.org/privacy-policy/`, `https://strongtech.org/locations/`, `https://www.ziffdavis.com/brands/security/ipvanish` |

### Total VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.totalvpn.com/`, `https://help.totalvpn.com/en/vpn` |
| Legal / privacy URLs | `https://legal.totalvpn.com/terms`, `https://legal.totalvpn.com/privacy`, `https://www.totalvpn.com/privacy` |
| Legal entity shown by official pages | Total Security Limited, Total Security U.S. LLC, and affiliates, each part of Point Wild. |
| Address / identifier | Terms identify Total Security Limited as a UK company incorporated under number `10161957`, Total Security U.S. LLC, and affiliates. Terms list U.S. notices to Total Security U.S. LLC, 250 Northern Ave., 3rd Floor, Boston, MA 02210, and non-U.S. notices to Total Security Limited, 16-18 Barnes Wallis Road, Segensworth, Fareham, Hampshire, United Kingdom, PO15 5TT. Privacy pages say the group is part of Point Wild, formerly known as Pango. |
| Registry / incorporation evidence | UK Companies House lists TOTAL SECURITY LIMITED, company number `10161957`, registered office at 16-18 Barnes Wallis Road, Segensworth, Fareham, Hampshire, England, PO15 5TT, active private limited company, incorporated on May 4, 2016. No U.S. LLC registry extract was captured in this batch. |
| Who is behind it | Total VPN is part of the Total Security / TotalAV / Point Wild family. Privacy pages explicitly connect the group to Point Wild, formerly Pango, so this belongs in the broader Pango/Point Wild family research set. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages publish legal text, app/product pages, help pages, and marketing claims such as 35+ country locations and thousands of servers in 90+ countries. Common public paths (`/servers`, `/vpn-servers`, `/openvpn`, `/wireguard`, `/router`, help pages, and legal pages) did not expose exact IPs, CIDRs, hostnames, or config archives. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, terms, privacy, help, sitemap/product paths, and legal pages fetched successfully on 2026-07-05. The current Gluetun clone had no Total VPN provider/source match. |
| Caveats | Do not infer Total VPN exits from Pango/Point Wild sibling brands or from Total Security's country/server-count marketing. A future source needs exact public exits and must distinguish Total VPN from other Point Wild VPN products. |
| Primary source URLs | `https://www.totalvpn.com/`, `https://legal.totalvpn.com/terms`, `https://legal.totalvpn.com/privacy`, `https://www.totalvpn.com/privacy`, `https://help.totalvpn.com/en/vpn`, `https://find-and-update.company-information.service.gov.uk/company/10161957` |

### SetupVPN

| Field | Detail |
|---|---|
| Public service URL | `https://setupvpn.com/`, `https://setupvpn.com/download/`, `https://setupvpn.com/faq` |
| Legal / privacy URLs | `https://setupvpn.com/terms`, `https://setupvpn.com/privacy-policy`, `https://setupvpn.com/register` |
| Legal entity shown by official pages | SetupVPN Inc. |
| Address / identifier | Terms list SetupVPN Inc, 815 Ponce De Leon Blvd, Second Floor, 33134 Coral Gables, Florida, USA. The privacy page/footer also lists SetupVPN Inc, Coral Gables, Florida 33134, USA. |
| Registry / incorporation evidence | Official pages verify the operator name and Florida address. A Sunbiz entity-name search from this environment returned HTTP 403, so no primary Florida registry extract or incorporation date was captured in this batch. |
| Who is behind it | SetupVPN is a free/premium browser/mobile VPN service. Official FAQ says it avoids sharing users' bandwidth/resources, supports browser extensions and mobile apps, does not support TVs/routers, and requires a valid SetupVPN account. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages expose terms, privacy, FAQ, account/app registration, and public app download links. The download page links `baseserver.io/public/s/...` paths for browser/mobile/desktop downloads; live probes of those paths returned HTML and only exposed app/download/support hostnames such as `api.keepthisdomain.com`, not an egress inventory. FAQ says server locations change every day and that SetupVPN has servers in the listed countries, but no exact list is published. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official terms, privacy, FAQ, register, download, sitemap/common paths, and `baseserver.io` download endpoints fetched successfully on 2026-07-05. The current Gluetun clone had no SetupVPN provider/source match. |
| Caveats | Do not decompile app packages, use account state, or infer exits from browser extension behavior. The FAQ explicitly says server locations change daily, which makes a public exact source even more important before any provider label is emitted. |
| Primary source URLs | `https://setupvpn.com/`, `https://setupvpn.com/terms`, `https://setupvpn.com/privacy-policy`, `https://setupvpn.com/faq`, `https://setupvpn.com/download/`, `https://setupvpn.com/register`, `https://baseserver.io/public/s/browser/chrome/`, `https://baseserver.io/public/s/browser/firefox/`, `https://baseserver.io/public/s/browser/edge/`, `https://baseserver.io/public/s/android/`, `https://baseserver.io/public/s/desktop/windows/` |

### uVPN

| Field | Detail |
|---|---|
| Public service URL | `https://uvpn.me/`, `https://uvpn.me/downloads/`, `https://uvpn.me/servers/` |
| Legal / privacy URLs | `https://uvpn.me/privacy-policy/` |
| Legal entity shown by official pages | The Brocode Limited / Brocode Limited. |
| Address / identifier | The privacy policy lists The Brocode Limited, No. 5, 17/F Bonham Trade Centre, 50 Bonham Strand, Sheung Wan, Hong Kong. |
| Registry / incorporation evidence | Official privacy policy verifies the Hong Kong operator name and address. No Hong Kong Companies Registry extract, company number, or incorporation date was captured in this batch. |
| Who is behind it | uVPN is a consumer VPN with apps for Windows, macOS, iOS, Android, and browser extensions for Chrome, Edge, and Firefox. The site presents itself as a one-click VPN and lists country-level server coverage. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | The public `/servers/` page lists countries/regions only: Europe, Asia Pacific, and The Americas country names. The WordPress JSON for that page exposes the page/template metadata but no server records. Download and support pages expose app/product links, not exact IPs, CIDRs, hostnames, or configs. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official privacy, servers, downloads, support, sitemap, and WordPress JSON pages fetched successfully on 2026-07-05. The current Gluetun clone had no uVPN provider/source match. |
| Caveats | Do not infer current exits from country names. Do not rely on app/extension packages, account state, or marketing claims such as "unlimited servers" without an exact public inventory. |
| Primary source URLs | `https://uvpn.me/`, `https://uvpn.me/privacy-policy/`, `https://uvpn.me/servers/`, `https://uvpn.me/downloads/`, `https://uvpn.me/support/`, `https://uvpn.me/sitemap.xml`, `https://uvpn.me/wp-json/wp/v2/pages/2026` |

### GOOSE VPN

| Field | Detail |
|---|---|
| Public service URL | `https://goosevpn.com/`, `https://goosevpn.com/vpn-routers`, `https://goosevpn.com/faq` |
| Legal / privacy URLs | `https://goosevpn.com/terms-of-service`, `https://goosevpn.com/privacy-policy` |
| Legal entity shown by official pages | GOOSE B.V.; business name GOOSE VPN, part of GOOSE B.V. |
| Address / identifier | Terms/privacy pages list GOOSE B.V., Treubstraat 31, 2288EH Rijswijk, The Netherlands, Chamber of Commerce `34278975`, VAT `NL818275066B01`. The terms contact block also lists business address Kreeksehaven 61, 3077 AG Rotterdam, The Netherlands. |
| Registry / incorporation evidence | Official legal pages verify the Dutch company name, Chamber of Commerce number, VAT number, and addresses. The live KVK site returned an app-shell page from this environment, so no primary KVK extract or incorporation date was captured in this batch. |
| Who is behind it | GOOSE VPN is a Dutch VPN operated/developed/maintained by Goose B.V. Its privacy policy says the GOOSE server network is property of and administered/monitored by Goose BV in Rotterdam, The Netherlands. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages publish legal details, product pages, router protocol support, country/benefit pages, and support material. The router page says GOOSE supports PPTP, L2TP, OpenVPN, and IKEv2 for routers, but directs users to the portal/support flow and does not publish a public config archive or exact server host/IP inventory. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, terms, privacy, router, FAQ, sitemap, and country/benefit pages fetched successfully on 2026-07-05. Candidate `/faq/openvpn` and `/faq/manual-configuration` paths returned 404. The current Gluetun clone had no GOOSE VPN provider/source match. |
| Caveats | Do not scrape user portal state or user-exported configs. GOOSE's legal pages are unusually good for operator identity, but operator identity is not egress provenance. A future accepted source needs exact public hostnames/IPs/CIDRs from GOOSE B.V. or a license-clean authority. |
| Primary source URLs | `https://goosevpn.com/`, `https://goosevpn.com/terms-of-service`, `https://goosevpn.com/privacy-policy`, `https://goosevpn.com/vpn-routers`, `https://goosevpn.com/faq`, `https://goosevpn.com/sitemap.xml`, `https://goosevpn.com/wp-sitemap-posts-page-1.xml` |

## Batch 12 - MEGA, WLVPN/FastVPN, BullVPN, hidemy.name, FineVPN

This batch added one OpenASN source: WLVPN's exact public server-list API.
The important attribution decision is that Spaceship/FastVPN and Namecheap
FastVPN are not emitted as separate providers. Their public setup docs point at
WLVPN hostnames, and WLVPN is a white-label backend used by multiple brands, so
OpenASN labels the exact backend source as `provider: "WLVPN"`.

The other four services were fully documented but not added. Their public
material is location-only, product/legal text, or account/trial-gated config
downloads. Those are useful research facts, but not OpenASN source data.

### MEGA VPN

| Field | Detail |
|---|---|
| Public service URL | `https://mega.io/vpn` |
| Legal / privacy URLs | `https://mega.io/terms`, `https://mega.io/privacy`, `https://mega.io/contact`, `https://mega.io/about`, `https://mega.io/server-locations` |
| Legal entity shown by official pages | MEGA terms split contract parties by product path. Users of MEGA Cloud, bundled MEGA VPN/Pass, and MEGA S4 contract with MEGA Privacy Kft, Hungarian Cg. `13-09-239012`, registered office Templom utca 17, 2161 Csomad, Hungary. Standalone paid MEGA VPN or MEGA Pass subscriptions contract with MEGA Privacy (NZ) Limited, NZ company number `9324253`, registered office 120 Albert Street, Auckland, New Zealand. |
| Address / identifier | MEGA contact/about pages list Hungary head office MEGA Privacy Kft, Templom utca 17, 2161 Csomad, Hungary; New Zealand Mega Privacy (NZ), Level 21, Huawei Centre, 120 Albert St, Auckland, New Zealand; Spain Mega Cloud Services SL, Calle Toro 22, Salamanca; Luxembourg Mega Europe SARL, 202, Z.A.E. Wolser F, L-3290 Bettembourg. |
| Registry / incorporation evidence | New Zealand Companies Office lists MEGA PRIVACY (NZ) LIMITED, company number `9324253`, NZBN `9429052660849`, registered, NZ Limited Company, incorporated `2025-02-28`, registered office 120 Albert Street, Huawei Centre, Level 15, Auckland 1010. It also lists MEGA LIMITED, company number `7970438`, NZBN `9429048146128`, registered, NZ Limited Company, incorporated `2020-05-05`, former name MEGA CLOUD SERVICES LIMITED from `2020-05-01` to `2022-03-01`. No Hungarian company-register extract for MEGA Privacy Kft was captured in this batch. |
| Who is behind it | MEGA is the privacy/cloud-storage company operating the broader MEGA product suite. MEGA's terms and contact pages distinguish MEGA Privacy Kft, MEGA Privacy (NZ) Limited, MEGA Limited, and regional offices, so OpenASN documentation keeps those entities separate instead of collapsing all VPN responsibility into "MEGA Limited". |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official VPN page lists country-level availability and says users can choose cities across Australia, Canada, France, Germany, Ireland, Italy, Japan, Netherlands, Singapore, Spain, Sweden, Switzerland, Turkey, United Kingdom, United States, and more. It does not publish exact VPN exit IPs, CIDRs, server hostnames, config archives, or an unauthenticated server API. `https://mega.io/server-locations` is MEGA cloud-storage/data-centre geography, not VPN egress provenance. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official VPN, terms, privacy, contact, about, server-locations, and sitemap pages fetched successfully on 2026-07-05. MEGA privacy text says MEGA processes IP address and port information for VPN usage, including times and dates, which confirms the service has assigned VPN server IPs internally but does not expose an inventory. |
| Caveats | Do not infer VPN exits from MEGA cloud-storage server locations, MEGA API hostnames, or MEGA client source code. Do not use app/account state or user-observed VPN assignments. A future accepted source needs an unauthenticated MEGA-published exact exit list/API or explicit license-clean redistribution rights. |
| Primary source URLs | `https://mega.io/vpn`, `https://mega.io/terms`, `https://mega.io/privacy`, `https://mega.io/contact`, `https://mega.io/about`, `https://mega.io/server-locations`, `https://companies-register.companiesoffice.govt.nz/companies/app/ui/pages/companies/9324253`, `https://companies-register.companiesoffice.govt.nz/companies/app/ui/pages/companies/7970438` |

### WLVPN / Spaceship FastVPN / Namecheap FastVPN

| Field | Detail |
|---|---|
| Public service URL | `https://wlvpn.com/`, `https://wlvpn.com/about-wlvpn/`, `https://wlvpn.com/wlpvn-locations/`, `https://www.spaceship.com/vpn/`, `https://www.namecheap.com/vpn/` |
| Legal / privacy URLs | `https://wlvpn.com/privacy-policy/`, `https://www.spaceship.com/legal/fastvpn-privacy-policy-spaceship-legal/`, `https://www.spaceship.com/legal/privacy-policy/`, `https://www.namecheap.com/legal/` |
| Legal entity shown by official pages | WLVPN says it is a white-label VPN solution powered by IPVanish and part of VIPRE Security Group, a Ziff Davis (NASDAQ: ZD) company. Spaceship pages identify Spaceship, Inc. and Namecheap ownership/trademarks. Namecheap pages identify Namecheap, Inc. |
| Address / identifier | Spaceship FastVPN privacy/footer lists Spaceship, Inc., 4600 East Washington Street, Suite 300, Phoenix, AZ 85034, USA, and says Spaceship is an ICANN-accredited registrar serving customers since 2022. Namecheap support/footer lists Namecheap, Inc., 4600 East Washington Street, Suite 300, Phoenix, AZ 85034, USA. WLVPN pages expose partner/support email `partners@wlvpn.com` but no standalone street address was captured in this batch. |
| Registry / incorporation evidence | No Delaware/Arizona/other U.S. registry extract for WLVPN/VIPRE/Spaceship/Namecheap was captured in this batch. Official Spaceship blog copy says Spaceship is an ICANN-accredited domain-registration and web-services platform founded by CEO Richard Kirkendall, and that Unbox and Spaceship are trademarks and/or registered trademarks of Namecheap, Inc. Namecheap press copy separately says Namecheap was founded in 2000 by CEO Richard Kirkendall. |
| Who is behind it | WLVPN is backend/white-label VPN infrastructure powered by IPVanish under VIPRE Security Group / Ziff Davis. Spaceship FastVPN and Namecheap FastVPN are reseller/customer-facing brands that public setup docs connect to WLVPN hostnames. |
| OpenASN data source | Added `wlvpn_server_list`: `https://api.wlvpn.com/v2/list/wlvpnserverList.xml`, parser `wlvpn_server_list_xml`, provider `WLVPN`, source group `vpn_providers`, enabled by default. |
| Source quality / status | Accepted as exact-IP Tier B. The WLVPN API returns XML `server` elements with exact `name`, `ip`, city, country, status, visibility, coordinates, capacity, features, and WireGuard port metadata. Parser keeps only `visible="1"` and `status="1"` rows and reads exact `ip` attributes. WLVPN's official pages say it is powered by IPVanish and part of VIPRE Security Group / Ziff Davis; WLVPN location pages claim 40,000+ shared IPs, 2,200+ remote VPN servers, and 85+ cities. |
| Live smoke | Live API smoke on 2026-07-05 fetched a 1,093,143-byte XML body with 3,483 `server` rows, all active and visible, across 112 country codes. Samples included `mel-b19.wlvpn.com|103.209.254.114|Melbourne|AU`, `phx-a01.wlvpn.com` in Namecheap docs, and `nyc-c19.vpn.wlvpn.com` in Spaceship docs. End-to-end Ruby smoke wrote 3,483 IPv4 overlays, 0 IPv6 overlays, and classified `103.209.254.114` as `verdict: :vpn`, `provider: "WLVPN"`, `sources: [:wlvpn_server_list]`. |
| Caveats | Do not label these hits as `FastVPN`, `Namecheap`, `Spaceship`, `IPVanish`, `StrongVPN`, or any other reseller unless a more specific exact source wins. WLVPN is shared backend infrastructure; the observed exit IP cannot identify which reseller's customer used it. Do not infer additional IPs from nearby WLVPN hostnames or WLVPN's 40,000+ shared-IP marketing claim. |
| Primary source URLs | `https://api.wlvpn.com/v2/list/wlvpnserverList.xml`, `https://wlvpn.com/`, `https://wlvpn.com/about-wlvpn/`, `https://wlvpn.com/why-wlvpn/`, `https://wlvpn.com/wlpvn-locations/`, `https://wlvpn.com/privacy-policy/`, `https://www.spaceship.com/legal/fastvpn-privacy-policy-spaceship-legal/`, `https://www.spaceship.com/blog/fastvpn-on-spaceship/`, `https://www.spaceship.com/knowledgebase/setup-fastvpn-on-pfsense-router/`, `https://www.namecheap.com/support/knowledgebase/article.aspx/10409/2269/how-to-set-up-ikev2-vpn-connection-on-ios/`, `https://www.namecheap.com/support/knowledgebase/article.aspx/10395/2270/how-to-set-up-fastvpn-on-pfsense-router/`, `https://www.namecheap.com/about/press-releases/24-04-16/the-new-domain-registration-web-services-platform-spaceship-wants-to-help-shape-the-unseen-future-internet/` |

### BullVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.bullvpn.com/`, `https://www.bullvpn.com/en/location`, `https://www.bullvpn.com/en/private-vpn`, `https://www.bullvpn.com/en/setup/windows_client` |
| Legal / privacy URLs | `https://www.bullvpn.com/en/term`, `https://www.bullvpn.com/term`, `https://www.bullvpn.com/faq` |
| Legal entity shown by official pages | PERSEC COMPANY LIMITED / Persec Co.,Ltd. |
| Address / identifier | BullVPN terms/privacy list data controller PERSEC COMPANY LIMITED, 95/26 Saen Suk Road, Saen Suk, Mueang, Chonburi 20130, Thailand, email `support@bullvpn.com`, phone `096-787-1632`. Public footers say copyright 2014-2026 Persec Co.,Ltd. |
| Registry / incorporation evidence | Official pages verify the company name, Thai address, support email, phone, and 2014-2026 footer. No Thai Department of Business Development extract, registration number, or incorporation date was captured in this batch. Treat 2014 as public-service/footer history, not verified incorporation. |
| Who is behind it | BullVPN is operated by PERSEC COMPANY LIMITED / Persec Co.,Ltd. The Android package id is `th.co.persec.bullvpn`, consistent with the Persec operator. Public copy markets 300+ servers in 49 countries, OpenVPN/IKEv2/WireGuard/private VPN/proxy support, and 1,000,000+ users in app-store copy. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official location pages publish country-level pages, server counts, and supported protocol columns, not exact exits. Windows setup docs show server selection in the app and protocols, but no exact host/IP inventory. Private VPN/proxy pages sell dedicated IP/private VPN service but do not publish the pool. Common API/config paths such as `/api/servers`, `/api/location`, and `api.bullvpn.com` returned 404 or no DNS from this environment. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official terms, location, private VPN, FAQ, sitemap, and Windows setup pages fetched successfully on 2026-07-05. Token scans found public site/asset hostnames only, not server hostnames or exit IPs. |
| Caveats | Do not scrape app state, user logs, payment/private-order output, or dedicated-IP customer assignments. Do not infer exits from country pages or from Persec-owned domains/assets. A future source should be exact public IP/CIDR/hostname data from BullVPN/Persec, preferably an unauthenticated server list or public config archive. |
| Primary source URLs | `https://www.bullvpn.com/`, `https://www.bullvpn.com/en/term`, `https://www.bullvpn.com/term`, `https://www.bullvpn.com/en/location`, `https://www.bullvpn.com/en/location/thailand`, `https://www.bullvpn.com/en/private-vpn`, `https://www.bullvpn.com/en/setup/windows_client`, `https://www.bullvpn.com/faq`, `https://www.bullvpn.com/sitemap.xml`, `https://play.google.com/store/apps/details?id=th.co.persec.bullvpn` |

### hidemy.name / hide.mn

| Field | Detail |
|---|---|
| Public service URL | `https://hidemy.name/en/vpn/`, `https://hide.mn/en/vpn/`, `https://hide.mn/en/vpn/router/`, `https://vpnpay.io/en/hmn-vpn/` |
| Legal / privacy URLs | `https://vpnpay.io/en/hmn-vpn/`; linked footer labels on that page: `Terms of Use`, `Privacy Policy`, `Refund`, `Support` |
| Legal entity shown by official pages | EUPHORIATECH LIMITED appears on the VPNPay checkout/product page for hidemy.name VPN. |
| Address / identifier | VPNPay lists EUPHORIATECH LIMITED, Akropoleos, 82, 2nd floor, 2012, Nicosia, Cyprus, registration number `HE 484287`. hidemy.name/hide.mn VPN pages themselves did not expose a separate legal entity in the fetched public pages. |
| Registry / incorporation evidence | VPNPay page verifies the Cyprus entity name, address, and registration number. No Cyprus Registrar extract or incorporation date for EUPHORIATECH LIMITED was captured in this batch. The VPNPay product page says hidemy.name VPN was founded in 2006, but that is product-history text, not registry evidence. |
| Who is behind it | Public evidence ties the checkout/product route to EUPHORIATECH LIMITED. The site markets hidemy.name as a long-running censorship-circumvention VPN with DNS leak protection, split tunneling, Double VPN, port forwarding, router/client support, and a network of 240 servers in 74 cities across 41 countries. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official VPN pages list network size and countries and router pages confirm OpenVPN/PPTP/L2TP style setup. The crucial exact data is account-gated: router instructions repeatedly say `.ovpn` configuration files and server IP settings require an access code obtained after payment or by requesting a trial period. Direct probes of common API/config paths returned 404/403/site pages, not an exact public inventory. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official VPN and router pages fetched successfully on 2026-07-05. Token scans found only site/CDN/app-store/support hostnames and private RFC1918 router addresses, not VPN server hostnames or exits. |
| Caveats | Do not use trial/account-generated `.ovpn` files, access codes, customer configs, or screenshots. Do not treat VPNPay's product/founding page as egress data. If hidemy.name later publishes a public config archive or exact API, add it as Tier B with careful legal review because the current public footer says use of site materials without permission is prohibited. |
| Primary source URLs | `https://hidemy.name/en/vpn/`, `https://hide.mn/en/vpn/`, `https://hide.mn/en/vpn/router/`, `https://hidemy.name/en/vpn/router/`, `https://vpnpay.io/en/hmn-vpn/`, `https://apps.apple.com/gm/app/hidemy-name-vpn/id1200692581`, `https://play.google.com/store/apps/details?id=com.fourksoft.openvpn` |

### FineVPN

| Field | Detail |
|---|---|
| Public service URL | `https://finevpn.org/`, `https://finevpn.org/services/wire/`, `https://finevpn.org/site-map/` |
| Legal / privacy URLs | `https://finevpn.org/rules-of-use/`, `https://finevpn.org/terms-of-service/`, `https://finevpn.org/privacy-policy/`, `https://finevpn.org/disclaimer-limitation-of-liability-and-refund-policy/`, `https://billing.finevpn.org/` |
| Legal entity shown by official pages | QualityNetwork OÜ / QualityNetwork OU. |
| Address / identifier | FineVPN Rules of Use list QualityNetwork OÜ, Karu 14-8, Kesklinn, Harju District, Tallinn, Estonia, email `support@finevpn.org`, website `finevpn.org`. Google Play developer details list QualityNetwork OU, `vladimir.i@quality-network.eu`, Karu tn 14-8, 10120 Tallinn, Estonia, and phone `+254 746 366651`. |
| Registry / incorporation evidence | Official FineVPN pages verify the company name and Tallinn address. The Estonian e-Business Register page fetched only the generic search/app shell from this environment, so no primary registry code or incorporation date was captured in this batch. The FineVPN footer says 2011-2026, but that is product/site history, not verified incorporation. |
| Who is behind it | FineVPN is operated by QualityNetwork OÜ, which also appears across FineProxy/QualityNetwork web properties. Public pages say FineVPN moved from a permanent free plan to a 14-day full-access trial, supports WireGuard and Xray, uses trusted open-source clients rather than a proprietary app-first model, and offers servers in 20 countries. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | FineVPN pages repeatedly describe downloading WireGuard configuration files for chosen locations, but the public flow is trial/signup/account driven via `billing.finevpn.org` or Telegram. Direct probes of common API/config archive paths returned FineVPN HTML/anti-bot pages, not a config archive or server manifest. No unauthenticated exact IP/CIDR/hostname inventory was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. The public pages rendered through browser/search tooling on 2026-07-05; direct curl saw a JavaScript/anti-bot HTML wrapper for several paths. Search/open verification confirmed the legal/operator text and server/location marketing but not exact exits. |
| Caveats | Do not use customer/trial WireGuard or Xray configs, Telegram-generated configs, billing-panel state, or country/use-case SEO pages as source data. FineVPN is related to proxy products, so avoid importing proxy lists or surrounding QualityNetwork/FineProxy infrastructure as `vpn` exits without exact FineVPN provenance. |
| Primary source URLs | `https://finevpn.org/`, `https://finevpn.org/rules-of-use/`, `https://finevpn.org/services/wire/`, `https://finevpn.org/site-map/`, `https://billing.finevpn.org/`, `https://play.google.com/store/apps/details?id=com.fineprotectapp.android`, `https://fineproxy.org/terms-of-service/` |

## Batch 13 - ZoogVPN, SuperVPN, VPN Super, FreeVPN.org, VPNLY

This batch did not add a source. It did improve the negative-evidence ledger
for five popular/free/mobile-heavy VPN brands. The common pattern was strong
public product/app evidence, but no legally clean exact egress inventory.

Two tempting candidate paths were deliberately rejected: VPN Super's Windows
installer and FreeVPN.org's desktop client package. Both are useful research
evidence, but OpenASN should not turn proprietary client inspection into public
source data, especially when a service's terms prohibit reverse engineering or
when the result is only location/accelerator metadata rather than exact exits.

### ZoogVPN

| Field | Detail |
|---|---|
| Public service URL | `https://zoogvpn.com/`, `https://zoogvpn.com/about/`, `https://zoogvpn.com/zoogvpn-servers/`, `https://zoogvpn.com/vpn-setup-configuration/`, `https://app.zoogvpn.com/` |
| Legal / privacy URLs | `https://zoogvpn.com/privacy/`, `https://zoogvpn.com/terms/` |
| Legal entity shown by official pages | Zoog Services IKE / Zoog Services PC / Zoog Services P.C. |
| Address / identifier | Official about/footer pages list Zoog Services IKE, 130 Germanou, Patras 26224, Greece, phone `+1 321 396 5183`. The privacy policy refers to Zoog Services PC. |
| Registry / incorporation evidence | The official about page says ZoogVPN was founded in May 2013 and is legally registered in Greece. No Greek registry extract, company number, or incorporation date beyond that product-history statement was captured in this batch. |
| Who is behind it | ZoogVPN presents itself as an independent Greece-registered consumer VPN founded by networking/IT operators. Apple lists the iOS seller as Zoog Services P.C.; Google Play lists developer Zoog Services IKE. |
| App/store identity | Apple lookup/app page: `https://itunes.apple.com/lookup?id=1204851407&country=US`, `https://apps.apple.com/us/app/zoogvpn-fast-secure-proxy/id1204851407`; Google Play developer: `https://play.google.com/store/apps/developer?id=Zoog+Services+IKE`. |
| Claimed network | Official pages currently market 200+ servers across 35+ countries and also describe 100+ locations/thousands of IP addresses in app-store style copy. Those are coverage claims, not exact egress provenance. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Public setup and server pages are explanatory/product pages, not exact inventories. The authenticated app dashboard exposes API surface under `https://api-d.zoogvpn.com`, including setup server/download endpoints, but `https://api-d.zoogvpn.com/api/setup/servers/get` and `https://api-d.zoogvpn.com/api/setup/downloads/get` returned `401` with `WWW-Authenticate: jwt-auth` on 2026-07-05. `https://api-d.zoogvpn.com/api/ip/info` returns only the caller's current IP/country. Third-party GitHub/config mirrors containing `*.zoogvpn.com` hostnames were rejected. |
| Live smoke | Official home, about, privacy, terms, setup, server, sitemap, and app-dashboard pages fetched successfully on 2026-07-05. API probes confirmed auth gating for exact setup data and no unauthenticated server list. |
| Caveats | Do not infer exits from product server counts, app-dashboard JS, third-party config mirrors, or customer/account-generated configuration files. A future accepted source needs an unauthenticated Zoog-published exact IP/CIDR/hostname list or explicit license-clean redistribution rights. |
| Primary source URLs | `https://zoogvpn.com/`, `https://zoogvpn.com/about/`, `https://zoogvpn.com/privacy/`, `https://zoogvpn.com/terms/`, `https://zoogvpn.com/zoogvpn-servers/`, `https://zoogvpn.com/vpn-servers/`, `https://zoogvpn.com/vpn-setup-configuration/`, `https://app.zoogvpn.com/`, `https://api-d.zoogvpn.com/api/setup/servers/get`, `https://api-d.zoogvpn.com/api/setup/downloads/get`, `https://api-d.zoogvpn.com/api/ip/info`, `https://apps.apple.com/us/app/zoogvpn-fast-secure-proxy/id1204851407`, `https://play.google.com/store/apps/developer?id=Zoog+Services+IKE` |

### SuperVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.supervpn.best/`, `https://www.supervpn.best/faq.html`, `https://www.supervpn.best/contact.html` |
| Legal / privacy URLs | `https://www.supervpn.best/privacy.html`, `https://find-and-update.company-information.service.gov.uk/company/12451849` |
| Legal entity shown by official pages | NetworkSuper LTD / NETWORKSUPER LTD. The site footer has both `NetworkSuper LTD` and one misspelled `NetwokSuper LTD`; app stores and Companies House use `NETWORKSUPER LTD`. |
| Address / identifier | Companies House lists company number `12451849`, registered office 44 Mayford Road, London, England, SW12 8SD. Google Play lists the same address, support email `goanalyticsapp@gmail.com`, business email `business@networksuper.net`, and phone `+44 7762 484138`. |
| Registry / incorporation evidence | Companies House lists NETWORKSUPER LTD as active, private limited company, incorporated `2020-02-10`, SIC `62012 - Business and domestic software development`, previous company name LUNASPEED LTD from `2020-02-10` to `2024-05-30`. |
| Who is behind it | SuperVPN is a free mobile VPN app currently published by NETWORKSUPER LTD. It appears to be a continuation/rebranding of the long-running `com.jrzheng.supervpnfree` Android package under a UK company identity. |
| App/store identity | Apple: `https://itunes.apple.com/lookup?id=6673905322&country=US`, `https://apps.apple.com/pk/app/supervpn-fast-vpn-client/id6673905322`; Google Play: `https://play.google.com/store/apps/details?id=com.jrzheng.supervpnfree`, and paid/pro listing `https://play.google.com/store/apps/details?id=com.jrzheng.supervpnpayment`. |
| Claimed network | Official site markets one-click/free/unlimited VPN and says the app connects to the fastest server automatically. No public server-count, exact hostname, exact IP, or CIDR inventory was found. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official home/privacy/FAQ/contact pages and app-store pages identify the operator and support surface, but do not publish exact VPN exits. No unauthenticated config archive, server API, hostname list, or CIDR list was verified. |
| Live smoke | Official pages fetched successfully on 2026-07-05. Cloudflare-protected support email on `contact.html` decodes to `goanalyticsapp@gmail.com`; Google Play independently shows the same support email and UK company address. No parser smoke because no OpenASN-compatible source was found. |
| Caveats | Do not infer exits from package name history, automatic-server UX, app screenshots, or user-observed assignments. The name `SuperVPN` is overloaded across unrelated apps; keep this entry scoped to `www.supervpn.best`, NETWORKSUPER LTD, and `com.jrzheng.supervpnfree`. |
| Primary source URLs | `https://www.supervpn.best/`, `https://www.supervpn.best/privacy.html`, `https://www.supervpn.best/faq.html`, `https://www.supervpn.best/contact.html`, `https://find-and-update.company-information.service.gov.uk/company/12451849`, `https://apps.apple.com/pk/app/supervpn-fast-vpn-client/id6673905322`, `https://play.google.com/store/apps/details?id=com.jrzheng.supervpnfree`, `https://play.google.com/store/apps/details?id=com.jrzheng.supervpnpayment`, `https://itunes.apple.com/lookup?id=6673905322&country=US` |

### VPN Super

| Field | Detail |
|---|---|
| Public service URL | `https://vpnsuper.com/`, `https://vpnsuper.com/download-vpn`, `https://vpnsuper.com/vpn-server`, `https://account.vpnsuper.com/en/pricing` |
| Legal / privacy URLs | `https://vpnsuper.com/privacy-notice`, `https://vpnsuper.com/terms-of-service` |
| Legal entity shown by official pages | Terms of Service say the agreement is with VPN Super Inc. Privacy Notice says it covers Super Unlimited Inc., VPN Super Inc., Free VPN Pte. Ltd, and Mobile Jump Pte. Ltd. |
| Address / identifier | No official street address was captured from the VPN Super legal pages. Apple lists seller Mobile Jump Pte Ltd for app id `1370293473`; app-store/secondary Singapore registry pages identify Mobile Jump Pte. Ltd. with UEN `201933447E`. Google Play lists developer VPN Super Inc for package `com.free.vpn.super.hotspot.open`. |
| Registry / incorporation evidence | Secondary Singapore company directories derived from ACRA list Mobile Jump Pte. Ltd., UEN `201933447E`, incorporated `2019-10-04`, live company, address 36 Robinson Road #20-01, City House, Singapore 068877. No official ACRA paid extract was captured in this batch. Top10VPN has older ownership notes tying Mobile Jump Pte Ltd to Free VPN Pte Ltd; treat those as investigative context, not OpenASN source data. |
| Who is behind it | VPN Super is a large mobile/Windows consumer VPN brand with a split public identity: VPN Super Inc in terms/Google Play and Mobile Jump Pte Ltd in Apple/app-store metadata. The privacy page groups it with Super Unlimited Inc. and Free VPN Pte. Ltd. |
| App/store identity | Apple: `https://itunes.apple.com/lookup?id=1370293473&country=US`, `https://apps.apple.com/us/app/vpn-super-unlimited-proxy/id1370293473`; Google Play: `https://play.google.com/store/apps/details?id=com.free.vpn.super.hotspot.open`; Windows MSI: `https://download.vpnsuper.com/win/VPNSuper_x64.msi`. |
| Claimed network | Official pages claim 100M+ users, 210+ cities / 55+ countries on the home page, 100+ global VPN server locations on the server page, and app/pricing claims such as 80+ locations / 10Gbps servers. These are product/location claims, not exact exits. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Public server pages enumerate country/location pages, not exact IPs/CIDRs/hostnames. The Windows MSI was downloaded and extracted offline on 2026-07-05. Extracted `server_list_loc.json` was a 14-language localization table with translation keys, not a server inventory; JSON settings files only contained local pipe/log/service settings; binary strings exposed support/update/token/location code paths but no clean static exit list. |
| Live smoke | `https://download.vpnsuper.com/win/VPNSuper_x64.msi` downloaded and extracted with 7-Zip; `server_list_loc.json` contained 14 entries of `language` plus `translations`, each around 292 translation keys. Official privacy and terms pages fetched successfully and identify the corporate scope. No parser smoke because no OpenASN-compatible source was found. |
| Caveats | Do not import installer-derived hostnames, app state, token endpoints, screenshots, app-store location lists, or generated country pages. If a future clean endpoint appears, verify whether it is operated by VPN Super Inc, Mobile Jump Pte Ltd, Super Unlimited Inc., or another affiliate before assigning provider text. |
| Primary source URLs | `https://vpnsuper.com/`, `https://vpnsuper.com/download-vpn`, `https://vpnsuper.com/vpn-server`, `https://vpnsuper.com/privacy-notice`, `https://vpnsuper.com/terms-of-service`, `https://account.vpnsuper.com/en/pricing`, `https://download.vpnsuper.com/win/VPNSuper_x64.msi`, `https://apps.apple.com/us/app/vpn-super-unlimited-proxy/id1370293473`, `https://play.google.com/store/apps/details?id=com.free.vpn.super.hotspot.open`, `https://itunes.apple.com/lookup?id=1370293473&country=US`, `https://sg.ltddir.com/companies/mobile-jump/`, `https://www.sgpbusiness.com/company/Mobile-Jump-Pte-Ltd`, `https://www.top10vpn.com/research/free-vpn-investigations/china-vpn-ownership-taiwan/` |

### FreeVPN.org / FreeVPNApp.org

| Field | Detail |
|---|---|
| Public service URL | `https://freevpn.org/`, `https://freevpnapp.org/`, `https://freevpnapp.org/downloads/`, `https://freevpnapp.org/support.html`, `https://freevpnapp.org/contact/` |
| Legal / privacy URLs | `https://freevpn.org/privacy-policy/`, `https://freevpn.org/terms-of-use/`, `https://freevpnapp.org/privacy-policy/`, `https://freevpnapp.org/terms-of-use/index.html` |
| Legal entity shown by official pages | Free VPN LLC appears in Apple and Google Play metadata. The `freevpn.org` and `freevpnapp.org` legal pages are branded as Free VPN / Free VPN .org and list support contacts but did not expose a street address or LLC registration details in the fetched pages. |
| Address / identifier | Official contact emails: `support@freevpn.org` on `freevpn.org`, `support@freevpnapp.org` on `freevpnapp.org`. No official company address or company number was captured. |
| Registry / incorporation evidence | No primary LLC registry extract was captured in this batch. Top10VPN's 2018 ownership investigation says Free VPN, LLC is associated with ActMobile Networks, Inc. through California filings; treat this as secondary ownership context unless independently revalidated from current filings. |
| Who is behind it | Public app-store metadata says Free VPN LLC publishes `Free VPN by Free VPN .org`. The current desktop client package contains Go build paths under `github.com/actmobile/freevpn-cli` and ActMobile/`dft-cdn42.net` control/data-plane strings, which is strong technical evidence of ActMobile infrastructure involvement but not a license-clean source for OpenASN artifacts. |
| App/store identity | Apple: `https://itunes.apple.com/lookup?id=1050171910&country=US`, `https://apps.apple.com/us/app/free-vpn-by-free-vpn-org/id1050171910`; Google Play: `https://play.google.com/store/apps/details?id=org.freevpn`; package/bundle IDs include `org.freevpn` and `org.freevpn.vpn`. |
| Claimed network | `freevpnapp.org` claims 100M+ installs, 10+ years, 1,000+ servers/global exits, no account/email/tracking, and current Mac/Windows/Linux/iOS/Android downloads. `freevpn.org` presents Free VPN .org as modular VPN technology for apps/software platforms. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Current `https://freevpnapp.org/downloads/LATEST` returned `0.3.6` on 2026-07-05, and `freevpn-0.3.6-linux-amd64.deb`, `freevpn-0.3.6-linux-arm64.deb`, `freevpn-0.3.6-windows-amd64.msi`, and `freevpn-0.3.6-darwin.pkg` returned 200. The Linux package was downloaded and extracted offline; it contains `freevpnd`, `freevpn`, and `freevpn-gui`. Binary strings exposed region/accelerator concepts, `control.actmobile.com`, `content.actmobile.com`, `content.dft-cdn42.net`, `c.dft-cdn42.net`, and `accel.*.dft-cdn42.net` hostnames. DNS for `accel.closest.f.dft-cdn42.net` returned many IPs. This was rejected as OpenASN source data because the evidence came from proprietary client inspection, `freevpn.org` terms prohibit reverse engineering/disassembly/deriving source code, and DNS accelerator answers do not establish redistribution rights or exact brand-specific VPN egress semantics. |
| Live smoke | Official product/legal/download pages fetched successfully on 2026-07-05. `LATEST=0.3.6`; Linux `.deb` size was 19,245,588 bytes. Extracted ELF binaries totaled 37,097,380 bytes. No parser smoke because no accepted OpenASN-compatible source was found. |
| Caveats | Do not publish or compile DNS-expanded `dft-cdn42.net` accelerator pools from the client package. Do not infer FreeVPN exits from ActMobile sibling products, package internals, current DNS answers, or user-observed VPN sessions. A future accepted source needs an explicit public server list/API/config archive with redistribution-safe rights, not client reverse engineering. |
| Primary source URLs | `https://freevpn.org/`, `https://freevpn.org/privacy-policy/`, `https://freevpn.org/terms-of-use/`, `https://freevpnapp.org/`, `https://freevpnapp.org/privacy-policy/`, `https://freevpnapp.org/terms-of-use/index.html`, `https://freevpnapp.org/downloads/`, `https://freevpnapp.org/downloads/LATEST`, `https://freevpnapp.org/downloads/freevpn-0.3.6-linux-amd64.deb`, `https://freevpnapp.org/downloads/freevpn-0.3.6-windows-amd64.msi`, `https://freevpnapp.org/downloads/freevpn-0.3.6-darwin.pkg`, `https://apps.apple.com/us/app/free-vpn-by-free-vpn-org/id1050171910`, `https://play.google.com/store/apps/details?id=org.freevpn`, `https://www.top10vpn.com/research/free-vpn-investigations/ownership/` |

### VPNLY

| Field | Detail |
|---|---|
| Public service URL | `https://vpnly.com/`, `https://vpnly.com/servers/`, `https://vpnly.com/premium-servers/`, `https://vpnly.com/download-free-vpn/` |
| Legal / privacy URLs | `https://vpnly.com/policy/`, `https://vpnly.com/terms/`, `https://vpnly.com/cookie-policy/`, `https://www.uid.admin.ch/Detail.aspx?lang=fr&uid_id=CHE467694739` |
| Legal entity shown by official pages | Free VPN Unlimited AG. |
| Address / identifier | Official site footer lists Free VPN Unlimited AG, Rigistrasse 3, CH-6300 Zug, Switzerland. Google Play currently lists Rigistrasse 2, 6300 Zug, Switzerland. Apple EU trader pages list DUNS `480475919`, Rigistrasse 3, phone `+48 793449398`, email `support@vpnly.com`. Swiss UID lists CHE `467.694.739`, active, RC/TVA, Free VPN Unlimited AG. |
| Registry / incorporation evidence | Swiss UID page verifies active UID `CHE-467.694.739`. Commercial-register-derived sources list commercial register number `CH-170.3.044.734-9`, entry/register date `2020-07-13`, legal form Aktiengesellschaft/AG, capital CHF 100,000, and a 2026 domicile update to Rigistrasse 2. No paid Swiss register extract was captured in this batch. |
| Who is behind it | VPNLY is operated by Free VPN Unlimited AG in Zug, Switzerland. Public registry-derived purposes include operating/providing VPN services and user databases plus software/application development and IT/consulting. |
| App/store identity | Apple: `https://itunes.apple.com/lookup?id=6739255199&country=US`, `https://apps.apple.com/us/app/vpnly-vpn-unlimited-proxy/id6739255199`; Google Play: `https://play.google.com/store/apps/details?id=free.vpn.proxy.vpnly`; Firefox add-on: `https://addons.mozilla.org/en-US/firefox/addon/vpn-free-unlimited-vpnly/`; Chrome extension id observed in public metadata: `lneaocagcijjdpkcabeanfpdbmapcjjg`. |
| Claimed network | Official pages claim a free VPN without registration/traffic/speed limits, 1000+ premium servers, 20+ countries, browser/desktop/mobile apps, and country-specific server pages. Those pages are location/marketing pages, not exact exit inventories. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Website sitemaps and `/servers/*` pages expose country pages only. Chrome-extension public strings referenced `https://api.telegra.ph/getPage/fvp-11-30` and `https://s3.hub-vpn.com`; the Telegraph body contained encrypted-looking blobs, and `https://s3.hub-vpn.com/servers.json` returned three HTTPS proxy entries with credentials. That object was rejected: it is proxy configuration, contains credentials, has unclear publication/redistribution rights, and is not a clean VPN egress inventory. Secrets are intentionally not reproduced in OpenASN docs. |
| Live smoke | Official home, policy, terms, premium-servers, page sitemap, and server sitemap fetched successfully on 2026-07-05. `https://s3.hub-vpn.com/servers.json` returned HTTP 200 with 898 bytes and `Last-Modified: Tue, 16 Jun 2026 14:12:13 GMT`; it was treated as a rejected candidate, not an OpenASN source. |
| Caveats | Do not import proxy credentials, browser-extension configs, encrypted Telegraph blobs, or country page locations. Do not infer VPN exits from S3 bucket names, `freeruproxy.ink` hostnames, or marketing server counts. A future accepted source needs exact Free VPN Unlimited AG-published exits and no secret material. |
| Primary source URLs | `https://vpnly.com/`, `https://vpnly.com/policy/`, `https://vpnly.com/terms/`, `https://vpnly.com/servers/`, `https://vpnly.com/premium-servers/`, `https://vpnly.com/sitemap.xml`, `https://vpnly.com/servers-sitemap.xml`, `https://www.uid.admin.ch/Detail.aspx?lang=fr&uid_id=CHE467694739`, `https://www.moneyhouse.ch/en/company/free-vpn-unlimited-ag-21450053451`, `https://play.google.com/store/apps/details?id=free.vpn.proxy.vpnly`, `https://apps.apple.com/us/app/vpnly-vpn-unlimited-proxy/id6739255199`, `https://addons.mozilla.org/en-US/firefox/addon/vpn-free-unlimited-vpnly/`, `https://api.telegra.ph/getPage/fvp-11-30?return_content=true`, `https://s3.hub-vpn.com/servers.json` |

## Batch 14 - Free / Public / Residential-Style Providers

### SuperFree VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.superfreevpn.com/`, `https://www.superfreevpn.com/download`, `https://app.superfreevpn.com/` |
| Legal / privacy URLs | `https://www.superfreevpn.com/terms`, `https://www.superfreevpn.com/privacy-policy`, `https://www.superfreevpn.com/contact-us` |
| Legal entity shown by official pages | The official pages identify the contracting party only as `SuperFree VPN` / `Super Free VPN`. No registered company name, registration number, or street address was verified from official pages. |
| Address / identifier | Contact page lists `support@superfreevpn.com`. No official address or company number was captured. |
| Registry / incorporation evidence | Not verified. Third-party software directories describe SuperFree VPN as founded in 2023 in the United States, but this was not registry-grade evidence and is not used as a legal fact. The about page makes broad history claims, including "10 years of SuperFree VPN", without registry evidence. |
| Who is behind it | Official pages do not name individuals or a registered corporate operator. Terms disclose a third-party bandwidth-sharing network relationship: in exchange for app access, users may participate as peers in a network including the Infatica P2B network. |
| App/store identity | Official download page links platform-specific downloads and login/registration flow, but this batch did not verify a stable app-store package id suitable for provenance. Public web pages reference `app.superfreevpn.com` and `api.superfreevpn.com`. |
| Claimed network | Official pages claim 20+ server locations, 25+ global servers/locations in snippets, unlimited bandwidth/IP changes, DPI bypassing, and apps for Windows, macOS, Linux, Android, iOS, Chrome, Firefox, Edge, Android TV, tvOS, and other platforms. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official product, about, download, terms, privacy, and contact pages were fetched on 2026-07-05. They expose marketing locations and account/client flows, not exact IPs, CIDRs, hostnames, config archives, or a public server-status API. Terms also restrict the software to personal, non-commercial use unless written consent is obtained. |
| Live smoke | `https://www.superfreevpn.com/`, `/about-us`, `/terms`, `/privacy-policy`, `/contact-us`, and `/download` returned HTTP 200 with a browser User-Agent. Direct no-UA curl previously returned 406 on the homepage, so clients should not assume UA-less fetching works. |
| Caveats | Do not infer VPN exits from country lists, screenshots, app domains, or the Infatica relationship. The peer/bandwidth-sharing economics are exactly the residential-proxy-adjacent area where OpenASN should prefer false negatives; a future source must identify provider-operated VPN exit IPs separately from user-peer traffic. |
| Primary source URLs | `https://www.superfreevpn.com/`, `https://www.superfreevpn.com/about-us`, `https://www.superfreevpn.com/download`, `https://www.superfreevpn.com/terms`, `https://www.superfreevpn.com/privacy-policy`, `https://www.superfreevpn.com/contact-us`, `https://app.superfreevpn.com/`, `https://infatica.io/p2b-network/` |

### FreeVPN.us

| Field | Detail |
|---|---|
| Public service URL | `https://www.freevpn.us/`, `https://www.freevpn.us/openvpn/`, `https://www.freevpn.us/wireguard/`, `https://www.freevpn.us/v2ray/`, `https://www.freevpn.us/pages/server-status.html` |
| Legal / privacy URLs | `https://www.freevpn.us/pages/term-of-service.html`, `https://www.freevpn.us/pages/privacy-policy.html`, `https://www.freevpn.us/pages/disclaimer.html`, `https://www.freevpn.us/pages/refund-policy.html` |
| Legal entity shown by official pages | Footer and schema metadata identify `Roosterkid x FreeVPN.us`; no incorporated company name was verified. |
| Address / identifier | Official schema/footer/contact material lists `freedom@roosterkid.com`, Roosterkid social/GitHub/Telegram links, and Indonesia / East Java locality metadata. Terms say governing law is Indonesia. |
| Registry / incorporation evidence | Not verified. Official site says FreeVPN.us has operated free VPN service since 2016; treat 2016 as service-start branding, not incorporation. |
| Who is behind it | FreeVPN.us is operated under the Roosterkid brand. Official pages link Roosterkid properties including `https://roosterkid.com`, `https://opentunnel.net`, GitHub `roosterkid`, and Telegram `freevpnus`. |
| App/store identity | Official pages promote an "Official FreeVPN Tunnel" Android app and Google Play link in site chrome, but the accepted OpenASN source is the first-party web status table, not the app. |
| Claimed network | The site exposes SSH Tunnel, SSH Custom, OpenVPN, PPTP/L2TP, WireGuard, and V2Ray products. Live status on 2026-07-05 listed OpenVPN, PPTP/L2TP, SSH Tunnel, and WireGuard rows with load/bandwidth/status values. |
| OpenASN data source | Added `freevpn_us_servers`: `https://www.freevpn.us/pages/server-status.html`, parser `freevpn_us_status_html`, provider `FreeVPN.us`, source group `public_relays`, disabled by default. |
| Source quality / status | Accepted as opt-in public-relay Tier B. The server-status page publishes first-party `data-type` and `data-host` attributes. Parser keeps only `openvpn`, `wireguard`, and `pptp` rows whose hostnames match the expected `ovpn-*`, `wireguard-*`, or `pptp-*` `vpnv.cc` forms. SSH Tunnel and V2Ray rows are deliberately excluded from the VPN overlay. |
| Live smoke | Parser found 17 VPN hostnames on 2026-07-05: 7 OpenVPN, 7 WireGuard, and 3 PPTP/L2TP. Local DNS from this environment resolved them to 14 IPv4 addresses and 0 IPv6 addresses; sample hostname `ovpn-ee-1.vpnv.cc` resolved to `5.189.254.17`, which classified as `vpn`, provider `FreeVPN.us`, source `freevpn_us_servers`. `robots.txt` allows `*` and points to `https://freevpn.us/sitemap.xml`. |
| Caveats | Keep this behind `public_relays`: endpoints are free/public, high-churn, and DNS-vantage-dependent. Do not add SSH Tunnel or V2Ray to `vpn` without a separate proxy/relay semantic model. Do not scrape generated account credentials or server-specific account pages. |
| Primary source URLs | `https://www.freevpn.us/`, `https://www.freevpn.us/openvpn/`, `https://www.freevpn.us/wireguard/`, `https://www.freevpn.us/v2ray/`, `https://www.freevpn.us/pages/server-status.html`, `https://www.freevpn.us/pages/term-of-service.html`, `https://www.freevpn.us/pages/privacy-policy.html`, `https://www.freevpn.us/pages/disclaimer.html`, `https://www.freevpn.us/pages/refund-policy.html`, `https://www.freevpn.us/robots.txt`, `https://www.trustpilot.com/review/www.freevpn.us` |

### VpnHood

| Field | Detail |
|---|---|
| Public service URL | `https://www.vpnhood.com/`, `https://www.vpnhood.com/vpnhood-manager/`, `https://github.com/vpnhood/VpnHood` |
| Legal / privacy URLs | `https://www.vpnhood.com/terms-of-use/`, `https://www.vpnhood.com/privacy-policy/`, `https://www.vpnhood.com/vpnhood-client-privacy-policy/` |
| Legal entity shown by official pages | Official pages brand the operator as `VpnHood`; no registered company name, company number, or street address was verified in this batch. |
| Address / identifier | Google Play and public pages list `support@vpnhood.com` for support. No official street address was captured. |
| Registry / incorporation evidence | Not verified. The GitHub project history and Open Technology Fund audit show the project was active by 2023, but that is project history, not incorporation evidence. |
| Who is behind it | VpnHood is an open-source .NET VPN engine/client/server ecosystem. GitHub organization `vpnhood` publishes the source under LGPL-2.1. Product pages split `VpnHood! CONNECT` (free/premium app), `VpnHood! CLIENT`, self-hosting/manager, reseller, and store/account surfaces. |
| App/store identity | Google Play package `com.vpnhood.client.android` is the client app and says it requires a server key. The Connect app source contains store/account integration using `https://store-api.vpnhood.com`; debug builds include sample access keys, but those are not public egress inventory. |
| Claimed network | Official homepage claims a free VPN with resilient servers, no registration/personal data for the free app, and a global server network. It also states the Windows app does not have a free server. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Source and site were inspected on 2026-07-05. The repo changelog says public servers moved to VpnHood Connect, and source code shows access-key, store-account, and subscription flows rather than a clean static server/IP list. GitHub discussion context says VpnHood is software and that public servers are for testing. No unauthenticated exact IP/CIDR/hostname inventory was verified. |
| Live smoke | `https://www.vpnhood.com/` returned HTTP 200 and states "Windows app does not have a free server." `https://www.vpnhood.com/terms-of-use/` returned HTTP 200. The cloned GitHub repo contained public-server changelog lines and `store-api.vpnhood.com` account integration, but no accepted list. |
| Caveats | Do not import sample/debug access keys, generated server tokens, account/store API responses, or self-hosted third-party VpnHood servers. A future accepted source would need VpnHood-operated exact exits published for recognition, not client/session state. |
| Primary source URLs | `https://www.vpnhood.com/`, `https://www.vpnhood.com/terms-of-use/`, `https://www.vpnhood.com/privacy-policy/`, `https://www.vpnhood.com/vpnhood-client-privacy-policy/`, `https://www.vpnhood.com/vpnhood-manager/`, `https://github.com/vpnhood/VpnHood`, `https://github.com/vpnhood/VpnHood/discussions/1`, `https://play.google.com/store/apps/details?id=com.vpnhood.client.android`, `https://www.opentech.fund/wp-content/uploads/2023/11/OTF-2023-Q3-VPN-Hood-Final-V2.pdf` |

### FreeVPN724 / WorldVPN

| Field | Detail |
|---|---|
| Public service URL | `https://freevpn724.com/`, `https://worldvpn.net/`, `https://worldvpn.net/servers`, `https://worldvpn.net/about-us` |
| Legal / privacy URLs | `https://freevpn724.com/terms`, `https://freevpn724.com/privacy`, `https://worldvpn.net/privacy-policy`, `https://worldvpn.net/refund-policy` |
| Legal entity shown by official pages | Official web pages identify the service/brand as `WorldVPN`; no registered company name is shown on the WorldVPN legal pages. Apple App Store metadata for the iOS app lists developer `MEMETRIX LIMITED`, but this was not verified as the legal operator of the website/service. |
| Address / identifier | No official WorldVPN street address or registration number was captured. FreeVPN724 footer says it is powered and supported by WorldVPN. WorldVPN support/billing lives under `billing.worldvpn.net`. |
| Registry / incorporation evidence | Not verified. WorldVPN about page says the service has operated since 2008; treat this as service history, not company incorporation. No registry-grade evidence for WorldVPN or MEMETRIX LIMITED was captured in this batch. |
| Who is behind it | FreeVPN724 is a free front-door/client profile powered by WorldVPN. WorldVPN markets shared VPN, dedicated VPN, and reseller products, and publishes the backend server table accepted by OpenASN. App-store identity is inconsistent: Google Play package `io.world.vpn` is titled WorldVPN / myWorldVPN, while Apple app id `1598393107` lists MEMETRIX LIMITED. |
| App/store identity | Google Play: `https://play.google.com/store/apps/details?id=io.world.vpn`. Apple: `https://apps.apple.com/us/app/worldvpn-fast-vpn-services/id1598393107`. FreeVPN724 pages also QR/link these app stores. |
| Claimed network | WorldVPN pages claim 200+ server locations, 50+ countries on `/servers`, 1 Gbps server speed, and support for PPTP, L2TP, OpenConnect, and WireGuard. FreeVPN724 describes a "WorldVPN for Free" app profile with free server selection and no account needed. |
| OpenASN data source | Added `worldvpn_servers`: `https://worldvpn.net/servers`, parser `worldvpn_servers_html`, provider `WorldVPN`, source group `vpn_providers`, enabled by default. |
| Source quality / status | Accepted as exact-IP Tier B. The first-party server table publishes location, exact IP, exact hostname, protocol availability columns, and per-row OpenVPN profile download links. Parser reads only table rows whose host cell is `*.ocservvpn.com` and emits the exact IP cell. It intentionally does not scrape arbitrary IP-looking text and does not need DNS expansion. |
| Live smoke | Parser found 180 IPv4 tokens and 0 IPv6 tokens on 2026-07-05; the Tier B executor merged them to 170 IPv4 overlay ranges. Sample IP `116.203.253.222` came from `de1.ocservvpn.com` and classified as `vpn`, provider `WorldVPN`, source `worldvpn_servers`. `https://worldvpn.net/robots.txt` returned HTTP 200 with `Disallow:` empty. FreeVPN724 homepage exposed a smaller free list including `ch1.ocservvpn.com`, `de10.ocservvpn.com`, `de6.ocservvpn.com`, `lv1.ocservvpn.com`, `pl3.ocservvpn.com`, `pl4.ocservvpn.com`, `us21.ocservvpn.com`, and `us32.ocservvpn.com`, but OpenASN uses the fuller WorldVPN server table. |
| Caveats | Tier B only: WorldVPN does not grant redistribution rights for republishing the table. FreeVPN724 location/router pages indexed by search currently resolve to 404/SPA fallback content in direct fetches, so do not use them as source data. Provider attribution is `WorldVPN`; FreeVPN724 is a free-client/profile brand unless it later publishes a distinct exact inventory. |
| Primary source URLs | `https://freevpn724.com/`, `https://freevpn724.com/terms`, `https://freevpn724.com/privacy`, `https://worldvpn.net/`, `https://worldvpn.net/servers`, `https://worldvpn.net/about-us`, `https://worldvpn.net/privacy-policy`, `https://worldvpn.net/refund-policy`, `https://worldvpn.net/robots.txt`, `https://play.google.com/store/apps/details?id=io.world.vpn`, `https://apps.apple.com/us/app/worldvpn-fast-vpn-services/id1598393107` |

### StarVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.starvpn.com/`, `https://www.starvpn.com/free-vpn`, `https://www.starvpn.com/frequently-asked-questions`, `https://www.starvpn.com/setup-instructions` |
| Legal / privacy URLs | `https://www.starvpn.com/terms-of-service`, `https://www.starvpn.com/terms-of-service-free-vpn`, `https://www.starvpn.com/privacy-policy`, `https://www.starvpn.com/contact-us` |
| Legal entity shown by official pages | Terms identify `Star Internet Services A.K.A. STARVPN INC.` as a corporation incorporated under Ontario law. Footer/app stores use `StarVPN Inc.`. |
| Address / identifier | Contact page lists 595 Bay Street, Toronto ON M5G 0B4 (Operating space), Ontario Business Corporation `#5019951`. Terms/free terms list notices to `STARVPN INC.`, 595 Bay St., PO Box 99900 UA 997 652, RPO Atrium on Bay, Toronto ON M5G 0B4. |
| Registry / incorporation evidence | Official pages verify Ontario corporation number `5019951`, but the exact Ontario incorporation date was not verified from a registry-grade source in this batch. |
| Who is behind it | StarVPN presents itself as a global VPN and SOCKS proxy provider specializing in residential IP network services. Public pages do not name founders/individual owners. |
| App/store identity | Google Play: `https://play.google.com/store/apps/details?id=com.starvpn`, publisher StarVPN Inc., 500K+ downloads in fetched metadata. Apple: `https://apps.apple.com/us/app/residential-vpn/id1624494670`, developer StarVPN Inc. |
| Claimed network | Official pages claim the world's largest residential VPN service provider, static/rotating/mobile/datacenter IPs, 10M+ rotating residential IPs in homepage metadata, 1000+ servers/access points, 10 Gbps global access network in app-store copy, and dedicated/static residential IPs. FAQ says residential IPs come through contracts with LLC ISP providers and include broadband residential carriers such as Comcast/Verizon. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages, app stores, setup pages, and legal pages were inspected on 2026-07-05. Public setup docs require registration/login to the member dashboard, then user-specific selection of IP type (Static Residential, Mobile, Rotating, or Datacenter), country, region, and ISP, followed by account-generated OpenVPN/WireGuard configs. No unauthenticated exact IP/CIDR/hostname feed was verified. |
| Live smoke | `https://www.starvpn.com/privacy-policy`, `/terms-of-service`, `/terms-of-service-free-vpn`, `/free-vpn`, `/frequently-asked-questions`, `/setup-instructions`, and multiple OpenVPN setup pages returned HTTP 200. Setup pages repeatedly route users to member-dashboard config download rather than a public config archive. |
| Caveats | Do not classify StarVPN's claimed residential/mobile pool as provider-operated `vpn` exits from marketing claims. Residential and mobile IP products are real-user/ISP-space sensitive, and a static offline source would need exact first-party egress inventory plus semantics separating datacenter VPN, static residential, rotating residential, and free network-sharing traffic. |
| Primary source URLs | `https://www.starvpn.com/`, `https://www.starvpn.com/contact-us`, `https://www.starvpn.com/privacy-policy`, `https://www.starvpn.com/terms-of-service`, `https://www.starvpn.com/terms-of-service-free-vpn`, `https://www.starvpn.com/free-vpn`, `https://www.starvpn.com/frequently-asked-questions`, `https://www.starvpn.com/setup-instructions`, `https://www.starvpn.com/how-to-setup-openvpn-connect-on-macos`, `https://www.starvpn.com/openvpn-configuration-setup-on-iphone-ipad`, `https://play.google.com/store/apps/details?id=com.starvpn`, `https://apps.apple.com/us/app/residential-vpn/id1624494670` |

## Batch 15 - GoFlyVPN, iTop VPN, Radmin VPN

This batch closes the remaining services from the page-2/page-3 Google queue.
Total VPN and SetupVPN were already captured with full dossiers in Batch 11, so
this section documents the three still-missing entries. No OpenASN source was
added: each failed for a different reason, but all failed the same hard rule:
no clean first-party exact IP/CIDR/hostname source.

### GoFlyVPN / RivoVPN

| Field | Detail |
|---|---|
| Public service URL | `https://goflyvpn.com/`, `https://goflyvpn.com/download`, `https://goflyvpn.com/help` |
| Legal / privacy URLs | `https://goflyvpn.com/privacy-policy`, `https://goflyvpn.com/privacy/privacy_us.md`, `https://goflyvpn.com/privacy/privacy_hk.md`, `https://goflyvpn.com/privacy/privacy_tw.md`, `https://goflyvpn.com/privacy/privacy_kr.md`, `https://goflyvpn.com/privacy/privacy_jp.md` |
| Legal entity shown by official pages | The GoFlyVPN website privacy markdown still contains template placeholders such as `[Company Name]` / `[products/websites/mobile applications/clients]`, so the website itself does not verify a legal operator. Google Play's public page for `com.ambrose.overwall` shows the app title `GoFly VPN,V2ray,Trojan,sock5`, author text `TracySteven`, and About-the-developer details for `NeoMortal LLC`. Apple lookup for app id `6760238667` shows `RivoVPN`, seller `NeoMortal LLC`, bundle `io.rivo.secure`, and seller URL `https://rivovpn.com/`. |
| Address / identifier | Google Play lists `support@goflyvpn.com`, `AndroidDeveloper@neo-mortal.com`, phone `+44 7543 932026`, and NeoMortal LLC at 30 N Gould St Ste N, Sheridan, WY 82801-6317, United States. Apple lookup lists seller `NeoMortal LLC` for the RivoVPN app. |
| Registry / incorporation evidence | Not verified. A Wyoming Secretary of State WyoBiz result was discoverable for a similar NeoMortal LLC query, but the direct registry page required a JavaScript/human challenge from this environment and was not accepted as a registry receipt. No incorporation date or entity number is recorded. |
| Who is behind it | Public evidence ties the GoFlyVPN web/Android surface to `com.ambrose.overwall` and the GoFly/Rivo download set, while Apple and Windows download naming point to RivoVPN / NeoMortal LLC. No individual owner/founder was verified; `TracySteven` appears as Google Play schema/author text, not a registry fact. |
| App/store identity | Google Play: `https://play.google.com/store/apps/details?id=com.ambrose.overwall`; Google Play testing link: `https://play.google.com/apps/testing/com.ambrose.overwall`; Apple lookup/app id: `https://itunes.apple.com/lookup?id=6760238667&country=US`, `https://apps.apple.com/app/id6760238667`; public downloads: `https://download.goflyclub.com/GoFly20260610.apk?=1`, `https://download.devboo.com/gofly-OpenBeta.apk?=1`, `https://download.goflyclub.com/RivoVPNWindows-amd64-setup.exe?=1`. |
| Claimed network | Website copy claims free VPN service, multiple countries/regions, global top-tier data-center servers, no activity logging, and encrypted traffic. The FAQ embedded in the website bundle explicitly says server nodes are not fixed and are dynamically assigned by the server. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official web routes are a Vite/React SPA; unknown paths such as `/api/servers`, `/servers`, `/server-list`, `/robots.txt`, and `/sitemap.xml` returned the same HTML app shell, not structured source data. Static privacy markdown exists but is placeholder-heavy and not an egress inventory. Public APK/EXE endpoints are real downloads, but proprietary client inspection is not a clean source and the public bundle says nodes are dynamically assigned. |
| Live smoke | On 2026-07-05 the website bundle was fetched from `https://goflyvpn.com/assets/index-YBlXSt2Q.js` and the static privacy markdown returned HTTP 200. Download headers returned APK/EXE content for the three public download URLs. No parser smoke because no OpenASN-compatible source was found. |
| Caveats | Do not decompile or import proprietary app state, embedded endpoints, user-observed assignments, V2Ray/Trojan/SOCKS-specific app behavior, or dynamically assigned nodes. The placeholder privacy policy is a governance warning and makes this a poor candidate until a clean public server manifest or provider-published exact list appears. |
| Primary source URLs | `https://goflyvpn.com/`, `https://goflyvpn.com/privacy-policy`, `https://goflyvpn.com/privacy/privacy_us.md`, `https://goflyvpn.com/download`, `https://play.google.com/store/apps/details?id=com.ambrose.overwall`, `https://itunes.apple.com/lookup?id=6760238667&country=US`, `https://download.goflyclub.com/GoFly20260610.apk?=1`, `https://download.devboo.com/gofly-OpenBeta.apk?=1`, `https://download.goflyclub.com/RivoVPNWindows-amd64-setup.exe?=1` |

### iTop VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.itopvpn.com/`, `https://www.itopvpn.com/about`, `https://www.itopvpn.com/free-vpn`, `https://www.itopvpn.com/vpn-servers` |
| Legal / privacy URLs | `https://www.itopvpn.com/terms`, `https://www.itopvpn.com/privacy`, `https://www.itopvpn.com/eula` |
| Legal entity shown by official pages | iTop Inc. Terms say iTop Inc. provides the website services/products; the privacy policy says `itopvpn.com`, sub-websites, software/apps, and services are owned and operated by iTop Inc. The iOS App Store seller for app id `1538546081` is `ORANGE VIEW LIMITED`, so app-store/payment/distribution identity is not identical to the website legal text. |
| Address / identifier | Official website pages did not expose a physical address or company number in this batch. Terms route unresolved complaints to `tickets@itopvpn.com`; EULA snippets route arbitration rejection and notices to `feedback@itopvpn.com` for the VPN product and other product-specific support aliases. App Store lookup lists seller `ORANGE VIEW LIMITED`, bundle `com.vpn.itop`, and seller URL `https://www.itopvpn.com/`. |
| Registry / incorporation evidence | Not verified. Official About page says iTop was founded in 2016 and now has more than 20 million users; treat 2016 as company/product history, not registry-grade incorporation evidence. No Hong Kong Companies Registry extract, Orange View registry receipt, or incorporation date was captured. |
| Who is behind it | Public pages identify iTop Inc. as website/service operator and present iTop as a multi-product software company: iTop VPN, iTop Screen Recorder, iTop Data Recovery, iTop PDF, iTop Easy Desktop, DualSafe Password Manager, and related utilities. No founders or individual owners were verified from primary sources. |
| App/store identity | Apple lookup/app page: `https://itunes.apple.com/lookup?id=1538546081&country=US`, `https://apps.apple.com/us/app/itop-vpn-vpn-fast-secure/id1538546081`; seller `ORANGE VIEW LIMITED`, artist `Orange View`, release date 2020-12-22, current version observed 7.1.1 on 2026-07-05. The guessed Android package `itopvpn.free.vpn.proxy` returned 404 in this environment, so no Android package id is accepted here. |
| Claimed network | Official about/server pages claim 3200+ VPN servers in 100+ locations, country-level free server list entries for France, Germany, Japan, United Kingdom, and United States, and optimized servers for streaming, gaming, torrenting, chatting, and social apps. These are coverage claims, not exact egress provenance. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official pages expose marketing location lists, app downloads, legal terms, privacy text, and a Windows installer redirect to `https://download.itopvpn.com/insurweb/vpn/iTopVPN_en_server_setup.exe`. Probes of `/vpn-server`, `/openvpn`, `/router-vpn`, `/api/serverlist`, and `/sitemap.xml` returned 404 or normal site pages; `api.itopvpn.com` redirected to Google. No unauthenticated exact IP/CIDR/hostname feed or public config archive was verified. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, free VPN, about, terms, privacy, EULA, VPN servers, and download redirect fetched successfully on 2026-07-05; the public server page produced country names and marketing counts only. |
| Caveats | Do not infer exits from the 3200+ server count, country pages, optimized app categories, installer download names, or app-store claims. The iTop Inc. / Orange View Limited split should remain explicit until a primary source explains the relationship. A future accepted source needs exact provider-published IPs/CIDRs/hostnames, not a generated location list. |
| Primary source URLs | `https://www.itopvpn.com/`, `https://www.itopvpn.com/about`, `https://www.itopvpn.com/free-vpn`, `https://www.itopvpn.com/vpn-servers`, `https://www.itopvpn.com/terms`, `https://www.itopvpn.com/privacy`, `https://www.itopvpn.com/eula`, `https://www.itopvpn.com/download?insur=en_server`, `https://itunes.apple.com/lookup?id=1538546081&country=US`, `https://apps.apple.com/us/app/itop-vpn-vpn-fast-secure/id1538546081` |

### Radmin VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.radmin-vpn.com/`, `https://www.radmin-vpn.com/about/`, `https://www.radmin.com/` |
| Legal / privacy URLs | `https://www.radmin-vpn.com/security/`, `https://www.radmin-vpn.com/privacy/`, `https://www.radmin.com/privacy/`, `https://www.radmin.com/contact/` |
| Legal entity shown by official pages | Famatech Corp. Radmin VPN security page says the Radmin VPN product and its servers belong to Famatech Corp., a BVI company. Radmin/Radmin VPN footers state copyright 1999-2026 Famatech Corp. |
| Address / identifier | Radmin contact page lists Famatech Corp., 3rd Floor, Glancina George Building, POB 676, Road Town, Tortola, British Virgin Islands. Sales phone numbers are `+1-866-325-9868` for North America and `+44-20-3519-7885` internationally. |
| Registry / incorporation evidence | Official pages verify BVI jurisdiction, company name, and BVI address, but no BVI registry extract, company number, or incorporation date was captured. Secondary LEI material identifies Famatech Corp. LEI `529900U3HJPNC34CLE87` at the same BVI agent/address, but that was not used as OpenASN source data. |
| Who is behind it | Famatech says it was founded in 1999 and develops remote-control and network-management software. The Radmin VPN About page says Radmin VPN launched in 2016 and is integrated with Famatech's Radmin remote-control product. |
| App/store identity | Windows-only product in official copy: compatible with Windows 11, 10, 8, and 7. Official download link routes through `download.radmin-vpn.com`; no mobile app-store identity is relevant to this dossier. |
| Claimed network | Radmin VPN creates virtual local networks so remote computers can connect as if on one LAN, including remote-work and LAN-gaming use cases. It is explicitly framed as "Connect remote computers to one local network", not as a commercial public-internet egress VPN. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Not an OpenASN VPN-exit candidate. Public pages expose product/security/privacy/about/contact material, but no public exit IPs because the product is a mesh/virtual-LAN tunnel between user machines rather than a provider-operated public egress network. |
| Live smoke | No parser smoke because no OpenASN-compatible source was found. Official home, about, security, privacy, Radmin contact, and Radmin privacy pages fetched successfully on 2026-07-05. |
| Caveats | Do not map Radmin VPN users as `vpn` exits. A Radmin client IP is normally the user's own network endpoint inside a private virtual LAN, not a Famatech public egress address. If Famatech later ships a separate public egress product, it needs a separate source and semantics. |
| Primary source URLs | `https://www.radmin-vpn.com/`, `https://www.radmin-vpn.com/about/`, `https://www.radmin-vpn.com/security/`, `https://www.radmin-vpn.com/privacy/`, `https://www.radmin.com/contact/`, `https://www.radmin.com/privacy/`, `https://lei.bloomberg.com/leis/view/529900U3HJPNC34CLE87` |

## Batch 16 - Kape Re-Audit, Perfect Privacy Retry, hide.me

This batch deliberately re-checks several high-value misses instead of adding
weak data. ExpressVPN, CyberGhost, ZenMate, and Perfect Privacy already have
Batch 5 dossiers; the rows below record the deeper 2026-07-05 re-audit and the
current no-ship reason. hide.me receives a full first dossier here.

### ExpressVPN re-audit

| Field | Detail |
|---|---|
| Public service URL | `https://www.expressvpn.com/` |
| Legal / privacy URLs | `https://www.expressvpn.com/tos`, `https://www.expressvpn.com/privacy-policy`, `https://www.expressvpn.com/about-us`, `https://www.expressvpn.com/blog/expressvpn-officially-joins-kape/` |
| Legal entity shown by official pages | Express Technologies Ltd. Current terms, last updated 2026-06-29, define the services as offered by Express Technologies Ltd. |
| Re-audit URLs | `https://www.expressvpn.com/support/vpn-setup/manual-config-for-linux-with-openvpn/`, `https://www.expressvpn.com/support/vpn-setup/manual-config-asustor-openvpn/`, `https://www.expressvpn.com/support/vpn-setup/manual-config-for-windows-with-openvpn/`, `https://www.expressvpn.com/support/vpn-setup/?srsltid=AfmBOorK-KlahjxnFaVEbfv5OZOHBozfQ98FwO06Nw7tqkljUwXKDyQk` |
| What changed in this pass | Official support pages now clearly document the account-gated shape: a user must go to the ExpressVPN setup page, sign in, pass email verification, then download individual `.ovpn` files from the authenticated list. The Linux guide also says not all ExpressVPN locations are available for manual configuration. |
| Source probes | A direct scan of the public Linux setup page found only ordinary site/support domains (`www.expressvpn.com`, `support.expressvpn.com`, `go.expressvpn.com`) and no `expressnetw.com` server catalog. Existing Gluetun `expressnetw.com` hostnames still resolve in samples, but they remain third-party hardcoded data. |
| OpenASN data source | Not added. No OpenASN source id. |
| Current status | High-value miss, but still source-blocked. The public site proves manual configs exist; it does not publish the config catalog without account state. |
| Caveats | Do not add inferred `expressnetw.com` patterns or Gluetun hardcoded hostnames. They are operationally tempting but fail both provenance and maintainability: a stale hardcoded list would silently become false positives. |
| Primary source URLs | `https://www.expressvpn.com/tos`, `https://www.expressvpn.com/privacy-policy`, `https://www.expressvpn.com/support/vpn-setup/manual-config-for-linux-with-openvpn/`, `https://www.expressvpn.com/support/vpn-setup/manual-config-asustor-openvpn/`, `https://www.expressvpn.com/support/vpn-setup/manual-config-for-windows-with-openvpn/`, `https://github.com/qdm12/gluetun/blob/master/internal/provider/expressvpn/updater/hardcoded.go` |

### CyberGhost re-audit

| Field | Detail |
|---|---|
| Public service URL | `https://www.cyberghostvpn.com/` |
| Legal / privacy URLs | `https://www.cyberghostvpn.com/imprint`, `https://www.cyberghostvpn.com/privacypolicy`, `https://www.cyberghostvpn.com/terms`, `https://www.cyberghostvpn.com/features/nospy` |
| Legal entity shown by official pages | CyberGhost S.R.L. |
| Address / identifier | Official imprint lists CyberGhost S.R.L., 70-72 Dionisie Lupu street, 1st, 2nd and 3rd floor, District 1, 010458, Bucharest, Romania; email `office@cyberghost.ro`; Trade Register No. `J40/1278/2011`; VAT `RO28003392`; EUID `ROONRC.J40/1278/2011`. The privacy policy says the services are owned and operated by CyberGhost S.R.L. and gives registration number `J40/1278/2011`. |
| Re-audit URLs | `https://support.cyberghostvpn.com/hc/en-us/articles/213190009-How-to-Set-Up-OpenVPN-on-Linux-Debian-via-Terminal`, `https://support.cyberghostvpn.com/hc/en-us/articles/360012606699-How-to-Use-CyberGhost-VPN-on-Synology-NAS-via-OpenVPN`, `https://support.cyberghostvpn.com/hc/en-us/articles/213269809-Router-How-to-Set-Up-OpenVPN-on-TomatoUSB-Merlin-Build` |
| What changed in this pass | Official support pages confirm that manual OpenVPN configs are generated inside the CyberGhost account. The user logs in, chooses OpenVPN type, country/region, and server type, saves a configuration, then downloads a ZIP containing certificates and `openvpn.ovpn`. One current Linux article explicitly lists server-type choices that can include Premium, Standard, ZenMate Premium, or Gaming. |
| Source probes | Public support pages were scanned for real `*.cg-dialup.net` inventories; current HTML did not expose a usable catalog. Search snippets and older examples show illustrative `12345-1-ca.cg-dialup.net`-style server group addresses, and Gluetun derives hostnames from group/country patterns, but pattern generation is not a first-party exact list. |
| OpenASN data source | Not added. No OpenASN source id. |
| Current status | High-value miss, still source-blocked. The correct future source would be a public CyberGhost server API/config archive, not enumeration of generated names. |
| Caveats | CyberGhost and ZenMate are entangled at the product layer, but OpenASN must not create a `ZenMate` or `CyberGhost` source by guessing from `cg-dialup.net` DNS behavior. The manual config workflow is account-generated and may vary by subscription, protocol, and selected server type. |
| Primary source URLs | `https://www.cyberghostvpn.com/imprint`, `https://www.cyberghostvpn.com/privacypolicy`, `https://support.cyberghostvpn.com/hc/en-us/articles/213190009-How-to-Set-Up-OpenVPN-on-Linux-Debian-via-Terminal`, `https://support.cyberghostvpn.com/hc/en-us/articles/360012606699-How-to-Use-CyberGhost-VPN-on-Synology-NAS-via-OpenVPN`, `https://github.com/qdm12/gluetun/blob/master/internal/provider/cyberghost/updater/hosttoserver.go` |

### ZenMate re-audit

| Field | Detail |
|---|---|
| Public service URL | `https://zenmate.com/` |
| Legal / privacy URLs | `https://zenmate.com/tos`, `https://zenmate.com/privacy-policy`, `https://zenmate.com/blog/zenmate-changes` |
| Legal entity shown by official pages | ZenGuard GmbH / ZenMate service under CyberGhost partnership, per current ZenMate legal and migration pages. |
| Re-audit URLs | `https://zenmate.com/`, `https://zenmate.com/blog/zenmate-changes`, `https://zenmate.com/anonymous-vpn`, `https://zenmate.com/products/vpn-for-windows` |
| What changed in this pass | Current ZenMate pages still contain historical/product pages for browser, mobile, desktop, OpenVPN, and Linux, and they market server locations. The authoritative migration notice remains stronger: from 2023-03-16 VPN service for subscribers moved to CyberGhost VPN apps, ZenMate apps were supported only until 2023-05-01, and new ZenMate accounts/subscriptions stopped from 2023-03-16. |
| Source probes | No independent ZenMate exact IP, CIDR, hostname, public config ZIP, or app-server-list source was found. The migration FAQ says CyberGhost receives ZenMate credentials through an API and sees only the total number of ZenMate users using its apps, so even CyberGhost's backend relationship does not give OpenASN a brand-distinguishable egress map. |
| OpenASN data source | Not added separately. Potential paid ZenMate traffic is a CyberGhost-family product flow, but OpenASN has no exact way to distinguish it at IP level. |
| Current status | Not a separate source candidate unless ZenMate publishes a distinct public inventory or CyberGhost publishes brand-tagged exits. |
| Caveats | Do not create a `ZenMate` provider label from CyberGhost examples. That would overstate attribution precision and make downstream decisions worse. |
| Primary source URLs | `https://zenmate.com/`, `https://zenmate.com/blog/zenmate-changes`, `https://zenmate.com/tos`, `https://zenmate.com/privacy-policy`, `https://www.prnewswire.com/news-releases/zenmate-acquired-by-kape-technologies-300731900.html` |

### Perfect Privacy retry

| Field | Detail |
|---|---|
| Public service URL | `https://www.perfect-privacy.com/` |
| Legal / privacy URLs | `https://www.perfect-privacy.com/en/terms`, `https://www.perfect-privacy.com/en/privacy-policy` |
| Candidate data URL | `https://www.perfect-privacy.com/downloads/openvpn/get?system=linux&scope=server&filetype=zip&protocol=udp`; TCP variant uses `protocol=tcp`. |
| Legal entity shown by official pages | Still not verified from live official pages in this environment. |
| Re-audit result | Ruby `Net::HTTP`, `curl`, and `dig` probes all failed/timed out from this environment for `www.perfect-privacy.com` on 2026-07-05. No home page, legal page, ZIP body, parser output, or resolver smoke was obtained. |
| OpenASN data source | Not added. No OpenASN source id. |
| Current status | Best technical candidate in this batch, but still blocked by fetch reliability. If the ZIP fetches from another network, it should be tested with the existing `ovpn_zip_remote_hosts` parser, then smoke-resolved locally before adding as opt-in `vpn_dns`. |
| Caveats | Do not ship Gluetun-derived Perfect Privacy source definitions until the first-party URL is fetched successfully. A manifest entry that cannot be smoked would become CI noise and a false sense of coverage. |
| Primary source URLs | `https://www.perfect-privacy.com/`, `https://www.perfect-privacy.com/en/terms`, `https://www.perfect-privacy.com/en/privacy-policy`, `https://www.perfect-privacy.com/downloads/openvpn/get?system=linux&scope=server&filetype=zip&protocol=udp`, `https://github.com/qdm12/gluetun/tree/master/internal/provider/perfectprivacy` |

### hide.me

| Field | Detail |
|---|---|
| Public service URL | `https://hide.me/`, `https://hide.me/en/` |
| Legal / privacy URLs | `https://hide.me/en/legal`, `https://hide.me/en/privacy`, `https://hide.me/en/about`, `https://hide.me/en/offshore-vpn`, `https://hide.me/en/network` |
| Legal entity shown by official pages | eVenture Ltd. The privacy policy says eVenture Ltd. operates the hide.me VPN service; the terms say the service is operated by eVenture Ltd. App-store disclosures render the name as `EVENTURE LTD.` / `EVENTURE LIMITED`. |
| Address / identifier | Apple App Store trader disclosure lists `EVENTURE LTD.`, D-U-N-S `534305302`, Level 2 Lot 19 Lazenda Commercial Centre Phase 3, 87007 Labuan, Malaysia, phone `+60 1546000451`, email `support@hide.me`. Google Play developer disclosure lists `EVENTURE LIMITED`, Unit 12F (1), Main Office Tower Financial Park Labuan, Jalan Merdeka, 87007 Labuan, Malaysia, same support email and phone. |
| Registry / incorporation evidence | Official/app-store pages verify legal name, Malaysia/Labuan addresses, D-U-N-S, and contact data. A Malaysia/Labuan registry extract, incorporation date, and company number were not captured in this batch. The official About page says hide.me was built in 2012; treat that as service founding, not legal-entity incorporation. |
| Who is behind it | Official pages do not name individual founders in the pages checked. Secondary press/profile material attributes the 2012 founding to Sebastian Schaub; this remains secondary context until a primary company page or registry filing is added. |
| Claimed network | Official network page says hide.me runs a self-managed VPN network without third-party involvement, supports WireGuard, OpenVPN, IKEv2 IPsec, SoftEther, and SSTP, and lists 91 VPN locations on 6 continents. The offshore-VPN page says hide.me is a product of eVenture Ltd., a Malaysian IT security company headquartered in Labuan. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official network pages expose location names and marketing text, not exact IPs/CIDRs/hostnames. Official OpenVPN docs say third-party/router `.ovpn` files require a Premium plan and are downloaded from the Members/Servers area. Unauthenticated `https://member.hide.me/en/server-status` redirects to `/en/user/login`. A direct scan of the public network page found only `www.hide.me` and `community.hide.me`, not server hostnames. |
| Live smoke | No parser smoke because no public exact source was found. Public home/about/network/legal/privacy/setup pages fetched successfully on 2026-07-05. `member.hide.me/en/server-status` returned HTTP 302 to login and then a login page. |
| Caveats | `nl.hide.me` appears in setup docs as an example remote address, not as a complete server inventory. Do not derive country hostnames from examples, scrape authenticated members pages, or import user-exported config files. If hide.me publishes a public server API or config bundle later, it could be a good opt-in `vpn_dns` candidate because the existing parser stack already supports OpenVPN remotes. |
| Primary source URLs | `https://hide.me/en/legal`, `https://hide.me/en/privacy`, `https://hide.me/en/about`, `https://hide.me/en/offshore-vpn`, `https://hide.me/en/network`, `https://hide.me/en/knowledgebase/where-can-i-download-openvpn-configuration-files/`, `https://hide.me/en/vpnsetup/openwrt-legacy/openvpn/`, `https://member.hide.me/en/server-status`, `https://apps.apple.com/ee/app/hide-me-vpn/id953040671`, `https://play.google.com/store/apps/details?id=hideme.android.vpn`, `https://www.forbes.com/sites/alisoncoleman/2019/07/19/the-privacy-entrepreneur-keeping-10-million-people-safe-online/`, `https://medium.com/authority-magazine/sebastian-schaub-of-hideme-vpn-five-things-you-need-to-create-a-highly-successful-startup-45d7f5ea84fd` |

## Batch 17 - OVPN.com, HMA, VyprVPN, Giganews VyprVPN, VPN Unlimited

This batch found two shippable opt-in DNS-expanded sources and one promising
OVPN lead. VyprVPN and Giganews VyprVPN are now in `fetch-manifest.json`
and the Ruby gem seed/source map. The OVPN config-form route below is
superseded by Batch 18's status API conversion, which avoids the CSRF-tokened,
multi-country, rate-limited POST matrix entirely.

### OVPN.com

| Field | Detail |
|---|---|
| Public service URL | `https://www.ovpn.com/en` |
| Legal / privacy URLs | `https://www.ovpn.com/en/privacy-notice`, `https://www.ovpn.com/en/tos`, `https://support.ovpn.com/hc/en-us/articles/46236219212307-Who-are-the-people-behind-OVPN`, `https://www.ovpn.com/en/configurations` |
| Legal entity shown by official pages | Current privacy notice says OVPN Inc and says OVPN was acquired by OVPN Inc. in 2025. The current support article "Who are the people behind OVPN?" says OVPN is operated by OVPN Integritet AB, organization number `556999-4469`, and that the owner is Pango. Treat this as unresolved corporate-transition evidence and cite both, rather than collapsing them into one entity. |
| Address / identifier | Primary source captured in this batch: OVPN Integritet AB organization number `556999-4469`. No OVPN Inc state registration, address, or incorporation date was captured from a primary registry in this batch. |
| Who is behind it | OVPN is a Pango/OVPN Inc service according to current privacy/support pages, with OVPN Integritet AB still named by support as operator. Earlier OVPN ownership/founding claims should not be used unless backed by current official or registry evidence. |
| Claimed network | Public configuration page lists 21 countries: AT, AU, CA, CH, DE, DK, ES, FI, FR, GB, IT, JP, NL, NO, PL, RO, SE, SG, UA, US, plus protocol choices UDP/TCP and DNS default/adblock. The page also markets owned hardware, but that is not exact egress data. |
| OpenASN data source | Superseded by Batch 18 source id `ovpn_status_servers`. No config-form source was added. |
| Source quality / status | Historical lead only. `GET https://www.ovpn.com/en/configurations` exposes a form with `_token`, `country`, `protocol`, `dns`, `datacenter_id=all`, `openvpn=2.5`, `output=.conf`, and `ciphter=chacha20`. A live authenticated-by-cookie-but-not-login POST on 2026-07-05 returned `content-disposition: attachment; filename=at.ovpn.com.conf` and OpenVPN remotes `pool-1.prd.at.ovpn.com 1194` / `1195`. The response also included `x-ratelimit-limit: 6`, so fetching all countries naively would violate the site's own rate posture. Batch 18 found the better first-party exact-IP status API and shipped that instead. |
| Live smoke | Unauthenticated config generation smoke succeeded for Austria/UDP/default DNS on 2026-07-05. No manifest/parser smoke because the current executor only supports static URL(s), static POST forms, and the Azure rotating-download resolver. |
| Caveats | Do not derive `pool-1.prd.<cc>.ovpn.com` for all countries from one sample, and do not implement the config-form route while `ovpn_status_servers` remains public and exact. The status API is safer, simpler, and returns exact IPs without DNS expansion. |
| Primary source URLs | `https://www.ovpn.com/en/privacy-notice`, `https://www.ovpn.com/en/tos`, `https://support.ovpn.com/hc/en-us/articles/46236219212307-Who-are-the-people-behind-OVPN`, `https://www.ovpn.com/en/configurations` |

### HMA / HideMyAss

| Field | Detail |
|---|---|
| Public service URL | `https://www.hidemyass.com/`, `https://www.hidemyass.com/servers` |
| Legal / privacy URLs | `https://www.hidemyass.com/legal/privacy`, `https://www.hidemyass.com/en-us/legal/vpn-terms`, `https://www.hidemyass.com/installation-files`, `https://support.hidemyass.com/s/article/download-links` |
| Legal entity shown by official pages | The HMA privacy policy says HMA is part of Gen and that the controller is Avast Software s.r.o., principal place of business 1737/1A Pikrtova, Prague 4, Czech Republic, 140 00. |
| Address / identifier | Avast Software s.r.o., 1737/1A Pikrtova, Prague 4, Czech Republic, 140 00. UK representative listed by the privacy policy: NortonLifeLock UK Limited, 100 New Bridge Street, London, England EC4V 6JA. No HMA-specific company number or incorporation year was captured from a primary registry in this batch. |
| Who is behind it | HMA is a Gen/Avast consumer VPN brand. Secondary partner/case-study material says Hide My Ass was founded in 2005 in the UK and became an Avast subsidiary in 2016; keep those as secondary context, not registry-grade evidence. |
| Claimed network | Official server page says 65+ countries, 100+ locations, and 3400+ VPN servers. It also says OpenVPN is used on PC and Android and IPsec/IKEv2 on iOS/macOS. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Current official installation page says HMA VPN is no longer supported on Linux and offers app downloads, not OpenVPN archives. Historical HMA blog posts and Gluetun point to `hidemyass.com/vpn-config/vpn-configs.zip` / `https://vpn.hidemyass.com/vpn-config/...`, but `vpn.hidemyass.com` did not resolve from this environment on 2026-07-05. Public server pages are location/count marketing only. |
| Live smoke | `curl -I -L https://vpn.hidemyass.com/vpn-config/TCP/` and UDP equivalent failed DNS resolution here. Public privacy, server, installation, and support pages fetched successfully. No parser smoke because no current exact source was found. |
| Caveats | Do not use old HMA blog config URLs, Gluetun updater paths, or third-party host dumps as source data. If HMA restores a public config archive or stable server API, it should likely be an opt-in `vpn_dns` source because OpenVPN configs generally publish remotes, not stable provider-owned CIDRs. |
| Primary source URLs | `https://www.hidemyass.com/legal/privacy`, `https://www.hidemyass.com/en-us/legal/vpn-terms`, `https://www.hidemyass.com/servers`, `https://www.hidemyass.com/installation-files`, `https://support.hidemyass.com/s/article/download-links`, `https://blog.hidemyass.com/en/how-do-i-use-openvpn-on-my-android-device`, `https://github.com/qdm12/gluetun/tree/master/internal/provider/hidemyass` |

### VyprVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.vyprvpn.com/` |
| Legal / privacy URLs | `https://www.vyprvpn.com/terms-of-service`, `https://www.vyprvpn.com/privacy-policy`, `https://support.vyprvpn.com/hc/en-us/articles/15903991797645-Certida-FAQ`, `https://www.vyprvpn.com/blog/post/trust`, `https://support.vyprvpn.com/hc/en-us/articles/360038096131-Where-can-I-find-the-OpenVPN-files` |
| Legal entity shown by official pages | Certida, LLC. The current site footer uses Copyright 2026 Certida, LLC, and a VyprVPN trust page states Certida, LLC is the legal name of the company that offers VyprVPN. The Certida FAQ says Certida is VyprVPN's parent company and is operating/supporting/improving the VyprVPN apps. |
| Address / identifier | No Certida, LLC registry filing, address, or incorporation date was captured from a primary registry in this batch. The old service lineage still appears in artifacts: generated OpenVPN files include certificate metadata naming Golden Frog GmbH / Golden Frog, which should be treated as legacy branding, not the current provider label. |
| Who is behind it | Current operator is Certida, LLC. The Certida FAQ says Certida has worked closely with and shares the vision of the original VyprVPN founders, Golden Frog. |
| Claimed network | Homepage says VyprVPN has protected users for more than 15 years. The implemented source is stronger than the marketing claim: it is the current first-party OpenVPN configuration archive. |
| OpenASN data source | Added opt-in `vpn_dns` source id `vyprvpn_openvpn`. |
| Source quality / status | First-party support article links `https://support.vyprvpn.com/hc/article_attachments/46761120489229`. Live fetch on 2026-07-05 returned a ZIP attachment named `VyprVPN_OpenVPN_2026-03-06.zip`, content type `application/x-zip-compressed`, `last-modified: Thu, 18 Jun 2026 19:23:09 GMT`, and ETag `"6cf492a2cf9dae94cd4821b0de329a95"`. The archive contained 73 `.ovpn` files with exact `remote *.vyprvpn.com` hostnames. |
| Live smoke | Parser smoke: 73 hostnames. DNS smoke: 73 hostnames -> 73 IPv4 answers, 0 DNS misses. End-to-end Tier B smoke: 67 merged IPv4 ranges, 0 IPv6 ranges, sample `31.6.10.254` classified as `vpn`, provider `VyprVPN`, source `vyprvpn_openvpn`. |
| Caveats | This is intentionally opt-in because DNS answers are resolver/vantage dependent. Do not widen resolved hosts into provider ASNs or `/24`s. Keep provider attribution as `VyprVPN`, not `Golden Frog`, even when old cert metadata appears inside configs. |
| Primary source URLs | `https://support.vyprvpn.com/hc/en-us/articles/360038096131-Where-can-I-find-the-OpenVPN-files`, `https://support.vyprvpn.com/hc/article_attachments/46761120489229`, `https://support.vyprvpn.com/hc/en-us/articles/15903991797645-Certida-FAQ`, `https://www.vyprvpn.com/blog/post/trust`, `https://www.vyprvpn.com/terms-of-service`, `https://www.vyprvpn.com/privacy-policy` |

### Giganews VyprVPN

| Field | Detail |
|---|---|
| Public service URL | `https://giganews.com/`, `https://www.giganews.com/vyprvpn/` |
| Legal / privacy URLs | `https://giganews.com/legal/`, `https://giganews.com/legal/privacy/`, `https://support.giganews.com/hc/en-us/articles/360039615432-What-are-the-VyprVPN-Server-Addresses` |
| Legal entity shown by official pages | Giganews, Inc. Current Giganews footer says "Giganews and the Giganews logo are registered trademarks of Giganews, Inc." and Copyright 2026 Giganews, Inc. Privacy policy says Giganews is the Data Controller. |
| Address / identifier | No Giganews, Inc. registry filing, address, or incorporation date was captured from a primary registry in this batch. The current legal/privacy pages verify entity name and data-controller role only. |
| Who is behind it | Giganews, Inc. operates the Usenet service and bundles VyprVPN support for Giganews accounts. The support site routes account management through Giganews control panel links. |
| Claimed network | Giganews markets "Free VPN Included" and hosts a VyprVPN support category. The source page says Giganews-account manual VyprVPN server addresses are different from server addresses used by direct Golden Frog/VyprVPN customers. |
| OpenASN data source | Added opt-in `vpn_dns` source id `giganews_vyprvpn_hosts`. |
| Source quality / status | First-party support page publishes an HTML table of exact `*.vpn.giganews.com` hostnames and explicitly says server IP addresses are subject to change, so users should use hostnames unless Giganews support directs otherwise. The current HTML splits hostnames across inline tags (`ca1.<span>vpn.giganews.com</span>`), so the generic `html_table_hostnames` parser now strips tags inside table cells before scanning. |
| Live smoke | Parser smoke: 73 hostnames. DNS smoke: 73 hostnames -> 73 IPv4 answers, 0 DNS misses. End-to-end Tier B smoke: 73 IPv4 ranges, 0 IPv6 ranges, sample `31.6.10.253` classified as `vpn`, provider `Giganews VyprVPN`, source `giganews_vyprvpn_hosts`. |
| Caveats | Keep this as a separate provider label from direct VyprVPN because Giganews itself says these hostnames differ from direct Golden Frog/VyprVPN customer hostnames. This still may share underlying infrastructure; OpenASN records the source/provider provenance visible to downstream users. |
| Primary source URLs | `https://giganews.com/legal/`, `https://giganews.com/legal/privacy/`, `https://www.giganews.com/vyprvpn/`, `https://support.giganews.com/hc/en-us/articles/360039615432-What-are-the-VyprVPN-Server-Addresses`, `https://support.giganews.com/api/v2/help_center/articles/360039615432.json` |

### VPN Unlimited / KeepSolid

| Field | Detail |
|---|---|
| Public service URL | `https://www.vpnunlimited.com/` |
| Legal / privacy URLs | `https://www.keepsolid.com/eua`, `https://www.keepsolid.com/privacy-policy`, `https://www.vpnunlimited.com/help/manuals/how-to-manually-create-vpn-conf`, `https://www.vpnunlimited.com/help/manuals/openvpn-openwrt`, `https://www.vpnunlimited.com/help/faq/technical-questions` |
| Legal entity shown by official pages | KeepSolid, Inc. The End User Agreement is titled `KEEPSOLID, INC. END USER AGREEMENT`, last updated July 23, 2025, and defines KeepSolid, Inc. as the provider of the services. |
| Address / identifier | No KeepSolid, Inc. registry filing, address, or incorporation date was captured from a primary registry in this batch. Public official pages identify the legal name and account/product workflow. |
| Who is behind it | KeepSolid, Inc. operates VPN Unlimited and related KeepSolid products. The public OEM site also markets a KeepSolid white-label VPN foundation with 3000+ servers across 80+ locations and 50+ countries, but that is marketing/network scale, not exact exits. |
| Claimed network | VPN Unlimited marketing says 3000+ servers across 80+ locations. OEM page says the white-label VPN foundation uses a worldwide backbone of 3000+ high-speed servers across 80+ locations and 50+ countries. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Official manuals instruct users to log into User Office, open VPN Unlimited management, create a manual configuration, choose protocol/device/server, and download account-generated OpenVPN files. Gluetun explicitly hardcodes VPN Unlimited hostnames from a user-provided ZIP because the source is behind a login wall. That is not a redistributable or unauthenticated OpenASN source. |
| Live smoke | Official home, EULA, User Office/help, manual configuration, OpenWrt/OpenVPN, and FAQ pages fetched successfully on 2026-07-05. No parser smoke because no public exact IP/CIDR/hostname/config archive was verified. |
| Caveats | Do not import Gluetun's user-ZIP-derived hardcoded map or derive `*.vpnunlimitedapp.com` hostnames from it. A future source needs a first-party public server list/config archive or a terms-cleared API that does not require account credentials. |
| Primary source URLs | `https://www.vpnunlimited.com/`, `https://www.keepsolid.com/eua`, `https://www.keepsolid.com/privacy-policy`, `https://www.vpnunlimited.com/help/manuals/how-to-manually-create-vpn-conf`, `https://www.vpnunlimited.com/help/manuals/openvpn-openwrt`, `https://www.vpnunlimited.com/help/faq/technical-questions`, `https://oem.vpnunlimited.com/`, `https://github.com/qdm12/gluetun/tree/master/internal/provider/vpnunlimited` |

## Batch 18 - OVPN Status API Conversion

OVPN moved from "promising but not added" to an implemented default source in
this batch. The key discovery is that the official status page renders VPN
server lists through small JSON endpoints; those endpoints are exact, public,
first-party, and do not require the CSRF-tokened OpenVPN config generator.

### OVPN.com status source

| Field | Detail |
|---|---|
| Public service URL | `https://www.ovpn.com/en`, `https://status.ovpn.com` |
| Legal / privacy URLs | `https://www.ovpn.com/en/privacy-notice`, `https://www.ovpn.com/en/tos`, `https://www.ovpn.com/en/configurations`, `https://www.ovpn.com/en/network`, `https://status.ovpn.com` |
| Legal entity shown by official pages | Same current evidence as Batch 17: OVPN Inc in the privacy notice and current marketing page; OVPN Integritet AB / `556999-4469` remains documented from the support article as older/current support evidence. |
| Source discovery | `https://status.ovpn.com` contains `Servers-List datacenter="..."` Vue components for 32 VPN datacenters and loads `/js/app.js`. The app's `ServersList` component calls `GET /datacenters/{datacenter}/servers`, rendering each row's `name`, `ip`, `online`, bandwidth, and uptime. |
| OpenASN data source | Added default `vpn_providers` source id `ovpn_status_servers`. |
| Source quality / status | First-party exact-IP JSON. The manifest enumerates the 32 datacenter endpoints (`sydney`, `vienna`, `toronto`, `copenhagen`, `helsinki`, `paris`, `frankfurt`, `erfurt`, `offenbach`, `milan`, `tokyo`, `amsterdam`, `oslo`, `warsaw`, `bucharest`, `singapore`, `madrid`, `sthlm`, `malmo`, `gothenburg`, `sundsvall`, `zurich`, `kyiv`, `london`, `losangeles`, `miami`, `newyork`, `chicago`, `atlanta`, `dallas`, `seattle`, `denver`). Parser keeps rows whose `online` flag is not false and emits the exact `ip` field. |
| Live smoke | Status API smoke on 2026-07-05: 32 endpoints, 97 rows, 96 unique IPv4 addresses. End-to-end Tier B smoke: 34 merged IPv4 ranges, 0 IPv6 ranges, sample `5.181.234.131` classified as `vpn`, provider `OVPN`, source `ovpn_status_servers`. |
| Config-form note | The OpenVPN config page remains useful corroboration: it can generate `.conf` files after a fresh CSRF token and returned `pool-1.prd.at.ovpn.com` in Batch 17. It is no longer needed for OpenASN because the status API gives exact IPs with less risk and no rate-limited form matrix. |
| Caveats | Do not infer pool hostnames, DNS-expand `pool-*.ovpn.com`, or use the config form while the status API remains public and exact. If the status app changes slug names, the manifest should be updated from the page's `Servers-List datacenter="..."` attributes after a live smoke, not guessed. |
| Primary source URLs | `https://status.ovpn.com`, `https://status.ovpn.com/js/app.js`, `https://status.ovpn.com/datacenters/sydney/servers`, `https://status.ovpn.com/datacenters/sthlm/servers`, `https://www.ovpn.com/en/configurations`, `https://www.ovpn.com/en/privacy-notice`, `https://www.ovpn.com/en/network` |

## Batch 18 - Remaining Rechecks

This batch also rechecked SlickVPN, CalyxVPN, Cloudflare WARP, and Opera
VPN. Only SlickVPN crossed the source-quality bar: its current public
locations page publishes exact config-linked hostnames without credentials.
The linked configs are useful corroboration but not the source of record. The
other three remain documented negative findings.

### SlickVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.slickvpn.com/`, `https://www.slickvpn.com/locations/`, `https://www.slickvpn.com/press/` |
| Legal / privacy URLs | `https://www.slickvpn.com/terms-and-conditions/`, `https://www.slickvpn.com/privacy-policy/`, `https://www.slickvpn.com/warrant-canary/`, `https://www.slickvpn.com/refund-policy/` |
| Legal entity shown by official pages | Terms list notices to `Slick Networks, Inc.`; the current warrant canary names `SlickVPN.com, Slick Networks, Inc., Slick Network, LTD.` as `SlickVPN`; footer contact block says `SLICKVPN`. |
| Address / identifier | Terms notice address: `Slick Networks, Inc., 3504 Hwy 153 #14, Greenville, SC 29611, USA`, phone `(866) 521-1757`. Footer contact block: `SLICKVPN, Weston Road PMB #231, Weston, Florida 33331, USA`. |
| Registry / incorporation evidence | Official press page says SlickVPN was founded in 2011 and the website launched in 2012. No state registry extract was added in this batch; official pages disclose a complex structure with US marketing and an operational entity in Nevis, but not the full corporate hierarchy. |
| Who is behind it | SlickVPN is operated under the Slick Networks/Slick Network entities above. NewsDemon publicly markets SlickVPN as included with NewsDemon subscriptions, and the current SlickVPN locations page links OpenVPN configs hosted under `members.newsdemon.com`. |
| Source discovery | `https://www.slickvpn.com/locations/` currently says it is "a list of the active VPN servers" and publishes 11 location rows. Each row links a public `https://members.newsdemon.com/vpn/2025/SV-2025-*.ovpn` config. |
| OpenASN data source | Added opt-in `vpn_dns` source id `slickvpn_locations`; parser id `slickvpn_locations_html`. |
| Source quality / status | First-party active-server page with exact `gw*.slickvpn.com` hostnames. Parser keeps only visible hostnames whose anchor points at `https://members.newsdemon.com/vpn/2025/*.ovpn`, so page chrome and unrelated domains cannot enter the overlay. This is intentionally DNS-expanded and off by default because SlickVPN publishes hostnames rather than raw IPs, and DNS answers are resolver-vantage data. |
| Live smoke | On 2026-07-05, the locations page yielded 11 config-linked hostnames and this resolver returned 11 IPv4 addresses. End-to-end Tier B smoke wrote 11 IPv4 ranges, 0 IPv6 ranges; sample `gw2.ams3.slickvpn.com -> 151.236.14.57` classified as `vpn`, provider `SlickVPN`, source `slickvpn_locations`. |
| Page/config mismatch | All 11 linked configs returned HTTP 200 and contained one `remote` line each, but the Amsterdam page label was `gw2.ams3.slickvpn.com` while the linked official config said `remote gw2.ams2.slickvpn.com 8080`; `gw2.ams2` did not resolve from this environment. OpenASN therefore uses the current active-server page as source of record and treats the config files as corroboration only. |
| Caveats | Do not import Gluetun hardcoded SlickVPN hostnames, do not infer the older "145 gateways / 45+ countries" press claims into hostnames, and do not crawl arbitrary NewsDemon directories. The only accepted source is the current SlickVPN locations page's config-linked visible hostnames. |
| Primary source URLs | `https://www.slickvpn.com/locations/`, `https://members.newsdemon.com/vpn/2025/SV-2025-Singapore.ovpn`, `https://members.newsdemon.com/vpn/2025/SV-2025-Amsterdam.ovpn`, `https://www.slickvpn.com/press/`, `https://www.slickvpn.com/terms-and-conditions/`, `https://www.slickvpn.com/privacy-policy/`, `https://www.slickvpn.com/warrant-canary/`, `https://www.newsdemon.com/free-vpn-with-usenet` |

### CalyxVPN

| Field | Detail |
|---|---|
| Public service URL | `https://calyxos.org/docs/guide/apps/calyx-vpn/`, `https://f-droid.org/en/packages/org.calyxinstitute.vpn/`, `https://leap.se/` |
| Legal / privacy URLs | `https://calyx.org/legal/privacy-policy`, `https://calyx.org/legal/terms-of-service` |
| Legal entity shown by official pages | The Calyx Institute. |
| Address / identifier | Privacy policy contact address: `The Calyx Institute, 254 36th Street, Suite C660, Brooklyn, NY 11232`. |
| Registry / incorporation evidence | Official pages identify the institute and address. No New York nonprofit/IRS registry extract was added in this batch. |
| Who is behind it | CalyxVPN is the Calyx Institute's branded LEAP/Bitmask VPN. F-Droid describes it as a free VPN service offered by The Calyx Institute and based on Bitmask; LEAP says LEAP VPN is the shared code base for RiseupVPN, CalyxVPN, and Bitmask. |
| OpenASN data source | Not added. The existing `leap_eip_service_json` parser would support Calyx if a live LEAP EIP JSON endpoint becomes reachable. |
| Source quality / status | Blocked by unavailable source, not by parser shape. Public docs prove the product and operator, but no fetched, current, first-party gateway JSON was obtained. |
| Live smoke | On 2026-07-05, `https://api.calyx.net/3/config/provider.json`, `https://api.calyx.net/3/config/eip-service.json`, the same paths on `:4430`, `https://calyx.net/provider.json`, and `https://calyx.net/3/config/eip-service.json` timed out from this environment. |
| Caveats | Do not import IPs from community logs, troubleshooting posts, or local client runtime output. Those can be stale, vantage-specific, or Riseup/Calyx-confused. Add Calyx only after a live first-party provider endpoint fetches and the parser smoke passes. |
| Primary source URLs | `https://calyxos.org/docs/guide/apps/calyx-vpn/`, `https://f-droid.org/en/packages/org.calyxinstitute.vpn/`, `https://gitlab.com/CalyxOS/bitmask_android`, `https://leap.se/`, `https://calyx.org/legal/privacy-policy`, `https://api.calyx.net/3/config/eip-service.json` |

### Cloudflare WARP / 1.1.1.1 recheck

| Field | Detail |
|---|---|
| Public service URL | `https://1.1.1.1/`, `https://developers.cloudflare.com/warp-client/`, `https://developers.cloudflare.com/cloudflare-one/` |
| Legal / privacy URLs | `https://www.cloudflare.com/privacypolicy/`, `https://www.cloudflare.com/website-terms/`, `https://developers.cloudflare.com/1.1.1.1/privacy/` |
| OpenASN data source | Existing `cloudflare_ranges` remains context-only via `https://www.cloudflare.com/ips-v4` and `https://www.cloudflare.com/ips-v6`; no WARP-specific `vpn` source added. |
| 2026-07-05 recheck | Cloudflare's egress-policy docs, last updated 2026-05-05, explicitly say Cloudflare does not publish Cloudflare One Client egress IP ranges and that those egress IPs are not listed at Cloudflare's public IP Ranges page. |
| Caveats | Do not map all Cloudflare ranges to `vpn`: that would conflate CDN/reverse-proxy, Cloudflare One, Gateway, Apple Private Relay overlap, and ordinary Cloudflare infrastructure. Keep `cloudflare_ranges` as context unless Cloudflare publishes consumer WARP exits separately. |
| Primary source URLs | `https://developers.cloudflare.com/cloudflare-one/traffic-policies/egress-policies/`, `https://www.cloudflare.com/ips/`, `https://www.cloudflare.com/ips-v4`, `https://www.cloudflare.com/ips-v6`, `https://developers.cloudflare.com/fundamentals/concepts/cloudflare-ip-addresses/` |

### Opera VPN / Opera VPN Pro recheck

| Field | Detail |
|---|---|
| Public service URL | `https://www.opera.com/features/free-vpn`, `https://www.opera.com/features/vpn-pro`, `https://help.opera.com/en/mobile/vpn/` |
| Legal / privacy URLs | `https://www.opera.com/legal/privacy`, `https://www.opera.com/legal/terms`, `https://blogs.opera.com/security/2024/09/opera-free-browser-vpn-no-log-audit-deloitte/`, `https://investor.opera.com/news-releases/news-release-details/opera-unveils-revamped-vpn-pro-its-premium-vpn-service-offering` |
| Legal entity shown by official pages | Opera Norway AS. |
| Address / identifier | Privacy statement contact address: `Opera Norway AS, P.O. Box 4214, Nydalen 0401, Oslo, Norway`. |
| OpenASN data source | Not added. No exact public exit IP, CIDR, or hostname inventory found. |
| 2026-07-05 recheck | The Free VPN page says Free VPN is browser-only, has 3 general locations and 100+ servers, while VPN Pro is device-wide. The current VPN Pro page says 3,000+ private servers and 47 global locations; Opera's July 2025 investor release says revamped VPN Pro has 48 locations and Lightway. Opera's 2024 no-log audit post said VPN Pro servers were then provided in collaboration with Nord while free browser VPN used Opera infrastructure. None of these pages publish exact exits. |
| Live smoke | Previously tested `de.opera-proxy.net`, `us.opera-proxy.net`, `ca.opera-proxy.net`, and numbered variants did not resolve from this environment. Reverse-engineered SurfEasy/Opera proxy flows require app-style registration/client keys and remain outside OpenASN's source bar. |
| Caveats | Do not label Nord, Express/Lightway-capable, SurfEasy/Pango, or generic Opera infrastructure as Opera VPN unless Opera publishes an exact exit inventory or unauthenticated config source that distinguishes Opera-branded egress. |
| Primary source URLs | `https://www.opera.com/features/free-vpn`, `https://www.opera.com/features/vpn-pro`, `https://help.opera.com/en/mobile/vpn/`, `https://www.opera.com/legal/privacy`, `https://blogs.opera.com/security/2024/09/opera-free-browser-vpn-no-log-audit-deloitte/`, `https://investor.opera.com/news-releases/news-release-details/opera-unveils-revamped-vpn-pro-its-premium-vpn-service-offering`, `https://github.com/spaze/oprah-proxy` |

## Batch 19 - Anonine, AzireVPN, VPN.AC, Trust.Zone, Ivacy, SaferVPN

This batch focused on first-party provider surfaces that were either hidden
behind modern app bundles, published as server-status pages, or surfaced only
after following support/setup paths. Four sources crossed the OpenASN bar:
Anonine as default exact IP data, plus AzireVPN, VPN.AC, and Trust.Zone as
opt-in DNS-expanded provider hostname data. Ivacy and SaferVPN remain documented
negative findings: both have useful discovery leads, but neither currently has
a locally fetchable, dependency-light, first-party exact source suitable for the
gem.

### Anonine

| Field | Detail |
|---|---|
| Public service URL | `https://anonine.com/`, `https://anonine.com/network/` |
| Legal / privacy URLs | `https://anonine.com/privacy-policy/`, `https://anonine.com/terms-of-service/`, `https://anonine.com/about/`, `https://anonine.com/contact/` |
| Legal entity shown by official pages | Current footer says `Edelino Commerce Inc.`. The About page says Anonine was founded in Sweden and later transferred to a Seychelles-based company. |
| Address / identifier | No street address, registry number, or incorporation year was found on official public pages in this pass. |
| Registry / incorporation evidence | Official pages provide a service founding claim, not a registry extract. The About page fetched on 2026-07-05 says Anonine was founded "11 years ago in Sweden"; because that text appears stale relative to the 2026 page footer, OpenASN records it only as a site claim and not as a verified incorporation year. |
| Who is behind it | Anonine presents itself as a privacy-focused VPN team originally founded in Sweden and now operated through a Seychelles-based company; current public footer names Edelino Commerce Inc. |
| Source discovery | The public Network page is a Gatsby app. Its JavaScript bundle calls `serverStatusUrl()`, which resolves to `https://anonine.com/www/server-status` for the English site. |
| OpenASN data source | Added default `vpn_providers` source id `anonine_status`; parser id `anonine_status_json`. |
| Source quality / status | First-party exact-IP JSON. The endpoint returns an array of location rows with `primary_ip`, `alias`, and nested `servers[].ips`; parser collects exact IPs only and ignores host aliases because DNS expansion is unnecessary here. |
| Live smoke | On 2026-07-05, the endpoint yielded 38 rows, 39 host aliases, and 296 unique IPv4 addresses, merged by the executor into 82 IPv4 ranges. Sample exact IP `198.57.26.18` classified end-to-end as `vpn`, provider `Anonine`, source `anonine_status`. |
| Caveats | Do not import haugene or other third-party OpenVPN config inventories for Anonine. The accepted source is the first-party status JSON; if that endpoint starts emitting empty IP arrays, keep stale data and investigate the Network page bundle again. |
| Primary source URLs | `https://anonine.com/network/`, `https://anonine.com/www/server-status`, `https://anonine.com/about/`, `https://anonine.com/privacy-policy/`, `https://anonine.com/terms-of-service/`, `https://anonine.com/contact/` |

### AzireVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.azirevpn.com/`, `https://www.azirevpn.com/about`, `https://www.azirevpn.com/support` |
| Legal / privacy URLs | `https://www.azirevpn.com/docs/api/locations`, `https://www.azirevpn.com/legal/privacy`, `https://www.azirevpn.com/legal/terms`, `https://www.malwarebytes.com/tos`, `https://www.malwarebytes.com/privacy` |
| Legal entity shown by official pages | AzireVPN's current site says it is owned by Malwarebytes. Current AzireVPN footer says `2012-2026 Malwarebytes`; Malwarebytes legal pages name Malwarebytes Inc. and related Malwarebytes entities. |
| Address / identifier | Malwarebytes terms/footer identify `2445 Augustine Drive, Suite 550, Santa Clara, CA, USA 95054` and `One Albert Quay, 2nd Floor, Cork T12 X8N6, Ireland`. |
| Registry / incorporation evidence | AzireVPN official About page says the service was founded in Stockholm, Sweden in 2012. Malwarebytes announced the AzireVPN acquisition on 2024-11-07; no separate AzireVPN registry number was found on public pages in this pass. |
| Who is behind it | AzireVPN was founded by a Stockholm security team in 2012 and joined Malwarebytes in 2024; the current About page says the original team remains in Sweden. |
| Claimed network | Current About page says 62 locations and 153 servers. |
| Source discovery | Official API docs publish unauthenticated `GET https://api.azirevpn.com/v3/locations` and document `pool` as the hostname pool with IPs available for a location. |
| OpenASN data source | Added opt-in `vpn_dns` source id `azirevpn_locations`; parser id `azirevpn_locations_json`. |
| Source quality / status | First-party location API with exact provider-published pool hostnames. Because the API publishes hostnames rather than raw exits, clients resolve locally and the source stays behind `config.tier_b[:vpn_dns]`. |
| Live smoke | On 2026-07-05, the API yielded 62 pool hostnames and the local resolver returned 64 IPs, merged by the executor into 63 IPv4 ranges and 1 IPv6 range. Sample `ar-bue.azirevpn.net -> 200.110.149.179` classified as `vpn`, provider `AzireVPN`, source `azirevpn_locations`. |
| Caveats | The source is DNS-vantage-specific. In this local Mac environment, Ruby `TCPSocket`/`Net::HTTP` connections to `api.azirevpn.com:443` were transparently redirected to loopback port `10011`, while `curl` and `openssl s_client` reached `193.187.90.89` and verified the public certificate; the source/parser/DNS/overlay smoke therefore used a curl-fetched body for Azire only. Do not use Azire marketing location pages as source data, do not widen by ASN, and do not reattribute all Malwarebytes/IPVanish/other partner infrastructure as AzireVPN. |
| Primary source URLs | `https://www.azirevpn.com/about`, `https://www.azirevpn.com/docs/api/locations`, `https://api.azirevpn.com/v3/locations`, `https://www.malwarebytes.com/blog/news/2024/11/malwarebytes-acquires-azirevpn`, `https://www.malwarebytes.com/tos`, `https://www.malwarebytes.com/privacy` |

### VPN.AC

| Field | Detail |
|---|---|
| Public service URL | `https://vpn.ac/`, `https://vpn.ac/status`, `https://vpn.ac/ovpn/` |
| Legal / privacy URLs | `https://vpn.ac/tos`, `https://vpn.ac/privacy`, `https://vpn.ac/about`, `https://vpn.ac/contact` |
| Legal entity shown by official pages | Terms say VPN.AC and the VPN service are operated by `Cryptolayer SRL`, formerly `Netsec Interactive Solutions SRL`. |
| Address / identifier | Terms list `76 Calea Dumbravii Street, 550399, Sibiu, Romania`, company registration `J32/500/2015`, VAT `RO34573525`. |
| Registry / incorporation evidence | The company registration number indicates the current Romanian entity was registered in 2015. Official About page says the team's security company roots go back to Netsec Interactive Solutions in 2009 and that VPN.AC launched at the end of 2012. |
| Who is behind it | VPN.AC is operated by Cryptolayer SRL / the former Netsec Interactive Solutions team in Romania. |
| Source discovery | The official status page renders a VPN Nodes Status table with exact `*.vpn.ac` node hostnames. The official `/ovpn/` directory exposes public OpenVPN config bundles that corroborate the same hostname namespace. |
| OpenASN data source | Added opt-in `vpn_dns` source id `vpnac_status`; parser id `vpnac_status_html`. |
| Source quality / status | First-party status table with exact provider hostnames, not generated patterns. Parser scans only hostname text inside table cells ending in `.vpn.ac`; clients resolve locally. |
| Live smoke | On 2026-07-05, the status page yielded 130 hostnames and the local resolver returned 132 IPv4 addresses, merged by the executor into 130 IPv4 ranges. Sample `au1.vpn.ac -> 103.231.88.140` classified end-to-end as `vpn`, provider `VPN.AC`, source `vpnac_status`. |
| Caveats | DNS answers can vary by resolver, and VPN.AC has multiple hostname variants per location. Keep the source opt-in; do not infer hostnames from country/location labels or import third-party provider maps. |
| Primary source URLs | `https://vpn.ac/status`, `https://vpn.ac/ovpn/`, `https://vpn.ac/tos`, `https://vpn.ac/about`, `https://vpn.ac/contact`, `https://vpn.ac/privacy` |

### Trust.Zone

| Field | Detail |
|---|---|
| Public service URL | `https://trust.zone/`, `https://trust.zone/servers` |
| Legal / privacy URLs | `https://trust.zone/terms`, `https://trust.zone/privacy`, `https://trust.zone/setup`, `https://trust.zone/contact-us` |
| Legal entity shown by official pages | Terms say the Trust.Zone website is operated by `Internet Privacy Ltd` as Licensor. The same terms authorize `Tersys Group OÜ` as Distributor for receiving payments and payouts. |
| Address / identifier | Terms list head office `Unit 117, Orion Mall, Palm Street, P.O. Box 828, Victoria, Mahe, Seychelles` for Internet Privacy Ltd. Distributor address: `Harjumaa, Tallinn, Kesklinna linnaosa, Vesivärava tn 50-201, 10152, Estonia`. |
| Registry / incorporation evidence | No registry extract or incorporation year was found on official public pages in this pass. |
| Who is behind it | Trust.Zone is presented as a Seychelles-operated VPN service with an Estonian payment distributor. |
| Claimed network | The official servers page fetched on 2026-07-05 advertised 188 servers across 90+ zones. |
| Source discovery | `https://trust.zone/servers` publishes exact `*.trust.zone` server/zone hostnames in the public servers table. Manual setup pages hide downloadable `.ovpn` files behind login, so the servers page is the clean unauthenticated source. |
| OpenASN data source | Added opt-in `vpn_dns` source id `trustzone_servers`; parser id `trustzone_servers_html`. |
| Source quality / status | First-party server hostname page. Parser extracts `*.trust.zone` hostnames and excludes the apex and `www`; clients resolve locally because raw IPs are not published. |
| Live smoke | On 2026-07-05, the page yielded 70 server hostnames and the local resolver returned 90 IPv4 addresses, merged by the executor into 86 IPv4 ranges. Sample `za.trust.zone -> 102.165.60.216` classified end-to-end as `vpn`, provider `Trust.Zone`, source `trustzone_servers`. |
| Caveats | Keep DNS-expanded and opt-in. Do not use account-hidden `.ovpn` files, app traffic, or inferred country-code hostnames as source data. If the page gains non-server `*.trust.zone` hostnames, tighten the parser to table-row structure before shipping. |
| Primary source URLs | `https://trust.zone/servers`, `https://trust.zone/terms`, `https://trust.zone/privacy`, `https://trust.zone/setup/openvpn`, `https://trust.zone/contact-us` |

### Ivacy

| Field | Detail |
|---|---|
| Public service URL | `https://www.ivacy.com/`, `https://support.ivacy.com/servers-list/` |
| Legal / privacy URLs | `https://support.ivacy.com/vpnusecases/openvpn-files-windows-routers-ios-linux-and-mac/`, `https://www.ivacy.com/terms-of-usage/`, `https://www.ivacy.com/privacy-policy/`, `https://www.ivacy.com/about/` |
| Legal entity shown by official pages | Official support footer identified `PMG Pte. Ltd.` during the browser-rendered audit. |
| Address / identifier | Official support footer identified `38 Beach Road #29-11 South Beach Tower Singapore 189767`. |
| Registry / incorporation evidence | Ivacy marketing uses a 2006 founding/copyright claim, but no official registry extract was added in this pass. |
| Who is behind it | Ivacy is presented as a Singapore-associated VPN service under PMG Pte. Ltd. on official support pages. |
| Source discovery | Browser-rendered official support pages expose exact server hostnames such as `us2-auto-tcp.dns2use.com` and support pages link official S3 config archives. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Promising but not shippable yet. `https://support.ivacy.com/servers-list/` returns 403 to local/gem-style fetches, even though browser search/rendering shows useful hostnames. Official S3 config artifacts such as `https://ivacy.s3.amazonaws.com/support/OpenVPN-Configs.rar` and `https://ivacy.s3.amazonaws.com/support/OpenVPN-Configs-with-certificate.rar` fetch as RAR files, not ZIPs. |
| Live smoke | On 2026-07-05, local fetch of the server-list page returned HTTP 403. The two S3 RAR artifacts returned HTTP 200, but OpenASN does not have a RAR parser and does not add new archive dependencies lightly for a single provider. |
| Caveats | Do not bypass the WAF, do not scrape browser-rendered content that cannot be reproduced by the gem updater, and do not add a RAR dependency until it is justified by multiple high-value first-party sources and covered by zip-bomb-equivalent safety tests. |
| Primary source URLs | `https://support.ivacy.com/servers-list/`, `https://support.ivacy.com/vpnusecases/openvpn-files-windows-routers-ios-linux-and-mac/`, `https://ivacy.s3.amazonaws.com/support/OpenVPN-Configs.rar`, `https://ivacy.s3.amazonaws.com/support/OpenVPN-Configs-with-certificate.rar`, `https://www.ivacy.com/terms-of-usage/`, `https://www.ivacy.com/privacy-policy/` |

### SaferVPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.safervpn.com/` |
| Legal / privacy URLs | `https://www.safervpn.com/terms`, `https://www.safervpn.com/privacy`, `https://support.safervpn.com/` |
| Legal entity shown by official pages | Not verified from a locally fetchable official page in this batch; official site/support fetches returned 403 from the local environment. Historical public material tied SaferVPN to the Perimeter 81 / J2 Global lineage, but that is not enough for source attribution. |
| Address / identifier | Not found in locally fetchable official pages in this pass. |
| Registry / incorporation evidence | Not found in locally fetchable official pages in this pass. |
| Who is behind it | Historical/legal research indicates SaferVPN is a legacy consumer VPN brand associated with the Perimeter 81/J2 Global acquisition path, but current official public pages did not provide a clean, fetchable operator/source record from this environment. |
| Source discovery | Third-party router/vendor and community references point to historical SaferVPN OpenVPN configs, but no current first-party exact IP/CIDR/hostname source fetched cleanly. |
| OpenASN data source | Not added. No OpenASN source id. |
| Source quality / status | Blocked by source quality and fetchability. The official pages that might establish legal/operator facts or config paths returned 403 locally; third-party historical config links are not redistributable source data. |
| Live smoke | On 2026-07-05, official site/support fetches returned 403 or non-useful public pages. No parser smoke because no accepted source body was obtained. |
| Caveats | Do not import GL.iNet, haugene, or forum-derived SaferVPN hosts. Revisit only if a current first-party config archive/status/API becomes fetchable without account credentials, bot-challenge bypassing, or proprietary client inspection. |
| Primary source URLs | `https://www.safervpn.com/`, `https://support.safervpn.com/`, `https://www.safervpn.com/terms`, `https://www.safervpn.com/privacy` |

## Batch 20 - Non-Provider And Discontinued VPN Traps

This batch closes common false leads: discontinued Google One VPN, current
Pixel-only VPN by Google, VPN client/server software, mesh networking, and
router setup documentation. These products contain the word "VPN" and often
appear in search results, but they do not publish reusable public egress
inventories that OpenASN can map to `vpn`.

### Google One VPN / VPN by Google

| Field | Detail |
|---|---|
| Public service URL | `https://one.google.com/`, `https://support.google.com/pixelphone/answer/2819573` |
| Legal / privacy URLs | `https://policies.google.com/terms`, `https://policies.google.com/privacy`, `https://support.google.com/pixelphone/answer/2819573` |
| Legal entity shown by official pages | Google terms identify Google LLC as the service operator for US users. |
| Address / identifier | Google terms identify `Google LLC, 1600 Amphitheatre Parkway, Mountain View, California 94043, USA` for US users. No service-specific VPN entity or registry number was found in this pass. |
| Registry / incorporation evidence | Not checked beyond Google public legal pages. The useful product fact is operational: Google One VPN is discontinued, while VPN by Google remains a Pixel-device feature. |
| Who is behind it | Google. Current support says Pixel 7 and later phones plus Pixel Tablet have access to the built-in VPN by Google in supported countries. |
| Source discovery | Google One community/help pages say VPN by Google One was discontinued as of 2024-06-20. Pixel support documents current VPN by Google availability and behavior, including that users cannot choose an IP location for content access. |
| OpenASN data source | Not added. No source id. |
| Source quality / status | No public exact egress IP/CIDR/hostname source was found for either the discontinued Google One VPN or the current Pixel VPN by Google. Pixel support is product documentation, not an exit inventory. |
| Live smoke | Official Google One support/community search results returned the discontinuation date. Current Pixel support page fetched on 2026-07-05 and exposed eligibility/country docs, but no server list or config/API endpoint. |
| Caveats | Do not infer Google VPN exits from all Google ASN ranges, Google Cloud ranges, or `googleusercontent.com`. Google operates many unrelated networks; without a VPN-specific first-party egress list, broad Google labeling would be a high-impact false positive. |
| Primary source URLs | `https://support.google.com/googleone/thread/339367691/what-happened-to-the-google-one-vpn`, `https://support.google.com/googleone/thread/320108310/is-google-one-vpn-still-operating-in-canada`, `https://support.google.com/pixelphone/answer/2819573`, `https://policies.google.com/terms`, `https://policies.google.com/privacy` |

### OpenVPN Connect

| Field | Detail |
|---|---|
| Public service URL | `https://openvpn.net/client/`, `https://openvpn.net/` |
| Legal / privacy URLs | `https://openvpn.net/legal/`, `https://openvpn.net/privacy-policy/` |
| Legal entity shown by official pages | OpenVPN Inc. |
| Address / identifier | Public OpenVPN legal/privacy pages did not expose a full street address in the fetched text. A LEI lookup identifies OpenVPN Inc. as a Delaware entity with registration authority entity id `3761256`, but OpenASN treats that as corporate context, not VPN source evidence. |
| Registry / incorporation evidence | LEI record: Delaware jurisdiction, entity id `3761256`; not needed for data inclusion because OpenVPN Connect is client software, not an egress provider. |
| Who is behind it | OpenVPN Inc., the company behind OpenVPN Connect, Access Server, and CloudConnexa. |
| Source discovery | Official OpenVPN Connect page says it is the official client application for securely accessing an organization's network resources and instructs users to import a connection profile or provider-supplied `.ovpn` file. |
| OpenASN data source | Not added. No source id. |
| Source quality / status | OpenVPN Connect is a client. It has no universal egress IP inventory; exits are whichever private organization, Access Server, CloudConnexa, or third-party VPN profile the user imports. |
| Live smoke | Official client page and legal/privacy pages fetched on 2026-07-05. No parser smoke because there is no provider source body. |
| Caveats | Do not map OpenVPN Inc., OpenVPN protocol usage, `.ovpn` syntax, or Access Server customers to `vpn`. Only provider-published endpoint lists belong in OpenASN. |
| Primary source URLs | `https://openvpn.net/client/`, `https://openvpn.net/legal/`, `https://openvpn.net/privacy-policy/`, `https://lei.bloomberg.com/leis/view/2549000IB62FH9U1KW87` |

### SoftEther VPN

| Field | Detail |
|---|---|
| Public service URL | `https://www.softether.org/`, `https://www.vpngate.net/` |
| Legal / privacy URLs | `https://www.softether.org/`, `https://www.softether.org/9-about/news/800-open-source`, `https://www.vpngate.net/` |
| Legal entity shown by official pages | SoftEther VPN Project is described as an academic project from the University of Tsukuba. VPN Gate is the public free relay experiment built on SoftEther. |
| Address / identifier | No separate SoftEther corporate operator/address was relevant or found in this pass. |
| Registry / incorporation evidence | Not applicable for OpenASN data inclusion; this is software/project infrastructure, not a commercial egress network. |
| Who is behind it | SoftEther VPN Project / University of Tsukuba for the software; VPN Gate for the public relay service. |
| Source discovery | Official SoftEther page says SoftEther is open-source, cross-platform, multi-protocol VPN software. VPN Gate separately publishes public relay endpoints and is already represented by OpenASN's `vpngate` source. |
| OpenASN data source | No SoftEther source id. Existing `vpngate` source covers the public relay service. |
| Source quality / status | SoftEther itself is software that anyone can run; it has no global egress list. VPN Gate is the exact public relay network and is already opt-in `public_relays`. |
| Live smoke | Official SoftEther and VPN Gate pages fetched on 2026-07-05. No new parser smoke; existing VPN Gate parser remains the accepted data path. |
| Caveats | Do not label arbitrary SoftEther servers as VPN Gate or provider-operated VPN exits. Only the official VPN Gate API/source should feed OpenASN. |
| Primary source URLs | `https://www.softether.org/`, `https://www.softether.org/9-about/news/800-open-source`, `https://www.vpngate.net/`, `https://www.vpngate.net/en/download.aspx` |

### Tailscale

| Field | Detail |
|---|---|
| Public service URL | `https://tailscale.com/`, `https://tailscale.com/docs/concepts/what-is-tailscale` |
| Legal / privacy URLs | `https://tailscale.com/terms`, `https://tailscale.com/privacy-policy`, `https://tailscale.com/security`, `https://tailscale.com/blog/tailscale-privacy-anonymity` |
| Legal entity shown by official pages | Current footer and legal pages identify Tailscale Inc. |
| Address / identifier | No street address or registry number was found on the fetched public pages in this pass. |
| Registry / incorporation evidence | Not needed for source inclusion; OpenASN is rejecting Tailscale because it is not a public egress provider inventory. External company histories say Tailscale started in 2019, but no official registry extract was added. |
| Who is behind it | Tailscale Inc. |
| Source discovery | Official docs describe Tailscale as a Zero Trust identity-based connectivity platform. Tailscale's own privacy/anonymity post says it is not trying to be an anonymity tool and that customer traffic is end-to-end encrypted between devices; DERP relays do not decrypt traffic. |
| OpenASN data source | Not added. No source id. |
| Source quality / status | Tailscale is a mesh/private-network product, not a public consumer VPN egress list. Exit nodes are user/admin-selected within private tailnets; Tailscale also offers Mullvad over Tailscale, where the exit nodes are Mullvad-operated and already covered by Mullvad. |
| Live smoke | Official homepage/docs/legal/security/anonymity pages fetched on 2026-07-05. No parser smoke because there is no public egress inventory to parse. |
| Caveats | Do not map DERP relay infrastructure, Tailscale coordination servers, CGNAT tailnet addresses, or Tailscale-owned ASNs to `vpn`. A public IP seen behind a Tailscale exit node belongs to the user-selected exit provider or device, not to a global Tailscale VPN pool. |
| Primary source URLs | `https://tailscale.com/`, `https://tailscale.com/docs/concepts/what-is-tailscale`, `https://tailscale.com/blog/tailscale-privacy-anonymity`, `https://tailscale.com/security`, `https://tailscale.com/terms`, `https://tailscale.com/privacy-policy` |

### TP-Link VPN Pages

| Field | Detail |
|---|---|
| Public service URL | `https://www.tp-link.com/us/support/faq/3135/`, `https://www.tp-link.com/` |
| Legal / privacy URLs | `https://www.tp-link.com/us/about-us/privacy/`, `https://privacy.tp-link.com/web/official/privacy-policy`, `https://www.tp-link.com/us/about-us/kasa-terms-of-use/` |
| Legal entity shown by official pages | TP-Link pages identify TP-Link / TP-Link Systems Inc. depending on product, app, and regional context. |
| Address / identifier | No VPN-service-specific address or registry number was relevant or found in this pass. |
| Registry / incorporation evidence | Not applicable for OpenASN source inclusion; TP-Link is a networking hardware/software vendor and documentation publisher here. |
| Who is behind it | TP-Link, publishing router VPN client/server setup instructions. |
| Source discovery | Official TP-Link FAQ says the router VPN client feature routes selected devices through a third-party VPN server and that users need credentials or configuration files from their VPN provider. |
| OpenASN data source | Not added. No source id. |
| Source quality / status | TP-Link router pages are setup documentation, not an egress provider source. The actual exit depends on the third-party VPN profile the customer uploads or the private VPN server they operate. |
| Live smoke | Official TP-Link support FAQ fetched on 2026-07-05 and was last updated 2026-04-17. It contained no IP/CIDR/hostname inventory. |
| Caveats | Do not label TP-Link routers, `tplinkwifi.net`, or TP-Link support examples as VPN exits. If a TP-Link manual mentions a provider example, audit that provider separately from first-party provider sources. |
| Primary source URLs | `https://www.tp-link.com/us/support/faq/3135/`, `https://www.tp-link.com/pl/support/faq/2801/`, `https://www.tp-link.com/us/about-us/privacy/`, `https://privacy.tp-link.com/web/official/privacy-policy`, `https://www.tp-link.com/us/about-us/kasa-terms-of-use/` |

## Batch Queue

Suggested next batches, five-ish services each:

1. Batch 21+: remaining non-provider/context entries from `PROVIDER_SOURCES.md` such as Sophos guidance, Canadian Centre VPN guidance, and VPN.com.
