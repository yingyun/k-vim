adb forward tcp:1234 tcp:1234
#Vmlinux for hayabusa_dcm
arm-eabi-gdb -ex "set gnutarget elf32-littlearm" -ex "file /home/CORPUSERS/28851301/SonyEricsson/Blue/out/target/product/hayabusa_docomo/obj/KERNEL_OBJ/vmlinux"
#target remote 127.0.0.1:1234
