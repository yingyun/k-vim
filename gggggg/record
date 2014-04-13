#!/system/bin/sh
#
# record the temp
#
#
top_dir=/data/ktests
tmp_dir=$top_dir/record/

#Source the PATH variable
#. $top_dir/.bashrc

#recorded temp Path
sys_cpufreq=/sys/devices/system/cpu/cpu0/cpufreq

current_cpufreq=$sys_cpufreq/scaling_cur_freq
cpu_temp_s4=/sys/class/thermal/thermal_zone0/curr_temp
cpu_temp_m65=/sys/class/hwmon/hwmon0/temp1_input
cpu_online=/sys/devices/system/cpu/online

sys_power=/sys/class/power_supply/fuelgauge
battery_temp=$sys_power/temp
battery_current=$sys_power/current_avg
battery_voltage=$sys_power/voltage_avg
bus_mif=/sys/class/devfreq/exynos5-busfreq-mif/cur_freq
bus_int=/sys/class/devfreq/exynos5-busfreq-int/cur_freq
gpu_freq=/sys/module/pvrsrvkm/parameters/sgx_gpu_clk
cpu_load_s4=/sys/devices/system/cpu/cpufreq/ondemand/cpu_utilization
cpu_load_m65=/sys/devices/system/cpu/cpufreq/april/cpu_utilization

if [ -f $cpu_load_s4 ]; then
	cpu_load=$cpu_load_s4
else
	cpu_load=$cpu_load_m65
fi

if [ -f $cpu_temp_s4 ]; then
	cpu_temp=$cpu_temp_s4
else
	cpu_temp=$cpu_temp_m65
fi


#check the path and file
#if [ ! -d $sys_cpufreq ]; then
#	echo "no $sys_cpufreq found,Test fail" && exit 1
#fi

#if [ ! -f $cpu_temp ]; then
#	echo "no $cpu_temp fount, Test fail " && exit 1

#fi

#if [ ! -d $sys_power ] ; then
#	echo "no $sys_power fount ,Test fail" && exit 1

#fi

# creat tmp dir
#[ ! -d $top_dir ] && mkdir $top_dir
#[ ! -d $tmp_dir ] && mkdir $tmp_dir
#[ -f $tmp_dir/recorddata.txt ] && rm $tmp_dir/recorddata.txt

# record the temp
echo "start record the temp"
#cd $tmp_dir


while :;
do
	cpufreq=`cat $current_cpufreq`
	cpuonline=`cat $cpu_online`
	cpuTemp=`cat $cpu_temp`
	batteryTemp=`cat $battery_temp`
	batteryCurrent=`cat $battery_current`
	batteryVoltage=`cat $battery_voltage`
	busMif=`cat $bus_mif`
	busInt=`cat $bus_int`
	gpuFreq=`cat $gpu_freq`
	cpuload=`cat $cpu_load`

	echo "cpufreq: $cpufreq cpuload: $cpuload cpuon: $cpuonline cputemp: $cpuTemp battemp: $batteryTemp batcur: $batteryCurrent batvol: $batteryVoltage busMif: $busMif busInt: $busInt gpuFreq: $gpuFreq" 
#	echo "cpufreq: $cpufreq cpuload: $cpuload cpuon: $cpuonline cputemp: $cpuTemp battemp: $batteryTemp batcur: $batteryCurrent batvol: $batteryVoltage busMif: $busMif busInt: $busInt gpuFreq: $gpuFreq" >> recorddata.txt

	sleep 1
done

exit 1
