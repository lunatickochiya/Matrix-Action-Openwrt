#!/bin/sh
# Ban a client by MAC address using nftables.
#
# usage: ban.sh <mac> [--no-log]
#
# The rule lives in the dedicated "inet banmac" table, so a single rule
# blocks both IPv4 and IPv6 traffic of the client.

LOG_FILE="/etc/banmaclog"
TABLE="banmac"
CHAIN="forward"

mac=$(echo "$1" | tr 'A-Z' 'a-z')
nolog="$2"

case "$mac" in
	[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f])
		;;
	*)
		echo "ban.sh: invalid MAC address: $1" >&2
		exit 1
		;;
esac

command -v nft >/dev/null 2>&1 || {
	echo "ban.sh: nft not found" >&2
	exit 1
}

if ! nft list table inet "$TABLE" >/dev/null 2>&1; then
	nft add table inet "$TABLE" || exit 1
	nft add chain inet "$TABLE" "$CHAIN" '{ type filter hook forward priority filter; policy accept; }' || exit 1
fi

# Repeated bans must not add duplicate rules: drop existing rules for this MAC first.
while :; do
	handle=$(nft -a list chain inet "$TABLE" "$CHAIN" 2>/dev/null | \
		awk -v s="ether saddr $mac " 'index($0, s) { for (i = 1; i < NF; i++) if ($i == "handle") { print $(i + 1); exit } }')
	[ -n "$handle" ] || break
	nft delete rule inet "$TABLE" "$CHAIN" handle "$handle" || break
done

nft add rule inet "$TABLE" "$CHAIN" ether saddr "$mac" counter drop || {
	echo "ban.sh: failed to add rule for $mac" >&2
	exit 1
}

# Flush conntrack entries of the client so already accelerated flows
# (nft flowtable, shortcut-fe, ...) are torn down as well.
ip=$(awk -v m="$mac" 'tolower($2) == m { print $3; exit }' /tmp/dhcp.leases 2>/dev/null)
if [ -n "$ip" ] && command -v conntrack >/dev/null 2>&1; then
	conntrack -D -s "$ip" >/dev/null 2>&1
fi

# Disconnect the station from every wireless interface (names may vary).
if command -v iw >/dev/null 2>&1; then
	for dev in $(iw dev 2>/dev/null | awk '$1 == "Interface" { print $2 }'); do
		for sta in $(iw dev "$dev" station dump 2>/dev/null | awk '$1 == "Station" { print $2 }'); do
			[ "$(echo "$sta" | tr 'A-Z' 'a-z')" = "$mac" ] && \
				iw dev "$dev" station del "$sta" >/dev/null 2>&1
		done
	done
fi

if [ "$nolog" != "--no-log" ]; then
	lease=$(grep -i -m1 "$mac" /tmp/dhcp.leases 2>/dev/null)
	hostip=""
	hostname=""
	if [ -n "$lease" ]; then
		hostip=$(echo "$lease" | awk '{ print $3 }')
		hostname=$(echo "$lease" | awk '{ print $4 }')
	fi
	echo "★禁网设备：$hostname($hostip) MAC地址：$mac 操作日期：$(date +%Y年%m月%d日\ %H点%M分%S秒)" >> "$LOG_FILE"
fi

exit 0
