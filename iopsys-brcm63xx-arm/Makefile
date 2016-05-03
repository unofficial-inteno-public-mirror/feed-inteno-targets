#
# Copyright (C) Inteno Broadband AB
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=arm
BOARD:=iopsys-brcm63xx-arm
BOARDNAME:=Iopsys Broadcom ARM
FEATURES:=usb jffs2_nand nand ubifs
MAINTAINER:=Benjamin Larsson <benjamin.larsson@inteno.se>
CFLAGS:=-Os -pipe -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp

LINUX_VERSION:=3.4.11

include $(INCLUDE_DIR)/target.mk

define Target/Description
	Build firmware images for Broadcom based xDSL/routers
	based on the Broadcom SDK for arm
endef

define Target/Config
	source "$(CURDIR)/Config.in"
endef

DEFAULT_PACKAGES += bcmkernel bcmhotproxy brcm_fw_tool brcminfo mcpd


KERNEL_BUILD_DIR ?= $(BUILD_DIR)/linux-$(BOARD)$(if $(SUBTARGET),_$(SUBTARGET))
LINUX_DIR ?= $(KERNEL_BUILD_DIR)/linux-$(LINUX_VERSION)

# Override kmods
SOUNDCORE_FILES := \
	$(LINUX_DIR)/sound/soundcore.ko \
	$(LINUX_DIR)/sound/core/snd.ko \
	$(LINUX_DIR)/sound/core/snd-hwdep.ko \
	$(LINUX_DIR)/sound/core/seq/snd-seq-device.ko \
	$(LINUX_DIR)/sound/core/snd-rawmidi.ko \
	$(LINUX_DIR)/sound/core/snd-timer.ko \
	$(LINUX_DIR)/sound/core/snd-pcm.ko \
	$(LINUX_DIR)/sound/core/oss/snd-mixer-oss.ko \
	$(LINUX_DIR)/sound/core/oss/snd-pcm-oss.ko \
	$(LINUX_DIR)/sound/core/snd-page-alloc.ko

IPSET_MODULES:= \
	ipset/ip_set \
	ipset/ip_set_bitmap_ip \
	ipset/ip_set_bitmap_ipmac \
	ipset/ip_set_bitmap_port \
	ipset/ip_set_hash_ip \
	ipset/ip_set_hash_ipport \
	ipset/ip_set_hash_ipportip \
	ipset/ip_set_hash_ipportnet \
	ipset/ip_set_hash_net \
	ipset/ip_set_hash_netport \
	ipset/ip_set_hash_netiface \
	ipset/ip_set_list_set \
	xt_set

$(eval $(call BuildTarget))
