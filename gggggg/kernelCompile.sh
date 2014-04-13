#hayabusa dcm
#. ./kernel-build-sin.sh hayabusa_dcm /home/CORPUSERS/28851301/SonyEricsson/Blue/device/semc/blue/fsconfig-16GB.xml

#huashan
#. ./kernel-build-sin.sh huashan ~/SonyEricsson/jb-Viskan/device/semc/viskan/fsconfig-16GB.xml

#Meizu MX3
echo "Change to M65 kernel directory"
cd /home/yingyun/code/linux-3.4.5-m65/trunk
echo "rebuild config"
rm .config
make ARCH=arm CROSS_COMPILE=arm-eabi- m6x_v31_eng_defconfig
#make ARCH=arm CROSS_COMPILE=arm-eabi- m65_v3_eng_defconfig
make -j4 ARCH=arm CROSS_COMPILE=arm-eabi-
echo "copy to Android out directory"
cp arch/arm/boot/zImage /home/yingyun/code/4.21-Flyme3.0/trunk/out/target/product/mx3/zImage-yingyun

echo "Backup original zImage as zImage-back"
mv /home/yingyun/code/4.21-Flyme3.0/trunk/out/target/product/mx3/zImage /home/yingyun/code/4.21-Flyme3.0/trunk/out/target/product/mx3/zImage-back

#compile module 
#make -C /home/yingyun/code/linux-3.4.5-m65/trunk M='/home/yingyun/code/gggggg/gator/5.11-gator/driver-src/gator-driver' ARCH=arm CROSS_COMPILE=arm-eabi- modules
#gator usage
#put the module and daemon on the same dir, type ./gatord -m /data/gator.ko -p 5779 &
