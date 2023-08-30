#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Write By lunatickochiya
# You can replace lean package with yours and patch his source
# under this directory mypatch should put your patch
# delete his package confict with yours
#=================================================


sed -i 's/CONFIG_PACKAGE_firewall4=y/# CONFIG_PACKAGE_firewall4 is not set/g' .config
sed -i 's/CONFIG_PACKAGE_dnsmasq=y/# CONFIG_PACKAGE_dnsmasq is not set/g' .config
sed -i 's/CONFIG_PACKAGE_nftables-json=y/# CONFIG_PACKAGE_nftables-json is not set/g' .config
sed -i 's/CONFIG_PACKAGE_kmod-nft-offload=y/# CONFIG_PACKAGE_kmod-nft-offload is not set/g' .config
sed -i 's/# CONFIG_BUILD_PATENTED is not set/CONFIG_BUILD_PATENTED=y/g' .config
sed -i 's/# CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy is not set/CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y/g' .config
sed -i 's/CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y/# CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy is not set/g' .config
sed -i 's/CONFIG_PACKAGE_libnetwork=y/# CONFIG_PACKAGE_libnetwork is not set/g' .config




