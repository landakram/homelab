$ORIGIN homelab.markhudnall.com.
$TTL 5m
@ IN SOA localhost. root.locahost. (
1 ; Serial
4h ; Refresh
15m ; Retry
8h ; Expire
4m ; Negative Cache TTL
)

@ IN NS dns.homelab.markhudnall.com.
dns IN A {{ tailscale_ingress_server_ip }}
wiki IN A {{ tailscale_ingress_server_ip }}
grafana IN A {{ tailscale_ingress_server_ip }}
prometheus IN A {{ tailscale_ingress_server_ip }}

