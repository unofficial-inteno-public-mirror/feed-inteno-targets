
define Profile/inteno
  NAME:=Inteno
  PACKAGES:=bcmkernel bcmhotproxy layer2interface
  CONFIG=KEN_CONFA
endef


define Profile/inteno/Description
        Inteno base config for DG301.
endef

$(eval $(call Profile,inteno))
