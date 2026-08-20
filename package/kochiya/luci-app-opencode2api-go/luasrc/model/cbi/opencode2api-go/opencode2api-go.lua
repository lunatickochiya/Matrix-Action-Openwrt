local m, s, o

m = Map("opencode2api-go")
m.title = translate("opencode2api (Go)")
m.description = translate("OpenCode AI API 代理配置 - Go 版本")

m:section(SimpleSection).template = "opencode2api-go/opencode2api-go_status"

s = m:section(TypedSection, "opencode2api-go", translate("基本配置"))
s.addremove = false
s.anonymous = true

o = s:option(Flag, "enabled", translate("启用"))
o.default = 0

o = s:option(Button, "btncq", translate("重启"))
o.inputtitle = translate("重启")
o.description = translate("在没有修改参数的情况下快速重新启动一次")
o.inputstyle = "apply"
o:depends("enabled", "1")
o.write = function()
  os.execute("/etc/init.d/opencode2api-go restart ")
end

o = s:option(Value, "port", translate("监听端口"))
o.datatype = "uinteger"
o.default = 8000

o = s:option(Value, "prog_path", translate("程序路径"))
o.description = translate("opencode2api 二进制文件路径")
o.default = "/usr/bin/opencode2api"

o = s:option(Value, "config_path", translate("配置文件路径"))
o.description = translate("opencode2api 配置文件，默认 /etc/opencode2api-go/config.json")
o.default = "/etc/opencode2api-go/config.json"

o = s:option(Value, "admin_password", translate("管理面板密码"), translate("留空则不启用登录验证"))
o.password = true

o = s:option(ListValue, "log_level", translate("日志级别"))
o.default = "info"
o:value("debug", translate("Debug"))
o:value("info", translate("Info"))
o:value("warn", translate("Warn"))
o:value("error", translate("Error"))

o = s:option(Value, "log_file", translate("日志文件路径"))
o.default = "/var/log/opencode2api-go.log"

o = s:option(Flag, "debug", translate("调试日志"), translate("等价于日志级别 Debug，输出更详细日志"))
o.default = 0

o = s:option(Flag, "fwan", translate("端口放行"), translate("添加防火墙放行规则，外网访问服务"))
o.default = 0

m.apply_on_parse = true
m.on_after_apply = function(self, map)
	luci.sys.exec("/etc/init.d/opencode2api-go restart")
end

return m