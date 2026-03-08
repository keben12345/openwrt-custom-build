#!/bin/bash
set -e

VERSION=$1

git clone https://github.com/openwrt/openwrt -b $VERSION openwrt

cd openwrt

./scripts/feeds update -a
./scripts/feeds install -a

cd ..

bash config.sh

cd openwrt

rm -f .config
cp ../.config .

make defconfig
make -j$(nproc)
