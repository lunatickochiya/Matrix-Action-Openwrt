#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Write By lunatickochiya
#=================================================

# 生成每个固件文件的 SHA-256 哈希值并保存为 .sha 文件
function gen_sha256sum() {
    for f in firmware/*; do
        sha256sum "$f" | awk '{print $1}' >"${f}.sha"
    done
}

# 将所有 .sha 文件的内容放入 Markdown 格式的 release.txt 文件中
function put_sha256sum() {
    echo "# Firmware SHA-256 Hashes" >> release.txt
    echo "" >> release.txt
    for a in firmware/*.sha; do
        # 提取文件名和哈希值
        filename=$(basename "$a" .sha)
        hash=$(cat "$a")
        # 以 Markdown 格式输出：[文件名](哈希值)
        echo "- **$filename:** \`$hash\`" >> release.txt
        rm -f "$a"  # 删除临时的 .sha 文件
    done
}

# 输出当前内核版本号到 release.txt 文件中
function kernel_ver() {
    echo "## 当前内核版本号：" >> release.txt
    kernelversion=$(grep "LINUX_KERNEL_HASH" openwrt/include/kernel-* | awk -F "LINUX_KERNEL_HASH-| = " '/LINUX_KERNEL_HASH-/{print $2}' | sed 's/$(strip $(LINUX_VERSION)))//g')
    echo "\`\`\`" >> release.txt
    echo "$kernelversion" >> release.txt
    echo "\`\`\`" >> release.txt
}

# 输出当前 feeds 的 git 日志到 release.txt 文件中
function feeds_git_log() {
    echo "## 当前 feeds git 日志：" >> release.txt
    for dir in ./openwrt/feeds/*; do
        if [[ -d "$dir" && ! "$dir" =~ \.tmp$ ]]; then
            echo "### 当前目录: $dir" >> release.txt
            echo "\`\`\`" >> release.txt
            (cd "$dir" && git log -n 2 --oneline) >> release.txt
            echo "\`\`\`" >> release.txt
        fi
    done
}

# 输出当前 lunatic7 feed 的 git 日志到 release.txt 文件中
function feeds_lunatic_git_log() {
    echo "## 当前 lunatic7 git 日志：" >> release.txt
    dir2='./openwrt/feeds/lunatic7'
    if [ -d "$dir2" ]; then
        echo "### 目录: $dir2" >> release.txt
        echo "\`\`\`" >> release.txt
        (cd "$dir2" && git log -n 1 --oneline) >> release.txt
        echo "\`\`\`" >> release.txt
    fi
}

# 输出当前 OpenWrt 项目的 git 日志到 release.txt 文件中
function git_log() {
    echo "## 当前 OpenWrt git 日志：" >> release.txt
    dir1='./openwrt'
    if [ -d "$dir1" ]; then
        echo "### 目录: $dir1" >> release.txt
        echo "\`\`\`" >> release.txt
        (cd "$dir1" && git log -n 1 --oneline) >> release.txt
        echo "\`\`\`" >> release.txt
    fi
}

function mt798x_status() {
eeprom_status=""
if [ -e openwrt/target/linux/mediatek/filogic/base-files/lib/firmware/mediatek/nx30pro_eeprom.bin ] ; then
  echo "- eeprom 使用 H3C NX30 Pro 提取版本" >> release.txt
  eeprom_status="nx30pro_eeprom"
else
echo "- eeprom 未修改" >> release.txt
  eeprom_status="default_eeprom"
fi
max_frequency=$(($(grep -oP "max-frequency = <\K[0-9]*" openwrt/target/linux/mediatek/dts/mt7981b-cmcc-rax3000m-emmc-ubootmod.dts) / 1000000))
echo "- 使用闪存频率: ${max_frequency}MHz" >> release.txt
}

git_log
kernel_ver
feeds_git_log
gen_sha256sum
put_sha256sum


