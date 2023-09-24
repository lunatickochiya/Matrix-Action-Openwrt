#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Write By lunatickochiya
#=================================================
function gen_sha256sum() {
for f in firmware/*; do
sha256sum "$f" >"${f}.sha"
done
}

function put_sha256sum() {
for a in firmware/*.sha; do
cat "$a" >>release.txt
rm -f "$a"
done
}

function kernel_ver() {
echo "当前内核版本号：" >> release.txt
kernelversion=$(grep "LINUX_KERNEL_HASH" openwrt/include/kernel-* | awk -F "LINUX_KERNEL_HASH-| = " '/LINUX_KERNEL_HASH-/{print $2}' | sed 's/$(strip $(LINUX_VERSION)))//g')
echo $kernelversion >> release.txt
}

function feeds_git_log() {
echo "当前feeds git日志：" >> release.txt
for dir in ./openwrt/feeds/*; do
  if [ -d "$dir" ]; then
    echo "当前目录: $dir" >> release.txt
    (cd "$dir" && git log -n 2)
  fi
done >> release.txt
}

function git_log() {
echo "当前 openwrt git日志：" >> release.txt
for dir1 in ./openwrt; do
  if [ -d "$dir1" ]; then
    (cd "$dir1" && git log -n 1)
  fi
done >> release.txt
}

git_log
kernel_ver
feeds_git_log
gen_sha256sum
put_sha256sum


