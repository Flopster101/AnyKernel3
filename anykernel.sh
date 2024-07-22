# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=CaraKernel Milestone 19 for Ginkgo | @Flopster101
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=ginkgo
device.name2=willow
device.name3=
device.name4=
device.name5=
supported.versions=11.0-14.0
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel boot install
split_boot;

# Retrofit dynamic partitions
if [ -d "/dev/block/mapper" ]; then
    blockdev --setrw /dev/block/mapper/system
    blockdev --setrw /dev/block/mapper/vendor
	ui_print "Patching for dynamic partitions..."
    patch_cmdline "plain_partitions" ""
else
	ui_print "Patching for plain partitions..."
    patch_cmdline "plain_partitions" "plain_partitions"
fi

ui_print "Mounting /vendor..."
mount -o rw,remount /vendor

# Remove forced zram algorithm setting
remove_line "/vendor/etc/init/hw/init.ginkgo.rc" "comp_algorithm" "global"
ui_print "Patching init.ginkgo.rc done!"

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

# end ramdisk changes

flash_boot;
flash_dtbo;
## end boot install


# shell variables
#block=vendor_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for vendor_boot patching
#reset_ak;


## AnyKernel vendor_boot install
#split_boot; # skip unpack/repack ramdisk since we don't need vendor_ramdisk access

#flash_boot;
## end vendor_boot install

