#!/bin/bash

set -e

VERSION=$1
TARGET=$2

echo "build target start ..."

git clone https://github.com/openwrt/openwrt -b $VERSION openwrt

cd openwrt

./scripts/feeds update -a
./scripts/feeds install -a

cd ..

bash config.sh

cd openwrt

make defconfig

make -j$(nproc) V=s
