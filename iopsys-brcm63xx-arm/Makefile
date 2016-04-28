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

$(eval $(call BuildTarget))
