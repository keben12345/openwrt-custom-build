#!/bin/bash

cd openwrt

echo "Add WR720N DTS"

cp ../dts/ar9331_tplink_tl-wr720n-v3.dts target/linux/ath79/dts/

echo "Add device definition"

cat >> target/linux/ath79/image/tiny-tp-link.mk << 'EOF'

define Device/tplink_tl-wr720n-v3
  SOC := ar9331
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  IMAGE_SIZE := 15872k
  DEVICE_PACKAGES := \
        kmod-usb2 \
        kmod-usb-ohci \
        kmod-usb-storage \
        kmod-usb-printer \
        kmod-fs-ext4 \
        kmod-fs-vfat \
        block-mount \
        samba4-server \
        p910nd
endef
TARGET_DEVICES += tplink_tl-wr720n-v3

EOF

echo "Create config"

cat >> .config << EOF

CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_tiny=y
CONFIG_TARGET_ath79_tiny_DEVICE_tplink_tl-wr720n-v3=y

CONFIG_PACKAGE_luci=y

CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-printer=y

CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_kmod-fs-ext4=y
CONFIG_PACKAGE_kmod-fs-vfat=y

CONFIG_PACKAGE_samba4-server=y

CONFIG_PACKAGE_p910nd=y

EOF

make defconfig
