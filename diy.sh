#!/bin/bash

echo "Patch WR720N flash..."

# 16MB flash 分区
sed -i 's/0x7d0000/0xfd0000/g' target/linux/ath79/dts/ar9331_tplink_tl-wr710n-8m.dtsi
sed -i 's/0x7f0000/0xff0000/g' target/linux/ath79/dts/ar9331_tplink_tl-wr710n-8m.dtsi

# 8MB layout → 16MB layout
sed -i 's/tplink-8mlzma/tplink-16mlzma/g' target/linux/ath79/image/generic-tp-link.mk

echo "Patch done."
