# SPDX-Identifier-License: GPL-3.0-only
#
# Copyright (C) 2025 ipt mod by lunatickochiya
# Copyright (C) 2023-2024 沉默の金 <cmzj@cmzj.org>
# Copyright (C) 2022 Lean <coolsnowwolf@gmail.com>
# Copyright (C) 2019-2022 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-turboacc-ipt
PKG_VERSION:=1.5
PKG_RELEASE:=1

PKG_LICENSE:=GPL-3.0-only
PKG_MAINTAINER:=chenmozhijin <cmzj11@gmail.com>

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_BBR_CCA \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_CM \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_DRV \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_IPT_FULLCONE

LUCI_TITLE:=LuCI support for Flow Offload / Shortcut-FE
LUCI_DEPENDS:= \
	+luci +luci-compat \
	+PACKAGE_$(PKG_NAME)_INCLUDE_BBR_CCA:kmod-tcp-bbr \
	+PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING:kmod-ipt-offload \
	+PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE:kmod-fast-classifier \
	+PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_CM:kmod-shortcut-fe-cm \
	+PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_DRV:kmod-shortcut-fe-drv \
	+PACKAGE_$(PKG_NAME)_INCLUDE_IPT_FULLCONE:kmod-ipt-fullconenat
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/config
config PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING
	bool "Include Flow Offload"
	default y if !(TARGET_ipq60xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_qualcommax)

config PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE
	bool "Include Shortcut-FE"
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING=n
	default n

config PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_CM
	bool "Include Shortcut-FE CM"
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING=n
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE=n
	default y if !(TARGET_ipq60xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_qualcommax)

config PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_DRV
	bool "Include Shortcut-FE ECM"
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING=n
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE=n
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_CM=n
	depends on (TARGET_ipq60xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_qualcommax)
	default y

config PACKAGE_$(PKG_NAME)_INCLUDE_BBR_CCA
	bool "Include BBR CCA"
	default y

config PACKAGE_$(PKG_NAME)_INCLUDE_IPT_FULLCONE
	bool "Include IPT FULLCONE"
	default y
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
