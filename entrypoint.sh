#!/bin/sh
set -e
echo "nameserver 1.1.1.1" >/etc/resolv.conf

if [[ -z "$EXPRESSVPN_CODE" ]] || [[ -z "$EXPRESSVPN_LOCATION" ]]; then
  echo "❌ Error: Can't get EXPRESSVPN_CODE or EXPRESSVPN_LOCATION variables!"
  exit 1
fi

echo "🔑 Activate ExpressVPN..."
expressvpn activate --code "$EXPRESSVPN_CODE"

echo "🌍 Conneting to server: $EXPRESSVPN_LOCATION..."
expressvpn connect "$EXPRESSVPN_LOCATION"

sleep 5

if ip a | grep wg0; then
  echo "✅ ExpressVPN connected"
else
  echo "❌ Can't connect to ExpressVPN" >&2
  exit 1
fi

iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

/usr/sbin/sockd
