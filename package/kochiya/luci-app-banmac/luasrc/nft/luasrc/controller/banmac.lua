module("luci.controller.banmac", package.seeall)

function index()
	local fs = require "nixio.fs"

	-- hide the page when nftables is not installed
	if not fs.access("/usr/sbin/nft") then
		return
	end

	local page = entry({"admin", "services", "banmac"}, cbi("banmac"), _("BanMac (Nft)"), 5)
	page.dependent = true
end
