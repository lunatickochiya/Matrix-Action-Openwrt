 #!/bin/bash

function ws1508() {
for file1 in arch-configs/meson.config
do
echo "CONFIG_TARGET_meson_meson8b_DEVICE_thunder-ws1508=y" >> $file1
done
}

function tpm312() {
for file2 in arch-configs/rockchip.config
do
echo "CONFIG_TARGET_rockchip_armv8_DEVICE_lunatickochiya-tpm312=y" >> $file2
done
}

function onecloud() {
for file3 in arch-configs/meson.config
do
echo "CONFIG_TARGET_meson_meson8b_DEVICE_thunder-onecloud=y" >> $file3
done
}

if [ "$1" == "tpm312" ]; then
tpm312
echo "tpm312"
elif [ "$1" == "ws1508" ]; then
ws1508
echo "ws1508"
elif [ "$1" == "onecloud" ]; then
onecloud
echo "onecloud"
else
echo "Invalid argument"
fi
