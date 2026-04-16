#!/usr/bin/env bash
# Copyright (C) 2006 OpenWrt.org

#[ $# == 5 ] || {
#	echo "SYNTAX: $0 <file> <kernel size> <kernel directory> <rootfs size> <rootfs image>"
#	exit 1
#}
echo $1 $2 $3
file="$1"
part1s="$2"
part1d="$3"
part2s="$4"
part2f="$5"
head=16
sect=63
cyl=$(( ($part1s + $part2s) * 1024 * 1024 / ($head * $sect * 512)))

#dd if=/dev/zero of="$file" bs=1M count=$(($part1s + $part2s - 1))  2>/dev/null || exit
# create partition table
rm -f $file

which ptgen
set `./image-tools/ptgen -o "$file" -h $head -s $sect -p ${part1s}m -p ${part2s}m`

KERNELOFFSET="$(($1 / 512))"
KERNELSIZE="$(($2 / 512))"
ROOTFSOFFSET="$(($3 / 512))"
ROOTFSSIZE="$(($4 / 512))"
BLOCKS="$((($KERNELSIZE / 2) - 1))"
echo  ./image-tools/fatfs-tool -i image-tools/fat32.img mkfs
./image-tools/fatfs-tool -i image-tools/fat32.img mkfs
echo ./image-tools/fatfs-tool -i image-tools/fat32.img cp $part1d / 
./image-tools/fatfs-tool -i image-tools/fat32.img cp $part1d /
echo dd if="image-tools/fat32.img" of="$file" bs=512 seek="${KERNELOFFSET}" conv=notrunc

dd if="image-tools/fat32.img" of="$file" bs=512 seek="${KERNELOFFSET}" conv=notrunc
echo dd if="$part2f" of="$file" bs=512 seek="${ROOTFSOFFSET}" conv=notrunc
dd if="$part2f" of="$file" bs=512 seek="${ROOTFSOFFSET}" conv=notrunc

