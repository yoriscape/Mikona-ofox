#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH=device/xiaomi/mikona

# Inherit from munch device
$(call inherit-product, device/xiaomi/mikona/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Release name
PRODUCT_RELEASE_NAME := munch

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := twrp_munch
PRODUCT_DEVICE := mikona
PRODUCT_BRAND := POCO
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := POCO F4

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
#