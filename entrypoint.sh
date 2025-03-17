#!/bin/sh
set -e
echo "nameserver 1.1.1.1" >/etc/resolv.conf
wg-quick up wg0
sleep 5

if ip a | grep wg0; then
  echo "✅ WireGuard connected"
else
  echo "❌ Can't connect to Wireguard" >&2
  exit 1
fi

iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE

/usr/sbin/sockd
