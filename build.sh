#!/bin/bash
set -e

VERSION=$1   # 例: v22.03.5
TARGET=$2    # 例: ath79/generic/tplink_tl-wr710n-usb

echo "Cloning OpenWrt $VERSION ..."
git clone -b $VERSION https://github.com/openwrt/openwrt openwrt

cd openwrt

./scripts/feeds update -a
./scripts/feeds install -a

# 调用配置脚本
cd ..
bash config.sh

cd openwrt

make defconfig
make -j$(nproc)
