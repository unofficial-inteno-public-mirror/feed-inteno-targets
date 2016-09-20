#
# Copyright (C) 2009 OpenWrt.org
#

SUBTARGET:=ex400
BOARDNAME:=EX400
ARCH_PACKAGES:=ramips_1004kc
FEATURES+=usb nand ubifs
CPU_TYPE:=1004kc
CPU_SUBTYPE:=dsp
CFLAGS:=-Os -pipe -mmt -mips32r2 -mtune=1004kc

DEFAULT_PACKAGES += uboot-ex400 kmod-mt7603-mtk

define Target/Description
	Build firmware images for Ralink MT7621 based boards.
endef

