#
# Copyright (C) 2006-2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=iopsys-brcm63xx-mips
BOARDNAME:=iopsys broadcom MIPS
SUBTARGETS:=cg300 cg301 dg150 dg200 dg301 dg301al dg351 eg200 eg300 vg50 vox25
FEATURES:=

KERNEL_PATCHVER:=3.4
LINUX_VERSION-3.4 = .11

MAINTAINER:=Benjamin Larsson <benjamin.larsson@inteno.se>

#define Target/Description
#	Build firmware images for Broadcom based xDSL/routers
#	based on the Broadcom 4.16 SDK
#endef

include $(INCLUDE_DIR)/target.mk
$(eval $(call BuildTarget))
