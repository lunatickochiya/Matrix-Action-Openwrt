#!/bin/sh
parted /dev/mmcblk1 resizepart 2 100%
losetup /dev/loop0 /dev/mmcblk1p2
resize2fs -f /dev/loop0
