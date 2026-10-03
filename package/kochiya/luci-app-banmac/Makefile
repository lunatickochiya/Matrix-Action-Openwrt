#
# Merged BanMac package: one package, two independent interfaces.
#   - "BanMac (Nft)" page operates nftables
#   - "BanMac (Ipt)" page operates iptables/ip6tables
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-banmac
PKG_VERSION:=20261002
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-banmac
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI Support for Ban Client (nftables + iptables)
	PKGARCH:=all
	MAINTAINER:=lunatickochiya
endef

define Package/luci-app-banmac/description
 One-click MAC ban/unban with two independent pages:
  - "BanMac (Nft)" operates nftables (uses the nft binary)
  - "BanMac (Ipt)" operates iptables/ip6tables

 Required packages (install manually, no hard dependency is declared):
  - both pages: luci-compat
  - Nft page: nftables-json (nft)
  - Ipt page: iptables-zz-legacy, ip6tables-zz-legacy
  - recommended: conntrack (flush accelerated flows right after banning)
 A page is hidden automatically when its backend binary is not installed.
endef

define Build/Compile
endef

define Package/luci-app-banmac/conffiles
/etc/config/banmac
/etc/banmaclog
/etc/config/banmac_ipt
/etc/banmaclog_ipt
endef

define Package/luci-app-banmac/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/nft/luasrc/* $(1)/usr/lib/lua/luci/
	$(CP) ./luasrc/ipt/luasrc/* $(1)/usr/lib/lua/luci/
	$(INSTALL_DIR) $(1)/usr/banmac/nft
	$(INSTALL_BIN) ./files/nft/ban.sh ./files/nft/unban.sh ./files/nft/reapply.sh $(1)/usr/banmac/nft/
	$(INSTALL_DIR) $(1)/usr/banmac/ipt
	$(INSTALL_BIN) ./files/ipt/ban.sh ./files/ipt/unban.sh ./files/ipt/reapply.sh $(1)/usr/banmac/ipt/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/nft/banmaclog $(1)/etc/banmaclog
	$(INSTALL_CONF) ./files/ipt/banmaclog $(1)/etc/banmaclog_ipt
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/nft/banmac.conf $(1)/etc/config/banmac
	$(INSTALL_CONF) ./files/ipt/banmac.conf $(1)/etc/config/banmac_ipt
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/nft/etc/uci-defaults/99-banmac-nft $(1)/etc/uci-defaults/99-banmac-nft
	$(INSTALL_BIN) ./root/ipt/etc/uci-defaults/99-banmac-ipt $(1)/etc/uci-defaults/99-banmac-ipt
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/nft/etc/init.d/banmac-nft $(1)/etc/init.d/banmac-nft
	$(INSTALL_BIN) ./root/ipt/etc/init.d/banmac-ipt $(1)/etc/init.d/banmac-ipt
endef

$(eval $(call BuildPackage,luci-app-banmac))
