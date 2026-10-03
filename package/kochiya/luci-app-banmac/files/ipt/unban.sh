#!/bin/sh
# Unban a client by MAC address (iptables backend).
#
# usage: unban.sh <mac> [--no-log]
#
# Removes every IPv4 and IPv6 rule for the given MAC, so a device that was
# banned multiple times is really unblocked with a single click.

LOG_FILE="/etc/banmaclog_ipt"

mac=$(echo "$1" | tr 'A-Z' 'a-z')
nolog="$2"

case "$mac" in
	[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f])
		;;
	*)
		echo "unban.sh: invalid MAC address: $1" >&2
		exit 1
		;;
esac

if command -v iptables >/dev/null 2>&1; then
	while iptables -D FORWARD -m mac --mac-source "$mac" -j DROP 2>/dev/null; do :; done
fi

if command -v ip6tables >/dev/null 2>&1; then
	while ip6tables -D FORWARD -m mac --mac-source "$mac" -j DROP 2>/dev/null; do :; done
fi

# Remove all log lines of this device (fixed string match, no regex surprises).
if [ "$nolog" != "--no-log" ] && [ -f "$LOG_FILE" ]; then
	grep -Fiv "$mac" "$LOG_FILE" > /tmp/.banmaclog_ipt.new 2>/dev/null
	[ $? -le 1 ] && cat /tmp/.banmaclog_ipt.new > "$LOG_FILE"
	rm -f /tmp/.banmaclog_ipt.new
fi

exit 0
