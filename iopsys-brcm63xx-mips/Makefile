#
# Copyright (C) Inteno Broadband AB
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=iopsys-brcm63xx-mips
BOARDNAME:=Iopsys Broadcom MIPS
FEATURES:=usb jffs2_nand nand ubifs
MAINTAINER:=Benjamin Larsson <benjamin.larsson@inteno.se>
CFLAGS:=-Os -pipe -mips32 -mtune=mips32 -fno-caller-saves

LINUX_VERSION:=3.4.11

include $(INCLUDE_DIR)/target.mk

define Target/Description
	Build firmware images for Broadcom based xDSL/routers
	based on the Broadcom SDK
endef

DEFAULT_PACKAGES += bcmkernel bcmhotproxy brcm_fw_tool brcminfo mcpd

$(eval $(call BuildTarget))
