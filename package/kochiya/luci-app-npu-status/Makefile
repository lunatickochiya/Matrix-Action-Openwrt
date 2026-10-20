# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-npu-status
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0-only

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-npu-status
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI NPU/VPU status page (Rockchip RKNPU + rk_vcodec)
  DEPENDS:=+luci-base +rpcd
  PKGARCH:=all
endef

define Package/luci-app-npu-status/description
 LuCI status page showing Rockchip NPU load (rknpu debugfs),
 VPU/MPP session activity (rk_vcodec procfs) and SoC temperatures.
endef

define Build/Compile
endef

define Package/luci-app-npu-status/install
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) ./files/usr/libexec/rpcd/npu_status $(1)/usr/libexec/rpcd/npu_status
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./files/usr/share/rpcd/acl.d/luci-app-npu-status.json $(1)/usr/share/rpcd/acl.d/
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/status/include
	$(INSTALL_DATA) ./files/www/luci-static/resources/view/status/include/15_npu.js $(1)/www/luci-static/resources/view/status/include/
endef

$(eval $(call BuildPackage,luci-app-npu-status))
