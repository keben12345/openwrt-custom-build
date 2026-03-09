#!/bin/bash
set -e

echo "=== Start DIY patch for WR720N-v3 ==="

# ----------------------------
# 1️⃣ 拷贝 DTS 文件
# ----------------------------
echo "Copy DTS file..."
mkdir -p openwrt/target/linux/ath79/dts/
cp dts/ar9331_tplink_tl-wr720n-v3.dts openwrt/target/linux/ath79/dts/

# ----------------------------
# 2️⃣ 修改 generic-tp-link.mk 生成 16MB 固件
# ----------------------------
GENERIC_MK="openwrt/target/linux/ath79/image/generic-tp-link.mk"

echo "Patch generic-tp-link.mk for WR720N-v3 16MB..."
cat >> $GENERIC_MK << 'EOF'

define Device/tplink_tl-wr720n-v3
  $(Device/tplink-16mlzma)
  SOC := ar9331
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  IMAGE_SIZE := 16192k
  DEVICE_PACKAGES := \
    kmod-usb-core \
    kmod-usb-ohci \
    kmod-usb-printer \
    p910nd \
    luci \
    luci-i18n-base-zh-cn
  FIRMWARES := factory sysupgrade
  TPLINK_HWID := 0x07030101
endef
TARGET_DEVICES += tplink_tl-wr720n-v3
EOF

# ----------------------------
# 3️⃣ 自动生成 .config
# ----------------------------
echo "Generate OpenWrt .config..."
cat > openwrt/.config << 'EOF'
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_generic=y
CONFIG_TARGET_ath79_generic_DEVICE_tplink_tl-wr720n-v3=y

# LuCI Web 界面及中文包
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y

# USB
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-ohci=y

# USB 打印机
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
EOF

echo "=== DIY patch complete ==="
