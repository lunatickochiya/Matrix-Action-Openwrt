 #!/bin/bash
for file1 in arch-configs/meson.config
do
echo "CONFIG_TARGET_meson_meson8b_DEVICE_thunder-ws1508=y" >> $file1
#echo "CONFIG_TARGET_meson_meson8b_DEVICE_thunder-onecloud=y" >> $file1
done

for file2 in arch-configs/rockchip.config
do
echo "CONFIG_TARGET_rockchip_armv8_DEVICE_lunatickochiya-tpm312=y" >> $file2
done
