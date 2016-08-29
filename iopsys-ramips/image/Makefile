#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

UIMAGE:=$(IMG_PREFIX)-uImage
UBIFS_OPTS:="-m 2048 -e 126976 -c 4096"

DEVICE_VARS += DTS

loadaddr-y := 0x80000000
loadaddr-$(CONFIG_TARGET_iopsys_ramips_ex300) := 0x80001000

KERNEL_LOADADDR := $(loadaddr-y)

KERNEL_DTB = kernel-bin | patch-dtb | lzma 
define Device/Default
  KERNEL := $(KERNEL_DTB) | uImage lzma | Install_uimage_dtb
  IMAGES := sysupgrade.bin
  IMAGE_SIZE := 30m
  IMAGE/sysupgrade.bin := append-kernel | append-rootfs | pad-rootfs | check-size $$$$(IMAGE_SIZE)
endef

define CompressLzma
        $(STAGING_DIR_HOST)/bin/lzma e $(1) -lc1 -lp2 -pb2 $(2)
endef

define MkImage
        $(eval imagename=$(if $(4),$(4),MIPS OpenWrt Linux-$(LINUX_VERSION)))
        -mkimage -A mips -O linux -T kernel -C $(1) -a $(loadaddr-y) -e $(loadaddr-y) \
                -n "$(imagename)" \
                -d $(2) $(3)
endef
 
define Build/patch-dtb 
	$(LINUX_DIR)/scripts/dtc/dtc -O dtb -o $@.dtb ../dts/$(DTS).dts
	$(STAGING_DIR_HOST)/bin/patch-dtb $@ $@.dtb
	mkdir -p  $(TARGET_DIR)/boot
	cp $@.dtb $(TARGET_DIR)/boot/dtb
        cp $@.dtb $(BIN_DIR)/

endef

define Build/Install_uimage_dtb
	echo "ken was here" >/tmp/B
	$(call CompressLzma,$(KDIR)/vmlinux,$(KDIR)/vmlinux.bin.lzma)
	$(call MkImage,lzma,$(KDIR)/vmlinux.bin.lzma,$(KDIR)/uImage.lzma)
	echo "ken was here again" >>/tmp/B
	cp $(KDIR)/uImage.lzma $(BIN_DIR)/$(UIMAGE).bin
	mkdir -p  $(TARGET_DIR)/boot
        cp $(KDIR)/uImage.lzma $(TARGET_DIR)/boot/uImage.bin
endef



ifeq ($(SUBTARGET),ex300)
  TARGET_DEVICES += ex300
endif

define Device/ex300
  DTS := EX300

endef


$(eval $(call BuildImage))
