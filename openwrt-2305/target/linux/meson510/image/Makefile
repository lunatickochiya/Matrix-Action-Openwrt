#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# makefile mod by lunatickochiya ain at s805 soc  mostly onecloud ws1508
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_TARGET_KERNEL_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

define Build/boot-script
	# Make an U-boot image and copy it to the boot partition
	mkimage -C none -A arm -T script -d $(if $(1),$(1),mmc).bootscript $(KDIR)/boot.scr
	mkimage -C none -A arm -T script -d $(if $(1),$(1),mmc).bootscript.universal $(KDIR)/boot.scr.universal
endef

define Build/sdcard-common
	$(RM) -f $@.boot
	mkfs.fat -C $@.boot $(FAT32_BLOCKS)

	mkdir -p $(KDIR)/boot.fat

	$(CP) $(KDIR)/boot.scr $(KDIR)/boot.fat/boot.scr
	$(CP) $(KDIR)/boot.scr.universal $(KDIR)/boot.fat/boot.scr.universal
	mcopy -i $@.boot $(KDIR)/boot.scr ::
	mcopy -i $@.boot $(KDIR)/boot.scr.universal ::
	$(CP) $(IMAGE_KERNEL) $(KDIR)/boot.fat/uImage
	mcopy -i $@.boot $(KDIR)/boot.fat/uImage ::

	$(foreach dts,$(shell echo $(DEVICE_DTS)),$(CP) $(DTS_DIR)/$(dts).dtb $(KDIR)/boot.fat/dtb;)
	mcopy -i $@.boot $(KDIR)/boot.fat/dtb ::

	$(RM) -rf $(KDIR)/boot.fat

	./gen_aml_sdcard_img.sh $@ $@.boot $(IMAGE_ROOTFS) \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
endef

### Devices ###
define Device/Default
  FILESYSTEMS := ext4
  IMAGES := sdcard.img
  KERNEL_DEPENDS = $$(wildcard $(DTS_DIR)/$$(DEVICE_DTS).dts)
  KERNEL_LOADADDR := 0x01080000
  KERNEL_NAME := Image
  KERNEL := kernel-bin | uImage none
  PROFILES = Default $$(DEVICE_NAME)
endef

define Device/odroid-c1
  DEVICE_DTS := meson8b-odroidc1
  DEVICE_PACKAGES +=
  DEVICE_TITLE := ODROID C1
  KERNEL_LOADADDR := 0x00208000
  IMAGE/sdcard.img := boot-script | sdcard-common $$(DEVICE_NAME)
endef
ifeq ($(SUBTARGET),meson8b)
  TARGET_DEVICES += odroid-c1
endif

define Device/odroid-c2
  DEVICE_DTS := amlogic/meson-gxbb-odroidc2
  DEVICE_PACKAGES +=
  DEVICE_TITLE := ODROID C2
  IMAGE/sdcard.img := boot-script | sdcard-common $$(DEVICE_NAME)
endef
ifeq ($(SUBTARGET),mesongx)
  TARGET_DEVICES += odroid-c2
endif

define Device/gxl-s905x-p212
  DEVICE_DTS := amlogic/meson-gxl-s905x-p212
  DEVICE_PACKAGES +=
  DEVICE_TITLE := S905X Design Reference Board
  IMAGE/sdcard.img := boot-script | sdcard-common $$(DEVICE_NAME)
endef
ifeq ($(SUBTARGET),mesongx)
  TARGET_DEVICES += gxl-s905x-p212
endif

define Device/gxm-q200
  DEVICE_DTS := amlogic/meson-gxm-q200
  DEVICE_PACKAGES +=
  DEVICE_TITLE := GXM Q200 Development Board
  IMAGE/sdcard.img := boot-script | sdcard-common $$(DEVICE_NAME)
endef
ifeq ($(SUBTARGET),mesongx)
  TARGET_DEVICES += gxm-q200
endif

define Device/thunder-onecloud
  DEVICE_DTS := meson8b-onecloud
  DEVICE_TITLE := Thunder OneCloud
  KERNEL_LOADADDR := 0x00208000
  IMAGE/sdcard.img := boot-script onecloud | sdcard-common $$(DEVICE_NAME)
endef
ifeq ($(SUBTARGET),meson8b)
  TARGET_DEVICES += thunder-onecloud
endif

define Device/thunder-ws1508
  DEVICE_DTS := meson8b-ws1508
  DEVICE_TITLE := Thunder WS1508
  KERNEL_LOADADDR := 0x00208000
  IMAGE/sdcard.img := boot-script  ws1508| sdcard-common $$(DEVICE_NAME)
endef
ifeq ($(SUBTARGET),meson8b)
  TARGET_DEVICES += thunder-ws1508
endif

$(eval $(call BuildImage))
