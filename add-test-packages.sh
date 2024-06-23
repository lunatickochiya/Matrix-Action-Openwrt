#!/bin/bash
#=================================================
# this script is from https://github.com/lunatickochiya/Lunatic-s805-rockchip-Action
# Written By lunatickochiya
# QQ group :286754582  https://jq.qq.com/?_wv=1027&k=5QgVYsC
#=================================================
function add_nft_config() {
for file in package-configs/single/*-nft.config; do     echo "# ADD TURBOACC
CONFIG_PACKAGE_luci-app-turboacc=y

# iptable legacy in nft
CONFIG_PACKAGE_ip6tables-zz-legacy=y
CONFIG_PACKAGE_iptables-zz-legacy=y

# sfe
CONFIG_PACKAGE_kmod-fast-classifier=m
CONFIG_PACKAGE_kmod-shortcut-fe=m
CONFIG_PACKAGE_kmod-shortcut-fe-cm=m
" >> "$file"; done
}

function add_ipt_config() {
for file in package-configs/single/*-ipt.config; do     echo "# ADD TURBOACC
CONFIG_PACKAGE_luci-app-turboacc=y

# iptable legacy in nft
CONFIG_PACKAGE_ip6tables-zz-legacy=y
CONFIG_PACKAGE_iptables-zz-legacy=y

# sfe
CONFIG_PACKAGE_kmod-fast-classifier=m
CONFIG_PACKAGE_kmod-shortcut-fe=m
CONFIG_PACKAGE_kmod-shortcut-fe-cm=m
" >> "$file"; done
}

if [ "$1" == "nft" ]; then
add_nft_config
elif [ "$1" == "ipt" ]; then
add_ipt_config
else
echo "Invalid argument"
fi
