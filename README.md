
# Actions-OpenWrt mod


特色功能： 可以替换package，给源码打入patch， 加入自己的东西
单独上传ipk文件包
原生的openwrt管理系统



LAN默认地址：192.168.11.1
没有密码

固件名称不带burn的写入sd卡 然后进入U盘 把boot分区里 boot.scr.universal改为 boot.scr
使用 USB_Burning_Tool刷入hzyitc的底包启动(在此感谢制作uboot底包并开源) 底包地址:https://github.com/hzyitc/u-boot-onecloud/releases/download/build-20221028-0940/eMMC.burn.img

带burn的固件 解压后 使用 USB_Burning_Tool 刷入使用 不需要刷底包
进入burn固件后使用bash resize.sh 自动扩容


建议使用istoreos

目前只支持meson8b 玩客云 onecloud  流量宝盒 ws1508

源码更新交流学习：点击链接加入群聊 ：https://jq.qq.com/?_wv=1027&k=5QgVYsC  
群号： 286754582



