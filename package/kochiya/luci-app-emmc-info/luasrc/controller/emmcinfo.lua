module("luci.controller.emmcinfo", package.seeall)

function index()
    entry({"admin", "system", "emmcinfo"}, template("emmcinfo/status"), "eMMC Info", 90)
    entry({"admin", "system", "emmcinfo_run"}, call("action_run")).leaf = true
end

function action_run()
    luci.http.prepare_content("text/plain")
    local util = require "luci.util"
    local output = util.exec("/usr/bin/emmcinfo.sh 2>&1")
    luci.http.write(output)
end