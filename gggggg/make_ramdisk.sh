#! /bin/sh

#Unpack
###############################
mv $1 > ramdisk.img.gz
gunzip ramdisk.img.gz 
cpio -i -F ramdisk.img


#Pack
###############################
