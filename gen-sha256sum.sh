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

gen_sha256sum
put_sha256sum
