#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Write By lunatickochiya
# You can replace lean package with yours and patch his source
# under this directory mypatch should put your patch
# delete his package confict with yours
#=================================================
sleep 3
rm -rf package/lean/luci-app-ssr-plus package/lean/default-settings
sleep 3

        for i in $( ls mypatch ); do
            echo Applying mypatch $i
            patch -p1 < mypatch/$i
        done
sleep 6
echo "CONFIG_PACKAGE_luci-app-control-weburl=y" >> .config
echo "CONFIG_PACKAGE_luci-app-fileassistant=y" >> .config
