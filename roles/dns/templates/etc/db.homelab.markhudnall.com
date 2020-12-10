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
* IN A {{ tailscale_ingress_server_ip }}
