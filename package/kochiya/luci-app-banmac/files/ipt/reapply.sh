#!/bin/sh
# Re-apply all configured bans. Called by the firewall include and by
# /etc/init.d/banmac-ipt on every boot / firewall reload.

SCRIPT_DIR="/usr/banmac/ipt"
CONFIG="banmac_ipt"

uci -q show "$CONFIG" 2>/dev/null | while IFS= read -r line; do
	case "$line" in
		*.banlist_mac=*)
			mac=$(echo "${line#*=}" | tr -d "'\"")
			[ -n "$mac" ] && "$SCRIPT_DIR/ban.sh" "$mac" --no-log
			;;
	esac
done

exit 0
