while true;
do
	adb shell dumpsys SurfaceFlinger | grep -e Purgatory -e "Total allocated"
#	adb shell dumpsys SurfaceFlinger | -e "Total allocated"
	sleep 1
done
