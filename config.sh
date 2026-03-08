#!/bin/bash
set -e

DEVICE_NAME="tplink_tl-wr710n-usb"

echo "Create DTS and device definition for $DEVICE_NAME ..."

# 创建 DTS 目录，如果不存在
mkdir -p openwrt/target/linux/ath79/dts

# 动态生成 DTS 文件
cat > openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr710n-usb.dts <<'EOF'
/dts-v1/;
/include "ar9331_tplink_tl-wr710n-8m.dtsi"

/ {
    compatible = "tplink,tl-wr710n-v1", "qca,ar9331";
    model = "TP-Link TL-WR710N v1 USB";
};

&switch0 {
    ports {
        port@0 { reg = <0>; label = "wan"; };
        port@1 { reg = <1>; label = "lan1"; };
        port@2 { reg = <2>; label = "lan2"; };
        port@6 { reg = <6>; label = "cpu"; ethernet = <&eth0>; };
    };
};
EOF

# 添加 device 定义
cat >> openwrt/target/linux/ath79/image/generic-tp-link.mk <<EOF

define Device/$DEVICE_NAME
  SOC := ar9331
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR710N
  DEVICE_VARIANT := v1-usb
  IMAGE_SIZE := 8192k
  DEVICE_PACKAGES := \
    kmod-usb2 \
    kmod-usb-ohci \
    kmod-usb-printer \
    p910nd \
    luci \
    luci-i18n-base-zh-cn
  FIRMWARES := factory sysupgrade
endef
TARGET_DEVICES += $DEVICE_NAME
EOF

# 生成精简 .config
cat > openwrt/.config <<EOF
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_generic=y
CONFIG_TARGET_ath79_generic_DEVICE_$DEVICE_NAME=y

# luci
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y

# USB 支持
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
EOF

echo "config.sh done."
