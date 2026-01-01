#!/bin/bash

DEVICE="/dev/mmcblk0"
START="3894MB"
END="100%"

echo "当前设备分区信息："
parted $DEVICE print
echo

read -p "是否需要创建新的分区？(y/n): " create_part
if [[ "$create_part" != "y" && "$create_part" != "Y" ]]; then
  echo "跳过创建分区。"
else
  parted $DEVICE mkpart primary ext4 $START $END
fi

# 获取最后一个分区号
PART_NUM=$(parted $DEVICE print | grep primary | tail -n1 | sed 's/^ *//;s/  */ /g' | cut -d' ' -f1)

if [[ ! "$PART_NUM" =~ ^[0-9]+$ ]]; then
  echo "错误：无法获取分区号，得到：'$PART_NUM'"
  exit 1
fi

PARTITION="${DEVICE}p${PART_NUM}"

echo "检测到分区：$PARTITION"

read -p "是否需要格式化该分区为ext4？(y/n): " format_part
if [[ "$format_part" != "y" && "$format_part" != "Y" ]]; then
  echo "跳过格式化。"
else
  mkfs.ext4 $PARTITION
fi

echo "当前设备分区信息："
parted $DEVICE print
