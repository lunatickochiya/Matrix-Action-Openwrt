include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-modechange
PKG_VERSION=1.0
PKG_RELEASE:=1
PKG_MAINTAINER:=LunaticUrey <lunaticurey@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	PKGARCH:=all
	TITLE:=luci for modechange
	DEPENDS:=
endef

define Package/$(PKG_NAME)/description
    A luci app for modechange
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
rm -rf /tmp/luci*
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/i18n/zh-cn/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_BIN) ./files/ap-mode $(1)/etc/modechange
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/modechange $(1)/etc/config/modechange
	$(INSTALL_DIR) $(1)/usr/
	$(CP) ./files/usr/* $(1)/usr/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
