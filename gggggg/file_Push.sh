if test $# -eq 0 ; then
	echo "Please enter File Name which you want to upload"
	return
fi

adb root
sleep 1
adb remount
echo "Start to upload, Be Patient, let it go."
adb push $1 /mnt/sdcard/Sync_File
echo "---Upload Done, Show the remote file list---"
adb shell ls -l /mnt/sdcard/Sync_File

