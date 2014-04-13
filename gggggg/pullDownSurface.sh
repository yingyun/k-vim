#Simple Tool 
#2012-6 Convert Framebuffer to the dividual screen just available on Blue platform
#2012-7 Add support to dump each layer in which SF create via gralloc
#Maker:Cui,Yingyun
#

usage() {
	echo "Enter 1 to dump FB with Raw data"
	echo "Enter 2 to dump Each layer, need your dir name what you want to dump in host,it also do FB dump"
	
	echo "~Enjoy:)~"
}

dumpFB() {
#Celar previous grabage
rm -rf FB-1.*
rm -rf FB-2.*
rm -rf FB-3.*

adb pull /dev/graphics/fb0 frame_buffer 
echo "-> Pull frame buffer dump Done"

split -b 3768320 frame_buffer
echo "-> Spilit Done"

convert -depth 8 -size "736x1280" rgba:xaa -channel BGR -separate -combine FB-1.png
convert -depth 8 -size "736x1280" rgba:xab -channel BGR -separate -combine FB-2.png
convert -depth 8 -size "736x1280" rgba:xac -channel BGR -separate -combine FB-3.png
echo "-> Convert Done"

mv xaa FB-1.raw
mv xab FB-2.raw
mv xac FB-3.raw

#Clear
rm -rf frame_buffer
echo "-> Clear Done"
}

#Main Function
if   test $# -eq 0 ; then 
	usage
	return  
elif test $1 -eq 1 ; then  
	dumpFB
	return
elif test $1 -eq 2 ; then  
	if test $# -eq 1 ; then
		echo "Enter your dir what you want to create"
		return 
	fi

	dirName=$2
	echo "Create $dirName under PWD"
	adb shell setprop debug.layer.dump 1
	adb shell setprop debug.layer.dir.dump $dirName
	mkdir ./$dirName
	echo "Let's dump..."
	adb shell dumpsys SurfaceFlinger
	adb pull /data/$dirName ./$dirName
	echo "clear remote"
	adb shell rm -r /data/$dirName

	echo "Time to dump FB with raw data"
	dumpFB
	mv FB-1.* ./$dirName
	mv FB-2.* ./$dirName
	mv FB-3.* ./$dirName
	
#recover setprop
	adb shell setprop debug.layer.dump 0
	
	return 

fi
