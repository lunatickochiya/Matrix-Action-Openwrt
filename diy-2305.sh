#!/bin/bash
#=================================================
# this script is from https://github.com/lunatickochiya/Lunatic-s805-rockchip-Action
# Written By lunatickochiya
# QQ group :286754582  https://jq.qq.com/?_wv=1027&k=5QgVYsC
#=================================================

autosetver() {
version=23.05
sed -i "52i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-meson
sed -i "58i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-mediatek
sed -i "51i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-ramips
sed -i "51i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-ath79
sed -i "52i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-rockchip
sed -i "51i\echo \"DISTRIB_DESCRIPTION='OpenWrt $version Compiled by 2U4U'\" >> /etc/openwrt_release" package/kochiya/autoset/files/zzz-autoset-rockchip-siderouter

grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-mediatek
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-meson
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-rockchip
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-ramips
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-ath79
grep DISTRIB_DESCRIPTION package/kochiya/autoset/files/zzz-autoset-rockchip-siderouter
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
    "feeds/lunatic7/rtl8821cu"
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
    "feeds/lunatic7/rtl8821cu"
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
        for packagepatch in $( ls feeds/packages/feeds-package-patch-2305 ); do
            cd feeds/packages/
            echo Applying feeds-package-patch-2305 $packagepatch
            patch -p1 --no-backup-if-mismatch < feeds-package-patch-2305/$packagepatch
            cd ../..
        done
        }

function patch_luci() {
        for lucipatch in $( ls feeds/luci/luci-patch-2305 ); do
            cd feeds/luci/
            echo Applying luci-patch-2305 $lucipatch
            patch -p1 --no-backup-if-mismatch < luci-patch-2305/$lucipatch
            cd ../..
        done
        }
function patch_lunatic7() {
        for lunatic7patch in $( ls feeds/lunatic7/lunatic7-revert ); do
            cd feeds/lunatic7/
            echo Revert lunatic7 $lunatic7patch
            patch -p1 -R --no-backup-if-mismatch < lunatic7-revert/$lunatic7patch
            cd ../..
        done
        }

function patch_rockchip() {
        for rockpatch in $( ls tpm312/core ); do
            echo Applying tpm312 $rockpatch
            patch -p1 --no-backup-if-mismatch < tpm312/core/$rockpatch
        done
        rm -rf tpm312
        }

function remove_firewall() {

directories1=(
    "package/network/config/firewall"
    "package/network/config/firewall4"
)

for directory1 in "${directories1[@]}"; do
    if [ -d "$directory1" ]; then
        echo "目录 $directory1 存在，进行删除操作..."
        rm -r "$directory1"
        echo "目录 $directory1 已删除。"
    else
        echo "目录 $directory1 不存在。"
    fi
done
        }

# add luci
function add_meson_ipt_packages() {
echo "$(cat package-configs/meson-ipt-2305.config)" >> package-configs/.config
mv -f package-configs/.config .config
}

function add_meson_nft_packages() {
echo "$(cat package-configs/meson-nft-2305.config)" >> package-configs/.config
mv -f package-configs/.config .config
}


function add_rockchip_ipt_packages() {
echo "$(cat package-configs/rockchip-ipt-2305.config)" >> package-configs/.config
mv -f package-configs/.config .config
}

function add_rockchip_nft_packages() {
echo "$(cat package-configs/rockchip-nft-2305.config)" >> package-configs/.config
mv -f package-configs/.config .config
}

if [ "$1" == "meson-ipt" ]; then
autosetver
remove_error_package_not_install
patch_package
patch_luci
patch_lunatic7
add_meson_ipt_packages
elif [ "$1" == "meson-nft" ]; then
autosetver
remove_error_package_not_install
patch_package
patch_luci
patch_lunatic7
add_meson_nft_packages
elif [ "$1" == "rockchip-ipt" ]; then
autosetver
remove_error_package_not_install
patch_package
patch_luci
patch_lunatic7
add_rockchip_ipt_packages
elif [ "$1" == "rockchip-nft" ]; then
autosetver
remove_error_package_not_install
patch_package
patch_luci
patch_lunatic7
add_rockchip_nft_packages
elif [ "$1" == "patch-openwrt" ]; then
patch_openwrt
elif [ "$1" == "rockpatch" ]; then
patch_rockchip
elif [ "$1" == "firewallremove" ]; then
remove_firewall
else
echo "Invalid argument"
fi
