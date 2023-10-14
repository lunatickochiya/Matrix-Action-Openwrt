#!/bin/sh


function rand_str() {
	(base64 /dev/urandom | tr -dc 'A-Za-z' | head -c $1) 2>/dev/null
}

function rand_str_upper() {
	(rand_str $1 | tr 'a-z' 'A-Z') 2>/dev/null
}

function rand_str_lower() {
	(rand_str $1 | tr 'A-Z' 'a-z') 2>/dev/null
}

function rand_easy_rsa_vars() {
	local KEY_PROVINCE="$(rand_str_upper 6)"
	local KEY_CITY="$(rand_str 8)"
	local KEY_ORG="$(rand_str 8)"
	local KEY_EMAIL="$(rand_str_lower 8)@$(rand_str_lower 4).$(rand_str_lower 3)"
	local KEY_OU="$(rand_str 8)"
	sed -i \
		-e "s/^[[:space:]]*set_var[[:space:]]\+EASYRSA_REQ_COUNTRY[[:space:]]\+\".*\"$/set_var EASYRSA_REQ_COUNTRY\t\"$KEY_PROVINCE\"/" \
		-e "s/^[[:space:]]*set_var[[:space:]]\+EASYRSA_REQ_PROVINCE[[:space:]]\+\".*\"$/set_var EASYRSA_REQ_PROVINCE\t\"$KEY_CITY\"/" \
		-e "s/^[[:space:]]*set_var[[:space:]]\+EASYRSA_REQ_CITY[[:space:]]\+\".*\"$/set_var EASYRSA_REQ_CITY\t\"$KEY_ORG\"/" \
		-e "s/^[[:space:]]*set_var[[:space:]]\+EASYRSA_REQ_ORG[[:space:]]\+\".*\"$/set_var EASYRSA_REQ_ORG\t\"$KEY_ORG\"/" \
		-e "s/^[[:space:]]*set_var[[:space:]]\+EASYRSA_REQ_EMAIL[[:space:]]\+\".*\"$/set_var EASYRSA_REQ_EMAIL\t\"$KEY_EMAIL\"/" \
		-e "s/^[[:space:]]*set_var[[:space:]]\+EASYRSA_REQ_OU[[:space:]]\+\".*\"$/set_var EASYRSA_REQ_OU\t\"$KEY_OU\"/" \
		/etc/easy-rsa/vars
}

rand_easy_rsa_vars

rm -rf /root/pki
easyrsa init-pki
easyrsa gen-dh
easyrsa build-ca nopass
easyrsa build-server-full server nopass
easyrsa build-client-full client1 nopass
cp /root/pki/ca.crt /etc/openvpn/
cp /root/pki/private/ca.key /etc/openvpn/
cp /root/pki/issued/server.crt /etc/openvpn/
cp /root/pki/private/server.key /etc/openvpn/
cp /root/pki/dh.pem /etc/openvpn/
cp /root/pki/issued/client1.crt /etc/openvpn/
cp /root/pki/private/client1.key /etc/openvpn/
echo "OpenVPN Cert renew successfully"
