#Cui, Yingyun MEIZU
#2013-6-6
#Simple tool to observer GPU/CPU clock


#!/usr/bin/perl

while(1)
{
    	$gpu3dclk = `adb shell cat /sys/module/pvrsrvkm/parameters/sgx_gpu_clk`;
	$cpu0clk = `adb shell cat  /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`;
	$cpu1clk = `adb shell cat  /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq`;	
	$cpu2clk = `adb shell cat  /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq`;
	$cpu3clk = `adb shell cat  /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq`;	
	$cpubusy = `adb shell cat  /proc/stat`;	

	$pct = 0.0;	
	if( $gpu3dclk=~ m/\s*(\d+)/)
	{
	    $pct = $1;
	    printf("PowerVR:%8.2fMHz, ", $pct);
	}

	$pct = 0.0;	
	if( $cpu0clk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000;
		}
	    printf("CPU0:%8.2fMHzx, ", $pct);
	}

	$pct = 0.0;	
	if( $cpu1clk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000;
		}
	    printf("CPU1:%8.2fMHz, ", $pct);
	}

	$pct = 0.0;	
	if( $cpu2clk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000;
		}
	    printf("CPU2:%8.2fMHz, ", $pct);
	}
	$pct = 0.0;	
	if( $cpu3clk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000;
		}
	    printf("CPU3:%8.2fMHz, ", $pct);
	}

	$pct = 0.0;	
	if( $cpubusy =~ m/(\d+) (\d+) (\d+) (\d+) (\d+)/)
	{
		$n1 = $1 - $o1;
		$n2 = $2 - $o2;
		$n3 = $3 - $o3;
		$n4 = $4 - $o4;
		$n5 = 0; #$5 - $o5;
		$pct = ($n1 + $n2 + $n3 + $n5) * 100 / ($n1 + $n2 + $n3 + $n4 + $n5);
		printf("cpu busy %5.2f\%", $pct);
		$o1 = $1;
		$o2 = $2;
		$o3 = $3;
		$o4 = $4;
		$o5 = $5;
	}


	printf("\n");

}

