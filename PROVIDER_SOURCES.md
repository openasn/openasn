# Provider Source Research

Status date: 2026-07-05

This ledger records the VPN/provider enrichment pass. It is intentionally
conservative: exact IPs first, original authority preferred, licensed fallback
only when rights are clear, no account-only APIs, no bot-challenge bypasses, no
ShareAlike data, no widened `/24` or ASN inference for `vpn`.

Detailed provider/operator dossiers live in `VPN_PROVIDER_DOSSIERS.md`. Keep
this file focused on source decisions and the dossier file focused on who
operates each service, exact legal URLs, registry evidence,
incorporation/founding caveats, and OpenASN data provenance.

## Source Quality Modes

| Mode | Meaning | Default posture |
|---|---|---|
| Exact first-party IP/CIDR | Provider publishes exact IPs/CIDRs in JSON/CSV/API/configs. | Can be default when small and stable. |
| Licensed exact feed | Third party republishes exact IPs under a clean license. | Acceptable for Tier B only, with source/license noted. |
| DNS-expanded first-party hostnames | Provider publishes exact server hostnames; OpenASN resolves them locally at update time. | Opt-in `vpn_dns` only because DNS answers vary by resolver/vantage. |
| Public/volunteer relays | Current public relay endpoints, often residential-looking and high-churn. | Opt-in `public_relays` only. |
| Location-only / generated / account-only | Marketing location pages, inferred hostname patterns, authenticated APIs, or challenged endpoints. | Not added. Document and revisit only with better evidence. |

## Added Or Changed In This Pass

| Source id | Provider | URL | Group | Parser | Live smoke on 2026-07-05 |
|---|---|---|---|---|---|
| `pia_servers` | Private Internet Access | `https://serverlist.piaservers.net/vpninfo/servers/v7` | default `vpn_providers` | `pia_servers_json` | 1310 v4, 0 v6 |
| `nordvpn_servers` | NordVPN | `https://api.nordvpn.com/v2/servers?limit=0` | opt-in `vpn_heavy` | `nordvpn_servers_json` | 9455 v4, 1 v6 |
| `privadovpn` | PrivadoVPN | `https://privadovpn.com/apps/servers_export.json` | default `vpn_providers` | `privado_servers_json` | 166 v4, 0 v6 |
| `riseup_vpn` | RiseupVPN | `https://api.black.riseup.net/3/config/eip-service.json` | default `vpn_providers` | `leap_eip_service_json` | 21 v4, 0 v6 |
| `wlvpn_server_list` | WLVPN | `https://api.wlvpn.com/v2/list/wlvpnserverList.xml` | default `vpn_providers` | `wlvpn_server_list_xml` | 3483 active visible v4, 0 v6 |
| `worldvpn_servers` | WorldVPN | `https://worldvpn.net/servers` | default `vpn_providers` | `worldvpn_servers_html` | 180 exact v4 IPs -> 170 merged v4 ranges, 0 v6 |
| `surfshark_generic` | Surfshark | `https://api.surfshark.com/v4/server/clusters/generic` | opt-in `vpn_dns` | `surfshark_clusters_json` | 142 hostnames / 280 v4, 0 v6 |
| `surfshark_static` | Surfshark | `https://api.surfshark.com/v4/server/clusters/static` | opt-in `vpn_dns` | `surfshark_clusters_json` | 36 hostnames / 36 v4, 0 v6 |
| `surfshark_obfuscated` | Surfshark | `https://api.surfshark.com/v4/server/clusters/obfuscated` | opt-in `vpn_dns` | `surfshark_clusters_json` | 7 hostnames / 7 v4, 0 v6 |
| `ipvanish_openvpn` | IPVanish | `https://configs.ipvanish.com/openvpn/v2.6.0-0/configs.zip` | opt-in `vpn_dns` | `ovpn_zip_remote_hosts` | 3483 hostnames / 3448 v4, 0 v6; 31 DNS misses |
| `privatevpn_openvpn` | PrivateVPN | `https://privatevpn.com/client/PrivateVPN-TUN.zip` | opt-in `vpn_dns` | `ovpn_zip_remote_hosts` | 100 hostnames + 1 direct IP / 100 v4, 0 v6; 26 DNS misses |
| `purevpn_openvpn` | PureVPN | `https://d11a57lttb2ffq.cloudfront.net/heartbleed/router/Recommended-CA2.zip` | opt-in `vpn_dns` | `ovpn_zip_remote_hosts` | 166 hostnames / 129 v4, 0 v6 |
| `torguard_openvpn_tcp` | TorGuard | `https://torguard.net/downloads/OpenVPN-TCP-Linux.zip` | opt-in `vpn_dns` | `ovpn_zip_remote_hosts` | 52 hostnames / 430 v4, 0 v6 |
| `torguard_openvpn_udp` | TorGuard | `https://torguard.net/downloads/OpenVPN-UDP-Linux.zip` | opt-in `vpn_dns` | `ovpn_zip_remote_hosts` | 52 hostnames / 430 v4, 0 v6 |
| `fastestvpn_tcp` | FastestVPN | `https://support.fastestvpn.com/wp-admin/admin-ajax.php`, form `action=vpn_servers&protocol=tcp` | opt-in `vpn_dns` | `html_table_hostnames` | 68 hostnames / 55 v4, 0 v6 |
| `fastestvpn_udp` | FastestVPN | `https://support.fastestvpn.com/wp-admin/admin-ajax.php`, form `action=vpn_servers&protocol=udp` | opt-in `vpn_dns` | `html_table_hostnames` | 68 hostnames / 55 v4, 0 v6 |
| `vpnsecure_locations` | VPNSecure | `https://www.vpnsecure.me/vpn-locations/` | opt-in `vpn_dns` | `vpnsecure_locations_html` | 60 hostnames / 60 v4, 0 v6 |
| `tunnelbear_openvpn` | TunnelBear | `https://tunnelbear.s3.amazonaws.com/support/linux/openvpn.zip` | opt-in `vpn_dns` | `ovpn_zip_remote_hosts` | 47 hostnames / 925 resolved v4 -> 571 merged v4 ranges, 0 v6 |
| `strongvpn_locations` | StrongVPN | `https://strongtech.org/locations/` | opt-in `vpn_dns` | `strongvpn_locations_html` | 145 hostnames / 74 resolved v4 -> 59 merged v4 ranges, 0 v6; 71 DNS misses |
| `vyprvpn_openvpn` | VyprVPN | `https://support.vyprvpn.com/hc/article_attachments/46761120489229` | opt-in `vpn_dns` | `ovpn_zip_remote_hosts` | 73 hostnames / 73 v4 -> 67 merged v4 ranges, 0 v6 |
| `giganews_vyprvpn_hosts` | Giganews VyprVPN | `https://support.giganews.com/hc/en-us/articles/360039615432-What-are-the-VyprVPN-Server-Addresses` | opt-in `vpn_dns` | `html_table_hostnames` | 73 hostnames / 73 v4, 0 v6 |
| `vpnbook_openvpn` | VPNBook | `https://www.vpnbook.com/freevpn/openvpn` | opt-in `public_relays` | `vpnbook_html_hosts` | 10 hostnames / 9 v4, 0 v6; 1 DNS miss |
| `freevpn_us_servers` | FreeVPN.us | `https://www.freevpn.us/pages/server-status.html` | opt-in `public_relays` | `freevpn_us_status_html` | 17 VPN hostnames / 14 v4, 0 v6 |

DNS-expanded counts are resolver-vantage-specific. Hostname counts are the
stable parser smoke; resolved IP counts can move when provider DNS changes,
when a resolver suppresses records, or when a lookup times out.

Also verified unchanged existing sources in the same run:

| Source id | Provider | Live smoke on 2026-07-05 |
|---|---|---|
| `protonvpn` | ProtonVPN licensed feed | 823 v4, 0 v6 |
| `apple_private_relay` | Apple iCloud Private Relay | 286946 CSV rows |
| `mullvad_relays` | Mullvad | 539 v4, 532 v6 |
| `ivpn_servers` | IVPN | 169 v4, 0 v6 |
| `airvpn_status` | AirVPN | 445 v4, 1004 v6 |
| `windscribe_servers` | Windscribe | 1023 v4, 0 v6 |
| `vpngate` | VPN Gate | 98 v4, 0 v6 |

End-to-end sample classifications from the live run:

| Source id | Sample IP | Result |
|---|---|---|
| `privadovpn` | `45.38.15.4` | `vpn`, provider `PrivadoVPN` |
| `riseup_vpn` | `51.15.9.205` | `vpn`, provider `RiseupVPN` |
| `surfshark_generic` | `2.56.189.114` | `vpn`, provider `Surfshark` |
| `ipvanish_openvpn` | `23.248.176.130` | `vpn`, provider `IPVanish` |
| `privatevpn_openvpn` | `2.58.241.51` | `vpn`, provider `PrivateVPN` |
| `purevpn_openvpn` | `5.254.106.8` | `vpn`, provider `PureVPN` |
| `torguard_openvpn_tcp` | `2.58.46.138` | `vpn`, provider `TorGuard` |
| `fastestvpn_tcp` | `5.181.233.122` | `vpn`, provider `FastestVPN` |
| `vpnsecure_locations` | `103.106.228.223` | `vpn`, provider `VPNSecure` |
| `tunnelbear_openvpn` | `5.253.206.35` | `vpn`, provider `TunnelBear` |
| `strongvpn_locations` | `176.67.81.250` | `vpn`, provider `StrongVPN` |
| `vyprvpn_openvpn` | `31.6.10.254` | `vpn`, provider `VyprVPN` |
| `giganews_vyprvpn_hosts` | `31.6.10.253` | `vpn`, provider `Giganews VyprVPN` |
| `wlvpn_server_list` | `103.209.254.114` | `vpn`, provider `WLVPN` |
| `worldvpn_servers` | `116.203.253.222` | `vpn`, provider `WorldVPN` |
| `vpnbook_openvpn` | `142.4.216.196` | `vpn`, provider `VPNBook` |
| `freevpn_us_servers` | `5.189.254.17` | `vpn`, provider `FreeVPN.us` |
| `vpngate` | `1.244.51.251` | `vpn`, provider `VPN Gate` |

## Provider Audit Ledger

### Implemented

| Provider/service | Decision | Evidence and notes |
|---|---|---|
| Apple iCloud Private Relay | Existing Tier B `relay`, not `vpn`. | Apple publishes `https://mask-api.icloud.com/egress-ip-ranges.csv`. These are real-user relay exits and must not be treated as hostile VPN infrastructure. |
| ProtonVPN | Existing default Tier B via licensed feed. | `https://raw.githubusercontent.com/tn3w/ProtonVPN-IPs/master/protonvpn_ips.txt`. Proton's official logicals API still requires client/session auth for anonymous callers, so the licensed exact feed remains the clean source. |
| Mullvad | Existing default Tier B. | `https://api.mullvad.net/www/relays/all/` returns exact active relays. |
| Mozilla VPN / paid Firefox VPN | Covered by Mullvad source. | Mozilla documents that Mozilla VPN uses Mullvad infrastructure; Mullvad also published the partnership. We cannot distinguish Mozilla users from Mullvad users at IP level. |
| IVPN | Existing default Tier B. | `https://api.ivpn.net/v4/servers.json` returns exact server IP fields. |
| Private Internet Access | Updated default Tier B from v6 to v7. | `https://serverlist.piaservers.net/vpninfo/servers/v7` is the current first-party client server list. |
| AirVPN | Existing default Tier B. | `https://airvpn.org/api/status/` returns exact server entry IPs. |
| Windscribe | Existing default Tier B. | `https://assets.windscribe.com/serverlist/mob-v2/1/0` returns exact node/ping IPs. |
| NordVPN | Existing opt-in heavy, upgraded to v2. | `https://api.nordvpn.com/v2/servers?limit=0` is first-party and exact, but large enough to keep behind `vpn_heavy`. |
| PrivadoVPN | Added default Tier B. | `https://privadovpn.com/apps/servers_export.json`; a PrivadoVPN developer publicly described this as the official server list, updated hourly. |
| RiseupVPN | Added default Tier B. | `https://api.black.riseup.net/3/config/eip-service.json`; OONI documents the LEAP provider API shape and that it advertises gateways. |
| WLVPN | Added default Tier B. | `https://api.wlvpn.com/v2/list/wlvpnserverList.xml` is a public WLVPN/IPVanish white-label server API with exact `ip` attributes. WLVPN's own site says the service is powered by IPVanish and part of VIPRE Security Group / Ziff Davis, so attribution is `WLVPN` rather than a reseller brand. |
| WorldVPN | Added default Tier B. | `https://worldvpn.net/servers` is a first-party public server table with exact IPs and `*.ocservvpn.com` hostnames. Parser reads only table rows and exact IP cells; no DNS expansion. |
| Surfshark | Added opt-in DNS-expanded Tier B. | First-party cluster APIs publish `connectionName` hostnames: generic/static/obfuscated. Double-hop was empty live on 2026-07-05. |
| IPVanish | Added opt-in DNS-expanded Tier B. | First-party OpenVPN config archive `https://configs.ipvanish.com/openvpn/v2.6.0-0/configs.zip` contains thousands of `remote` hostnames. |
| PrivateVPN | Added opt-in DNS-expanded Tier B. | `https://privatevpn.com/client/PrivateVPN-TUN.zip` contains OpenVPN remotes. |
| PureVPN | Added opt-in DNS-expanded Tier B. | `https://d11a57lttb2ffq.cloudfront.net/heartbleed/router/Recommended-CA2.zip` contains router OpenVPN remotes. |
| TorGuard | Added opt-in DNS-expanded Tier B. | Public TCP/UDP OpenVPN archives fetched cleanly; challenged `servers.json` is not used. |
| FastestVPN | Added opt-in DNS-expanded Tier B. | Public support page `https://support.fastestvpn.com/vpn-servers/` uses the first-party AJAX endpoint now in the manifest. |
| VPNSecure | Added opt-in DNS-expanded Tier B. | `https://www.vpnsecure.me/vpn-locations/` publishes per-server labels and status; parser keeps only `status--up` hosts. |
| TunnelBear | Added opt-in DNS-expanded Tier B. | `https://www.tunnelbear.com/blog/setting-up-tunnelbear-on-linux/` links the first-party public OpenVPN ZIP at `https://tunnelbear.s3.amazonaws.com/support/linux/openvpn.zip`. |
| StrongVPN | Added opt-in DNS-expanded Tier B. | `https://strongtech.org/locations/` publishes exact `vpn-*.reliablehosting.com` speedtest/server hostnames from the StrongVPN/StrongTech first-party site. |
| VyprVPN | Added opt-in DNS-expanded Tier B. | `https://support.vyprvpn.com/hc/en-us/articles/360038096131-Where-can-I-find-the-OpenVPN-files` links the public first-party OpenVPN ZIP at `https://support.vyprvpn.com/hc/article_attachments/46761120489229`; parser extracts exact `*.vyprvpn.com` remotes and clients resolve locally. |
| Giganews VyprVPN | Added opt-in DNS-expanded Tier B. | `https://support.giganews.com/hc/en-us/articles/360039615432-What-are-the-VyprVPN-Server-Addresses` publishes the exact `*.vpn.giganews.com` hostnames used by Giganews accounts with bundled VyprVPN, and says IPs are subject to change. |
| VPN Gate | Existing opt-in public relay Tier B. | `http://www.vpngate.net/api/iphone/` is the official public relay API. |
| VPNBook | Added opt-in public relay Tier B. | `https://www.vpnbook.com/freevpn/openvpn` publishes current OpenVPN hostnames. |
| FreeVPN.us | Added opt-in public relay Tier B. | `https://www.freevpn.us/pages/server-status.html` publishes live first-party status rows. Parser keeps only OpenVPN, WireGuard, and PPTP/L2TP hosts and excludes SSH Tunnel / V2Ray rows. |

### Researched, Not Added

| Provider/service | Status | Why not added yet |
|---|---|---|
| ExpressVPN | Re-audited, not added. | Official manual OpenVPN pages send users to the authenticated ExpressVPN setup page to download per-location `.ovpn` files. The public Linux setup page exposes no `expressnetw.com` catalog, and Gluetun's hardcoded hostnames remain a third-party inventory rather than provider-published source data. |
| CyberGhost | Re-audited, not added. | Official support pages require users to log in, choose OpenVPN type/location/server type, then download an account-generated ZIP. Public examples and Gluetun's generated `cg-dialup.net` patterns are not an exact provider-published catalog. Owned by Kape. |
| ZenMate | Re-audited, not added separately. | Current ZenMate pages and migration notice route paid VPN service through CyberGhost apps. No independent exact source was found, and CyberGhost cannot distinguish ZenMate users beyond aggregate app-auth counts. |
| Perfect Privacy | Promising but still blocked. | Gluetun indicates a first-party OpenVPN ZIP path under `www.perfect-privacy.com`, but official home/legal/ZIP URLs timed out from this environment again on 2026-07-05. Not shipped without a fetched body, parser output, and legal/source smoke. |
| hide.me | Re-audited, not added. | Official network page lists locations/self-managed claims only. Official OpenVPN docs place config ZIPs behind `member.hide.me` Premium/member login, and unauthenticated `member.hide.me/en/server-status` redirects to login. No public exact IP/CIDR/hostname source verified. |
| OVPN.com | Promising but not added yet. | Public configuration page can generate `.conf` files after a CSRF-tokened POST and returned `pool-1.prd.at.ovpn.com` in a live smoke, but the workflow is multi-request/stateful and rate-limited (`x-ratelimit-limit: 6`). It needs a dedicated resolver design before shipping. |
| HMA / HideMyAss | Not added. | Current official installation page says Linux is no longer supported. Historical/OpenVPN blog links and Gluetun point at `https://vpn.hidemyass.com/vpn-config/...`, but `vpn.hidemyass.com` did not resolve here. |
| VPN Unlimited / KeepSolid | Not added. | Official manuals generate/download OpenVPN files from the authenticated User Office. Gluetun notes hardcoded data from a user-provided ZIP behind a login wall. Not a redistributable or unauthenticated source. |
| SlickVPN | Not added. | Gluetun hardcodes hostnames because the public listing degraded. Hardcoded third-party inventory is not a source. |
| CalyxVPN | Not added in this pass. | LEAP-shaped endpoint `https://api.calyx.net/3/config/eip-service.json` timed out from this environment. Retry later; parser already supports LEAP EIP JSON. |
| Cloudflare WARP / 1.1.1.1 | Context-only, not `vpn`. | Cloudflare publishes global proxy IP ranges, already held as context-only `cloudflare_ranges`. Cloudflare One docs explicitly say Cloudflare One Client/WARP egress ranges are not published and are not the same as the public Cloudflare IP Ranges page. |
| Apple "VPN" / Private Relay | Covered as `relay`. | Same source as above; semantics are not `vpn`. |
| Google One VPN | Not added. | Product has been discontinued; no current exact public egress source. |
| Firefox built-in/free VPN | Not added separately. | Paid Mozilla VPN is Mullvad-backed. Newer built-in/browser-only Firefox VPN does not have a verified separate exact egress source in this pass. |
| Opera VPN | Not added. | Opera Norway AS operates the free browser VPN on Opera infrastructure; VPN Pro is provided in collaboration with Nord. Public pages and audit posts do not publish exact exit IPs/CIDRs. Reverse-engineered SurfEasy/Opera proxy flows require app-style registration/client keys, and public `opera-proxy.net` hostnames did not resolve here. |
| Brave VPN | Not added. | Brave Firewall + VPN is powered by Guardian. Guardian exposes a public country/city region endpoint with server counts, but no IPs/CIDRs/hostnames; connection APIs are credentialed. No OpenASN-compatible exact source verified. |
| Hotspot Shield | Not added. | Anchorfree/Pango/Point Wild family. Official legal pages identify operators and server-location marketing, but no public exact egress inventory. Gluetun has no Hotspot Shield provider because it also requires a public server/config source. |
| Touch VPN | Not added. | VPN Proxy Pro, LLC / TouchVPN LLC within the Pango/Point Wild family. Official pages and stores publish server counts/locations only, not exact IPs, CIDRs, or hostnames. |
| Bitdefender VPN | Not added. | Official privacy/support pages say IPVanish processes VPN delivery and Bitdefender does not provide router configs, `.ovpn`, `.conf`, or direct-auth details. Existing `ipvanish_openvpn` may catch shared infrastructure, but there is no exact Bitdefender-branded egress map. |
| Kaspersky VPN | Not added. | Product pages publish server/location counts and support pages document account-generated OpenVPN/WireGuard router configs through My Kaspersky. Those configs are authenticated/customer-specific, so no public exact egress source was accepted. |
| ESET VPN | Not added. | Product pages publish country/protocol claims and router docs require ESET HOME login before downloading WireGuard/OpenVPN configs. No unauthenticated exact IP/CIDR/hostname inventory was verified. |
| F-Secure VPN / Freedome | Not added. | Official privacy docs say the new VPN feature uses Pango as a third-party provider and help pages publish protocols/ports, but support material does not expose router configs or exact exits. No brand-specific exact source was verified. |
| Avast SecureLine / AVG VPN | Not added. | Official VPN policies say the apps process selected/assigned location, protocol, and server IP as internal metadata, but Avast/AVG do not publish the inventory and community support says router/OpenVPN config files are not officially supported. |
| Betternet | Not added. | Pango/Point Wild brand. Official pages and app stores publish marketing counts only, and Betternet terms prohibit attempting to compile/use/distribute the service IP list. No public exact egress source was accepted. |
| VPN 360 | Not added. | Pango/Point Wild brand. Product/app/support pages confirm shared VPN IP pools and inconsistent server/location counts, while terms prohibit IP-list compilation. No public exact source was verified. |
| UltraVPN | Not added. | Pango/Point Wild brand operated by Fast VPN Pro, S. de R.L.; pages publish virtual-location and capacity claims, and terms prohibit service IP-list compilation. No config/feed/API inventory was found. |
| Norton Secure VPN | Not added. | Gen Digital brand. Product pages publish country/city locations, server counts, IP rotation, and privacy details, but no exact public IP/CIDR/hostname source. Third-party hostname dumps were rejected as non-authoritative. |
| McAfee VPN | Not added. | McAfee legal/about pages and support snippets were checked; available material is virtual-location/product behavior only. TunnelBear remains a separate McAfee-owned service and cannot be used to infer McAfee VPN exits. |
| Urban VPN | Not added. | Urban Cyber Security Inc. publishes legal/contact details and a FAQ claiming 80+ countries / 632 locations, with premium dedicated servers, but only location pages/sitemaps were public. No exact IP/CIDR/hostname inventory or config archive was verified. |
| Hola VPN | Not added. | Hola VPN Ltd. documents a P2P/value-exchange free network, Bright Data resource sharing, and premium dedicated servers. Public sitemap/location pages are country marketing pages only. Do not label Hola peers or Bright Data customer traffic as `vpn` without an exact first-party relay inventory. |
| Bright VPN | Not added. | Bright Data Ltd. operates BrightVPN as a free VPN tied to Bright Data's peer/proxy network economics. Public pages explain that users allow Bright Data to use their connection, and the server-list page is location marketing only. No exact public egress list was found. |
| Mysterium VPN | Not added. | UAB MN Intelligence operates the VPN product; Mysterium Network/BlockDev AG publishes a public discovery API with node proposal metadata. Live API smoke returned thousands of proposals but no exact exit IP field, only ASN/ISP/IP-type and NATS broker contacts. Residential/decentralized semantics need a separate model before any `vpn` mapping. |
| Planet VPN | Not added. | FREE VPN PLANET S.R.L. publishes legal/company details and location/server marketing. OpenVPN/L2TP docs route users through premium/account configuration (`/cabinet/configuration`) and support attachments were screenshots, not configs. No unauthenticated exact source was verified. |
| Turbo VPN | Not added. | Innovative Connecting Pte. Limited / UEN `201812738K`; official pages publish legal text, app links, and location/server marketing (`/servers`, `/vpn-server/*`) but no exact IP/CIDR/hostname feed or public config archive. |
| 1ClickVPN | Not added. | `www.1clickvpn.com` did not expose a clear legal operator in verified pages; separate `1clickvpn.net` terms name Kodice LLC. Both publish browser/product/location marketing only; no exact exits verified. |
| VeePN | Not added. | VeePN Corp., Panama; official server page lists 2,600+ servers / 109 locations / 85 countries, while legal pages name Laraun Limited and IT Research LLC for payments. No exact public egress source verified. |
| SkyVPN | Not added. | SkyVPN, Inc.; terms say Hong Kong office control and product pages claim 3000+ servers / 30M users, but no exact IP/CIDR/hostname list, config archive, or server API was found. |
| X-VPN | Not added. | LIGHTNINGLINK NETWORKS PTE. LTD.; official pages claim 10,000+ servers / 80+ countries / 250+ locations. Router OpenVPN configs are premium/account-gated; no public exact source verified. |
| Total VPN | Not added. | Total Security Limited / Total Security U.S. LLC / Point Wild legal pages and product pages were checked. Public material is legal text, help pages, and country/server-count marketing only; no exact IP/CIDR/hostname/config source verified. |
| SetupVPN | Not added. | SetupVPN Inc. public pages, FAQ, registration/download routes, and `baseserver.io` download endpoints were checked. FAQ says locations change daily and no exact public inventory is published. |
| uVPN | Not added. | Product page only; no exact source verified. |
| GooseVPN | Not added. | Product page only; no exact source verified. |
| MEGA VPN | Not added. | Official VPN/product/legal pages identify the responsible MEGA entities and list countries/cities for consumer selection, but no public exact VPN exit IP/CIDR/hostname/API/config archive was verified. `https://mega.io/server-locations` is cloud-storage data-centre geography, not VPN egress provenance. |
| Spaceship/FastVPN | Not added as a separate provider. | Spaceship and Namecheap FastVPN support docs point users at `*.wlvpn.com` server names from the FastVPN account panel, and WLVPN exact backend IPs are covered by `wlvpn_server_list`. OpenASN deliberately labels the backend `WLVPN` instead of guessing whether a hit came from Spaceship, Namecheap, or another reseller. |
| BullVPN | Not added. | PERSEC COMPANY LIMITED publishes location/server-count marketing and app/setup pages, but common API/config paths returned 404 or site pages. No public exact IP/CIDR/hostname inventory was verified. |
| hidemy.name / hide.mn | Not added. | Public pages list network size and router support, but `.ovpn` downloads/server IP settings require an access code from payment or trial flow. Account-gated configs are not OpenASN source data. |
| FineVPN | Not added. | QualityNetwork OÜ publishes legal/contact pages and many country/use-case pages, but exact WireGuard/Xray configuration files are behind signup/trial/account flows. No public exact egress source verified. |
| ZoogVPN | Not added. | Official pages identify Zoog Services IKE/PC and 200+ servers across 35+ countries, but exact setup/server APIs under `api-d.zoogvpn.com` require JWT auth. Public setup pages and third-party config mirrors are not accepted source data. |
| SuperVPN | Not added. | NETWORKSUPER LTD / company number `12451849`; official site/app stores expose product, privacy, contact, and auto-fastest-server UX only. No public exact IP/CIDR/hostname source verified. |
| VPN Super | Not added. | Terms name VPN Super Inc; privacy covers Super Unlimited Inc., VPN Super Inc., Free VPN Pte. Ltd, and Mobile Jump Pte. Ltd. Public server pages list locations only. The Windows MSI was inspected offline; embedded `server_list_loc.json` is localization data, not an exit inventory. |
| FreeVPN.org / FreeVPNApp.org | Not added. | Free VPN LLC app-store brand with current desktop downloads and ActMobile/`dft-cdn42.net` infrastructure visible in the public client package. Not accepted because the useful hostnames/region data are derived from proprietary client inspection and terms prohibit reverse engineering; no clean exact source with redistribution rights. |
| VPNLY | Not added. | Free VPN Unlimited AG / CHE-467.694.739; official pages list countries/locations only. A public browser-extension S3 config contained proxy credentials and was rejected; secrets are not reproduced and it is not a clean VPN egress source. |
| SuperFree VPN | Not added. | Official pages expose product/location/account flows, not exact exits. Terms disclose participation in a third-party bandwidth-sharing network including Infatica P2B, so peer/residential semantics must not be mapped to provider-operated `vpn` exits. |
| FreeVPNApp.org / FreeVPNApp.io | Not added. | `freevpnapp.org` is covered with FreeVPN.org above. `freevpnapp.io` was only a placeholder/coming-soon page in this pass and exposed no source data. |
| VpnHood | Not added. | Open-source VPN engine/client/server and Connect app. Public-server support exists, but current app flows use access keys/store/account integration and no clean exact egress inventory was verified. |
| FreeVPN724 | Not added as separate provider. | `worldvpn.net/servers` is accepted as the backend provider source. FreeVPN724 is a free-client/front-door brand powered by WorldVPN and does not need a separate source id unless it publishes a distinct exact inventory. |
| StarVPN | Not added. | Residential/static/mobile/datacenter VPN/proxy provider. Router/client configs are generated from the member dashboard after selecting IP type, country, region, and ISP; no unauthenticated exact egress source verified. |
| GoFlyVPN / RivoVPN | Not added. | SPA, static privacy markdown, Google Play/App Store metadata, and public APK/EXE download endpoints were checked. Web copy says nodes are dynamically assigned by the server; no exact public egress inventory was found. |
| iTop VPN | Not added. | iTop Inc. legal/about pages and Apple app metadata were checked. The public "VPN server list" is country-level marketing for 3200+ servers / 100+ locations, not exact IP/CIDR/hostname data. |
| Radmin VPN | Not added. | Famatech's Radmin VPN is a virtual LAN/remote-network product for connecting computers into one local network, not a public internet egress VPN source. |
| OpenVPN Connect | Not added. | Client software, not a provider. |
| SoftEther | Not added. | VPN software/project. VPN Gate is the public relay service and is already covered. |
| Tailscale | Not added. | Mesh/zero-trust private networking product, not a public VPN egress provider. |
| TP-Link VPN pages | Not added. | Router/vendor documentation, not a provider source. |
| Sophos VPN explainer | Not added. | Cybersecurity documentation, not a provider source. |
| Canadian Centre VPN guidance | Not added. | Government guidance, not a provider source. |
| VPN.com | Not added. | Review/marketplace site, not a provider source. |

## Future Implementation Rules

1. Add a manifest source only when the endpoint has exact IP/CIDR tokens or exact provider-published server hostnames.
2. Keep DNS-expanded sources opt-in. They are useful, but not byte-stable across resolvers.
3. Do not use account-only APIs, app/session impersonation, captchas, Cloudflare challenges, or private client state.
4. Do not import generated hostname patterns unless a first-party page/API publishes the actual hostnames.
5. Public/free relay networks stay opt-in because they can be high-churn and residential-looking.
6. Every new parser needs unit tests plus at least one live source smoke showing nonzero ranges and a real lookup classification.
