module("luci.controller.opencode2api_go", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/opencode2api-go") then
		return
	end

	local e = entry({"admin", "services", "opencode2api-go"}, alias("admin", "services", "opencode2api-go", "setting"), _("opencode2api (Go)"), 48)
	e.dependent = false
	e.acl_depends = { "luci-app-opencode2api-go" }
	entry({"admin", "services", "opencode2api-go", "setting"}, cbi("opencode2api-go/opencode2api-go"), _("配置"), 20).leaf = true
	entry({"admin", "services", "opencode2api-go", "opencode2api-go"}, template("opencode2api-go/opencode2api-go"), _("主页"), 30).leaf = true
	entry({"admin", "services", "opencode2api-go_status"}, call("act_status"))
	entry({"admin", "services", "opencode2api-go", "log"}, template("opencode2api-go/opencode2api-go_log"), _("日志"), 40).leaf = true
	entry({"admin", "services", "opencode2api-go", "fetch_log"}, call("fetch_log"), nil).leaf = true
	entry({"admin", "services", "opencode2api-go", "clear_log"}, call("clear_log")).leaf = true
end

local function uci_get(section, option, default)
	local uci = luci.model.uci.cursor()
	local val = uci:get("opencode2api-go", section, option)
	if not val or val == "" then
		return default
	end
	return val
end

function act_status()
	local sys = require "luci.sys"
	local e = {}
	e.running = sys.call("pidof opencode2api >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function fetch_log()
	local fs = require "nixio.fs"
	local log_file = uci_get("opencode2api-go", "log_file", "/var/log/opencode2api-go.log")
	local log_content = fs.readfile(log_file) or "没有日志."
	luci.http.write(log_content)
end

function clear_log()
	local fs = require "nixio.fs"
	local log_file = uci_get("opencode2api-go", "log_file", "/var/log/opencode2api-go.log")
	local f = io.open(log_file, "w")
	if f then
		f:close()
		luci.http.status(204, "没有内容.")
	else
		luci.http.status(500, "内部服务器错误.")
	end
end