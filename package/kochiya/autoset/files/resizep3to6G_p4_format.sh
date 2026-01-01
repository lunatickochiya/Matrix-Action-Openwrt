#!/bin/bash

DEVICE="/dev/mmcblk0"

echo "当前设备分区信息："
parted $DEVICE print
echo

read -p "确认要调整分区吗？这将删除第3个分区并重新创建，可能导致数据丢失！(y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "操作取消。"
  exit 0
fi

# 删除第3个分区
echo "删除第3个分区..."
parted $DEVICE rm 3

# 创建新的第3个分区，大小6GB，从3894MB开始
echo "创建新的第3个分区，大小6GB..."
parted $DEVICE mkpart primary ext4 3894MB 9894MB

# 创建第4个分区，剩余空间
echo "创建第4个分区，使用剩余空间..."
parted $DEVICE mkpart primary ext4 9894MB 100%

echo
echo "分区调整完成，当前设备分区信息："
parted $DEVICE print
echo

# 格式化第3和第4个分区
PART3="${DEVICE}p3"
PART4="${DEVICE}p4"

read -p "是否格式化第3个分区 $PART3 为 ext4？(y/n): " format3
if [[ "$format3" == "y" || "$format3" == "Y" ]]; then
  echo "格式化 $PART3 ..."
  mkfs.ext4 $PART3
else
  echo "跳过格式化 $PART3"
fi

read -p "是否格式化第4个分区 $PART4 为 ext4？(y/n): " format4
if [[ "$format4" == "y" || "$format4" == "Y" ]]; then
  echo "格式化 $PART4 ..."
  mkfs.ext4 $PART4
else
  echo "跳过格式化 $PART4"
fi

echo "操作完成。"
