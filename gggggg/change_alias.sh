if [ ! -d "/data/bin" ]; then
mkdir /data/bin
/data/busybox --install -s /data/bin/
echo "Creat /data/bin"
fi

export PATH="$PATH:/data/bin"
echo $PATH


alias sl='ls -l'
alias ls='ls -l'
alias la='ls -al'
alias c='/data/busybox clear'
alias top='/data/busybox top'
alias ss='stop && start'
alias ps='ps -t -p -P'

#Gfx debug
alias dsf='dumpsys SurfaceFlinger'
alias dsw='dumpsys window'
alias showSF='ps | grep surfaceflinger'

#Show information
alias pm_list_package='pm list packages'

#Frequency Debug
alias cg='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'
alias cf='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq'
alias cc='cd /sys/devices/system/cpu/cpu0/cpufreq/'
alias sf='echo 1200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed'
alias sg='echo userspace > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'

#SF feature enable
alias enableDaltonizer='service call SurfaceFlinger 1014 i32 13'
alias disableDaltonizer='service call SurfaceFlinger 1014 i32 0'
alias enableBlurGlassForce='service call SurfaceFlinger 1024 i32 1'
alias disableBlurGlassForce='service call SurfaceFlinger 1024 i32 0'

#CTS test
alias cts_choreographer='am instrument -e class android.view.cts.ChoreographerTest  -w com.android.cts.view/android.test.InstrumentationCtsTestRunner'

echo "Apply alias keyword"


#Enable KGTP
#/data/busybox nc -l -p 1234 < /sys/kernel/debug/gtp > /sys/kernel/debug/gtp &


#Mount Debug FS
mount -t debugfs nodev /sys/kernel/debug

#change USB mount configuration
#setprop persist.sys.usb.config adb
#setprop sys.usb.config adb 
