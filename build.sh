#!/bin/bash
set -e

VERSION=$1  # e.g., v22.03.5
TARGET=$2   # e.g., ath79/tiny/tplink_tl-wr720n-v3

echo "build target start ..."

git clone -b $VERSION https://github.com/openwrt/openwrt

cd openwrt

./scripts/feeds update -a
./scripts/feeds install -a

bash ../config.sh

make defconfig
make -j$(nproc)
