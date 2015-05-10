while true;
do
	#sleep 1
#	adb shell cat /proc/interrupts | head
	#adb shell cat /proc/meminfo 
    adb shell am start -W -S  com.meizu.mstore/com.meizu.flyme.appcenter.activitys.AppMainTabActivity
    sleep 1
    adb shell am start -W -S com.meizu.media.music/com.meizu.media.music.MusicActivity
    sleep 1
    adb shell am start -W -S com.meizu.media.video/com.meizu.media.video.VideoMainActivity
    sleep 1
    adb shell am start -W -S com.meizu.flyme.weather/com.meizu.flyme.weather.WeatherMainActivity
    sleep 1
    adb shell am start -W -S com.meizu.flyme.gamecenter/com.meizu.flyme.gamecenter.GameMainTabActivity
    sleep 1
    adb shell am start -W -S com.meizu.customizecenter/com.meizu.customizecenter.CustomizeCenterActivity
    sleep 1
    adb shell am start -W -S com.android.alarmclock/com.meizu.flyme.alarmclock.AlarmClock
    sleep 1
#	adb shell procrank | head
done
