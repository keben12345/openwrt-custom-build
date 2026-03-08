#!/bin/bash
set -e

echo "Add WR720N mod device..."

cp dts/ar9331_tplink_tl-wr720n-v3-16m.dts openwrt/target/linux/ath79/dts/

cat >> openwrt/target/linux/ath79/image/generic-tp-link.mk << 'EOF'

define Device/tplink_tl-wr720n-v3-16m
  SOC := ar9331
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3-16M
  IMAGE_SIZE := 15872k
  DEVICE_PACKAGES := \
    kmod-usb2 \
    kmod-usb-ohci \
    kmod-usb-printer \
    p910nd \
    luci \
    luci-i18n-base-zh-cn
  TPLINK_HWID := 0x07030101
endef
TARGET_DEVICES += tplink_tl-wr720n-v3-16m

EOF

echo "Generate .config..."

cat > openwrt/.config << 'EOF'
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_generic=y
CONFIG_TARGET_ath79_generic_DEVICE_tplink_tl-wr720n-v3-16m=y

CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y

CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
EOF

echo "config.sh done."
