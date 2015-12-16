
define Profile/inteno
  NAME:=Inteno
  PACKAGES:=bcmkernel bcmhotproxy brcm-base-files iopsys-base-files natalie-dect 
  CONFIG=KEN_CONFA
endef

define Profile/inteno/Config
config	TARGET_CUSTOMER
	string
	default "INT" if TARGET_iopsys_brcm63xx_mips_dg301_inteno
endef

define Profile/inteno/Description
        Inteno base config for DG301.
endef

$(eval $(call Profile,inteno))
