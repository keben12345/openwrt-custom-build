#!/bin/bash

cd openwrt

echo "Adding WR720N v3 support..."

mkdir -p target/linux/ath79/dts

cat > target/linux/ath79/dts/ar9331_tplink_tl-wr720n-v3.dts << "EOF"
// SPDX-License-Identifier: GPL-2.0-or-later

#include "ar9331_tplink_tl-wr720n.dtsi"

/ {
	model = "TP-Link TL-WR720N v3";
	compatible = "tplink,tl-wr720n-v3", "qca,ar9331";
};
EOF

cat > target/linux/ath79/dts/ar9331_tplink_tl-wr720n.dtsi << "EOF"
#include "ar9331.dtsi"

#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>

/ {
	aliases {
		led-boot = &led_system;
		led-running = &led_system;
	};

	keys {
		compatible = "gpio-keys";

		reset {
			label = "reset";
			linux,code = <KEY_RESTART>;
			gpios = <&gpio 11 GPIO_ACTIVE_LOW>;
		};
	};

	leds {
		compatible = "gpio-leds";

		led_system: system {
			label = "blue:system";
			gpios = <&gpio 27 GPIO_ACTIVE_LOW>;
		};
	};
};

&spi {
	status = "okay";

	flash@0 {
		compatible = "jedec,spi-nor";
		reg = <0>;

		partitions {
			compatible = "fixed-partitions";
			#address-cells = <1>;
			#size-cells = <1>;

			partition@0 {
				reg = <0x0 0x20000>;
				label = "u-boot";
				read-only;
			};

			partition@20000 {
				reg = <0x20000 0xfd0000>;
				label = "firmware";
			};

			partition@ff0000 {
				reg = <0xff0000 0x10000>;
				label = "art";
				read-only;
			};
		};
	};
};

&wmac {
	status = "okay";
	mtd-cal-data = <&art 0x1000>;
};
EOF

echo "Patching image mk..."

sed -i '$a \
define Device/tplink_tl-wr720n-v3\n\
  $(Device/tplink-16mlzma)\n\
  SOC := ar9331\n\
  DEVICE_MODEL := TL-WR720N\n\
  DEVICE_VARIANT := v3\n\
  DEVICE_PACKAGES := kmod-usb-chipidea2 kmod-usb-ledtrig-usbport\n\
  TPLINK_HWID := 0x07200103\n\
endef\n\
TARGET_DEVICES += tplink_tl-wr720n-v3\n' \
target/linux/ath79/image/generic-tp-link.mk
