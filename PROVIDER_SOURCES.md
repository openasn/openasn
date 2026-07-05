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
| `vpnbook_openvpn` | VPNBook | `https://www.vpnbook.com/freevpn/openvpn` | opt-in `public_relays` | `vpnbook_html_hosts` | 10 hostnames / 9 v4, 0 v6; 1 DNS miss |

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
| `vpnbook_openvpn` | `142.4.216.196` | `vpn`, provider `VPNBook` |
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
| Surfshark | Added opt-in DNS-expanded Tier B. | First-party cluster APIs publish `connectionName` hostnames: generic/static/obfuscated. Double-hop was empty live on 2026-07-05. |
| IPVanish | Added opt-in DNS-expanded Tier B. | First-party OpenVPN config archive `https://configs.ipvanish.com/openvpn/v2.6.0-0/configs.zip` contains thousands of `remote` hostnames. |
| PrivateVPN | Added opt-in DNS-expanded Tier B. | `https://privatevpn.com/client/PrivateVPN-TUN.zip` contains OpenVPN remotes. |
| PureVPN | Added opt-in DNS-expanded Tier B. | `https://d11a57lttb2ffq.cloudfront.net/heartbleed/router/Recommended-CA2.zip` contains router OpenVPN remotes. |
| TorGuard | Added opt-in DNS-expanded Tier B. | Public TCP/UDP OpenVPN archives fetched cleanly; challenged `servers.json` is not used. |
| FastestVPN | Added opt-in DNS-expanded Tier B. | Public support page `https://support.fastestvpn.com/vpn-servers/` uses the first-party AJAX endpoint now in the manifest. |
| VPNSecure | Added opt-in DNS-expanded Tier B. | `https://www.vpnsecure.me/vpn-locations/` publishes per-server labels and status; parser keeps only `status--up` hosts. |
| TunnelBear | Added opt-in DNS-expanded Tier B. | `https://www.tunnelbear.com/blog/setting-up-tunnelbear-on-linux/` links the first-party public OpenVPN ZIP at `https://tunnelbear.s3.amazonaws.com/support/linux/openvpn.zip`. |
| VPN Gate | Existing opt-in public relay Tier B. | `http://www.vpngate.net/api/iphone/` is the official public relay API. |
| VPNBook | Added opt-in public relay Tier B. | `https://www.vpnbook.com/freevpn/openvpn` publishes current OpenVPN hostnames. |

### Researched, Not Added

| Provider/service | Status | Why not added yet |
|---|---|---|
| ExpressVPN | Open candidate. | Public pages list locations and virtual locations, not exact IPs. Gluetun carries hardcoded hostnames, but that is not a first-party source catalog. Owned by Kape. |
| CyberGhost | Open candidate. | Public docs list locations/virtual locations. Gluetun derives possible `cg-dialup.net` hostnames from patterns and country codes; this is generated DNS probing, not a provider-published exact list. Owned by Kape. |
| ZenMate | Open candidate through Kape/CyberGhost family. | No independent exact first-party list found. |
| Perfect Privacy | Promising but blocked. | Public docs/Gluetun indicate an exact OpenVPN ZIP/API path under `www.perfect-privacy.com`, but live DNS/connection timed out repeatedly from this environment. Not shipped without smoke. |
| hide.me | Not added. | Network page and Linux client were checked; no unauthenticated exact-IP endpoint verified. |
| OVPN.com | Not added. | No public exact-IP endpoint verified. |
| HMA / HideMyAss | Not added. | Gluetun points at `https://vpn.hidemyass.com/vpn-config/...`, but `vpn.hidemyass.com` did not resolve here. |
| VyprVPN | Not added. | Current and old support attachment URLs returned 404. |
| Giganews VPN | Not added. | Gluetun derives from old VyprVPN archive; that archive returned 404. |
| VPN Unlimited / KeepSolid | Not added. | Gluetun notes hardcoded data from a user-provided ZIP behind a login wall. Not a redistributable or unauthenticated source. |
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
| Urban VPN | Not added. | Peer/residential-style network. No public exact exit list; semantics may be residential peers, not provider-operated VPN exits. |
| Hola VPN | Not added. | Peer/residential-style network. Do not label arbitrary peers as VPN without first-party exact relay inventory. |
| Bright VPN | Not added. | Consumer VPN tied to Bright Data-style peer/proxy economics; no exact public egress list. |
| Mysterium VPN | Not added. | Decentralized/residential node network. Needs separate product semantics before any `vpn` mapping. |
| Planet VPN | Not added. | No public exact egress/source endpoint verified. |
| Turbo VPN | Not added. | Product/app pages only; no exact source verified. |
| 1ClickVPN | Not added. | Browser extension/product page only; no exact source verified. |
| VeePN | Not added. | Product/app pages only; no exact source verified. |
| SkyVPN | Not added. | Product page only; no exact source verified. |
| X-VPN | Not added. | Product page only; no exact source verified. |
| StrongVPN | Not added. | Ziff Davis brand; no public exact egress source verified. |
| Total VPN | Not added. | Product page only; no exact source verified. |
| SetupVPN | Not added. | Product page only; no exact source verified. |
| uVPN | Not added. | Product page only; no exact source verified. |
| GooseVPN | Not added. | Product page only; no exact source verified. |
| MEGA VPN | Not added. | Product page only; no exact source verified. |
| Spaceship/FastVPN | Not added. | Product page only; no exact source verified. |
| BullVPN | Not added. | Product page only; no exact source verified. |
| hidemy.name / hide.mn | Not added. | Product/network pages only; no exact source verified. |
| FineVPN | Not added. | Product page only; no exact source verified. |
| ZoogVPN | Not added. | Product page only; no exact source verified. |
| SuperVPN | Not added. | App-store style listing; no exact source verified. |
| VPN Super | Not added. | Product page only; no exact source verified. |
| FreeVPN.org | Not added. | Product page only; no exact source verified. |
| VPNly | Not added. | Product page only; no exact source verified. |
| SuperFree VPN | Not added. | Product page only; no exact source verified. |
| FreeVPNApp.org / FreeVPNApp.io | Not added. | Product/placeholder pages only; no exact source verified. |
| FreeVPN.us | Not added. | Product page only; no exact source verified. |
| VpnHood | Not added. | Open-source VPN software/service builder, not a single provider egress inventory. |
| FreeVPN724 / WorldVPN | Not added. | Product/app page only; no exact source verified. |
| StarVPN | Not added. | Product page only; no exact source verified. |
| GoFlyVPN | Not added. | Product page only; no exact source verified. |
| iTop VPN | Not added. | Product page only; no exact source verified. |
| Radmin VPN | Not added. | Virtual LAN/remote network product, not a public internet egress VPN source. |
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
