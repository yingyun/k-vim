while true;
do
	#sleep 1
#	adb shell cat /proc/interrupts | head
	adb shell cat /proc/meminfo 
#	adb shell procrank | head
done
