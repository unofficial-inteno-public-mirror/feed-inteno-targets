#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

UIMAGE:=$(IMG_PREFIX)-uImage

define Image/Build/Initramfs
	$(call Image/Build/Profile/$(PROFILE),initramfs)
endef

DEVICE_VARS += DTS

loadaddr-y := 0x80000000
loadaddr-$(CONFIG_TARGET_iopsys_ramips_ex300) := 0x80001000

KERNEL_LOADADDR := $(loadaddr-y)

KERNEL_DTB = kernel-bin | patch-dtb | lzma
define Device/Default
  KERNEL := $(KERNEL_DTB) | uImage lzma
  IMAGES := sysupgrade.bin
  IMAGE_SIZE := 30m
  IMAGE/sysupgrade.bin := append-kernel | append-rootfs | pad-rootfs | check-size $$$$(IMAGE_SIZE)
endef

define Build/patch-dtb 
	$(LINUX_DIR)/scripts/dtc/dtc -O dtb -o $@.dtb ../dts/$(DTS).dts
	$(STAGING_DIR_HOST)/bin/patch-dtb $@ $@.dtb
endef

ifeq ($(SUBTARGET),ex300)
  TARGET_DEVICES += ex300
endif

define Device/ex300
  DTS := EX300

endef


# define Image/BuildKernel
#         echo "cp $(KDIR)/vmlinux.elf $(BIN_DIR)/$(VMLINUX).elf" >>/tmp/A
#         cp $(KDIR)/vmlinux.elf $(BIN_DIR)/$(VMLINUX).elf
#         cp $(KDIR)/vmlinux $(BIN_DIR)/$(VMLINUX).bin
#         $(call CompressLzma,$(KDIR)/vmlinux,$(KDIR)/vmlinux.bin.lzma)
#         $(call MkImage,lzma,$(KDIR)/vmlinux.bin.lzma,$(KDIR)/uImage.lzma)
#         cp $(KDIR)/uImage.lzma $(BIN_DIR)/$(UIMAGE).bin
#         mkdir -p  $(TARGET_DIR)/boot
#         cp $(KDIR)/uImage.lzma $(TARGET_DIR)/boot/uImage.bin
#         cp $(KDIR)/$$(KERNEL_IMAGE).dtb $(TARGET_DIR)/boot
#         cp $(KDIR)/$$(KERNEL_IMAGE).dtb $(BIN_DIR)/
# endef





$(eval $(call BuildImage))
