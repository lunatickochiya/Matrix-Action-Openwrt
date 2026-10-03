module("luci.controller.banmac_ipt", package.seeall)

function index()
	local fs = require "nixio.fs"

	-- hide the page when iptables is not installed
	if not fs.access("/usr/sbin/iptables") then
		return
	end

	local page = entry({"admin", "services", "banmac_ipt"}, cbi("banmac_ipt"), _("BanMac (Ipt)"), 6)
	page.dependent = true
end
