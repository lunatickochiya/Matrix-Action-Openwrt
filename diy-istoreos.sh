#!/bin/bash
#=================================================
# this script is from https://github.com/lunatickochiya/Lunatic-s805-rockchip-Action
# Written By lunatickochiya
# QQ group :286754582  https://jq.qq.com/?_wv=1027&k=5QgVYsC
#=================================================

autosetver() {
version=22.03
sed -i "52i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-meson
sed -i "51i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-mediatek
sed -i "51i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-rockchip
sed -i "51i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-rockchip-siderouter

grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-mediatek
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-meson
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-rockchip
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-rockchip-siderouter
        }

function remove_error_package() {
packages=(
    "luci-app-dockerman"
    "luci-app-argon-config"
    "luci-theme-argon"
    "luci-app-vlmcsd"
    "xray-core"
    "v2ray-core"
    "v2ray-geodata"
    "v2ray-plugin"
    "v2raya"
)

for package in "${packages[@]}"; do
        echo "卸载软件包 $package ..."
        ./scripts/feeds uninstall $package
        echo "软件包 $package 已卸载。"
done

directories=(
    "feeds/luci/applications/luci-app-dockerman"
    "feeds/kenzo/luci-app-argon-config"
    "feeds/kenzo/luci-theme-argon"
    "feeds/kenzo/luci-app-vlmcsd"
    "feeds/packages/net/xray-core"
    "feeds/packages/net/v2ray-core"
    "feeds/packages/net/v2ray-geodata"
    "feeds/packages/net/v2ray-plugin"
    "feeds/packages/net/v2raya"
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

echo "升级索引"
./scripts/feeds update -i

for package2 in "${packages[@]}"; do
        echo "安装软件包 $package2 ..."
        ./scripts/feeds install $package2
        echo "软件包 $package2 已经重新安装。"
done
        }

function remove_error_package_not_install() {

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

echo "升级索引"
./scripts/feeds update -i

for package2 in "${packages[@]}"; do
        echo "安装软件包 $package2 ..."
        ./scripts/feeds install $package2
        echo "软件包 $package2 已经重新安装。"
done
        }

function patch_openwrt() {
        for i in $( ls mypatch ); do
            echo Applying mypatch $i
            patch -p1 --no-backup-if-mismatch < mypatch/$i
        done
        }
function patch_package() {
        for packagepatch in $( ls feeds/packages/istoreos-package-patch ); do
            cd feeds/packages/
            echo Applying istoreos-package-patch $packagepatch
            patch -p1 --no-backup-if-mismatch < istoreos-package-patch/$packagepatch
            cd ../..
        done
        }
function patch_luci() {
        for lucipatch in $( ls feeds/luci/istoreos-luci-patch ); do
            cd feeds/luci/
            echo Applying istoreos-luci-patch $lucipatch
            patch -p1 --no-backup-if-mismatch < istoreos-luci-patch/$lucipatch
            cd ../..
        done
        }

function patch_rockchip() {
        for rockpatch in $( ls tpm312/core-istoreos ); do
            echo Applying tpm312 $rockpatch
            patch -p1 --no-backup-if-mismatch < tpm312/core-istoreos/$rockpatch
        done
        rm -rf tpm312
        }

# add luci

function add_mt798x_packages() {
echo "$(cat package-configs/mt798x-common.config)" >> package-configs/.config
mv -f package-configs/.config .config
}

function add_mt798x_istore_packages() {
echo "$(cat package-configs/mt798x-common-istore.config)" >> package-configs/.config
mv -f package-configs/.config .config
}

function add_mpc1917_packages() {
echo "$(cat package-configs/mpc1917-common.config)" >> package-configs/.config
mv -f package-configs/.config .config
}

function add_mpc1917_packages_istoreos() {
echo "$(cat package-configs/mpc1917-istoreos.config)" >> package-configs/.config
mv -f package-configs/.config .config
}

if [ "$1" == "mt798x" ]; then
autosetver
patch_openwrt
remove_error_package_not_install
patch_package
patch_luci
add_mt798x_packages
elif [ "$1" == "mpc1917" ]; then
autosetver
patch_openwrt
remove_error_package_not_install
patch_package
patch_luci
add_mpc1917_packages
elif [ "$1" == "mpc1917-istoreos" ]; then
autosetver
patch_openwrt
remove_error_package
patch_package
patch_luci
add_mpc1917_packages_istoreos
elif [ "$1" == "rockpatch" ]; then
patch_rockchip
else
echo "Invalid argument"
fi
