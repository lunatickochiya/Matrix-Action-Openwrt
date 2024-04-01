#!/bin/bash
#=================================================
# this script is from https://github.com/lunatickochiya/Lunatic-s805-rockchip-Action
# Written By lunatickochiya
# QQ group :286754582  https://jq.qq.com/?_wv=1027&k=5QgVYsC
#=================================================
function init() {
mkdir firmware firmware-onecloud firmware-ws1508 ipks
cp -f openwrt/bin/targets/*/*/*onecloud* ./firmware-onecloud/ 2>/dev/null || true
cp -f openwrt/bin/targets/*/*/*ws1508* ./firmware-ws1508/ 2>/dev/null || true
ls firmware-onecloud
ls firmware-ws1508
echo "::end-init::"
        }

function burn_onecloud() {
ls
gunzip firmware-onecloud/*.gz
diskimg1=$(ls firmware-onecloud/*.img)
loop1=$(sudo losetup --find --show --partscan $diskimg1)
sudo img2simg ${loop1}p1 burn/boot.simg
sudo img2simg ${loop1}p2 burn/rootfs.simg
sudo losetup -d $loop1
echo "::end-onecloud-unpackext4::"
cat <<EOF >>burn-onecloud/commands.txt
PARTITION:boot:sparse:boot.simg
PARTITION:rootfs:sparse:rootfs.simg
EOF
prefix1=$(ls firmware-onecloud/*.img | sed 's/\.img$//')
burnimg1=${prefix1}.burn.img
./AmlImg pack $burnimg1 burn-onecloud/
gzip -9 firmware-onecloud/*.burn.img

cp -u -f firmware-onecloud/*.burn.img.gz firmware

echo "::end-onecloud::"
        }

function burn_ws1508() {
gunzip firmware-ws1508/*.gz
diskimg2=$(ls firmware-onecloud/*.img)
loop2=$(sudo losetup --find --show --partscan $diskimg2)
sudo img2simg ${loop2}p1 burn/boot.simg
sudo img2simg ${loop2}p2 burn/rootfs.simg
sudo losetup -d $loop2
echo "::end-ws1508-unpackext4::"
cat <<EOF >>burn-ws1508/commands.txt
PARTITION:boot:sparse:boot.simg
PARTITION:rootfs:sparse:rootfs.simg
EOF
prefix2=$(ls firmware-ws1508/*.img | sed 's/\.img$//')
burnimg2=${prefix2}.burn.img
./AmlImg pack $burnimg2 burn-ws1508/
gzip -9 firmware-ws1508/*.burn.img

cp -u -f firmware-ws1508/*.burn.img.gz firmware


echo "::end-ws1508::"
        }

init
burn_onecloud
sudo rm -rf burn-onecloud firmware-onecloud
burn_ws1508
sudo rm -rf burn-ws1508 firmware-ws1508
ls firmware
