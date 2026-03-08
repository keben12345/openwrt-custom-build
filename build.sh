#!/bin/bash
set -e

VERSION=$1  # 例如 v22.03.5

echo "Cloning OpenWrt $VERSION..."
git clone -b $VERSION https://github.com/openwrt/openwrt openwrt

cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
cd ..

echo "Generating DTS and config..."
bash config.sh

cd openwrt
make defconfig
echo "Starting build..."
make -j$(nproc)

# 并行编译固件
make -j$(nproc) V=s

echo "=== Build completed: check openwrt/bin/targets for factory and sysupgrade bins ==="
