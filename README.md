
# Actions-OpenWrt mod


 特色功能

- 可以替换package
- 给源码打入patch 加入自己的东西
- 单独上传ipk文件包
- 原生的openwrt管理系统
- 可编译99%的kmod 可用于直接安装内核模块
- Actions页面选择 Repo Dispatcher 点击 Run workflow

## 目录结构

- archive  归档文件夹
- env   环境文件夹
- machine-configs 机型配置文件
- openwrt-2203 openwrt-2305 openwrt-main  各个版本的op的补丁目录
- after_build.sh 打包ipk脚本 diy-*.sh diy脚本 refineconfig.sh 配置优化脚本 gen-sha256sum.sh 获取sha256sum脚本
- package-configs 编译进入固件的ipk包配置文件夹


## 关于rockchip：
- 默认网口为wan口 可上级获取DHCP 管理地址从上级路由获取
- 固件默认不带密码~ istoreos 为password


## 关于meson：
- 默认旁路由：
- 默认地址：192.168.7.186 
- 网关192.168.7.1
- 因此请把上级路由改为192.168.7.1 然后登录修改为你喜欢的地址
- 固件默认不带密码~

固件名称不带burn的写入sd卡 然后进入U盘 把boot分区里 boot.scr.universal改为 boot.scr
使用 USB_Burning_Tool刷入hzyitc的底包启动(在此感谢制作uboot底包并开源) 底包地址:https://github.com/hzyitc/u-boot-onecloud/releases/download/build-20221028-0940/eMMC.burn.img

带burn的固件 解压后 使用 USB_Burning_Tool 刷入使用 不需要刷底包
进入burn固件后使用bash resize.sh 自动扩容




当前版本支持情况：
# 20240307
- rockchip mpc1917 （不可定制）
- ws1508 （可定制）
- onecloud（可定制）

# 20241227
- rockchip mpc1917(不可定制） r08 fxm1-pro tpm312 （istoreos可定制 openwrt-23.05不可定制）
- ws1508 （可定制）
- onecloud（可定制）


# 20250309
- rockchip mpc1917(不可定制) fxm1-pro tpm312 （istoreos可定制 openwrt-23.05不可定制） 完善tpm312支持
- ws1508 （可定制）
- onecloud（可定制）
- 全面升级到24.10 后期可能会移除23.05  因为r08机器手上没了故后期可能移除 目前全系列支持bcmfullcone 完善了SFE支持


## 源码更新交流学习：
 - 点击链接加入群聊 ：https://jq.qq.com/?_wv=1027&k=5QgVYsC  
 - 群号： 286754582
 - 部分功能和补丁提取自 https://github.com/chenmozhijin/turboacc 感谢


