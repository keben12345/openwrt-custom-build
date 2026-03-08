#!/bin/bash
# config.sh - 动态生成 WR720N v3 DTS、mk 文件和 OpenWrt .config

set -e

# 定义变量
DEVICE_NAME="tplink_tl-wr720n-v3"
SOC="ar9331"
IMAGE_SIZE="15872k"

echo "Generating DTS for $DEVICE_NAME..."

# 创建 DTS 文件
mkdir -p openwrt/target/linux/ath79/dts
cat > openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr720n-v3.dts << 'EOF'
/dts-v1/;

/include "ar9331_tplink_tl-wr710n-8m.dtsi"

 / {
    compatible = "tplink,tl-wr720n-v3", "qca,ar9331";
    model = "TP-Link TL-WR720N v3";
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

echo "Generating tiny-tp-link.mk..."

# 创建 mk 文件
mkdir -p openwrt/target/linux/ath79/image
cat >> openwrt/target/linux/ath79/image/tiny-tp-link.mk << EOF

define Device/$DEVICE_NAME
  SOC := $SOC
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  IMAGE_SIZE := $IMAGE_SIZE
  DEVICE_PACKAGES := \\
    kmod-usb-core \\
    kmod-usb-ohci \\
    kmod-usb-printer \\
    p910nd \\
    luci \\
    luci-i18n-base-zh-cn
  FIRMWARES := factory sysupgrade
endef
TARGET_DEVICES += $DEVICE_NAME
EOF

echo "Generating .config..."

# 生成 OpenWrt 配置
cat > openwrt/.config << EOF
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_tiny=y
CONFIG_TARGET_ath79_tiny_DEVICE_$DEVICE_NAME=y

CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y

# USB 支持
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
EOF

echo "config.sh done."
