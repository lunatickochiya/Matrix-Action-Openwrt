#!/bin/bash
#=================================================
# this script is from https://github.com/lunatickochiya/Lunatic-s805-rockchip-Action
# Written By lunatickochiya
# QQ group :286754582  https://jq.qq.com/?_wv=1027&k=5QgVYsC
#=================================================


autosetver() {
version=22.03
sed -i "52i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-meson
sed -i "51i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-rockchip

grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-meson
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-rockchip
        }

function remove_error_package() {

packages=(
    "luci-app-dockerman"
    "rtl8821cu"
    "xray-core"
)

for package in "${packages[@]}"; do
        echo "卸载软件包 $package ..."
        ./scripts/feeds uninstall $package
        echo "软件包 $package 已卸载。"
done

directories=(
    "feeds/luci/applications/luci-app-dockerman"
    "feeds/kiddin9/rtl8821cu"
    "feeds/packages/net/xray-core"
)

for directory in "${directories[@]}"; do
    if [ -d "$directory" ]; then
        echo "目录 $directory 存在，进行删除操作..."
        rm -r "$directory"
        echo "目录 $directory 已删除。"
    else
        echo "目录 $directory 不存在。"
    fi
done
rm -rf tmp
./scripts/feeds update -i
./scripts/feeds install -a -d y
        }

function patch_openwrt() {
        for i in $( ls mypatch ); do
            echo Applying mypatch $i
            patch -p1 < mypatch/$i
        done
        }
function patch_package() {
        for packagepatch in $( ls feeds/packages/my-package-patch ); do
            cd feeds/packages/
            echo Applying my-package-patch $packagepatch
            patch -p1 < my-package-patch/$packagepatch
            cd ../..
        done
        }
function patch_luci() {
        for lucipatch in $( ls feeds/luci/luci-patch ); do
            cd feeds/luci/
            echo Applying luci-patch $lucipatch
            patch -p1 < luci-patch/$lucipatch
            cd ../..
        done
        }
function patch_kiddin9() {
        for kiddin9patch in $( ls feeds/kiddin9/kiddin9-revert ); do
            cd feeds/kiddin9/
            echo Revert kiddin9 $kiddin9patch
            patch -p1 -R < kiddin9-revert/$kiddin9patch
            cd ../..
        done
        }

# add luci
function add_full_istore_luci_for_ws1508() {
echo "$(cat package-configs/ws1508-istore.config)" >> .config
}

function add_luci_packages_for_ws1508() {
echo "$(cat package-configs/ws1508-common.config)" >> .config
}




if [ "$1" == "ws1508-istore" ]; then
autosetver
remove_error_package
patch_openwrt
patch_package
patch_luci
patch_kiddin9
add_full_istore_luci_for_ws1508
elif [ "$1" == "ws1508" ]; then
autosetver
add_luci_packages_for_ws1508
remove_error_package
patch_openwrt
patch_package
patch_luci
patch_kiddin9
else
echo "Invalid argument"
fi
