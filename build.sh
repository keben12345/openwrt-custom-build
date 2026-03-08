#!/bin/bash
set -e

VERSION=$1

echo "Cloning OpenWrt $VERSION..."

git clone https://github.com/openwrt/openwrt -b $VERSION openwrt

cd openwrt

echo "Update feeds..."
./scripts/feeds update -a
./scripts/feeds install -a

cd ..

echo "Generate config..."
bash config.sh

cd openwrt

make defconfig

echo "Start build..."
make -j$(nproc)
