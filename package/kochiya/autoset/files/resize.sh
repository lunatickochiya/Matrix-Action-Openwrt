#!/bin/sh
parted /dev/mmcblk2 resizepart 2 100%
losetup /dev/loop0 /dev/mmcblk2p2
resize2fs -f /dev/loop0