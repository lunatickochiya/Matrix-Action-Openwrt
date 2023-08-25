-- Copyright (C) 2021 LunaticKochiya <125438787@qq.com>
-- Licensed to the public under the GNU General Public License v3.
module("luci.controller.modechange", package.seeall)

function index()
	local page
	page = entry({"admin", "services", "modechange"}, cbi("modechange"), _("网口模式切换"), 100)
	page.i18n = "modechange"
	page.dependent = true
end