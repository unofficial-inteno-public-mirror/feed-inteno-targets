#
# Copyright (C) 2006-2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
#
include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=iopsys-brcm63xx-mips
BOARDNAME:=iopsys broadcom MIPS
SUBTARGETS:=cg300 cg301 dg150 dg200 dg301 dg301al dg351 eg200 eg300 vg50 vox25
FEATURES:=usb jffs2_nand nand ubifs

KERNEL_PATCHVER:=3.4
LINUX_VERSION-3.4 = .11

MAINTAINER:=Benjamin Larsson <benjamin.larsson@inteno.se>

include $(INCLUDE_DIR)/target.mk

define Target/Description
	Build firmware images for Broadcom based xDSL/routers
	based on the Broadcom 4.16 SDK
endef

define Target/Config

# target config
config TARGET_iopsys_brcm63xx_mips
	bool
	select BRCM_SDK_VER_416040
	select BCM_ENDPOINT_MODULE
	select BCM_I2C

config 	KERNEL_GIT_CLONE_URI
	string
	default "git@ihgsp.inteno.se:bcmlinux.git" if TARGET_iopsys_brcm63xx_mips

config 	KERNEL_GIT_BRANCH
	string
	default "bcm_4.16L.04" if TARGET_iopsys_brcm63xx_mips

# brcm has it's own brctl
config 	BUSYBOX_DEFAULT_BRCTL
	bool
	default n if TARGET_iopsys_brcm63xx_mips

# brcm has it's own brctl
config 	BUSYBOX_DEFAULT_IFCONFIG
	bool
	default n if TARGET_iopsys_brcm63xx_mips

config 	BCM_CFE_PASSWORD
	string
	default "" if TARGET_iopsys_brcm63xx_mips

config 	BCM_BLNAND
	string
	default "0" if TARGET_iopsys_brcm63xx_mips




# board config
config	TARGET_MODEL_NAME
	string
	default "DG301-WU21U" if TARGET_iopsys_brcm63xx_mips_dg301

config	TARGET_IBOARDID
	string
	default "DG301" if TARGET_iopsys_brcm63xx_mips_dg301

config	BCM_KERNEL_PROFILE
	string
	default "963268GWV" if TARGET_iopsys_brcm63xx_mips_dg301

config 	BCM_CHIP_ID
	string
	default "63268" if TARGET_iopsys_brcm63xx_mips_dg301
endef


$(eval $(call BuildTarget))
