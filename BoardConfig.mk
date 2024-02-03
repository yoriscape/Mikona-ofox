#
# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2022-2024 The OrangeFox Recovery Project
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a76
TARGET_CPU_VARIANT_RUNTIME := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a55
TARGET_2ND_CPU_VARIANT_RUNTIME := kryo385

ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true
TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_IS_64_BIT := true

BOARD_VENDOR := xiaomi

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := mikona
PRODUCT_PLATFORM := kona
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Platform
TARGET_BOARD_PLATFORM := xiaomi_sm8250
TARGET_BOARD_PLATFORM_GPU := qcom-adreno650
QCOM_BOARD_PLATFORMS += xiaomi_sm8250
BOARD_USES_QCOM_HARDWARE := true

# asserts
ifeq ($(PRODUCT_RELEASE_NAME),munch)
   TARGET_OTA_ASSERT_DEVICE := munch
   BOARD_RAMDISK_OFFSET := 0x02000000
else
   TARGET_OTA_ASSERT_DEVICE := alioth,aliothin
   BOARD_RAMDISK_OFFSET := 0x01000000
endif

# Kernel
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_BASE          := 0x00000000
BOARD_KERNEL_TAGS_OFFSET   := 0x00000100
BOARD_KERNEL_OFFSET        := 0x00008000
BOARD_KERNEL_SECOND_OFFSET := 0x00f00000
BOARD_DTB_OFFSET           := 0x01f00000
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CLANG_COMPILE := true
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

# cmdline
VENDOR_CMDLINE := console=ttyMSM0,115200n8 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000
VENDOR_CMDLINE += msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 loop.max_part=7 cgroup.memory=nokmem,nosocket reboot=panic_warm
VENDOR_CMDLINE += androidboot.selinux=permissive androidboot.init_fatal_reboot_target=recovery

# header & cmdline
ifeq ($(FOX_VENDOR_BOOT_RECOVERY),1)
  BOARD_BOOT_HEADER_VERSION := 4
  BOARD_MKBOOTIMG_ARGS += --vendor_cmdline "$(VENDOR_CMDLINE)"
else
  BOARD_KERNEL_CMDLINE := $(VENDOR_CMDLINE)
  BOARD_BOOT_HEADER_VERSION := 3
endif

# other mbootimg arguments
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --second_offset $(BOARD_KERNEL_SECOND_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE) --board ""

# Kernel
# whether to do an inline build of the kernel sources [broken for vendor_boot targets]
ifeq ($(FOX_BUILD_FULL_KERNEL_SOURCES),1)
    TARGET_KERNEL_SOURCE := kernel/xiaomi/$(PRODUCT_RELEASE_NAME)
    TARGET_KERNEL_CONFIG := vendor/$(PRODUCT_RELEASE_NAME)-fox_defconfig
    TARGET_KERNEL_CLANG_COMPILE := true
    KERNEL_SUPPORTS_LLVM_TOOLS := true
    TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-gnu-
    # clang-r383902 = 11.0.1; clang-r416183b = 12.0.5; clang-r416183b1 = 12.0.7;
    # clang_13.0.0 (proton-clang 13.0.0, symlinked into prebuilts/clang/host/linux-x86/clang_13.0.0); clang-13+ is needed for Arrow-12.1 kernel sources
    TARGET_KERNEL_CLANG_VERSION := 13.0.0
    TARGET_KERNEL_CLANG_PATH := $(shell pwd)/prebuilts/clang/host/linux-x86/clang-$(TARGET_KERNEL_CLANG_VERSION)
    TARGET_KERNEL_ADDITIONAL_FLAGS := DTC_EXT=$(shell pwd)/prebuilts/misc/$(HOST_OS)-x86/dtc/dtc
    LLVM := 1
    LLVM_IAS := 1
else
    KERNEL_PATH := $(DEVICE_PATH)/prebuilt/$(PRODUCT_RELEASE_NAME)
    TARGET_PREBUILT_KERNEL := $(KERNEL_PATH)/Image.gz-dtb
    BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_PATH)/dtbo.img
    BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_PATH)/dtbs
endif

#A/B
BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
AB_OTA_UPDATER := true

# Avb
BOARD_AVB_ENABLE := true
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE:= 100663296

# Dynamic Partition
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
# BOARD_QTI_DYNAMIC_PARTITIONS_SIZ=BOARD_SUPER_PARTITION_SIZE - 4MB
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9122611200
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system product odm system_ext vendor

# System as root
BOARD_ROOT_EXTRA_FOLDERS := bluetooth dsp firmware persist
BOARD_SUPPRESS_SECURE_ERASE := true

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Workaround for error copying vendor files to recovery ramdisk
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
LC_ALL := C

# broken stuff
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_USES_NETWORK := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true # may not really be needed

# TWRP specific build flags
TW_THEME := portrait_hdpi
BOARD_HAS_NO_REAL_SDCARD := true
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := en
TW_INCLUDE_NTFS_3G := true
TW_USE_TOOLBOX := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_DEFAULT_BRIGHTNESS := 750
TW_MAX_BRIGHTNESS := 2047
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TARGET_USES_MKE2FS := true
TW_NO_SCREEN_BLANK := true
TW_EXCLUDE_APEX := true
TW_SUPPORT_INPUT_AIDL_HAPTICS := true

# enable python
TW_INCLUDE_PYTHON := true

# unified script
PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/$(PRODUCT_RELEASE_NAME)/unified-script.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/unified-script.sh

# vendor_boot as recovery?
ifeq ($(FOX_VENDOR_BOOT_RECOVERY),1)
  BOARD_USES_RECOVERY_AS_BOOT :=
  BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE :=
  BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
  BOARD_USES_GENERIC_KERNEL_IMAGE := true
  BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
  ifeq ($(BOARD_BOOT_HEADER_VERSION),4)
      BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
  endif

  ifneq ($(FOX_VENDOR_BOOT_RECOVERY_FULL_REFLASH),1)
  # disable the reflash menu, until all vendor_boot ROMs have a v4 header - else it won't work
      OF_NO_REFLASH_CURRENT_ORANGEFOX := 1
  endif
endif
#
