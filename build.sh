#!/bin/bash
set -e

VERSION=$1
TARGET=$2

echo "build target start ..."

# 克隆 openwrt
git clone https://github.com/openwrt/openwrt -b $VERSION openwrt

# 进入 openwrt
cd openwrt

# 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 先生成默认配置
make defconfig

# 运行 config.sh（注意：config.sh 不再 cd openwrt）
bash ../config.sh $TARGET

# 确保 .config 更新
make defconfig

# 编译
make -j$(nproc)
