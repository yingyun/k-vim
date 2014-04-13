while true;
do
	#sleep 1
#	adb shell cat /proc/interrupts | head
#	adb shell cat /proc/meminfo 
#	adb shell procrank | head
	adb shell cat /proc/23865/status
done
