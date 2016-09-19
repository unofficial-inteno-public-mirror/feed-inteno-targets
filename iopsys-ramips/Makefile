#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=mipsel
BOARD:=iopsys-ramips
BOARDNAME:=Iopsys Ramips
SUBTARGETS:=ex400
FEATURES:= gpio
MAINTAINER:=Jonas Höglund <jonas.hoglund@inteno.se>

KERNEL_PATCHVER:=4.4

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES += \
	kmod-leds-gpio kmod-gpio-button-hotplug wpad-mini swconfig

define Target/Description
	Build firmware images for Mediatek boards with drivers from the Mediatek STK.
endef

define Target/Config
	source "$(CURDIR)/Config.in"
endef

$(eval $(call BuildTarget))
