
define Profile/inteno
  NAME:=Inteno
  PACKAGES:=bcmkernel bcmhotproxy brcm-base-files iopsys-base-files layer2interface
  CONFIG=KEN_CONFA
endef


define Profile/inteno/Description
        Inteno base config for DG301.
endef

$(eval $(call Profile,inteno))
