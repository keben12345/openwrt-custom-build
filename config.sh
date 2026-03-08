#!/bin/bash
set -e

cd openwrt

echo "create WR720N v3 dts..."
mkdir -p target/linux/ath79/dts
cp ../dts/ar9331_tplink_tl-wr720n-v3.dts target/linux/ath79/dts/

echo "add device mk..."
cat >> target/linux/ath79/image/tiny-tp-link.mk << 'EOF'

define Device/tplink_tl-wr720n-v3
  SOC := ar9331
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  IMAGE_SIZE := 15872k
  TPLINK_HWID := 0x07030101
  DEVICE_PACKAGES := \
    kmod-usb-core \
    kmod-usb-uhci \
    kmod-usb-ohci \
    kmod-usb-printer \
    p910nd \
    luci \
    luci-i18n-base-zh-cn
  FIRMWARES := factory sysupgrade
endef
TARGET_DEVICES += tplink_tl-wr720n-v3
EOF

echo "create .config..."
cat > .config << 'EOF'
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_tiny=y
CONFIG_TARGET_ath79_tiny_DEVICE_tplink_tl-wr720n-v3=y

CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y

CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
EOF
