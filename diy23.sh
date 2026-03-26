#!/bin/bash

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
		label-mac-device = &eth0;
	};

	keys {
		compatible = "gpio-keys";

		reset {
			label = "reset";
			linux,code = <KEY_RESTART>;
			gpios = <&gpio 11 GPIO_ACTIVE_HIGH>;
			debounce-interval = <60>;
		};
		
		sw1 {
			label = "sw1";
			linux,code = <BTN_0>;
			gpios = <&gpio 18 GPIO_ACTIVE_HIGH>;
			debounce-interval = <60>;
		};
		
		sw2 {
			label = "sw2";
			linux,code = <BTN_1>;
			gpios = <&gpio 20 GPIO_ACTIVE_HIGH>;
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
		gpios = <&gpio 8 GPIO_ACTIVE_HIGH>;
		enable-active-high;
	};
 
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

			uboot: partition@0 {
				reg = <0x0 0x20000>;
				label = "u-boot";
				read-only;
			};

			partition@20000 {
				compatible = "tplink,firmware";
				reg = <0x20000 0xfd0000>;
				label = "firmware";
			};

			art: partition@ff0000 {
				reg = <0xff0000 0x10000>;
				label = "art";
				read-only;
			};
		};
	};
};

&eth0 {
	status = "okay";
	mtd-mac-address = <&uboot 0x124e0>;

	gmac-config {
		device = <&gmac>;
		switch-phy-addr-swap = <0>;
		switch-phy-swap = <0>;
	};
};
&eth1 {
	status = "disabled";
};

&builtin_switch {
	status = "okay";
	enable-vlan;
};

&usb {
	compatible = "generic-ehci";
    has-transaction-translator;
    caps-offset = <0x100>;
	dr_mode = "host";
	vbus-supply = <&reg_usb_vbus>;
	status = "okay";
};

&usb_phy {
	status = "okay";
};

&wmac {
	status = "okay";

	mtd-cal-data = <&art 0x1000>;
	mtd-mac-address = <&uboot 0x1fc00>;
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
sed -i '/tplink_tl-wr720n-v3/,+8d' target/linux/ath79/image/generic-tp-link.mk

cat >> target/linux/ath79/image/generic-tp-link.mk << 'EOF'
define Device/tplink_tl-wr720n-v3 
  $(Device/tplink-16mlzma) 
  SOC := ar9331
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  DEVICE_PACKAGES := kmod-usb-core kmod-usblp kmod-usb2
  TPLINK_HWID := 0x07200103
  SUPPORTED_DEVICES += tl-wr720n
endef
TARGET_DEVICES += tplink_tl-wr720n-v3
EOF

############################
# Fix USB (very important)
############################
sed -i 's/"chipidea,usb2"/"generic-ehci"/g' target/linux/ath79/dts/ar9330.dtsi

sed -i '/usb@1b000000 {/a\        has-transaction-translator;\n        caps-offset = <0x100>;' target/linux/ath79/dts/ar9330.dtsi
sed -i '/usb@1b000000 {/,/};/ s/status = "disabled"/status = "okay"/' target/linux/ath79/dts/ar9330.dtsi

# Fix 02_network
grep -q "tplink,tl-wr720n-v3" target/linux/ath79/generic/base-files/etc/board.d/02_network || cat >> target/linux/ath79/generic/base-files/etc/board.d/02_network << 'EOF'
tplink,tl-wr720n-v3|tplink,tl-wr720n)
    ucidef_add_switch "switch0" \
        "0@eth0" "1:lan" "2:lan" "3:wan" "4:lan"
    ;;
EOF

echo "WR720N patch applied"
