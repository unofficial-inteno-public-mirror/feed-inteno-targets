
# This file must be sourced after common.sh to override OpenWRT defaults!



#--------------------------------------------------------------
get_chip_id() {
	awk '/^system type/ && $5 == "MT7621" { printf "7621" }' /proc/cpuinfo
}



#--------------------------------------------------------------
target_upgrade() {
	local from=$1
	local cfe_ofs cfe_sz nvram_ofs nvram_sz k_ofs k_sz
	local ubi_ofs ubi_sz ubifs_ofs ubifs_sz
	local cur_vol upd_vol mtd_no seqn

	v "Parsing image header..."

	cfe_ofs=1024
	cfe_sz="$(get_inteno_tag_val $from cfe)"
	[ $cfe_sz -gt 0 ] && v "- CFE: offset=$cfe_ofs, size=$cfe_sz"

	k_ofs=$(( $cfe_ofs + $cfe_sz ))
	k_sz="$(get_inteno_tag_val $from vmlinux)"
	[ $k_sz -gt 0 ] && v "- kernel: offset=$k_ofs, size=$k_sz"

	ubifs_ofs=$(( $k_ofs + $k_sz ))
	ubifs_sz="$(get_inteno_tag_val $from ubifs)"
	[ $ubifs_sz -gt 0 ] && v "- ubifs: offset=$ubifs_ofs, size=$ubifs_sz"

	ubi_ofs=$(( $ubifs_ofs + $ubifs_sz ))
	ubi_sz="$(get_inteno_tag_val $from ubi)"
	[ $ubi_sz -gt 0 ] && v "- ubi: offset=$ubi_ofs, size=$ubi_sz"

	if [ $(( $ubi_ofs + $ubi_sz )) -gt $(ls -l $from |awk '{print $5}') ]; then
		echo "Image file too small, upgrade aborted!" >&2
		return 1
	fi

	if [ $cfe_sz -eq 0 -a $k_sz -eq 0 -a $ubifs_sz -gt 0 -a $ubi_sz -eq 0 ] ;then
		# only ubifs -> mediatek image

		# if ub_vol is not same as cur_vol we have an alternative boot.
		# that is something is wrong with primary system. 
		ub_vol=$(fw_printenv -n root_vol)
		cur_vol=$(
			for opt in $(cat /proc/cmdline) ;do 
				case $opt in
					root=*) echo $opt
					;;
				esac;
			done | cut -f 2 -d:)

		case $cur_vol in
			rootfs_0) upd_vol_name=rootfs_1;;
			rootfs_1) upd_vol_name=rootfs_0;;
		esac

		# convert from ubi volume name to ubi id number 
		upd_vol=$(ubinfo -d 0 -N $upd_vol_name | grep "Volume ID:" |awk '{print $3}')

		grep -q ubi0_$upd_vol /proc/mounts && umount -f /dev/ubi0_$upd_vol
		if ubiupdatevol /dev/ubi0_$upd_vol --size=$ubifs_sz --skip=$ubifs_ofs $from; then
			v "wrote filesystem. setting to $upd_vol_name be active system"
			fw_setenv root_vol $upd_vol_name
			# set boot count to 0 as we now have a new system.
			fw_setenv boot_cnt_primary 0
			fw_setenv boot_cnt_alt 0
		else
			v "could not write filesystem to volume"
			return 1
		fi
	else
		echo "Unexpected image file contents, upgrade aborted!" >&2
		return 1
	fi
}

