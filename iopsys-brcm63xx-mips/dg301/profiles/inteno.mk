
define Profile/Inteno
  NAME:=Inteno
  PACKAGES:=bcmkernel bcmhotproxy
  CONFIG=KEN_CONFA
endef

#define Profile/Inteno/config
#        source "$(SOURCE)/Config.in"        
#endif

define Profile/Inteno/Description
        Inteno base config for DG301.
endef

$(eval $(call Profile,Inteno))
