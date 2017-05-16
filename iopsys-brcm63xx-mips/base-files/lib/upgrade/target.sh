
# This file must be sourced after common.sh to override defaults!



#--------------------------------------------------------------
get_chip_id() {
	local chip_id=$(brcm_fw_tool -k info)
	case $chip_id in
		6313?)  echo 63138 ;;
		*)      echo $chip_id ;;
	esac
}



#--------------------------------------------------------------
find_mtd_no() {
	local part=$(awk -F: "/\"$1\"/ { print \$1 }" /proc/mtd)
	echo ${part##mtd}
}



#--------------------------------------------------------------
write_cfe() {
	local from=$1
	local ofs=$2
	local size=$3
	local skip

	# Binary patch next CFE with current nvram0(?)
	local mtd_no=$(find_mtd_no "nvram")
	case $(get_chip_id) in
		63138)
			skip=$((65536+1408))
			;;
		*)
			skip=1408
			;;
	esac
	dd if=/dev/mtd$mtd_no bs=1 count=1k skip=$skip \
		of=$from seek=$(( $ofs + $skip )) conv=notrunc

	imagewrite -c -k $ofs -l $size /dev/mtd$mtd_no $from
}



#--------------------------------------------------------------
target_upgrade() {
	local from=$1
	local cfe_ofs cfe_sz nvram_ofs nvram_sz k_ofs k_sz
	local ubi_ofs ubi_sz ubifs_ofs ubifs_sz
	local cur_vol cur_mtd upd_vol upd_mtd seqn

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

	if [ $(( $ubi_ofs + $ubi_sz )) -gt \
		$(ls -l $from |awk '{print $5}') ]; then
		echo "Image file too small, upgrade aborted!" >&2
		return 1
	fi

	if [ $k_sz -gt 0 -a $ubifs_sz -gt 0 -o $k_sz -gt 0 -a $ubi_sz -gt 0 ]; then

		# Kernel + filesystem upgrade

		if [ $cfe_sz -gt 0 ]; then
			v "Writing CFE image to nvram (boot block) partition ..."
			write_cfe $from $cfe_ofs $cfe_sz
		fi

		if grep -q "ubi:rootfs_" /proc/cmdline; then							# TODO: extract to method brcm_mips_ubi_upgrade()
		
			# Upgrade for ubi flash layout

			if grep -q "ubi:rootfs_0" /proc/cmdline; then
				cur_vol=0
				upd_vol=1
			else
				cur_vol=1
				upd_vol=0
			fi

			upd_mtd=$(find_mtd_no "kernel_$upd_vol")
			v "Erasing old kernel in /dev/mtd$upd_mtd (kernel_${upd_vol})..."
			imagewrite /dev/mtd$upd_mtd || return 1

			grep -q ubi0_$upd_vol /proc/mounts && umount -f /dev/ubi0_$upd_vol
			if [ $ubi_sz -gt 0 ]; then
				v "Writing UBI data to rootfs_$upd_vol volume ..."
				ubifs_sz=$(deubinize -p 128KiB -n rootfs_0 \
					--length=$ubi_sz --skip=$ubi_ofs $from |\
					wc -c)
				deubinize -p 128KiB -n rootfs_0 \
					--length=$ubi_sz --skip=$ubi_ofs $from |\
					ubiupdatevol /dev/ubi0_$upd_vol \
						--size=$ubifs_sz - \
					|| return 1
			else
				v "Writing UBIFS data to rootfs_$upd_vol volume ..."
				ubiupdatevol /dev/ubi0_$upd_vol \
					--size=$ubifs_sz --skip=$ubifs_ofs $from \
					|| return 1
			fi

			# Get mtd number of current kernel
			cur_mtd=$(find_mtd_no "kernel_$cur_vol")

			# Get sequence number of current kernel
			seqn=$(brcm_fw_tool -s -1 update /dev/mtd$cur_mtd)

			# Write next sequnece number into image file (brcm_fw_tool
			# bumps it internaly).
			brcm_fw_tool -s $seqn -W $k_ofs -Z $k_sz update $from

			# Write image file to flash
			v "Writing kernel image to /dev/mtd$upd_mtd (kernel_${upd_vol}) partition ..."
			imagewrite -c -k $k_ofs -l $k_sz /dev/mtd$upd_mtd $from

			v "Setting bootline parameter to boot from newly flashed image..."
			brcm_fw_tool -u 0 set
			v "New software upgrade count: $((seqn + 1))"
		fi
	else
		echo "Unexpected image file contents, upgrade aborted!" >&2
		return 1
	fi
}
