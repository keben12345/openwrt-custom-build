#!/bin/bash

cd openwrt

echo "Add WR720N v3 support"

################################
# 添加 DTS
################################

cat > target/linux/ath79/dts/ar9331_tplink_tl-wr720n-v3.dts << 'EOF'
// SPDX-License-Identifier: GPL-2.0-or-later OR MIT

#include "ar9331_tplink_tl-wr710n.dtsi"

/ {
	model = "TP-Link TL-WR720N v3";
	compatible = "tplink,tl-wr720n-v3", "qca,ar9331";
};
EOF

################################
# 添加设备定义
################################

cat >> target/linux/ath79/image/generic-tp-link.mk << 'EOF'

define Device/tplink_tl-wr720n-v3
  $(Device/tplink-16mlzma)
  SOC := ar9331
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  TPLINK_HWID := 0x07200103
  DEVICE_PACKAGES := \
    kmod-usb-core \
    kmod-usb-ohci \
    kmod-usb-printer \
    p910nd \
    luci \
    luci-i18n-base-zh-cn
endef
TARGET_DEVICES += tplink_tl-wr720n-v3
EOF

################################
# 生成配置
################################

cat > .config << 'EOF'
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_generic=y
CONFIG_TARGET_ath79_generic_DEVICE_tplink_tl-wr720n-v3=y
EOF

echo "WR720N v3 patch done"
