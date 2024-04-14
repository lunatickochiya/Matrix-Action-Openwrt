#!/bin/sh

# 自动检测根设备
root_device=$(ls /dev/mmcblk* | grep -E 'mmcblk[0-9]+$')

# 检查是否找到根设备
if [[ -z $root_device ]]; then
    echo "未找到MMC块设备作为根设备。"
    exit 1
fi

# 获取根设备的大小
root_size=$(grep $root_device /proc/partitions | awk '{print $3}')

# 将字节转换为易读的单位
function human_readable {
    local bytes=$1
    local units=('KB' 'MB' 'GB' 'TB')
    local unit=0
    while (( bytes >= 1024 && unit < 3 )); do
        bytes=$(($bytes / 1024))
        unit=$(($unit + 1))
    done
    echo "$bytes ${units[$unit]}"
}

# 打印根设备的大小
echo "根设备 $root_device 的大小为：$(human_readable $root_size)"

# 检测根设备的分区大小
root_partitions=$(ls ${root_device}* | grep -v "${root_device}$")
max_size=0
max_partition=""

for partition in $root_partitions; do
    partition_size=$(grep $(basename $partition) /proc/partitions | awk '{print $3}')
    echo "分区 $partition 的大小为：$(human_readable $partition_size)"
    if (( partition_size > max_size )); then
        max_size=$partition_size
        max_partition=$partition
    fi
done

# 提取最大分区的分区号
partition_number=$(echo $max_partition | grep -o '[0-9]*$')

# 检查 /dev/loop1 是否已经被占用
if losetup /dev/loop1 &>/dev/null; then
    echo "/dev/loop1 已被占用。尝试寻找另一个未被占用的 loop 设备。"
    exit 1
fi

# 打印最大的分区和其大小
if [[ ! -z $max_partition ]]; then
    echo "最大的分区是 $max_partition，大小为：$(human_readable $max_size)"
    echo "修复 $max_partition "

    # 设置 loop 设备
    echo "将 $max_partition 设置为 loop 设备"
    read -p "再次确认一下最大分区，正确的话按任意键继续！"
    losetup /dev/loop1 $max_partition

    echo "修复文件系统"

    e2fsck -y /dev/loop1
else
    echo "没有找到分区"
fi

