#!/bin/sh

TMP_FILE="/tmp/emmc_test.img"

# 自动检测 eMMC 设备
for i in $(seq 0 3); do
    DEV="/dev/mmcblk$i"
    if [ -b "$DEV" ]; then
        break
    fi
done

# 如果没有找到有效设备则退出
if [ ! -b "$DEV" ]; then
    echo "[ERROR] No valid eMMC device found!"
    exit 1
fi

# 确保依赖包安装
for pkg in mmc-utils hdparm coreutils-dd; do
    opkg list-installed $pkg >/dev/null 2>&1 || opkg install $pkg
done

echo "==== eMMC Info & Health Check ===="
DEV_BASENAME=$(basename $DEV)

MODEL=$(cat /sys/block/$DEV_BASENAME/device/name 2>/dev/null)
CID=$(cat /sys/block/$DEV_BASENAME/device/cid 2>/dev/null)
DATE_RAW=$(cat /sys/block/$DEV_BASENAME/device/date 2>/dev/null)

FWREV=$(cat /sys/block/$DEV_BASENAME/device/fwrev 2>/dev/null)
HWREV=$(cat /sys/block/$DEV_BASENAME/device/hwrev 2>/dev/null)
MANFID=$(cat /sys/block/$DEV_BASENAME/device/manfid 2>/dev/null)
OEMID=$(cat /sys/block/$DEV_BASENAME/device/oemid 2>/dev/null)
PRV=$(cat /sys/block/$DEV_BASENAME/device/prv 2>/dev/null)
SERIAL=$(cat /sys/block/$DEV_BASENAME/device/serial 2>/dev/null)

# 统一日期格式 YYYY-MM
if echo "$DATE_RAW" | grep -q '/'; then
    MONTH=$(echo $DATE_RAW | cut -d'/' -f1)
    YEAR=$(echo $DATE_RAW | cut -d'/' -f2)
    DATE_FMT=$(printf "%04d-%02d" $YEAR $MONTH)
else
    DATE_FMT="$DATE_RAW"
fi

# 获取容量（字节）
SIZE_SECTORS=$(cat /sys/block/$DEV_BASENAME/size 2>/dev/null)
if [ -n "$SIZE_SECTORS" ]; then
    BYTES=$((SIZE_SECTORS * 512))
    if [ "$BYTES" -ge $((1024**3)) ]; then
        CAPACITY=$(awk "BEGIN {printf \"%.2f GB\", $BYTES/1024/1024/1024}")
    elif [ "$BYTES" -ge $((1024**2)) ]; then
        CAPACITY=$(awk "BEGIN {printf \"%.2f MB\", $BYTES/1024/1024}")
    else
        CAPACITY="${BYTES} Bytes"
    fi
else
    CAPACITY="Unknown"
fi

echo "Device    : $DEV"
echo "Model     : $MODEL"
echo "CID       : $CID"
echo "Date      : $DATE_FMT"
echo "Capacity  : $CAPACITY"
echo "FWRev    : $FWREV"
echo "HWRev    : $HWREV"
echo "Manf ID   : $MANFID"
echo "OEM ID    : $OEMID"
echo "Product Ver: $PRV"
echo "Serial : $SERIAL"

echo
echo "==== eMMC Health (EXT_CSD) ===="
EXT=$(mmc extcsd read $DEV 2>/dev/null)

A=$(echo "$EXT" | awk '/Life Time Estimation A/ {print $NF}' | sed 's/0x//')
B=$(echo "$EXT" | awk '/Life Time Estimation B/ {print $NF}' | sed 's/0x//')
EOL=$(echo "$EXT" | awk '/Pre EOL/ {print $NF}')

echo "Life Time Estimation A : 0x$A (~$((A*10))% used)"
echo "Life Time Estimation B : 0x$B (~$((B*10))% used)"
case "$EOL" in
    0x01) EOL_STR="Normal";;
    0x02) EOL_STR="Warning";;
    0x03) EOL_STR="Urgent";;
    *) EOL_STR="Unknown";;
esac
echo "Pre EOL info           : $EOL ($EOL_STR)"

echo
echo "==== eMMC Speed Test ===="
sync
echo "[WRITE TEST] Writing 1GB..."
dd if=/dev/zero of=$TMP_FILE bs=4M count=256 oflag=direct conv=fsync 2>&1 | grep --color=never -E "copied|bytes" | head -1

echo
echo "[READ TEST] Reading 1GB..."
dd if=$DEV of=/dev/null bs=4M count=256 iflag=direct 2>&1 | grep --color=never -E "copied|bytes" | head -1

echo
echo "[HDParm Cache/Read Test]"
hdparm -tT $DEV 2>&1 | grep -E "Timing cached reads|Timing buffered disk reads"

rm -f $TMP_FILE
echo
echo "==== Done ===="

