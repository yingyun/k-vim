#!/usr/bin/perl

while(1)
{
    $gpu3d = `adb shell cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/gpubusy`;
    $gpu3dclk = `adb shell cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/gpuclk`;
	$gpu2d0 = `adb shell cat  /sys/devices/platform/kgsl-2d0.0/kgsl/kgsl-2d0/gpubusy`;
	$gpu2d1 = `adb shell cat  /sys/devices/platform/kgsl-2d1.1/kgsl/kgsl-2d1/gpubusy`;
	$cpu0clk = `adb shell cat  /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`;
	$cpu1clk = `adb shell cat  /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq`;	
	$cpu2clk = `adb shell cat  /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq`;
	$cpu3clk = `adb shell cat  /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq`;	
	$cpubusy = `adb shell cat  /proc/stat`;	

	$pct = 0.0;
	if( $gpu3d =~ m/\s*(\d+)\s+(\d+)/)
	{
		if( $1 > 0  && $2 > 0 )
		{
			$pct = $1 / $2 * 100;
		}
	    printf("3D GPU Busy: %5.2f\%    ", $pct);
	}
	$pct = 0.0;
	if( $gpu2d0 =~ m/\s*(\d+)\s+(\d+)/)
	{
		if( $1 > 0  && $2 > 0 )
		{
			$pct = $1 / $2 * 100;
		}
	    printf("2D_0 GPU Busy: %5.2f\%   ", $pct);
	}
	$pct = 0.0;
	if( $gpu2d1 =~ m/\s*(\d+)\s+(\d+)/)
	{
		if( $1 > 0  && $2 > 0 )
		{
			$pct = $1 / $2 * 100;
		}
	    printf("2D_1 GPU Busy: %5.2f\%   ", $pct);
	}
	$pct = 0.0;	
	if( $gpu3dclk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000000;
		}
	    printf("3D GPU Clock: %5.2f MHz   ", $pct);
	}
	$pct = 0.0;	
	if( $cpu0clk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000000;
		}
	    printf("CPU0 Clock: %5.2f GHz   ", $pct);
	}
	$pct = 0.0;	
	if( $cpu1clk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000000;
		}
	    printf("CPU1 Clock: %5.2f GHz   ", $pct);
	}
	$pct = 0.0;	
	if( $cpu2clk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000000;
		}
	    printf("CPU2 Clock: %5.2f GHz   ", $pct);
	}
	$pct = 0.0;	
	if( $cpu3clk =~ m/\s*(\d+)/)
	{
		if( $1 > 0 )
		{
			$pct = $1 / 1000000;
		}
	    printf("CPU3 Clock: %5.2f GHz   ", $pct);
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

#	sleep 1;
}

