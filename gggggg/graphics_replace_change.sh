#!/bin/sh
#Author:yingyun.cui@borqs.com
#2011-5-1 add new feature :Improve script struct stable
#
#yingyun.cui@sonymobile.com
#2012-6-29 change to graphics realated stuff

#Specific File
replaceHWcomposer=hwcomposer.msm8960.so                #0
replaceSurfaceFlinger=libsurfaceflinger.so             #1
replaceGralloc=gralloc.msm8960.so                      #2
replaceLibUI=libui.so				       #3
replaceOverlay=liboverlay.so                           #4

#For hayabusa
#replaceLocationPrefixProduct=/home/CORPUSERS/28851301/SonyEricsson/Blue/out/target/product/hayabusa

#For hayabusa_docomo
replaceLocationPrefixProduct=/home/CORPUSERS/28851301/SonyEricsson/Blue/out/target/product/hayabusa_docomo

#For mint
#replaceLocationPrefixProduct=/home/CORPUSERS/28851301/SonyEricsson/Blue/out/target/product/mint

targetReplacePrefixLibHW=system/lib/hw
targetReplacePrefixLib=system/lib
targetReplacePrefixBin=system/bin

mRplacBIN=false
mRplacSO=false
mRplacSOHW=false

usage() {
echo " Usage:MSM graphics related replace tool"
echo " --->0   replace for HWcomposer"
echo " --->1   replace for SurfaceFligner"
echo " --->2   replace for Gralloc"
echo " --->3   replace for LibUI"
echo " --->4   replace for LibOverlay"
}

if   test $# -eq 0 ; then
	usage
	return
elif test $1 -eq 0 ; then
	mRplacSOFile=$replaceHWcomposer
	mRplacSOHW=true
elif test $1 -eq 1 ; then
	mRplacSOFile=$replaceSurfaceFlinger
	mRplacSO=true
elif test $1 -eq 2 ; then
	mRplacSOFile=$replaceGralloc
	mRplacSOHW=true
elif test $1 -eq 3 ; then
	mRplacSOFile=$replaceLibUI
	mRplacSO=true
elif test $1 -eq 4 ; then
	mRplacSOFile=$replaceOverlay
	mRplacSO=true
fi


echo "Current product is [$replaceLocationPrefixProduct]"

#change the property
echo "Change phone's property"
adb root
sleep 2
adb remount

#Below is binaryfile Part
if $mRplacBIN ; then
echo "bin file"
echo "Remove the old bin [$mRplacBINFile] file"
adb shell rm $targetReplacePrefixBin/$mRplacBINFile
echo "Push the new bin [$mRplacBINFile] file"
adb push $replaceLocationPrefixProduct/$targetReplacePrefixBin/$mRplacBINFile $targetReplacePrefixBin
fi

#Below is libarary
if $mRplacSO; then
echo "Remove the old [$mRplacSOFile] file"
adb shell rm $targetReplacePrefixLib/$mRplacSOFile
echo "Push the new [$mRplacSOFile] file"
adb push $replaceLocationPrefixProduct/$targetReplacePrefixLib/$mRplacSOFile $targetReplacePrefixLib
fi

#Below is HW libarary
if $mRplacSOHW; then
echo "Remove the old [$mRplacSOFile] file"
adb shell rm $targetReplacePrefixLibHW/$mRplacSOFile
echo "Push the new [$mRplacSOFile] file"
adb push $replaceLocationPrefixProduct/$targetReplacePrefixLibHW/$mRplacSOFile $targetReplacePrefixLibHW
fi

echo "-Done-"
echo "rebooting now....."
adb reboot

#Will_Kill_PID=`adb shell ps | grep mediaserver | cut -d" " -f6`
#echo "Will be killled $Will_Kill_PID PID for mediaserver"
#adb shell kill $Will_Kill_PID

#New_PID=`adb shell ps | grep mediaserver | cut -d" " -f6`
#echo "The new mediaserver PID is $New_PID"
#fi
