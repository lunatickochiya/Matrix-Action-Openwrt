-- Copyright (C) 2021 LunaticKochiya <125438787@qq.com>
-- Licensed to the public under the GNU General Public License v3.

m = Map("modechange", translate("模式切换"), translate("AP模式和路由模式自由切换。注意：点击按钮配置会写入配置文件不会立即生效，此时你可以点击另一个模式反悔，但是点击重启网络你写入的配置会立即生效。"))

s = m:section(TypedSection, "ap", "AP模式") 
s.addremove = false
s.anonymous = true                                           
button = s:option(Button, "_button", "AP模式（网口改为WAN）")                                     
button.inputtitle = translate("点击写入AP模式")                        
button.inputstyle = "apply"                                   
function button.write(self, section, value)         
	luci.sys.call("/etc/modechange start")
end
s.optional=false; 
s.rmempty = false;
                                                                
s = m:section(TypedSection, "router", "路由模式") 
s.addremove = false
s.anonymous = true                   
button = s:option(Button, "_button", "路由模式（网口改为LAN）")                                     
button.inputtitle = translate("点击写入路由模式")                        
button.inputstyle = "apply"                                   
function button.write(self, section, value)         
	luci.sys.call("/etc/modechange stop")
end
s.optional=false; 
s.rmempty = false;

s = m:section(TypedSection, "networkrestart", "重启网络") 
s.addremove = false
s.anonymous = true                                           
button = s:option(Button, "_button", "重启网络设置生效")                                     
button.inputtitle = translate("点击立即重启网络")                        
button.inputstyle = "apply"                                   
function button.write(self, section, value)         
	luci.sys.call("/etc/init.d/network restart")
end
s.optional=false; 
s.rmempty = false;

return m
