#!/bin/bash
set -e

VERSION=$1
TARGET=$2

echo "=== Build target start: $TARGET, OpenWrt $VERSION ==="

# 克隆 OpenWrt 源码
if [ ! -d openwrt ]; then
    git clone -b $VERSION https://github.com/openwrt/openwrt openwrt
fi

cd openwrt

# 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 调用 config.sh 动态生成 DTS、设备定义和 .config
cd ..
bash config.sh $TARGET

cd openwrt

# 确保 FIRMWARES 包含 factory sysupgrade
MAKEFILE="target/linux/ath79/image/tiny-tp-link.mk"
if ! grep -q "FIRMWARES := factory sysupgrade" "$MAKEFILE"; then
    echo "FIRMWARES := factory sysupgrade" >> "$MAKEFILE"
fi

# 重新生成配置
make defconfig

# 并行编译固件
make -j$(nproc) V=s

echo "=== Build completed: check openwrt/bin/targets for factory and sysupgrade bins ==="
