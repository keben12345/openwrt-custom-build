#!/bin/bash

set -e

VERSION=$1

echo "Clone OpenWrt"

git clone https://github.com/openwrt/openwrt -b $VERSION openwrt

cd openwrt

./scripts/feeds update -a
./scripts/feeds install -a

make defconfig

cd ..

bash config.sh

cd openwrt

make defconfig

echo "Start build"

make -j$(nproc) || make -j1 V=s
