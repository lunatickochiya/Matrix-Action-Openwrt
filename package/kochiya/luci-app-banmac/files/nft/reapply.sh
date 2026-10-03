#!/bin/sh
# Re-apply all configured bans. Called by the firewall include and by
# /etc/init.d/banmac-nft on every boot / firewall reload.

SCRIPT_DIR="/usr/banmac/nft"
CONFIG="banmac"
TABLE="banmac"

# Rebuild the table from the saved configuration so stale rules of removed
# clients are dropped as well.
if command -v nft >/dev/null 2>&1; then
	nft delete table inet "$TABLE" >/dev/null 2>&1
fi

uci -q show "$CONFIG" 2>/dev/null | while IFS= read -r line; do
	case "$line" in
		*.banlist_mac=*)
			mac=$(echo "${line#*=}" | tr -d "'\"")
			[ -n "$mac" ] && "$SCRIPT_DIR/ban.sh" "$mac" --no-log
			;;
	esac
done

exit 0
