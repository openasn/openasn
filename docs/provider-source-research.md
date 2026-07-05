# Provider Source Research

Status date: 2026-07-05

This ledger tracks provider-specific enrichment sources. The standard is:
exact IPs first, original authority preferred, no client impersonation, no DNS
expansion inside OpenASN, keep-stale on failure, and fuzzy nearby-prefix
inference only as future context.

## Added to Tier B

| Source id | Provider | URL | Default | Parser | Rationale |
|---|---|---|---|---|---|
| `apple_private_relay` | iCloud Private Relay | `https://mask-api.icloud.com/egress-ip-ranges.csv` | yes | `csv_cidr_first_column` | Existing source. Apple publishes egress ranges for recognition; maps to `relay`, not `vpn`. |
| `protonvpn` | ProtonVPN | `https://raw.githubusercontent.com/tn3w/ProtonVPN-IPs/master/protonvpn_ips.txt` | yes | `plain_ip_per_line` | Existing licensed feed. Proton's official API currently requires app/session auth for anonymous callers; this Apache-2.0 feed remains the clean default. |
| `mullvad_relays` | Mullvad | `https://api.mullvad.net/www/relays/all/` | yes | `mullvad_relays_json` | First-party public relay JSON used by Mullvad's server list. Exact active relay IPs only. Mozilla VPN / Firefox VPN use Mullvad infrastructure, so this also covers their underlying network but cannot distinguish Mozilla users from Mullvad users. |
| `ivpn_servers` | IVPN | `https://api.ivpn.net/v4/servers.json` | yes | `ivpn_servers_json` | First-party server JSON. Exact WireGuard host IPs and OpenVPN IP addresses. |
| `pia_servers` | Private Internet Access | `https://serverlist.piaservers.net/vpninfo/servers/v6` | yes | `pia_servers_json` | First-party client server list. JSON first line plus detached signature; exact server IPs. |
| `airvpn_status` | AirVPN | `https://airvpn.org/api/status/` | yes | `airvpn_status_json` | First-party public status API. AirVPN forum notes this endpoint lists all servers and entry IPs. |
| `windscribe_servers` | Windscribe | `https://assets.windscribe.com/serverlist/mob-v2/1/0` | yes | `windscribe_serverlist_json` | First-party mobile server list. Exact node IPs and ping IPs; hostnames ignored. |
| `nordvpn_servers` | NordVPN | `https://api.nordvpn.com/v1/servers?limit=0` | opt-in | `nordvpn_servers_json` | First-party API exposes exact station/IP values, but live response is around 35MB and Nord's public server API history is unstable. Behind `config.tier_b[:vpn_heavy]`. |
| `vpngate` | VPN Gate | `http://www.vpngate.net/api/iphone/` | opt-in | `vpngate_csv` | Official VPN Gate public relay API. Exact current volunteer relays; high churn and can be residential-looking IPs, so behind `config.tier_b[:public_relays]`. |

## Existing Non-VPN Tier B Provider Attribution

| Source id | Provider | URL | Maps to |
|---|---|---|---|
| `aws` | AWS | `https://ip-ranges.amazonaws.com/ip-ranges.json` | `hosting` |
| `gcp` | GCP | `https://www.gstatic.com/ipranges/cloud.json` | `hosting` |
| `azure` | Azure | `https://www.microsoft.com/en-us/download/details.aspx?id=56519` | `hosting` |
| `oracle` | Oracle Cloud | `https://docs.oracle.com/en-us/iaas/tools/public_ip_ranges.json` | `hosting` |
| `digitalocean` | DigitalOcean | `https://digitalocean.com/geo/google.csv` | `hosting` |
| `linode` | Linode/Akamai | `https://geoip.linode.com/` | `hosting` |
| `vultr` | Vultr/Constant | `https://geofeed.constant.com/` | `hosting` |
| `cloudflare_ranges` | Cloudflare | `https://www.cloudflare.com/ips-v4`, `https://www.cloudflare.com/ips-v6` | context flag only |
| `zscaler` | Zscaler | `https://config.zscaler.com/api/zscaler.net/cenr/json` | `enterprise_gateway` |

## Researched But Not Added

| Provider | URLs checked | Decision |
|---|---|---|
| Mozilla VPN / Firefox VPN | `https://www.mozilla.org/en-US/products/vpn/resource-center/vpn-servers-around-the-world/`, `https://mullvad.net/en/blog/mullvad-partnerships-page-has-been-updated-mozilla` | No separate exact egress list found. Mozilla says it uses Mullvad infrastructure; use `mullvad_relays` with provider `Mullvad`. |
| ProtonVPN official API | `https://api.protonvpn.ch/vpn/logicals` | Not added. Anonymous request returned missing app-version; adding app headers returned invalid access token. Do not impersonate clients. |
| Surfshark | `https://api.surfshark.com/v4/server/clusters`, `https://support.surfshark.com/hc/en-us/articles/360003069614-Server-locations` | Not added. Cluster API is first-party but exposes hostnames/encrypted entries, not exact IPs. OpenASN does not DNS-expand hostnames. |
| ExpressVPN | `https://www.expressvpn.com/support/knowledge-hub/virtual-server-locations/` | Not added. Public docs list locations/virtual locations, not exact machine-readable IPs. |
| CyberGhost | `https://www.cyberghostvpn.com/vpn-server`, `https://support.cyberghostvpn.com/hc/en-us/articles/214495965-CyberGhost-VPN-s-Virtual-Server-Locations` | Not added. Public docs list locations/virtual locations, not exact machine-readable IPs. |
| TorGuard | `https://torguard.net/downloads/servers.json` | Not added. Live probe hit Cloudflare challenge. Do not put challenged endpoints into client update jobs. |
| TunnelBear | `https://help.tunnelbear.com/hc/en-us/articles/360007004351-Where-can-I-tunnel-to-and-from`, `https://github.com/tn3w/TunnelBear-IPs` | Not added. Public docs list locations; third-party feed says accounts are required to authenticate against the TunnelBear/PolarBear API. |
| Perfect Privacy | `https://github.com/perfect-privacy/documentation`, `https://www.perfect-privacy.com/api/serverips` | Promising but not added in this pass. Public docs describe exact server IP API; live DNS resolution for `www.perfect-privacy.com` failed from this environment, so no live parser smoke yet. |
| hide.me | `https://hide.me/en/network`, `https://github.com/eventure/hide.client.linux` | Not added. Public page lists network locations; CLI exists but no unauthenticated exact-IP endpoint was verified. |
| OVPN.com | `https://www.ovpn.com/en` | Not added. No public exact-IP endpoint found in this pass. |
| Cloudflare WARP | `https://www.cloudflare.com/ips-v4`, `https://www.cloudflare.com/ips-v6` | Keep as context-only Cloudflare ranges. No WARP-specific exact egress list found. |
| Apple VPN | `https://developer.apple.com/icloud/prepare-your-network-for-icloud-private-relay/` | Apple Private Relay is already covered as `relay`; it is deliberately not treated as `vpn`. |
| Google One VPN | Public product state | Not added. Product has been discontinued; no current exact public egress source. |
| Opera VPN, Brave VPN, Avast/Norton/Bitdefender/Kaspersky/Hotspot Shield, VyprVPN, StrongVPN, IPVanish, PureVPN, PrivadoVPN, VPN Unlimited, Aircove/Express family brands | Provider docs/search pass | Not added. No original unauthenticated exact-IP source verified during this pass. Revisit individually if a first-party endpoint appears. |

## Implementation Rules For Future Sources

1. Add a fetch-manifest source only when the body has exact IP/CIDR tokens or a stable structured path to exact IP/CIDR tokens.
2. Prefer first-party endpoints. Licensed third-party feeds can be Tier B when original access is unavailable and the feed license is clear.
3. Do not add DNS resolution as a parser. DNS answers are vantage-dependent, load-balanced, and not the provider's published data.
4. Do not widen provider IPs to `/24` or ASN unless the result is explicitly context-only.
5. Large or fragile sources must be opt-in, not part of the default `vpn_providers` group.
6. Every new parser needs unit tests and at least one live smoke count before being enabled.

## Live Smoke Counts At Introduction

Run from the Ruby gem against the 2026-07-05 manifest, isolated temp data dir,
with exact overlay packing and classification verified end to end.

| Source id | IPv4 ranges | IPv6 ranges | Sample classified |
|---|---:|---:|---|
| `protonvpn` | 823 | 0 | existing source |
| `mullvad_relays` | 496 | 532 | `103.124.165.2` -> `vpn`, provider `Mullvad` |
| `ivpn_servers` | 169 | 0 | `37.120.206.53` -> `vpn`, provider `IVPN` |
| `pia_servers` | 1323 | 0 | `31.171.155.130` -> `vpn`, provider `Private Internet Access` |
| `airvpn_status` | 445 | 1004 | `185.156.175.170` -> `vpn`, provider `AirVPN` |
| `windscribe_servers` | 375 | 0 | `198.44.137.43` -> `vpn`, provider `Windscribe` |
| `nordvpn_servers` | 9108 | 1 | `194.99.105.99` -> `vpn`, provider `NordVPN` |
| `vpngate` | 99 | 0 | `219.100.37.224` -> `vpn`, provider `VPN Gate` |
