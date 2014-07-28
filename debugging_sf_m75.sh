#Easy debug SurfaceFliner on MTK platform
adb remount
BUILD_PATH=out/target/product/m75/
./makeMtk -t m75 mm frameworks/native/services/surfaceflinger/ && adb push $BUILD_PATH/system/lib/libsurfaceflinger.so /system/lib/ && adb push $BUILD_PATH/system/bin/surfaceflinger /system/bin/ && adb shell stop && adb shell start && adb logcat -c && adb logcat -s SurfaceFlinger
