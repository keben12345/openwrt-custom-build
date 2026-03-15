// SPDX-License-Identifier: GPL-2.0-or-later OR MIT

#!/bin/bash

cd openwrt

echo "Adding WR720N v3 support"

############################
# WR720N DTS
############################

cat > target/linux/ath79/dts/ar9331_tplink_tl-wr720n.dtsi << 'EOF'
#include "ar9331.dtsi"

#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>

/ {
	aliases {
		led-boot = &led_system;
		led-failsafe = &led_system;
		led-running = &led_system;
		led-upgrade = &led_system;
	};

	keys {
		compatible = "gpio-keys";

		reset {
			label = "reset";
			linux,code = <KEY_RESTART>;
			gpios = <&gpio 11 GPIO_ACTIVE_LOW>;
			debounce-interval = <60>;
		};
	};

	leds {
		compatible = "gpio-leds";

		led_system: system {
			label = "blue:system";
			gpios = <&gpio 27 GPIO_ACTIVE_LOW>;
		};
	};

	reg_usb_vbus: regulator {
		compatible = "regulator-fixed";
		regulator-name = "usb_vbus";
		regulator-min-microvolt = <5000000>;
		regulator-max-microvolt = <5000000>;
		gpio = <&gpio 8 GPIO_ACTIVE_HIGH>;
		enable-active-high;
	};
};

&eth0 {
	status = "okay";
	mtd-mac-address = <&art 0x0>;

	gmac-config {
		device = <&gmac>;
		switch-phy-swap = <0>;
		switch-phy-addr-swap = <0>;
	};
};

&eth1 {
	status = "okay";
	mtd-mac-address = <&art 0x0>;
};

&usb {
	status = "okay";
	dr_mode = "host";
	vbus-supply = <&reg_usb_vbus>;
};

&usb_phy {
	status = "okay";
};

&wmac {
	status = "okay";
	mtd-cal-data = <&art 0x1000>;
};

&spi {
	status = "okay";

	flash@0 {
		compatible = "jedec,spi-nor";
		reg = <0>;
		spi-max-frequency = <25000000>;

		partitions {
			compatible = "fixed-partitions";
			#address-cells = <1>;
			#size-cells = <1>;

			partition@0 {
				label = "u-boot";
				reg = <0x000000 0x020000>;
				read-only;
			};

			partition@20000 {
				label = "firmware";
				reg = <0x020000 0xfb0000>;
			};

			art: partition@ff0000 {
				label = "art";
				reg = <0xff0000 0x010000>;
				read-only;
			};
		};
	};
};
EOF


cat > target/linux/ath79/dts/ar9331_tplink_tl-wr720n-v3.dts << 'EOF'
#include "ar9331_tplink_tl-wr720n.dtsi"

/ {
	model = "TP-Link TL-WR720N v3";
	compatible = "tplink,tl-wr720n-v3", "tplink,tl-wr720n", "qca,ar9331";
};
EOF

############################
# Device profile
############################

cat >> target/linux/ath79/image/generic-tp-link.mk << 'EOF'
define Device/tplink_tl-wr720n-v3
  $(Device/tplink-8mlzma)
  SOC := ar9331
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  TPLINK_HWID := 0x07200103
  DEVICE_PACKAGES := \
        kmod-usb-core \
        kmod-usb-ohci 
	    SUPPORTED_DEVICES += tl-wr720n-v3
endef
TARGET_DEVICES += tplink_tl-wr720n-v3
EOF

############################
# build config
############################

cat > .config << 'EOF'
CONFIG_TARGET_ath79=y
CONFIG_TARGET_ath79_generic=y
CONFIG_TARGET_ath79_generic_DEVICE_tplink_tl-wr720n-v3=y
EOF

echo "WR720N patch applied"
