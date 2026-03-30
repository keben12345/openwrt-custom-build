#!/bin/bash

echo "Patch WR720N flash..."

# 16MB flash 分区
sed -i 's/0x7d0000/0xfd0000/g' target/linux/ath79/dts/ar9331_tplink_tl-wr710n-8m.dtsi
sed -i 's/0x7f0000/0xff0000/g' target/linux/ath79/dts/ar9331_tplink_tl-wr710n-8m.dtsi

# 8MB layout → 16MB layout
sed -i 's/tplink-8mlzma/tplink-16mlzma/g' target/linux/ath79/image/generic-tp-link.mk

# 5. MAC 地址改为 uboot
sed -i 's/mtd-mac-address = <&art 0x0>;/mtd-mac-address = <\&uboot 0x124e0>;/g' \
target/linux/ath79/dts/ar9331_tplink_tl-wr710n.dtsi

# 6. USB 供电
sed -i '/regulator-name = "usb_vbus";/a\        gpios = <\&gpio 8 GPIO_ACTIVE_HIGH>;\n        regulator-always-on;' \
target/linux/ath79/dts/ar9331_tplink_tl-wr710n.dtsi
############################
# Fix USB (very important)
############################
sed -i 's/"chipidea,usb2"/"generic-ehci"/g' target/linux/ath79/dts/ar9330.dtsi

sed -i '/usb@1b000000 {/a\        has-transaction-translator;\n        caps-offset = <0x100>;' target/linux/ath79/dts/ar9330.dtsi
sed -i '/usb@1b000000 {/,/};/ s/status = "disabled"/status = "okay"/' target/linux/ath79/dts/ar9330.dtsi

# 7. 改设备名为 WR720N v3
#sed -i 's/TL-WR710N/TL-WR720N v3/g' target/linux/ath79/dts/ar9331_tplink_tl-wr710n.dtsi

#sed -i 's/tplink,tl-wr710n/tplink,tl-wr720n-v3/g' target/linux/ath79/dts/ar9331_tplink_tl-wr710n.dtsi

echo "Patch done."
