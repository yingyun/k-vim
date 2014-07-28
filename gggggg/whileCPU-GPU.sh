#20130609: Initial version
#Cui, Yingyun
#Simple tool to observer cpu cluster and gpu freq tranlation
	
while true;
	do
		cpu0_freq=$(adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
		gpu_util=$(adb shell cat /sys/module/pvrsrvkm/parameters/sgx_gpu_utilization)
		gpu_freq=$(adb shell cat /sys/module/pvrsrvkm/parameters/sgx_gpu_clk)
#		cpu1_freq=$(cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq)
#		cpu2_freq=$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq)
#		cpu3_freq=$(cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq)
		#cpu_temp=$(cat /sys/class/hwmon/hwmon0/temp1_input)
#		echo $gpu_freq $cpu0_freq $cpu1_freq $cpu2_freq $cpu3_freq $gpu_util $cpu_temp
		echo $gpu_freq $gpu_util
		sleep 1
	done
