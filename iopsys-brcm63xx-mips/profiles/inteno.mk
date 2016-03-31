# Meta package support
ASTERISK_PACKAGES:=asterisk18-mod asterisk18-mod-app-playtones asterisk18-mod-app-read \
asterisk18-mod-app-system asterisk18-mod-app-transfer asterisk18-mod-cdr \
asterisk18-mod-chan-brcm asterisk18-mod-codec-a-mu asterisk18-mod-codec-alaw \
asterisk18-mod-codec-g722 asterisk18-mod-codec-g726 asterisk18-mod-codec-ulaw \
asterisk18-mod-format-g726 asterisk18-mod-format-g729 asterisk18-mod-format-sln \
asterisk18-mod-format-sln16 asterisk18-mod-func-channel asterisk18-mod-func-db \
asterisk18-mod-func-shell asterisk18-mod-pbx-spool asterisk18-mod-res-stun \
asterisk18-mod-res-voice asterisk18-mod-sounds

VOICE_SUPPORT:=luci-app-voice luci-app-voice-client voice-client endptcfg $(ASTERISK_PACKAGES)
DECT_SUPPORT:=natalie-dect dectmngr luci-app-dect

define Profile/cg300
  NAME:=cg300
  PACKAGES:=$(VOICE_SUPPORT) $(DECT_SUPPORT)
endef

define Profile/cg300/Description
	cg300 profile
endef

$(eval $(call Profile,cg300))


define Profile/cg301
  NAME:=cg301
  PACKAGES:=$(VOICE_SUPPORT) $(DECT_SUPPORT) bluez
endef

define Profile/cg301/Config
  select TARGET_NO_DECT
endef


define Profile/cg301/Description
	cg301 profile
endef

$(eval $(call Profile,cg301))


define Profile/dg150
  NAME:=dg150
  PACKAGES:=$(VOICE_SUPPORT)
endef

define Profile/dg150/Config
  select TARGET_NO_DECT
endef

define Profile/dg150/Description
	dg150 profile
endef

$(eval $(call Profile,dg150))


define Profile/dg150v2
  NAME:=dg150v2
  PACKAGES:=$(VOICE_SUPPORT)
endef

define Profile/dg150v2/Config
  select TARGET_NO_DECT
endef

define Profile/dg150v2/Description
	dg150v2 profile
endef

$(eval $(call Profile,dg150v2))


define Profile/dg200
  NAME:=dg200
  PACKAGES:=$(VOICE_SUPPORT)
endef

define Profile/dg200/Config
  select TARGET_NO_DECT
  select BCM_I2C
endef

define Profile/dg200/Description
	dg200 profile
endef

$(eval $(call Profile,dg200))


define Profile/dg200al
  NAME:=dg200al
endef

define Profile/dg200al/Config
  select TARGET_NO_VOICE
  select BCM_I2C
endef

define Profile/dg200al/Description
	dg200al profile
endef

$(eval $(call Profile,dg200al))


define Profile/dg301
  NAME:=dg301
  PACKAGES:=$(VOICE_SUPPORT) $(DECT_SUPPORT)
endef

define Profile/dg301/Description
	dg301 profile
endef

$(eval $(call Profile,dg301))


define Profile/dg301al
  NAME:=dg301al
endef

define Profile/dg301al/Config
  select TARGET_NO_VOICE
endef

define Profile/dg301al/Description
	dg301al profile
endef

$(eval $(call Profile,dg301al))


define Profile/eg200
  NAME:=eg200
  PACKAGES:=$(VOICE_SUPPORT)
endef

define Profile/eg200/Config
  select BCM_I2C
endef

define Profile/eg200/Description
	eg200 profile
endef

$(eval $(call Profile,eg200))


define Profile/eg300
  NAME:=eg300
  PACKAGES:=$(VOICE_SUPPORT) $(DECT_SUPPORT) catv luci-app-catv luci-app-sfp
endef

define Profile/eg300/Config
  select TARGET_NO_DSL
  select BCM_I2C
endef

define Profile/eg300/Description
	eg300 profile
endef

$(eval $(call Profile,eg300))


define Profile/vg50
  NAME:=vg50
endef

define Profile/vg50/Config
  select TARGET_NO_DHD
  select TARGET_NO_VOICE
endef

define Profile/vg50/Description
	vg50 profile
endef	

$(eval $(call Profile,vg50))


define Profile/vox25
  NAME:=vox25
  PACKAGES:=$(VOICE_SUPPORT)
endef

define Profile/vox25/Config
  select TARGET_NO_DHD
  select TARGET_NO_DECT
  select TARGET_NO_BLUETOOTH
endef

define Profile/vox25/Description
	vox25 profile
endef

$(eval $(call Profile,vox25))


