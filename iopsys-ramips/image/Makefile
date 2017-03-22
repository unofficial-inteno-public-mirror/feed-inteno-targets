#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

UIMAGE:=$(IMG_PREFIX).uImage
UBIFS_OPTS:="-m 2048 -e 126976 -c 4096"

DEVICE_VARS += DTS

loadaddr-y := 0x80000000
loadaddr-$(CONFIG_TARGET_iopsys_ramips_ex400) := 0x80001000

KERNEL_LOADADDR := $(loadaddr-y)

IHGSP_VERSION:=$(CONFIG_TARGET_MODEL_NAME)_$(CONFIG_TARGET_CUSTOMER)$(CONFIG_TARGET_VERSION)-$(shell date '+%y%m%d_%H%M')
IHGSP_BUILD_VERSION:=$(shell echo $(IHGSP_VERSION) | sed s/\"//g)

BUILD_DIR_ROOT:=$(BUILD_DIR)/root-$(shell echo $(CONFIG_TARGET_BOARD) | sed s/\"//g)

KERNEL_DTB = kernel-bin | patch-dtb | lzma 
define Device/Default
  KERNEL := $(KERNEL_DTB) | uImage lzma | Install_uimage_dtb
  IMAGE_SIZE := 30m
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
	$(call Image/BuildDTB,../dts/$(DTS).dts,$@.dtb)
	$(STAGING_DIR_HOST)/bin/patch-dtb $@ $@.dtb
	mkdir -p  $(TARGET_DIR)/boot
	cp $@.dtb $(TARGET_DIR)/boot/dtb
        cp $@.dtb $(BIN_DIR)/$(IMG_PREFIX).dtb
endef

define Build/Install_uimage_dtb
	$(call CompressLzma,$(KDIR)/vmlinux,$(KDIR)/vmlinux.bin.lzma)
	$(call MkImage,lzma,$(KDIR)/vmlinux.bin.lzma,$(KDIR)/uImage.lzma)
	cp $(KDIR)/uImage.lzma $(BIN_DIR)/$(UIMAGE)
	mkdir -p  $(TARGET_DIR)/boot
        cp $(KDIR)/uImage.lzma $(TARGET_DIR)/boot/uImage
endef

HEADER_VERSION:=3

define Image/Build/Header
	# Args: $1=header $2=cfe $3=kernel $4=ubifs $5=ubi $6=pkginfo
	# Any unused arguments should be passed as 'void'

	echo "In Image/Build/Header $(1) $(2) $(3) $(4) $(5) $(6)"

	truncate --size=0 $(KDIR)/void
	echo "IntenoBlob" > $(KDIR)/hdr
	echo "version $(HEADER_VERSION)" >> $(KDIR)/hdr
	echo "integrity MD5SUM" >> $(KDIR)/hdr
	echo "board $(CONFIG_TARGET_IBOARDID)" >> $(KDIR)/hdr
	echo "chip $(CONFIG_MEDIATEK_CHIP_ID)" >> $(KDIR)/hdr
	echo "arch all $(CONFIG_TARGET_ARCH_PACKAGES)" >> $(KDIR)/hdr
	echo "model $(CONFIG_TARGET_MODEL_NAME)" >> $(KDIR)/hdr
	echo "release $(CONFIG_TARGET_VERSION)" >> $(KDIR)/hdr
	echo "customer $(CONFIG_TARGET_CUSTOMER)" >> $(KDIR)/hdr
	echo "ubifs $$$$(ls -l $(KDIR)/$(4) | awk '{print $$$$5}')" >> $(KDIR)/hdr
	echo "ubi $$$$(ls -l $(KDIR)/$(5) | awk '{print $$$$5}')" >> $(KDIR)/hdr
	echo "pkginfo $$$$(ls -l $(KDIR)/$(6) | awk '{print $$$$5}')" >> $(KDIR)/hdr
    ifeq ($(CONFIG_SMIMEOPT),y)
	echo "sig 256" >> $(KDIR)/hdr
    endif
	cat $(KDIR)/hdr /dev/zero | head --bytes=1024 > $(KDIR)/$(1)

endef


define Image/Prepare
	sed -i 's/^IOP Version.*/IOP Version: $(IHGSP_BUILD_VERSION)/gi' $(BUILD_DIR_ROOT)/etc/banner
	mkdir -p $(BUILD_DIR_ROOT)/lib/db/version

# BUG anyhting using this ??
	echo $(IHGSP_BUILD_VERSION)  > $(BUILD_DIR_ROOT)/lib/db/version/iop_version
	echo $(CONFIG_TARGET_CUSTOMER)> $(BUILD_DIR_ROOT)/lib/db/version/iop_customer

# standard os version info https://www.freedesktop.org/software/systemd/man/os-release.html
	echo "NAME=\"Inteno Open Platform System (IOPSYS)\""	>$(BUILD_DIR_ROOT)/etc/os-release
	echo "VERSION=\"$(IHGSP_BUILD_VERSION)\""		>>$(BUILD_DIR_ROOT)/etc/os-release
	echo "ID=\"iopsys\""					>>$(BUILD_DIR_ROOT)/etc/os-release
	echo "ID_LIKE=\"openwrt\""				>>$(BUILD_DIR_ROOT)/etc/os-release
	echo "VARIANT=\"$(CONFIG_TARGET_CUSTOMER)\""		>>$(BUILD_DIR_ROOT)/etc/os-release
	echo "ANSI_COLOR=\"0;34\""				>>$(BUILD_DIR_ROOT)/etc/os-release
# inteno private
	echo "IOPSYS_BOARD=\"$(SUBTARGET)\""			>>$(BUILD_DIR_ROOT)/etc/os-release
endef

# how should we copy the root.ubifs to ./bin/iopsys-ramips ??? this is working sort of but still copies multiple times. 
define Image/Build
	@echo "BUG: this is run multiple times, why ?? C [$(1)]"
	# extract package info
	cat $(BUILD_DIR_ROOT)/usr/lib/opkg/status \
	   | awk '/^Package:/ {printf "%s ",$$$$2} /^Version:/ {printf "%s\n",$$$$2}' \
	   | sort \
	   | awk '{printf "===Package start===\nPackage: %s\nVersion: %s\n",$$$$1,$$$$2}' \
	   > $(KDIR)/pkginfo
	# copy ubifs and craete y2 image
	cp $(KDIR)/root.ubifs $(BIN_DIR)/$(IMG_PREFIX).ubifs
	# Make header (_cfe.y2)
	ls -l $(KDIR)/root.ubifs
	$(call Image/Build/Header,header.y2,void,void,root.ubifs,void,pkginfo)
	cat $(KDIR)/header.y2 \
	    $(KDIR)/root.ubifs \
	    $(KDIR)/pkginfo > $(BIN_DIR)/$(IHGSP_BUILD_VERSION).y2

	# If build is signed also sign the cfe,kernel,fs part of the image.
        ifeq ($(CONFIG_SMIMEOPT),y)
	    cat  $(KDIR)/root.ubifs | \
		openssl dgst -sha256 -sign $(CONFIG_OPKGSMIME_KEY) \
		-passin file:$(call qstrip,$(CONFIG_OPKGSMIME_PASSFILE)) \
		>> $(BIN_DIR)/$(IHGSP_BUILD_VERSION).y2
        endif

	# Attach checksum to combined image (.y2)
	md5sum $(BIN_DIR)/$(IHGSP_BUILD_VERSION).y2 |awk '{printf "%s",$$$$1}' \
		>> $(BIN_DIR)/$(IHGSP_BUILD_VERSION).y2
	ln -sf $(BIN_DIR)/$(IHGSP_BUILD_VERSION).y2 $(BIN_DIR)/last.y2
endef

ifeq ($(SUBTARGET),ex400)
  TARGET_DEVICES += ex400
endif

define Device/ex400
  DTS := EX400
endef


$(eval $(call BuildImage))
