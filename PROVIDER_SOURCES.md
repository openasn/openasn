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
| `ovpn_status_servers` | OVPN | `https://status.ovpn.com/datacenters/{slug}/servers` | default `vpn_providers` | `ovpn_status_servers_json` | 32 datacenter JSON endpoints / 97 rows / 96 unique v4 -> 34 merged v4 ranges, 0 v6 |
| `anonine_status` | Anonine | `https://anonine.com/www/server-status` | default `vpn_providers` | `anonine_status_json` | 38 status rows / 296 exact v4 -> 82 merged v4 ranges, 0 v6 |
| `azirevpn_locations` | AzireVPN | `https://api.azirevpn.com/v3/locations` | opt-in `vpn_dns` | `azirevpn_locations_json` | 62 pool hostnames / 64 resolved IPs -> 63 v4 + 1 v6 ranges |
| `vpnac_status` | VPN.AC | `https://vpn.ac/status` | opt-in `vpn_dns` | `vpnac_status_html` | 130 status hostnames / 132 resolved v4 -> 130 merged v4 ranges, 0 v6 |
| `trustzone_servers` | Trust.Zone | `https://trust.zone/servers` | opt-in `vpn_dns` | `trustzone_servers_html` | 70 server hostnames / 90 resolved v4 -> 86 merged v4 ranges, 0 v6 |
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
| `slickvpn_locations` | SlickVPN | `https://www.slickvpn.com/locations/` | opt-in `vpn_dns` | `slickvpn_locations_html` | 11 config-linked hostnames / 11 v4, 0 v6 |
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
| `slickvpn_locations` | `151.236.14.57` | `vpn`, provider `SlickVPN` |
| `wlvpn_server_list` | `103.209.254.114` | `vpn`, provider `WLVPN` |
| `worldvpn_servers` | `116.203.253.222` | `vpn`, provider `WorldVPN` |
| `ovpn_status_servers` | `5.181.234.131` | `vpn`, provider `OVPN` |
| `anonine_status` | `198.57.26.18` | `vpn`, provider `Anonine` |
| `azirevpn_locations` | `200.110.149.179` | `vpn`, provider `AzireVPN` |
| `vpnac_status` | `103.231.88.140` | `vpn`, provider `VPN.AC` |
| `trustzone_servers` | `102.165.60.216` | `vpn`, provider `Trust.Zone` |
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
| OVPN | Added default Tier B. | `https://status.ovpn.com` is the official OVPN status page; its Vue `Servers-List` component calls `/datacenters/{slug}/servers` JSON endpoints with exact server IPs and `online` flags. Parser keeps online exact IPs only. |
| Anonine | Added default Tier B. | `https://anonine.com/www/server-status` is the first-party JSON endpoint called by Anonine's public Network page. Parser reads exact `primary_ip` and `servers[].ips`; host aliases are ignored because exact IPs are available. |
| AzireVPN | Added opt-in DNS-expanded Tier B. | Official API docs publish unauthenticated `https://api.azirevpn.com/v3/locations`; parser reads `locations[].pool` hostnames and clients resolve them locally. |
| VPN.AC | Added opt-in DNS-expanded Tier B. | `https://vpn.ac/status` publishes exact `*.vpn.ac` node hostnames in the official status table; `/ovpn/` config bundles corroborate the same hostname namespace. |
| Trust.Zone | Added opt-in DNS-expanded Tier B. | `https://trust.zone/servers` publishes exact `*.trust.zone` server hostnames; setup pages hide `.ovpn` files behind login, so the public server hostnames are the source. |
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
| SlickVPN | Added opt-in DNS-expanded Tier B. | `https://www.slickvpn.com/locations/` says it lists active VPN servers and links public 2025 OpenVPN configs under `members.newsdemon.com`. Parser reads only config-linked visible `gw*.slickvpn.com` hostnames from that page. The linked config files are corroboration only because the Amsterdam page label (`gw2.ams3`, resolves) disagreed with the linked config remote (`gw2.ams2`, did not resolve) in the 2026-07-05 smoke. |
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
| HMA / HideMyAss | Not added. | Current official installation page says Linux is no longer supported. Historical/OpenVPN blog links and Gluetun point at `https://vpn.hidemyass.com/vpn-config/...`, but `vpn.hidemyass.com` did not resolve here. |
| VPN Unlimited / KeepSolid | Not added. | Official manuals generate/download OpenVPN files from the authenticated User Office. Gluetun notes hardcoded data from a user-provided ZIP behind a login wall. Not a redistributable or unauthenticated source. |
| CalyxVPN | Not added in this pass. | CalyxOS, F-Droid, Calyx legal pages, and LEAP pages establish the Calyx Institute/LEAP product, but live probes of `https://api.calyx.net/3/config/provider.json`, `https://api.calyx.net/3/config/eip-service.json`, the same paths on `:4430`, and `https://calyx.net/3/config/eip-service.json` timed out from this environment. Retry later; parser already supports LEAP EIP JSON. |
| Cloudflare WARP / 1.1.1.1 | Context-only, not `vpn`. | Cloudflare publishes global proxy IP ranges, already held as context-only `cloudflare_ranges`. Cloudflare One egress docs were rechecked on 2026-07-05 and explicitly say Cloudflare One Client/WARP egress ranges are not published and are not the same as the public Cloudflare IP Ranges page. |
| Apple "VPN" / Private Relay | Covered as `relay`. | Same source as above; semantics are not `vpn`. |
| Google One VPN / VPN by Google | Not added. | Google One VPN was discontinued on 2024-06-20. Current Pixel VPN by Google is product documentation only; no public exact egress IP/CIDR/hostname source was found. |
| Firefox built-in/free VPN | Not added separately. | Paid Mozilla VPN is Mullvad-backed. Newer built-in/browser-only Firefox VPN does not have a verified separate exact egress source in this pass. |
| Opera VPN | Not added. | Opera Norway AS operates Opera services. Current Free VPN and VPN Pro pages were rechecked on 2026-07-05 and publish browser/device scope, server-count/location marketing (Free VPN 100+ servers / 3 general locations; VPN Pro 3,000+ servers / 47+ locations), but no exact exit IPs/CIDRs/hostnames. Reverse-engineered SurfEasy/Opera proxy flows require app-style registration/client keys, and public `opera-proxy.net` hostnames did not resolve here. |
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
| Ivacy | Promising but not added. | Official browser-rendered server list publishes exact `*.dns2use.com` hostnames, and official support links S3 RAR config artifacts, but local/gem fetches of support pages returned 403 and the artifacts are RAR, which OpenASN's dependency-free ZIP parser does not support. |
| SaferVPN | Not added. | Official site/support returned 403 and current public material did not expose a first-party exact IP/CIDR/hostname source. Historical third-party router/config references are discovery leads only, not OpenASN source data. |
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
| OpenVPN Connect | Not added. | Client software, not a provider. The exit depends on the imported organization/provider profile. |
| SoftEther | Not added. | VPN software/project. VPN Gate is the public relay service built on SoftEther and is already covered. |
| Tailscale | Not added. | Mesh/zero-trust private networking product, not a public VPN egress provider. Mullvad over Tailscale exits are Mullvad-operated and already covered by Mullvad. |
| TP-Link VPN pages | Not added. | Router/vendor documentation, not a provider source. The exit depends on the third-party VPN profile or private server configured by the user. |
| Sophos VPN explainer | Not added. | Cybersecurity documentation, not a provider source. |
| Canadian Centre VPN guidance | Not added. | Government guidance, not a provider source. |
| VPN.com | Not added. | Review/marketplace site, not a provider source. |

## Verified Crawlers (added 2026-09-05)

The agent-era thesis made concrete: signed agents are verified by Web Bot Auth, everything
else is classified by network origin — and PROVIDER ATTRIBUTION is what lets a site allow
Googlebot while throttling anonymous cloud bots.

**Design (no verdict-enum change).** A source may declare an optional `role`. The verdict
stays `hosting` — a crawler egress genuinely IS a datacenter — while the operator id rides
alongside as `Result#crawler` plus a context flag. `Result::VERDICTS` remains closed and
append-only (D-IMPL-6).

**Attribution is read from a separate role index, not the verdict ladder.** This is
load-bearing, and the measurements are why:

| Feed | Overlap with a cloud recipe OpenASN already ships |
|---|---|
| Bingbot | 27 of 28 prefixes inside Azure ServiceTags |
| GPTBot / ChatGPT-User / OAI-SearchBot | 21/21, 207/207, 35/35 — all inside Azure |
| ClaudeBot | spans AWS + GCP + Azure at once; 20 of 26 entries are single `/32` hosts |
| Googlebot | 23 of 317 inside GCP `cloud.json` (the geo-crawl `/28`s) |
| Applebot | 0 — the only operator identifiable by ASN alone (AS714) |

Crawler space is almost entirely borrowed. If attribution came from the ladder, whichever
cloud overlay indexed first would swallow the entire agent web.

**Two roles, deliberately not one.**

| Role | Meaning | Examples |
|---|---|---|
| `verified_crawler` | Autonomous software on its own schedule; honors robots.txt; nobody is waiting. | Googlebot, GPTBot, ClaudeBot, Applebot, CCBot, DuckDuckBot |
| `verified_fetcher` | A PERSON asked for this page and is waiting. These deliberately do not follow all robots.txt directives. | ChatGPT-User, Perplexity-User, Google user-triggered fetchers, Google-Agent, Amzn-User |

Collapsing them would tell an app that a live user's request is well-behaved automation and
invite it to throttle a human — the exact false positive this project exists to avoid.

### Added (live-smoked 2026-09-05, counts are merged ranges)

| Source id | Operator | URL | Role | Default | v4 / v6 |
|---|---|---|---|---|---|
| `google_common_crawlers` | Googlebot | `developers.google.com/static/crawling/ipranges/common-crawlers.json` | crawler | on | 28 / 8 |
| `google_special_crawlers` | Google AdsBot/AdSense/Safety | `.../special-crawlers.json` | crawler | on | 9 / 8 |
| `google_user_triggered_fetchers_google` | Google fetchers | `.../user-triggered-fetchers-google.json` | fetcher | on | 17 / 20 |
| `google_user_triggered_agents` | Google-Agent (Web Bot Auth) | `.../user-triggered-agents.json` | fetcher | on | 5 / 1 |
| `openai_gptbot` | OpenAI GPTBot | `openai.com/gptbot.json` | crawler | on | 14 / 0 |
| `openai_chatgpt_user` | OpenAI ChatGPT-User | `openai.com/chatgpt-user.json` | fetcher | on | 184 / 0 |
| `openai_searchbot` | OpenAI OAI-SearchBot | `openai.com/searchbot.json` | crawler | on | 30 / 0 |
| `openai_adsbot` | OpenAI OAI-AdsBot | `openai.com/adsbot.json` | crawler | on | 2 / 0 |
| `anthropic_bots` | Anthropic (ClaudeBot + Claude-User + Claude-SearchBot) | `claude.com/crawling/bots.json` | crawler | on | 26 / 0 |
| `applebot` | Applebot | `search.developer.apple.com/applebot.json` | crawler | on | 18 / 0 |
| `commoncrawl_ccbot` | Common Crawl CCBot | `index.commoncrawl.org/ccbot.json` | crawler | on | 3 / 1 |
| `duckduckbot` | DuckDuckBot | `duckduckgo.com/duckduckbot.json` | crawler | on | 479 / 0 |
| `perplexitybot` | PerplexityBot | `www.perplexity.ai/perplexitybot.json` | crawler | on | 8 / 0 |
| `perplexity_user` | Perplexity-User | `www.perplexity.ai/perplexity-user.json` | fetcher | on | 4 / 0 |
| `bingbot` | Microsoft Bingbot | `www.bing.com/toolbox/bingbot.json` | crawler | opt-in | 27 / 0 |
| `google_infra` | Google infrastructure | `www.gstatic.com/ipranges/goog.json` | (none) | opt-in | 98 / 15 |
| `google_user_triggered_fetchers_gae` | shared App Engine egress | `.../user-triggered-fetchers.json` | (none) | opt-in | 50 / 58 |
| `amazonbot` | Amazonbot | `developer.amazon.com/amazonbot/ip-addresses/` | crawler | opt-in | 524 / 0 |
| `amzn_searchbot` | Amzn-SearchBot | `.../searchbot-ip-addresses/` | crawler | opt-in | 512 / 0 |
| `amzn_user` | Amzn-User | `.../live-ip-addresses/` | fetcher | opt-in | 1023 / 0 |

Live classification check against the shipped dataset: `66.249.66.1` -> hosting/googlebot
AS15169; `20.171.207.1` -> hosting/gptbot AS8075 (Azure); `216.73.216.1` -> hosting/claudebot
AS16509 (AWS); `17.241.219.1` -> applebot AS714; `8.8.8.8` -> provider `google-infra`, crawler
nil (goog.json carries no role, by design).

### Deliberate non-additions

| Candidate | Decision | Evidence |
|---|---|---|
| DuckAssistBot (`duckduckgo.com/duckassistbot.json`) | Reject | BYTE-IDENTICAL to `duckduckbot.json` (32,101 bytes, same MD5, same creationTime). DuckDuckGo publishes one shared egress pool; a second source would imply an IP-level search-vs-AI distinction the operator does not make. |
| Meta / Facebook crawlers | Reject | `developers.facebook.com/docs/sharing/webmasters/crawler/` names only user-agent strings and publishes no addresses. An `AS32934` origin-set query is a registry lookup, not a first-party recognition list. Verified: `57.141.0.1` gets no attribution. |
| Google `user-triggered-fetchers.json` | Added WITHOUT a role | These resolve to `*.gae.googleusercontent.com`: shared App Engine egress running arbitrary tenant code. Attributing it to Google as a verified fetcher would be a false statement about whoever's app is actually calling. 1058 prefixes; 0 inside GCP `cloud.json`. |
| `goog.json` | Added WITHOUT a role | Infrastructure, not a crawler list. Contains `8.8.8.0/24` (Public DNS) and aggregated `/15`–`/12` blocks, and is a superset of GCP customer space the `gcp` recipe already covers precisely. Answers the open question in the `gcp` recipe note: `cloud.json` stays the default, `goog.json` stays opt-in. |
| Bingbot | Added but opt-in | An EVIDENCE gap, not a technical one. Bing Webmaster help is a JS SPA serving no prose to a plain fetcher, and the only first-party text retrievable says the opposite — Bing Webmaster Blog, Dec 2018: "Since Bing does not release the list of IPs". Promote to default once a current Microsoft page can be quoted. |

### Traps future maintainers should not rediscover

1. **Google's crawler URLs moved.** The legacy `/search/apis/ipranges/googlebot.json` still
   answers, but the docs now point at `/static/crawling/ipranges/common-crawlers.json`.
2. **`www.anthropic.com/claudebot.json` does not exist.** It 404s with a 59 KB Next.js error
   page — which an earlier run stored as if it were the feed. The real feed is
   `claude.com/crawling/bots.json`, and it is COMBINED: ClaudeBot, Claude-User and
   Claude-SearchBot cannot be separated by IP.
3. **Freshness signals are inconsistent and contradictory.** Bing's in-body `creationTime` is
   frozen at 2024-01-03 while its HTTP `Last-Modified` is current — use the header. Anthropic
   serves no `Last-Modified` at all and its `creationTime` is Z-suffixed where everyone else
   emits naive microseconds — use the body. They are exact opposites.
4. **Only Google publishes IPv6.** Bing, OpenAI, Anthropic, Apple, Perplexity, DuckDuckGo and
   Amazon are IPv4-only today.
5. **Prefix lengths vary.** Perplexity publishes `/30` and `/29`, Amazon publishes BARE
   addresses with no suffix in two of its three files and `/32` in the third. Never assume `/32`.
6. **PerplexityBot's list is known-incomplete.** Cloudflare reported in August 2025 that
   Perplexity also crawled from undeclared IPs using a generic browser user agent. Absence
   from the list is not evidence a request is not Perplexity — a false negative, the safe
   direction, but worth knowing.


## Health Check 2026-09-05

Every recipe in `fetch-manifest.json` as of the 2026-07-05 pass (47 sources) was fetched
ONCE, live, with the identifying User-Agent `openasn-research/1.0
(+https://github.com/openasn/openasn)` and parsed with the gem's own parsers. "Tokens" is
what the parser returned; "v4/v6 ranges" is after merging; "Hostnames" counts DNS-expanded
sources, which report hostnames rather than ranges because the health check does no DNS.

**42 of 47 healthy. 5 failures, all diagnosed below — none was a silent data-quality
problem, and none required guessing.**

| Source id | HTTP | Bytes | Tokens | v4 ranges | v6 ranges | Hostnames | Result |
|---|---|---|---|---|---|---|---|
| `apple_private_relay` | 200 | 12,167,779 | 287,841 | 953 | 5,920 | 0 | ok |
| `tor_exits` | 200 | 19,025 | 1,339 | 660 | 0 | 0 | ok |
| `aws` | 200 | 2,606,812 | 16,869 | 932 | 1,945 | 0 | ok |
| `gcp` | 200 | 112,291 | 1,098 | 157 | 17 | 0 | ok |
| `azure` | 200 | 4,314,150 | 95,557 | 594 | 954 | 0 | ok |
| `oracle` | 200 | 234,112 | 1,107 | 478 | 0 | 0 | ok |
| `digitalocean` | 200 | 52,881 | 1,228 | 101 | 39 | 0 | ok |
| `linode` | 200 | 192,744 | 5,505 | 95 | 22 | 0 | ok |
| `vultr` | 200 | 21,353 | 499 | 82 | 17 | 0 | ok |
| `cloudflare_ranges` | 200 | 334 | 22 | 14 | 7 | 0 | ok |
| `protonvpn` | 200 | 12,589 | 855 | 528 | 0 | 0 | ok |
| `mullvad_relays` | 200 | 294,427 | 1,093 | 516 | 543 | 0 | ok |
| `ivpn_servers` | 200 | 38,752 | 176 | 169 | 0 | 0 | ok |
| `pia_servers` | 200 | 162,698 | 1,471 | 1,348 | 0 | 0 | ok |
| `airvpn_status` | 200 | 220,524 | 2,056 | 448 | 1,012 | 0 | ok |
| `windscribe_servers` | 403 | 0 | 0 | 0 | 0 | 0 | FAIL 403 |
| `nordvpn_servers` | 200 | 9,049,393 | 8,035 | 7,764 | 1 | 0 | ok |
| `privadovpn` | 200 | 44,178 | 165 | 164 | 0 | 0 | ok |
| `riseup_vpn` | 200 | 9,956 | 21 | 20 | 0 | 0 | ok |
| `wlvpn_server_list` | 200 | 1,143,725 | 3,611 | 3,611 | 0 | 0 | ok |
| `worldvpn_servers` | 200 | 601,026 | 180 | 166 | 0 | 0 | ok |
| `ovpn_status_servers` | 200 | 12,362 | 96 | 34 | 0 | 0 | ok |
| `anonine_status` | 200 | 19,335 | 293 | 77 | 0 | 0 | ok |
| `azirevpn_locations` | 200 | 9,693 | 62 | 0 | 0 | 62 | ok |
| `vpnac_status` | 200 | 37,052 | 130 | 0 | 0 | 130 | ok |
| `trustzone_servers` | 200 | 39,680 | 70 | 0 | 0 | 70 | ok |
| `surfshark_generic` | 200 | 100,538 | 142 | 0 | 0 | 142 | ok |
| `surfshark_static` | 200 | 27,241 | 38 | 0 | 0 | 38 | ok |
| `surfshark_obfuscated` | 200 | 4,813 | 7 | 0 | 0 | 7 | ok |
| `ipvanish_openvpn` | 200 | 5,207,382 | 3,612 | 0 | 0 | 3,612 | ok |
| `privatevpn_openvpn` | 200 | 377,342 | 101 | 1 | 0 | 100 | ok |
| `purevpn_openvpn` | 200 | 1,311,428 | 166 | 0 | 0 | 166 | ok |
| `torguard_openvpn_tcp` | 403 | 0 | 0 | 0 | 0 | 0 | FAIL 403 |
| `torguard_openvpn_udp` | 403 | 0 | 0 | 0 | 0 | 0 | FAIL 403 |
| `fastestvpn_tcp` | 200 | 5,231 | 63 | 0 | 0 | 63 | ok |
| `fastestvpn_udp` | 200 | 5,293 | 63 | 0 | 0 | 63 | ok |
| `vpnsecure_locations` | 404 | 0 | 0 | 0 | 0 | 0 | FAIL 404 |
| `tunnelbear_openvpn` | 200 | 60,247 | 47 | 0 | 0 | 47 | ok |
| `strongvpn_locations` | 200 | 181,994 | 145 | 0 | 0 | 145 | ok |
| `vyprvpn_openvpn` | 200 | 149,595 | 73 | 0 | 0 | 73 | ok |
| `giganews_vyprvpn_hosts` | 200 | 43,750 | 73 | 0 | 0 | 73 | ok |
| `slickvpn_locations` | 200 | 60,820 | 0 | 0 | 0 | 0 | FAIL parse |
| `vpnbook_openvpn` | 200 | 151,794 | 10 | 0 | 0 | 10 | ok |
| `freevpn_us_servers` | 200 | 90,522 | 15 | 0 | 0 | 15 | ok |
| `vpngate` | 200 | 1,320,355 | 98 | 97 | 0 | 0 | ok |
| `zscaler` | 200 | 130,036 | 935 | 136 | 28 | 0 | ok |
| `nazgul_mixed` | 200 | 230,037 | 14,375 | 5,742 | 415 | 0 | ok |

### The five failures, and what was done

| Source id | Symptom | Diagnosis | Action |
|---|---|---|---|
| `slickvpn_locations` | 200, parser returned 0 | SlickVPN redesigned `https://www.slickvpn.com/locations/` since 2026-07-05. Server addresses moved out of the `.ovpn` link text into `<button data-host="gw1.bos1.slickvpn.com" title="Copy server address">` next to an "Active" badge. | Parser rewritten to read `data-host`. Stricter than the old link-pairing heuristic: it is the exact address SlickVPN gives its own users. 11 hosts live. |
| `vpnsecure_locations` | 404 | `https://www.vpnsecure.me/vpn-locations/` is gone. `https://www.vpnsecure.me/locations` returns 200 but is now a marketing page: 0 server hostnames, 0 status markers, no `isponeder.com` references. The source is dead, not moved. | Recipe removed from the manifest and from the gem's `vpn_dns` group. The `vpnsecure_locations_html` parser stays registered so clients pinned to an older manifest keep working. |
| `windscribe_servers` | 403 | Cloudflare "Sorry, you have been blocked" interstitial on every path tried (`assets.windscribe.com/serverlist/mob-v2/1/0`, `.../openvpn/1/0`, `api.windscribe.com/ServerList/mob-v2/1/0`). OpenASN does not defeat bot challenges (D-CUR-1, and rule 3 below). | `enabled_default` changed true -> false so default clients stop failing this fetch every 24 hours. The recipe and its `vpn_providers` group membership are KEPT: Tier B runs on the end user's own network, the block may be vantage-specific, and `keep_stale` means an overlay fetched earlier keeps classifying. |
| `torguard_openvpn_tcp` | 403 | Cloudflare `error code: 1005` — an ASN-level ban of the network the check ran from. This is a fact about our vantage point, not about the archive. | No change beyond a dated note. Already opt-in (`vpn_dns`). |
| `torguard_openvpn_udp` | 403 | Same. | Same. |

Two 403s therefore mean two different things, and the distinction decides the fix: 1005 is
"your network is banned" (leave the recipe alone, another client will succeed), a challenge
interstitial is "we do not want automated fetchers" (stop recommending it on by default).

### Sources added in this pass

| Source id | Provider | URL | Group | Parser | Live smoke 2026-09-05 |
|---|---|---|---|---|---|
| `zscaler_gov` | Zscaler (US government cloud) | `https://config.zscaler.com/api/zscalergov.net/cenr/json` | opt-in `zscaler` | `zscaler_json` | 6 v4 + 7 v6 |
| `github_meta` | GitHub | `https://api.github.com/meta` | opt-in `clouds_extra` | `github_meta_json` | 2101 v4 + 648 v6 |
| `atlassian` | Atlassian | `https://ip-ranges.atlassian.com/` | opt-in `clouds_extra` | `atlassian_ipranges_json` | 68 v4 + 8 v6 |

**Zscaler sibling clouds: measured, then deliberately skipped.** Zscaler serves several named
clouds from the same CENR API path. All seven return 200 with the identical nested shape:

| Cloud | Ranges | Networks | New vs `zscaler.net` |
|---|---|---|---|
| `zscaler.net` (existing recipe) | 935 | 673 | — |
| `zscalerone.net` | 8 | 8 | 0 |
| `zscalertwo.net` | 951 | 672 | 3 |
| `zscalerthree.net` | 918 | 666 | 5 |
| `zscloud.net` | 948 | 674 | 5 |
| `zscalerbeta.net` | 23 | 20 | 1 |
| `zscalergov.net` | 30 | 30 | **30 (all of them)** |

Five extra fetches would buy 14 additional networks; the government cloud alone buys 30 and
is the only one whose address space is genuinely disjoint. Only `zscaler_gov` was added. The
FedRAMP cloud's users are US federal and state agency employees browsing from the office, so
`enterprise_gateway` (a likely-human verdict) is exactly the right mapping.

## Future Implementation Rules

1. Add a manifest source only when the endpoint has exact IP/CIDR tokens or exact provider-published server hostnames.
2. Keep DNS-expanded sources opt-in. They are useful, but not byte-stable across resolvers.
3. Do not use account-only APIs, app/session impersonation, captchas, Cloudflare challenges, or private client state.
4. Do not import generated hostname patterns unless a first-party page/API publishes the actual hostnames.
5. Public/free relay networks stay opt-in because they can be high-churn and residential-looking.
6. Every new parser needs unit tests plus at least one live source smoke showing nonzero ranges and a real lookup classification.

## Documentation-as-data clouds (added 2026-09-12)

Three large hosters — Scaleway, IBM Cloud Classic and OVHcloud shared hosting — never built
an `ip-ranges` endpoint. Their authoritative address list is a page in their own
documentation, and all three now serve that page as raw markdown from their own domain
(an LLM-era docs-platform feature that turns out to be the cleanest machine path they have).

| Source id | Provider | URL | Group | Parser | Live smoke 2026-09-12 |
|---|---|---|---|---|---|
| `scaleway_ranges` | Scaleway (Online SAS / Iliad) | `https://www.scaleway.com/en/docs/account/reference-content/scaleway-network-information.md` | opt-in `clouds_extra` | `scaleway_network_mdx` | 11 v4 + 1 v6 |
| `ibm_cloud_classic` | IBM Cloud Classic (ex-SoftLayer) | `https://cloud.ibm.com/docs/infrastructure-hub?topic=infrastructure-hub-ibm-cloud-ip-ranges&format=markdown` | opt-in `clouds_extra` | `ibm_cloud_ip_ranges_markdown` | 60 v4 + 0 v6 |
| `ovh_web_hosting_clusters` | OVHcloud (shared web hosting) | `https://docs.ovhcloud.com/en/guides/web-cloud/web-hosting/clusters-and-shared-hosting-ip.md` | opt-in `clouds_extra` | `ovh_web_hosting_cluster_md` | 259 v4 + 66 v6 |

All three are opt-in for the same reason Zscaler is: the operators' ASNs already carry
`hosting` from the core artifact, so what these recipes buy is range-level precision and
provider attribution, not new coverage.

### The IBM page is the most dangerous document in the manifest

509 of its 759 CIDRs are RFC1918. A parser that ingested the page whole would label every
home and office LAN on Earth as IBM hosting — the single worst false positive available to
this project. Two independent guards therefore both have to hold:

1. **Section allowlist.** Only `## Front-end (public) network`, `## Load balancer IPs` and
   `## Legacy networks` are read. `## Back-end (private) network`, `### Customer private
   network space`, `## Service network`, `### Service by data center` and the two SSL VPN
   sections are private space. `## Red Hat Enterprise Linux server requirements` and
   `## Windows virtual server instance requirements` are excluded on a different ground: they
   list endpoints an IBM CUSTOMER must be able to reach (Red Hat, Microsoft WSUS), which are
   not IBM address space and must never be attributed to IBM.
2. **RFC1918 guard** applied regardless of section, so a renamed heading degrades to "too few
   rows" (`keep_stale`) rather than to a catastrophe.

`## Legacy networks` is in the allowlist on evidence, not on faith. Its rows are
ex-ThePlanet/SoftLayer space and ARIN still answers IBM for them — checked 2026-09-12:
`209.85.4.0` → `NETBLK-THEPLANET-BLK-EV1-15`, registrant "IBM Cloud"; `12.96.160.0` →
`SOFTLAYER TECHNOLOGIES, INC`; `70.84.160.0` → `NETBLK-THEPLANET-BLK-13`, "IBM Cloud". The
209.85 prefix looks like Google at a glance (Google holds 209.85.128.0/17) and is not; that
near-miss is exactly why the section is allowlisted by hand instead of by heuristic.

Coverage is thin by design: these are IBM's own infrastructure subnets, not customer
allocations, and IBM Cloud VPC — the modern platform — is published nowhere. Do **not**
substitute `https://ibm.biz/cidr-calculator`; IBM itself disclaims it as a community tool.

### Traps in the other two

- **Scaleway**: the page has two bullet lists of addresses in identical syntax. The first
  (`## IP ranges used by Scaleway`) is prefix data; the second (`## DNS cache servers and NTP
  servers`) is bare resolver hosts. The parser stops dead at the next H2. A whole-page CIDR
  regex additionally picks up `62.210.16.0/24` from a later Dedibox section — harmless,
  because it is inside the published `62.210.0.0/16`, but proof that scraping the page
  wholesale reads out-of-scope content.
  `78.232.0.0/16` looks like Free SAS residential space and is not: RIPE gives netname
  SCALEWAY, org Scaleway, status ASSIGNED PA. Labelling it `hosting` corrects stale
  geolocation data rather than mislabelling French home users.
  The `.md` URL on `www.scaleway.com` is byte-identical (2,373 bytes) to the MDX in
  `github.com/scaleway/docs-content`, so we cite the first-party domain and depend on nobody.
- **OVHcloud**: the payload is 24 clusters, each with a per-country inbound VIP table, a
  shared-CDN address, and one **outgoing NAT gateway**. The gateways are the prize: every PHP
  script on a cluster — thousands of tenant sites — egresses from that single address, so
  traffic a site receives from `91.134.248.230` is server-side automation by construction.
  The flip side is shared fate: one gateway fronts an entire multi-tenant cluster, so a per-IP
  reputation decision punishes every tenant at once. Classify, do not block.
  Fetch gotcha: the same URL **with** a trailing slash returns a 404 page (the site strips
  trailing slashes client-side); the `.md` form is the only stable one.
  Scope: shared hosting only. OVH's bare metal, VPS and Public Cloud estates — the
  overwhelming majority of OVH space and of OVH-sourced abuse — are published nowhere: no
  ip-ranges endpoint exists, `geofeed.ovh.net` does not resolve, and OVH's RIPE objects carry
  no `geofeed:` attribute. OVH's RIPE data is also noisy because failover IPs are reassigned
  to end customers under their own org handles (`141.94.0.0/28` → netname `OVH_355850375`,
  org "Doskoil Toma"), which is why registry scraping is a poor substitute here.

## Tier B health check 2026-09-12

Every recipe in `fetch-manifest.json` fetched ONCE, live, with the identifying
User-Agent `openasn-research/1.0 (+https://github.com/openasn/openasn)` and parsed with the gem's own parsers. "Tokens" is what
the parser returned; "v4/v6 ranges" is after merging; "Hostnames" counts DNS-expanded
sources, which report hostnames rather than ranges because the health check does no DNS.

**77 of 77 healthy.** Reproduce with `ruby scripts/tier_b_healthcheck.rb` (all recipes),
`ruby scripts/tier_b_healthcheck.rb <source_id> …` for one, or `ONLY=vpn …` for a subset.
It writes `<OUT>.json` plus this table as `<OUT>.md`, and exits non-zero on any failure.

| Source id | HTTP | Bytes | Tokens | v4 ranges | v6 ranges | Hostnames | Result |
|---|---|---|---|---|---|---|---|
| `apple_private_relay` | 200 | 12,167,779 | 287841 | 953 | 5920 | 0 | ok |
| `tor_exits` | 200 | 19,020 | 1340 | 668 | 0 | 0 | ok |
| `aws` | 200 | 2,696,504 | 17438 | 932 | 2180 | 0 | ok |
| `gcp` | 200 | 112,790 | 1103 | 160 | 17 | 0 | ok |
| `azure` | 200 | 4,316,414 | 95623 | 594 | 954 | 0 | ok |
| `oracle` | 200 | 234,112 | 1107 | 478 | 0 | 0 | ok |
| `digitalocean` | 200 | 52,920 | 1229 | 101 | 39 | 0 | ok |
| `linode` | 200 | 192,744 | 5505 | 95 | 22 | 0 | ok |
| `vultr` | 200 | 21,353 | 499 | 82 | 17 | 0 | ok |
| `cloudflare_ranges` | 200 | 334 | 22 | 14 | 7 | 0 | ok |
| `github_meta` | 200 | 152,856 | 7305 | 2017 | 638 | 0 | ok |
| `atlassian` | 200 | 87,939 | 166 | 68 | 8 | 0 | ok |
| `google_common_crawlers` | 200 | 21,768 | 317 | 28 | 8 | 0 | ok |
| `google_special_crawlers` | 200 | 19,109 | 272 | 9 | 8 | 0 | ok |
| `google_user_triggered_fetchers_google` | 200 | 34,754 | 496 | 17 | 20 | 0 | ok |
| `google_user_triggered_agents` | 200 | 1,413 | 20 | 5 | 1 | 0 | ok |
| `google_user_triggered_fetchers_gae` | 200 | 71,822 | 1058 | 50 | 58 | 0 | ok |
| `google_infra` | 200 | 6,186 | 145 | 98 | 15 | 0 | ok |
| `bingbot` | 200 | 1,580 | 28 | 27 | 0 | 0 | ok |
| `openai_gptbot` | 200 | 1,133 | 21 | 14 | 0 | 0 | ok |
| `openai_chatgpt_user` | 200 | 7,699 | 213 | 190 | 0 | 0 | ok |
| `openai_searchbot` | 200 | 2,080 | 39 | 33 | 0 | 0 | ok |
| `openai_adsbot` | 200 | 177 | 2 | 2 | 0 | 0 | ok |
| `anthropic_bots` | 200 | 1,162 | 26 | 26 | 0 | 0 | ok |
| `applebot` | 200 | 2,218 | 33 | 18 | 0 | 0 | ok |
| `commoncrawl_ccbot` | 200 | 540 | 5 | 3 | 1 | 0 | ok |
| `duckduckbot` | 200 | 32,101 | 486 | 479 | 0 | 0 | ok |
| `perplexitybot` | 200 | 482 | 8 | 8 | 0 | 0 | ok |
| `perplexity_user` | 200 | 276 | 4 | 4 | 0 | 0 | ok |
| `amazonbot` | 200 | 529,818 | 1292 | 1292 | 0 | 0 | ok |
| `amzn_searchbot` | 200 | 506,824 | 816 | 816 | 0 | 0 | ok |
| `amzn_user` | 200 | 515,837 | 1023 | 1023 | 0 | 0 | ok |
| `fastly_ranges` | 200 | 402 | 21 | 16 | 2 | 0 | ok |
| `huawei_cloud_geofeed` | 200 | 33,235 | 927 | 135 | 26 | 0 | ok |
| `scaleway_ranges` | 200 | 2,373 | 13 | 11 | 1 | 0 | ok |
| `ibm_cloud_classic` | 200 | 37,832 | 90 | 60 | 0 | 0 | ok |
| `ovh_web_hosting_clusters` | 200 | 37,840 | 479 | 259 | 66 | 0 | ok |
| `mistralai_user` | 200 | 279 | 4 | 4 | 0 | 0 | ok |
| `mistralai_index` | 200 | 176 | 2 | 2 | 0 | 0 | ok |
| `ahrefsbot` | 200 | 3,350 | 81 | 74 | 0 | 0 | ok |
| `protonvpn` | 200 | 13,405 | 907 | 525 | 0 | 0 | ok |
| `mullvad_relays` | 200 | 291,324 | 1083 | 512 | 538 | 0 | ok |
| `ivpn_servers` | 200 | 38,752 | 176 | 169 | 0 | 0 | ok |
| `pia_servers` | 200 | 128,290 | 1117 | 1038 | 0 | 0 | ok |
| `airvpn_status` | 200 | 220,593 | 2056 | 448 | 1012 | 0 | ok |
| `windscribe_servers` | 200 | 305,203 | 1076 | 395 | 0 | 0 | ok |
| `nordvpn_servers` | 200 | 9,062,425 | 8044 | 7772 | 1 | 0 | ok |
| `privadovpn` | 200 | 44,719 | 167 | 166 | 0 | 0 | ok |
| `riseup_vpn` | 200 | 9,956 | 21 | 20 | 0 | 0 | ok |
| `wlvpn_server_list` | 200 | 1,137,010 | 3596 | 3596 | 0 | 0 | ok |
| `worldvpn_servers` | 200 | 601,026 | 180 | 166 | 0 | 0 | ok |
| `ovpn_status_servers` | 200 | 12,375 | 96 | 34 | 0 | 0 | ok |
| `anonine_status` | 200 | 19,337 | 293 | 77 | 0 | 0 | ok |
| `azirevpn_locations` | 200 | 9,693 | 62 | 0 | 0 | 62 | ok |
| `vpnac_status` | 200 | 37,097 | 130 | 0 | 0 | 130 | ok |
| `trustzone_servers` | 200 | 39,732 | 70 | 0 | 0 | 70 | ok |
| `surfshark_generic` | 200 | 100,547 | 142 | 0 | 0 | 142 | ok |
| `surfshark_static` | 200 | 25,837 | 36 | 0 | 0 | 36 | ok |
| `surfshark_obfuscated` | 200 | 4,813 | 7 | 0 | 0 | 7 | ok |
| `ipvanish_openvpn` | 200 | 5,184,342 | 3596 | 0 | 0 | 3596 | ok |
| `privatevpn_openvpn` | 200 | 377,342 | 101 | 1 | 0 | 100 | ok |
| `purevpn_openvpn` | 200 | 1,311,428 | 166 | 0 | 0 | 166 | ok |
| `torguard_openvpn_tcp` | 200 | 169,004 | 104 | 52 | 0 | 52 | ok |
| `torguard_openvpn_udp` | 200 | 169,006 | 104 | 52 | 0 | 52 | ok |
| `fastestvpn_tcp` | 200 | 5,231 | 63 | 0 | 0 | 63 | ok |
| `fastestvpn_udp` | 200 | 5,293 | 63 | 0 | 0 | 63 | ok |
| `tunnelbear_openvpn` | 200 | 60,247 | 47 | 0 | 0 | 47 | ok |
| `strongvpn_locations` | 200 | 181,994 | 145 | 0 | 0 | 145 | ok |
| `vyprvpn_openvpn` | 200 | 149,595 | 73 | 0 | 0 | 73 | ok |
| `giganews_vyprvpn_hosts` | 200 | 43,782 | 73 | 0 | 0 | 73 | ok |
| `slickvpn_locations` | 200 | 60,820 | 11 | 0 | 0 | 11 | ok |
| `vpnbook_openvpn` | 200 | 151,792 | 10 | 0 | 0 | 10 | ok |
| `freevpn_us_servers` | 200 | 90,532 | 15 | 0 | 0 | 15 | ok |
| `vpngate` | 200 | 1,320,837 | 98 | 96 | 0 | 0 | ok |
| `zscaler` | 200 | 130,041 | 935 | 136 | 29 | 0 | ok |

**Zero failures — and three of the five 2026-09-05 failures healed on their own.** That is
the finding worth keeping, because it validates how the last pass triaged them:

| Source id | 2026-09-05 | 2026-09-12 | What it means |
|---|---|---|---|
| `torguard_openvpn_tcp` / `_udp` | 403, Cloudflare `error code: 1005` | 200, 169 KB, 52 v4 + 52 hostnames each | 1005 is an ASN-level ban on the *fetching* network, a fact about our vantage point and not about the archive. Leaving the recipe untouched was right; it now fetches cleanly. |
| `windscribe_servers` | 403, Cloudflare challenge interstitial on every path | 200, 305 KB, 395 v4 | The interstitial was transient too. See the note below on `enabled_default`. |
| `slickvpn_locations` | 200, parser returned 0 | 200, 11 hostnames | The `data-host` rewrite landed in the last pass and holds. |
| `vpnsecure_locations` | 404, source genuinely gone | removed from the manifest | Still gone. The parser stays registered for clients pinned to an older manifest. |

The generalisation for future maintainers: **a fetch failure is a claim about the observer as
often as about the endpoint.** Before changing a recipe, decide which one you are looking at.
Nothing here needed a fix, so nothing was changed except the note above.

## SWG/SASE egress beyond Zscaler (added 2026-09-12)

D-ENRICH-1 says `enterprise_gateway` is SWG/SASE vendor egress only — the addresses real
human employees browse the web from through a vendor-operated cloud proxy. It is a
likely-human, never-blocking verdict. Ten vendors were checked; three publish a usable
first-party list.

| Source id | Vendor | URL | Group | Parser | Live smoke 2026-09-12 |
|---|---|---|---|---|---|
| `cisco_sse_geofeed` | Cisco (Umbrella SWG **and** Secure Access) | `https://geofeed.network.strln.net/` | opt-in `swg_egress` | `geofeed_csv_no_widen` | 86 v4 + 65 v6 |
| `broadcom_cloud_swg` | Broadcom / Symantec Cloud SWG (ex-WSS) | `https://servicepoints.threatpulse.com/api/v2/full` | opt-in `swg_egress` | `broadcom_servicepoints_json` | 232 v4 + 36 v6 |
| `cato_pop_ranges` | Cato Networks | `https://knowledge.catonetworks.com/docs/production-pop-guide` | opt-in `swg_egress` | `cato_pop_html` | 40 v4 |

**Check RIR whois for a `geofeed:` attribute before anything else.** That single move found
the Cisco feed, which is the best source in this category and which no amount of reading
Cisco's documentation would have surfaced: `whois 151.186.1.1` returns
`remarks: Geofeed https://geofeed.network.strln.net/`. One feed covers two products —
"the feed includes deployed egress prefixes for Cisco SSE products, including Secure Access
and Umbrella" — so Umbrella and Secure Access need no separate recipes.

**The D-ENRICH-1 trap in this category is the public DNS resolver, and the geofeed dodges it
by construction.** Cisco's static allowlist TechNote gives `208.67.216.0/21`, which swallows
the OpenDNS public resolvers at 208.67.220.0/24 and 208.67.222.0/24. The geofeed lists
208.67.216–219 and deliberately omits the resolver /24s. Anyone tempted to shortcut to the
documented /16s would label a public DNS resolver as an enterprise gateway.

**Broadcom's list is mostly rented Google Cloud.** 34.x, 35.x, 130.211.x and 144.49.x
dominate it. Two consequences: it overlaps the `gcp` recipe, and an ASN-level Broadcom
override would be actively wrong. Keep the refresh tight — released space reverts to
ordinary GCP.

### The seven that publish nothing usable, and the pattern behind it

| Vendor | Why not | Evidence |
|---|---|---|
| Netskope | Public page carries 5 CIDRs; the consolidated NewEdge list is login-gated; `wp-json` 403s. Site ToU restricts material to "personal, non-commercial" use. | `docs.netskope.com/en/newedge-ip-ranges-for-allowlisting`, `support.netskope.com/s/article/NewEdge-Consolidated-List-of-IP-Range-for-Allowlisting` |
| Palo Alto Prisma Access | Per-tenant only. Unauthenticated GET → 403 "Missing Authentication Token", POST → 401. The legacy `api.gpcloudservice.com` presents a private Palo Alto root CA no public trust store validates. | `api.prod.datapath.prismaaccess.com/getPrismaAccessIP/v2`; 22,898-URL sitemap grepped |
| iboss | Docs 307 to an authenticated GitBook app; support/KB hosts dead; iboss's own copy says each customer gets dedicated gateway IPs, so no shared pool exists to publish. | `docs.iboss.com`, `www.iboss.com/ip-ranges/` (SPA shell, 0 CIDRs) |
| Menlo Security | KB is login-gated — Zendesk's public API reports exactly one public article, unrelated. Terms also prohibit automated robots/spiders. | `csportal.menlosecurity.com/api/v2/help_center/en-us/articles.json` |
| Forcepoint | The single authoritative KB article is a Salesforce Lightning SPA: 409,479 bytes of JS shell, zero addresses without running JavaScript. | `support.forcepoint.com/s/article/Cloud-service-data-center-IP-addresses-port-numbers` |
| Fortinet FortiSASE | A public IP feed exists but "you must use a FortiCloud IAM API user token", and the URL is per-instance. | Fortinet docs |
| Lookout, Versa | Lookout: Cloudflare interstitial on the help centre (no bypass attempted). Versa: full 1,058-URL sitemap enumerated, including all 127 SSE pages — no such document exists. | — |

**The pattern is architectural, not editorial.** Four of these reject for the same reason:
the vendor gives each customer *dedicated* egress IPs, so there is no shared pool to
publish. Tier B `enterprise_gateway` coverage is realistically limited to vendors running
shared egress — Zscaler, Cisco SSE, Broadcom, Cato. That is a ceiling on this category, and
worth knowing before anyone budgets another pass against it.

**Skyhigh Security is deliberately NOT added, and needs an owner decision.** The data is
good: `success.skyhighsecurity.com/docs/allow-ip-address-ranges-for-points-of-presence.md`
returns 200 with 6 CIDRs, all RDAP-confirmed as Musarubra/Skyhigh WGCS space, and **five of
the six are not captured by the existing AS203724 override** (only 131.229.128.0/17
originates from it). The blocker is legal, not technical: that host's `robots.txt` is a
blanket `User-agent: * / Disallow: /` with the comment "Block all web crawlers from
accessing any part of the site", while the *same host's* `llms.txt` explicitly instructs
automated agents to fetch page `.md` variants — and the governing Trellix terms of service
return 403 to every client tried, so the actual anti-automation clause could not be read.
Unreadable terms plus an explicit robots Disallow is where this project stops (the Akamai
precedent). Recorded in full in the research ledger; reversible in minutes if the owner
reads the terms and disagrees.

Also re-verified 2026-09-12: **Cloudflare One / WARP egress ranges are still not published**
and are still distinct from the public Cloudflare IP Ranges page, so `cloudflare_ranges`
stays a context flag and never `enterprise_gateway`.

## VPN re-check 2026-09-12

Re-checking sources a previous pass wrote off was the highest-value VPN work of this pass:
three of them had changed.

| Provider | 2026-09-05 | 2026-09-12 | Action |
|---|---|---|---|
| Windscribe | 403 Cloudflare challenge on every path | 200, 305 KB, 395 v4 | `enabled_default` restored to true |
| TorGuard | 403 Cloudflare `error code: 1005` | 200, 52 v4 + 52 hostnames each | No change — it stays opt-in because `vpn_dns` is opt-in by policy, not because of the ban |
| OVPN | 32 status-page URLs, one per datacenter | one API call, same 96 IPs | `ovpn_status_servers` → `ovpn_servers` |
| Cryptostorm | not researched | 200, 92 configs, 138 hostnames | added to opt-in `vpn_dns` |
| Perfect Privacy | "timed out from this environment, retry later" | **the provider shut down in January 2026** | Closed permanently; stop retrying |
| CalyxVPN | "timed out, retry later" | `api.calyx.net` authoritative NODATA; pinned fallback times out | Still no |
| Ivacy, hide.me, ExpressVPN, CyberGhost | account-gated | unchanged (Ivacy is now behind a managed challenge, i.e. worse) | Still no |
| Astrill, CactusVPN, VPNArea, Speedify, Njalla, Obscura, Mozilla VPN | not researched | marketing counts, dead endpoints, or auth gates | Documented as negative findings |

**OVPN is a 32× reduction in requests aimed at a provider's own infrastructure**, for the
same data. `https://www.ovpn.com/v2/api/client/entry` returns the whole fleet; both sources
were verified to yield 96 exact IPs and 34 merged v4 ranges. Never log that response body:
its sibling `shadowsocks` object carries a shared credential.

**ProtonVPN stays on the licensed third-party feed.** Proton's own `/vpn/logicals` requires
an `x-pm-appversion` header naming a whitelisted Proton platform — app impersonation, which
this project does not do.

All twelve default-on exact-IP endpoints were re-verified live: **12/12 HTTP 200**. Three
notes for whoever maintains the health check: `check.torproject.org/torbulkexitlist` sends
no `Content-Type` at all, PIA's v7 list is JSON on line 1 with a signature blob after it (so
whole-file `jq` fails), and `worldvpn.net/servers` is the only HTML source in the default
set and therefore the likeliest to break silently — assert a minimum IP count there, not
just a 200.
