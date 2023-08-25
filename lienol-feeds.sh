#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Write By lunatickochiya
# Hack Lienol Feeds
#=================================================
sleep 3
        for i in $( ls lf ); do
            echo Applying lf $i
            patch -p1 < lf/$i
        done
