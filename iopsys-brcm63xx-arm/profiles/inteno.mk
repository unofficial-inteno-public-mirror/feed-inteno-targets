# Meta package support
ASTERISK_PACKAGES:=asterisk18-mod asterisk18-mod-app-playtones asterisk18-mod-app-read \
asterisk18-mod-app-system asterisk18-mod-app-transfer \
asterisk18-mod-chan-brcm asterisk18-mod-codec-a-mu asterisk18-mod-codec-alaw \
asterisk18-mod-codec-g722 asterisk18-mod-codec-g726 \
asterisk18-mod-format-g726 asterisk18-mod-format-g729 asterisk18-mod-format-sln \
asterisk18-mod-format-sln16 asterisk18-mod-func-channel asterisk18-mod-func-db \
asterisk18-mod-func-shell asterisk18-mod-pbx-spool asterisk18-mod-res-stun \
asterisk18-mod-res-voice asterisk18-mod-sounds

VOICE_SUPPORT:=voice-client endptcfg $(ASTERISK_PACKAGES) juci-inteno-voice-client
DECT_SUPPORT:=dectmngr2 juci-natalie-dect

define Profile/dg400
  NAME:=dg400
  PACKAGES:=$(VOICE_SUPPORT) $(DECT_SUPPORT)
endef

define Profile/dg400/Config
select BCM_ENDPOINT_MODULE
select TARGET_NO_DECT
endef

define Profile/dg400/Description
	dg400 profile
endef

$(eval $(call Profile,dg400))


