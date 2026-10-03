#!/bin/sh
# Ban a client by MAC address using iptables (and ip6tables when available).
#
# usage: ban.sh <mac> [--no-log]

LOG_FILE="/etc/banmaclog_ipt"

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

command -v iptables >/dev/null 2>&1 || {
	echo "ban.sh: iptables not found" >&2
	exit 1
}

# Repeated bans must not add duplicate rules: drop existing rules for this MAC first.
while iptables -D FORWARD -m mac --mac-source "$mac" -j DROP 2>/dev/null; do :; done
iptables -I FORWARD -m mac --mac-source "$mac" -j DROP || {
	echo "ban.sh: failed to add rule for $mac" >&2
	exit 1
}

if command -v ip6tables >/dev/null 2>&1; then
	while ip6tables -D FORWARD -m mac --mac-source "$mac" -j DROP 2>/dev/null; do :; done
	ip6tables -I FORWARD -m mac --mac-source "$mac" -j DROP 2>/dev/null
fi

# Flush conntrack entries of the client so already accelerated flows
# (flow offload, shortcut-fe, ...) are torn down as well.
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
