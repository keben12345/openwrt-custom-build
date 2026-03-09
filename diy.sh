#!/bin/bash

echo "Apply WR720N 16MB flash patch..."

sed -i 's/0x7d0000/0xfd0000/g' target/linux/ath79/dts/ar9331_tplink_tl-wr710n-8m.dtsi
sed -i 's/0x7f0000/0xff0000/g' target/linux/ath79/dts/ar9331_tplink_tl-wr710n-8m.dtsi

echo "Flash patch done."
