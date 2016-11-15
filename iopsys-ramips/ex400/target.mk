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

USB_PACKAGES = kmod-i2c-mt7621 kmod-usb-storage kmod-scsi-core kmod-fs-vfat kmod-nls-cp437 kmod-nls-iso8859-1 block-mount

DEFAULT_PACKAGES += uboot-ex400 kmod-mt7603-mtk kmod-hwnat-mtk wireless-tools bridge ated $(USB_PACKAGES)


define Target/Description
	Build firmware images for Ralink MT7621 based boards.
endef

