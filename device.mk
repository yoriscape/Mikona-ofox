#
# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2022-2023 The OrangeFox Recovery Project
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Our various search paths for Soong namespaces
MIKONA_SOONG_PATHS := device/xiaomi/mikona device/xiaomi/alioth device/xiaomi/munch

# Configure base.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Configure core_64_bit_only.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Configure gsi_keys.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Configure Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

PRODUCT_PACKAGES += \
    bootctrl.xiaomi_sm8250.recovery \
    android.hardware.boot@1.1-impl-qti.recovery

# API
PRODUCT_TARGET_VNDK_VERSION := 31
PRODUCT_SHIPPING_API_LEVEL := 30

# frame rate
TW_FRAMERATE := 120

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
	$(MIKONA_SOONG_PATHS) \
	vendor/qcom/opensource/commonsys-intf/display

PRODUCT_USE_DYNAMIC_PARTITIONS := true

# vendor_boot-as-recovery
ifeq ($(FOX_VENDOR_BOOT_RECOVERY),1)

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# -------------------- 20230724: fs compression --------------------
  PRODUCT_FS_COMPRESSION := true
  OF_ENABLE_FS_COMPRESSION := 1
  # this can be used instead of "OF_ENABLE_FS_COMPRESSION"
  PRODUCT_VENDOR_PROPERTIES += vold.has_compress=true

  # compare build/make/target/product/virtual_ab_ota/android_t_baseline.mk (A13 manifest)
  PRODUCT_VIRTUAL_AB_COMPRESSION := true
  PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.compression.enabled=true
  PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.compression.xor.enabled=true
  PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.userspace.snapshots.enabled=true
  PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.io_uring.enabled=true
# -------------------- 20230724: fs compression --------------------

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/fstab-generic.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom
#    $(DEVICE_PATH)/recovery/root/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

PRODUCT_PACKAGES += \
    linker.vendor_ramdisk \
    resize2fs.vendor_ramdisk \
    fsck.vendor_ramdisk \
    tune2fs.vendor_ramdisk
endif
# end: vendor_boot-as-recovery

# A/B
ENABLE_VIRTUAL_AB := true
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot

PRODUCT_PACKAGES += \
    otapreopt_script \
    checkpoint_gc \
    update_engine \
    update_engine_sideload \
    update_verifier

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    android.hardware.fastboot@1.0-impl-mock.recovery \
    fastbootd 

# Qcom decryption
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe

# Crypto
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
BOARD_USES_METADATA_PARTITION := true

# platform
PLATFORM_VERSION := 99.87.36

# Platform security
PLATFORM_SECURITY_PATCH := 2127-12-31

# Last stable
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)

# Vendor security
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Set boot SPL
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Modules
TARGET_RECOVERY_DEVICE_MODULES += libion vendor.display.config@1.0 vendor.display.config@2.0 libdisplayconfig.qti

# Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service

#Display
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/libdisplayconfig.qti.so

# OEM otacert
PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/recovery/security/miui
#
