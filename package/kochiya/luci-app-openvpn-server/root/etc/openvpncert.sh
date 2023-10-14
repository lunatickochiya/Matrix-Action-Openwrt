#!/bin/sh

clean-all
easyrsa init-pki
easyrsa gen-dh
easyrsa build-ca nopass
easyrsa build-server-full server nopass
easyrsa build-client-full client1 nopass
openvpn --genkey --secret ta.key
cp /etc/easy-rsa/keys/ca.crt /etc/openvpn/
cp /etc/easy-rsa/keys/private/ca.key /etc/openvpn/
cp /etc/easy-rsa/keys/issued/server.crt /etc/openvpn/
cp /etc/easy-rsa/keys/private/server.key /etc/openvpn/
cp /etc/easy-rsa/keys/dh.pem /etc/openvpn/
cp /etc/easy-rsa/keys/issued/client1.crt /etc/openvpn/
cp /etc/easy-rsa/keys/private/client1.key /etc/openvpn/
echo "OpenVPN Cert renew successfully"
