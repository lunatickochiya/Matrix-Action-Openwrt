m = Map("banmac", translate("BanMac (Nft)"),
	translate("Block client devices by MAC address. Rules are stored in the dedicated <code>inet banmac</code> nftables table, so IPv4 and IPv6 are blocked together."))

local logfile = "/etc/banmaclog"

local banlist = m:section(TypedSection, "banlist", translate("log"))
banlist.anonymous = true

local BMNXFS = require "nixio.fs"
bmd = banlist:option(TextValue, "details")
bmd.rows = 6
bmd.wrap = "off"
bmd.cfgvalue = function(self, section)
	return BMNXFS.readfile(logfile) or ""
end
bmd.write = function(self, section, value)
	BMNXFS.writefile(logfile, value:gsub("\r\n", "\n"))
end

s = m:section(TypedSection, "banmac", "")
s.anonymous = false
s.addremove = true

s:tab("banmactab", translate("BanMac Menu"))

banlist_mac = s:taboption("banmactab", Value, "banlist_mac", translate("MAC address"))
banlist_mac.rmempty = true
banlist_mac.datatype = "macaddr"
luci.sys.net.mac_hints(function(mac, name)
	banlist_mac:value(mac, "%s (%s)" %{ mac, name })
end)

local function get_mac(self, section)
	local mac = luci.http.formvalue("cbid." .. self.map.config .. "." .. section .. ".banlist_mac")
	if not mac or mac == "" then
		-- Fall back to the committed value. Reading it through the UCI session
		-- cursor is not reliable here: when the form did not submit the MAC
		-- field (JS widget not ready), CBI stages a delete in the session.
		if section and section:match("^[%w_%-]+$") then
			mac = luci.sys.exec("uci -q get " .. self.map.config .. "." .. section .. ".banlist_mac")
		end
	end
	if mac then
		mac = mac:gsub("^%s+", ""):gsub("%s+$", "")
	end
	if mac and mac ~= "" then
		mac = string.lower(mac)
	end
	return mac
end

local function valid_mac(mac)
	return mac and mac:match("^%x%x:%x%x:%x%x:%x%x:%x%x:%x%x$") ~= nil
end

local function run_action(self, section, action)
	local mac = get_mac(self, section)
	if not valid_mac(mac) then
		banlist_mac:add_error(section, "invalid", translate("Please select or enter a valid MAC address first"))
		return false
	end

	-- persist the address first so the ban can be restored after a reboot
	self.map.uci:set(self.map.config, section, "banlist_mac", mac)
	if not self.map.uci:commit(self.map.config) then
		banlist_mac:add_error(section, "invalid", translate("Failed to save the MAC address"))
		return false
	end

	local rc = luci.sys.call("/usr/banmac/nft/" .. action .. ".sh '" .. mac .. "'")
	if rc ~= 0 then
		banlist_mac:add_error(section, "invalid", translate("Operation failed, check the system log"))
		return false
	end

	return true
end

ban_mac = s:taboption("banmactab", Button, "ban_mac", translate("One-Click BAN"))
ban_mac.rmempty = false
ban_mac.inputstyle = "apply"
function ban_mac.write(self, section)
	return run_action(self, section, "ban")
end

unban_mac = s:taboption("banmactab", Button, "unban_mac", translate("One-Click UnBAN"))
unban_mac.rmempty = false
unban_mac.inputstyle = "apply"
function unban_mac.write(self, section)
	return run_action(self, section, "unban")
end

return m
