# OrangeFox device tree for mikona devices (Xiaomi Mi 11X / Redmi K40 / POCO F3 (alioth) and POCO F4 / Redmi K40S (munch))
This tree is for building OrangeFox Recovery for the _mikona_ platform: Xiaomi Mi 11X / Redmi K40 / POCO F3 and POCO F4 / Redmi K40S

The Xiaomi Mi 11X (codenamed _"aliothin"_), Redmi K40 / POCO F3 (codenamed _"alioth"_) and POCO F4 / Redmi K40S (codenamed _"munch"_) are mid range smartphones from Xiaomi.

## Other mikona devices
Other _mikona_ devices include Xiaomi Mi 10S (_thyme_) and Xiaomi 12X (_psyche_). This tree cannot be used to build for these devices because it lacks device-specific kernels for them.

# Device specifications

| Device       | Xiaomi Mi 11X / Redmi K40 / POCO F3 / POCOF4 / Redmi k40S  |
| -----------: | :----------------------------------------------------------|
| SoC          | Qualcomm SM8250 Snapdragon 870 5G                          |
| CPU          | 8x Qualcomm® Kryo™ 585 up to 2.84GHz                       |
| GPU          | Adreno 650                                                 |
| Memory       | 8GB / 6GB  (LPDDR 5)                                       |
| Shipped Android version | 11 (_alioth_) & 12 (_munch_)                    |
| Storage      | 128GB  (UFS 3.1)                                           |
| Battery      | Li-Po 4520 mAh, non-removable                              |
| Dimensions   | 163.7 x 76.4 x 7.8 mm                                      |
| Display      | 1080 x 2400 (20:9), 6.67 inches                            |

## Features

**Works**

- Booting.
- **Decryption** (Android 12+)
- ADB
- MTP
- OTG
- vA/B partition functions
- Vibration

POCO F3 and POCO F4 use a Virtual A/B Partition Scheme!

## Building

You can find a full compile guide for OrangeFox [Here](https://wiki.orangefox.tech/en/dev/building)

_Lunch_ command :

For **alioth** :
```
lunch twrp_alioth-eng && mka adbd bootimage
```
For **munch** :
```
lunch twrp_munch-eng && mka adbd bootimage
```


## Credits
- [Original alioth tree by Nebrassy](https://github.com/TeamWin/android_device_xiaomi_alioth)
- [Kernel for alioth](https://github.com/AOSPA/android_kernel_xiaomi_sm8250.git)
