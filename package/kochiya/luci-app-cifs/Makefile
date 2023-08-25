# Copyright 2015 
# Matthew

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cifs
PKG_VERSION:= 1.2
PKG_RELEASE:= 1.2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-cifs
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=Mounting Nat Drives
	PKGARCH:=all
	DEPENDS:=+kmod-fs-cifs +kmod-nls-utf8
endef

define Package/luci-app-cifs/description
	Allows you to use the Web Cotrol Center to mount networked drives.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-cifs/conffiles
/etc/config/cifs
endef

define Package/luci-app-cifs/preinst
endef

define Package/luci-app-cifs/postinst
#!/bin/sh
#	/etc/init.d/cifs.sh enable
exit 0
endef

define Package/luci-app-cifs/prerm 
endef

define Package/luci-app-cifs/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/cifs-config $(1)/etc/config/cifs
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/cifs-init.d.sh $(1)/etc/init.d/cifs

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/cifs-controller.lua $(1)/usr/lib/lua/luci/controller/cifs.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/cifs-model.lua $(1)/usr/lib/lua/luci/model/cbi/cifs.lua
endef

$(eval $(call BuildPackage,luci-app-cifs))
