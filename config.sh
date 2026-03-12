#!/bin/bash
set -e

echo "Generate OpenWrt config..."

cat > openwrt/.config << 'EOF'
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_generic=y
CONFIG_TARGET_ath79_generic_DEVICE_tplink_tl-wr720n-v3=y
# LuCI
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-compat=y
CONFIG_PACKAGE_luci-mod-admin-full=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci-theme-bootstrap=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
CONFIG_PACKAGE_uhttpd=y
CONFIG_PACKAGE_rpcd=y
CONFIG_PACKAGE_rpcd-mod-luci=y
CONFIG_PACKAGE_rpcd-mod-rrdns=y
CONFIG_PACKAGE_luci-app-opkg=y
# USB 支持
# CONFIG_PACKAGE_kmod-usb2=y
# CONFIG_PACKAGE_kmod-usb-ohci=y
# CONFIG_PACKAGE_kmod-usb-storage=y
# USB 文件系统
# CONFIG_PACKAGE_kmod-fs-ext4=y
# CONFIG_PACKAGE_block-mount=y
# USB 打印
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
CONFIG_PACKAGE_luci-app-p910nd=y
CONFIG_PACKAGE_luci-i18n-p910nd-zh-cn=y
CONFIG_PACKAGE_kmod-usb2=y
# CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_usbutils=y
# 常用工具
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_nano=y
CONFIG_PACKAGE_luci-app-opkg=y
CONFIG_PACKAGE_luci-app-watchcat=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-i18n-ttyd-zh-cn=y
EOF

echo "config.sh done."
