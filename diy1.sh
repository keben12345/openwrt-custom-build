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
	compatible = "tplink,tl-wr720n", "qca,ar9331";

	aliases {
		led-boot = &status;
		led-failsafe = &status;
		led-running = &status;
		led-upgrade = &status;
	};

	leds {
		compatible = "gpio-leds";

		status: status {
			label = "wr720n:green:status";
			gpios = <&gpio 27 GPIO_ACTIVE_LOW>;
		};
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
};

&usb {
	status = "okay";
};

&usb_phy {
	status = "okay";
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
  $(Device/tplink-16mlzma)
  SOC := ar9331
  DEVICE_MODEL := TL-WR720N
  DEVICE_VARIANT := v3
  TPLINK_HWID := 0x07200103
  DEVICE_PACKAGES := \
        kmod-usb2 \
        kmod-usb-ohci \
        kmod-usb-printer \
        p910nd
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
