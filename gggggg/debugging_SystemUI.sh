#20140126 Cui.Yingyun
#Easy build and push to the target
mm  -j10
BUILD_PATH=/home/yingyun/code/kitkat-Flyme/out/target/product/mx3/

adb push $BUILD_PATH/system/priv-app/SystemUI.apk /system/priv-app/
adb shell stop && adb shell start
