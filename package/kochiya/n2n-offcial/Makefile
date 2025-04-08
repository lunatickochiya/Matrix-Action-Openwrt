#
# Copyright (C) 2021 - ntop.org and contributors
#

include $(TOPDIR)/rules.mk

PKG_NAME:=n2n-offcial
PKG_VERSION:=20231024
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/ntop/n2n.git
PKG_SOURCE_VERSION:=fff50a7d80728069ca101a262d1543d85ac5313f
PKG_MIRROR_HASH:=skip


PKG_MAINTAINER:=Emanuele Faranda <faranda@ntop.org>
PKG_LICENSE:=GPL3

# autogen fix
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/n2n-offcial/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=N2N Peer-to-peer VPN
  URL:=http://www.ntop.org/n2n
  SUBMENU:=VPN
  DEPENDS+=+libcap
endef

define Package/n2n-edge
  $(call Package/n2n-offcial/Default)
  TITLE+= client (edge node)
  DEPENDS+=+kmod-tun
endef

define Package/n2n-supernode
  $(call Package/n2n-offcial/Default)
  TITLE+= server (supernode)
endef

define Package/n2n-edge/description
The client node for the N2N infrastructure
endef

define Package/n2n-supernode/description
The supernode for the N2N infrastructure
endef

define Build/Configure
	( cd $(PKG_BUILD_DIR); \
	./autogen.sh; \
	LDFLAGS=--static ./configure )
endef

define Package/n2n-edge/conffiles
/etc/n2n/edge.conf
endef

define Package/n2n-edge/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/edge $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/packages/openwrt/etc/init.d/edge $(1)/etc/init.d/edge
	$(INSTALL_DIR) $(1)/etc/n2n
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/packages/etc/n2n/edge.conf.sample $(1)/etc/n2n/edge.conf
endef

define Package/n2n-supernode/conffiles
/etc/n2n/supernode.conf
endef

define Package/n2n-supernode/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/supernode $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/packages/openwrt/etc/init.d/supernode $(1)/etc/init.d/supernode
	$(INSTALL_DIR) $(1)/etc/n2n
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/packages/etc/n2n/supernode.conf.sample $(1)/etc/n2n/supernode.conf
endef

$(eval $(call BuildPackage,n2n-edge))
$(eval $(call BuildPackage,n2n-supernode))
