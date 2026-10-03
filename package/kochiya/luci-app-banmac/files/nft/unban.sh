#!/bin/sh
# Unban a client by MAC address (nftables backend).
#
# usage: unban.sh <mac> [--no-log]
#
# Removes every rule for the given MAC, so a device that was banned
# multiple times is really unblocked with a single click.

LOG_FILE="/etc/banmaclog"
TABLE="banmac"
CHAIN="forward"

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

if command -v nft >/dev/null 2>&1 && nft list table inet "$TABLE" >/dev/null 2>&1; then
	while :; do
		handle=$(nft -a list chain inet "$TABLE" "$CHAIN" 2>/dev/null | \
			awk -v s="ether saddr $mac " 'index($0, s) { for (i = 1; i < NF; i++) if ($i == "handle") { print $(i + 1); exit } }')
		[ -n "$handle" ] || break
		nft delete rule inet "$TABLE" "$CHAIN" handle "$handle" || break
	done
fi

# Remove all log lines of this device (fixed string match, no regex surprises).
if [ "$nolog" != "--no-log" ] && [ -f "$LOG_FILE" ]; then
	grep -Fiv "$mac" "$LOG_FILE" > /tmp/.banmaclog.new 2>/dev/null
	[ $? -le 1 ] && cat /tmp/.banmaclog.new > "$LOG_FILE"
	rm -f /tmp/.banmaclog.new
fi

exit 0
