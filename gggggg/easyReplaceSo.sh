adb root
adb remount 
adb push out/target/product/huashan/system/lib/liboverlay.so /system/lib
adb push out/target/product/huashan/system/lib/libqdutils.so /system/lib
adb push out/target/product/huashan/system/lib/hw/hwcomposer.msm8960.so /system/lib/hw 
adb shell sync 
