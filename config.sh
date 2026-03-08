#!/bin/bash
set -e

TARGET="$1"

echo "create WR720N v3 dts..."

cat > target/linux/ath79/dts/ar9331_tplink_tl-wr720n-v3.dts << 'EOF'
/dts-v1/;

#include "ar9331_tplink_tl-wr720n.dtsi"

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

echo "add device..."

cat >> target/linux/ath79/image/tiny-tp-link.mk << 'EOF'

define Device/tplink_tl-wr720n-v3
  SOC := ar9331
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  IMAGE_SIZE := 15872k
  DEVICE_PACKAGES := kmod-usb2 kmod-usb-ohci kmod-usb-printer p910nd
endef
TARGET_DEVICES += tplink_tl-wr720n-v3

EOF

echo "create .config ..."

cat > .config << 'EOF'
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_tiny=y
CONFIG_TARGET_ath79_tiny_DEVICE_tplink_tl-wr720n-v3=y

CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y

# CONFIG_PACKAGE_luci-app-ssr-plus=y  # 如果要 SSR+，取消注释即可

CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
EOF
