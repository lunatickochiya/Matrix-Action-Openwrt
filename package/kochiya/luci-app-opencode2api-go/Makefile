#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-opencode2api-go
PKG_VERSION:=1.0.0

LUCI_TITLE:=LuCI Support for opencode2api (Go version)
LUCI_DEPENDS:=+luci-compat +opencode2api
LUCI_PKGARCH:=all

RSTRIP := :

define Package/$(PKG_NAME)/postinst
#!/bin/sh
# mirror build: operate on the target rootfs path
[ -n "$$IPKG_INSTROOT" ] && IPKG_INSTROOT="$$IPKG_INSTROOT/"
chmod +x "$${IPKG_INSTROOT}/etc/init.d/opencode2api-go"
mkdir -p "$${IPKG_INSTROOT}/etc/opencode2api-go"
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk
# call BuildPackage - OpenWrt buildroot signature