include $(TOPDIR)/rules.mk

PKG_NAME:=gecoosac
PKG_VERSION:=2.2.20251015
PKG_RELEASE:=1

ifeq ($(ARCH),aarch64)
  PKG_ARCH:=ac_linux_arm64
  PKG_HASH:=66ef7f030954216fcf503bd4586cc3e87ba68f986f9718afc1fd16d6cd924ff0
else ifeq ($(ARCH),arm)
  PKG_ARCH:=ac_linux_arm
  PKG_HASH:=e0d60d19234df39bebb6625eb6e2393fead70d36dd5986dcda6c98b85d6eb175
else ifeq ($(ARCH),mips)
  PKG_ARCH:=ac_linux_mips
  PKG_HASH:=c5636e2277e3d2de3a91c7e3f4f9749dd4d9f35edf274ab7f0c2041131ea8da3
else ifeq ($(ARCH),mipsel)
  PKG_ARCH:=ac_linux_mipsle
  PKG_HASH:=ddd30214e07080d8329ab0226d596a7a648c5cff409209ec8256ee2761d60ccb
else ifeq ($(ARCH),i386)
  PKG_ARCH:=ac_linux_386
  PKG_HASH:=4d49092a1301c98a67b3ad33ea5a34a9207d7737ba0209dd420216ef3057998a
else ifeq ($(ARCH),x86_64)
  PKG_ARCH:=ac_linux_amd64
  PKG_HASH:=2fa24bce8cf2cb6923f8f01197eb68ca07507d61f1ecaefd0d1e82c7fde16086
else
  PKG_HASH:=dummy
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(ARCH_PACKAGES)
PKG_SOURCE_URL:=https://github.com/lwb1978/gecoosac-core/releases/download/V$(PKG_VERSION)/$(PKG_ARCH)?
UNPACK_CMD=$(CP) $(DL_DIR)/$(PKG_SOURCE) $(PKG_BUILD_DIR)/$(PKG_NAME)

PKG_LICENSE:=AGPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=lwb1978 <lwb1978@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=gecoosac server (version $(PKG_VERSION))
  URL:=http://www.cnrouter.com/
  DEPENDS:=@(aarch64||arm||i386||mips||mipsel||x86_64)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
