#2012 12.10 first vetsion; Just simply copy symbol from jb-Viskan
egl_from=/home/CORPUSERS/xp011356/SonyEricsson/jb-Viskan/out/target/product/huashan/symbols/system/lib/egl/*
hw_from=/home/CORPUSERS/xp011356/SonyEricsson/jb-Viskan/out/target/product/huashan/symbols/system/lib/hw/*
common_from=/home/CORPUSERS/xp011356/SonyEricsson/jb-Viskan/out/target/product/huashan/symbols/system/lib/*
bin_from=/home/CORPUSERS/xp011356/SonyEricsson/jb-Viskan/out/target/product/huashan/symbols/system/bin/*

to=/home/CORPUSERS/xp011356/T32_debug_symbol/


#Copy

echo "---> Copy EGL library"
cp $egl_from $to

echo "---> Copy HW library"
cp $hw_from $to

echo "---> Copy common library"
cp $common_from $to

echo "---> Copy bin "
cp $bin_from $to

echo "---> Done <---"
