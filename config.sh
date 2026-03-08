#!/bin/bash
set -e

echo "Create DTS and device config..."

# 复制 DTS
cp dts/ar9331_tplink_tl-wr720n-v3.dts openwrt/target/linux/ath79/dts/

# 添加 device 定义
cat >> openwrt/target/linux/ath79/image/generic-tp-link.mk << 'EOF'

define Device/tplink_tl-wr720n-v3
  SOC := ar9331
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  IMAGE_SIZE := 8192k
  DEVICE_PACKAGES := \
    kmod-usb-core \
    kmod-usb-ohci \
    kmod-usb-printer \
    p910nd \
    luci \
    luci-i18n-base-zh-cn
  TPLINK_HWID := 0x07030101
endef
TARGET_DEVICES += tplink_tl-wr720n-v3
EOF

echo "Generating .config..."

cat > openwrt/.config << 'EOF'
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_generic=y
CONFIG_TARGET_ath79_generic_DEVICE_tplink_tl-wr720n-v3=y

CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y

CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
EOF

echo "config.sh done."
