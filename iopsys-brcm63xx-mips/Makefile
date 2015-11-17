#
# Copyright (C) 2006-2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=iopsys-brcm63xx-mips
BOARDNAME:=Broadcom BCM63xx_ref_nand
FEATURES:=
KERNEL_PATCHVER:=3.4
LINUX_VERSION-3.4 = .11

MAINTAINER:=Benjamin Larsson <benjamin.larsson@inteno.se>

include $(INCLUDE_DIR)/target.mk

define Target/Description
	Build firmware images for Broadcom based xDSL/routers
	based on the Broadcom 4.14 SDK
endef

$(eval $(call BuildTarget))
