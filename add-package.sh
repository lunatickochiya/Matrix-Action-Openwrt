 #!/bin/bash
for file in *.config
do
echo "CONFIG_PACKAGE_luci-app-control-weburl=y" >> $file
echo "CONFIG_PACKAGE_luci-app-fileassistant=y" >> $file
done

sed -i "/# CONFIG_PACKAGE_luci-app-https-dns-proxy is not set/d" *.config
sed -i "/CONFIG_PACKAGE_https-dns-proxy=y/d" *.config
sed -i "/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_https_dns_proxy=y/d" *.config