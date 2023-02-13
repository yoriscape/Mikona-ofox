#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2021-2023 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
FDEVICE="mikona"
FDEVICE1="alioth"
FDEVICE2="munch"
FDEVICE3="thyme"
FDEVICE4="psyche"
THIS_DEVICE=${BASH_ARGV[2]}

#set -o xtrace
fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w \"$FDEVICE\")
   if [ -n "$chkdev" ]; then 
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w \"$FDEVICE\")
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$FOX_BUILD_DEVICE" ]; then
   echo "ERROR! First run 'export FOX_BUILD_DEVICE=alioth' or 'export FOX_BUILD_DEVICE=munch' and then build again."
fi

if [ "$THIS_DEVICE" = "alioth" -o "$THIS_DEVICE" = "munch" ]; then
	FDEVICE="$THIS_DEVICE"
	[ -z "$FOX_BUILD_DEVICE" ] && FOX_BUILD_DEVICE="$THIS_DEVICE"
fi

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" -a -z "$FDEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE1"  -o "$FOX_BUILD_DEVICE" = "$FDEVICE2" ]; then
	export OF_USE_GREEN_LED=0
    	export FOX_ENABLE_APP_MANAGER=1
    	export OF_IGNORE_LOGICAL_MOUNT_ERRORS=1
   	export TW_DEFAULT_LANGUAGE="en"
	export LC_ALL="C"
 	export ALLOW_MISSING_DEPENDENCIES=true
	export OF_VIRTUAL_AB_DEVICE=1
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
	export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
	export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
	export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_SED_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export OF_ENABLE_LPTOOLS=1
	export FOX_USE_NANO_EDITOR=1
    	export OF_QUICK_BACKUP_LIST="/boot;/data;"
    	export FOX_DELETE_AROMAFM=1
    	export FOX_BUGGED_AOSP_ARB_WORKAROUND="1616300800"; # Sun 21 Mar 04:26:40 GMT 2021

    	# Device Specific Props
 	if [ "$FOX_BUILD_DEVICE" = "$FDEVICE2" -o  "$FDEVICE" = "$FDEVICE2" ]; then
    	   echo "Device is $FDEVICE2 ..."
 	else
    	   echo "Device is alioth ..."
	   export TARGET_DEVICE_ALT="aliothin"
 	fi

	# screen settings
	export OF_SCREEN_H=2400
	export OF_STATUS_H=100
	export OF_STATUS_INDENT_LEFT=48
	export OF_STATUS_INDENT_RIGHT=48
  	export OF_HIDE_NOTCH=1
	export OF_CLOCK_POS=1

	# ensure that /sdcard is bind-unmounted before f2fs data repair or format
	export OF_UNBIND_SDCARD_F2FS=1

	# instruct magiskboot v24+ to always patch the vbmeta header when patching the recovery/boot image; do *not* remove!
        export OF_PATCH_VBMETA_FLAG="1"

	# no special MIUI stuff
        export OF_VANILLA_BUILD=1
        export OF_DISABLE_OTA_MENU=1

	# full size
	export OF_DYNAMIC_FULL_SIZE=9126805504

	# let's see what are our build VARs
	if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
  	   export | grep "FOX" >> $FOX_BUILD_LOG_FILE
  	   export | grep "OF_" >> $FOX_BUILD_LOG_FILE
   	   export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
  	   export | grep "TW_" >> $FOX_BUILD_LOG_FILE
 	fi
fi
#
