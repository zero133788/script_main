#!/bin/bash
#Explain
#cert_name its random string
#vars_days its amount working days of client config
#config_name suffix for country used in config generation

cert_name=$1
vars_days=$2
config_name=$3
cert_name_key=$cert_name".key"
cert_name_req=$cert_name".req"
cert_name_crt=$cert_name".crt"
cert_name_ovpn=$cert_name".ovpn"

cp -f /root/openvpn_server/vars_example/vars_30/vars /root/CA/EasyRSA-3.0.8
cd /root/openvpn_server/EasyRSA-3.0.8/
printf "\n" | ./easyrsa gen-req $cert_name nopass
cp /root/openvpn_server/EasyRSA-3.0.8/pki/private/$cert_name_key /root/client-configs/keys/
cp /root/openvpn_server/EasyRSA-3.0.8/pki/reqs/$cert_name_req /tmpCA/
cd /root/CA/EasyRSA-3.0.8/
printf "\n" | ./easyrsa import-req /tmpCA/$cert_name_req $cert_name
printf "yes\n" | ./easyrsa sign-req client $cert_name
cp /root/CA/EasyRSA-3.0.8/pki/issued/$cert_name_crt /tmp
cp /tmp/$cert_name_crt /root/client-configs/keys/
cp /root/openvpn_server/EasyRSA-3.0.8/ta.key /root/client-configs/keys/
cp /etc/openvpn/ca.crt /root/client-configs/keys/
cd /root/client-configs
./make_config.sh $cert_name
mv /root/client-configs/files/$cert_name_ovpn /root/client-configs/files/$config_name-$vars_days_$cert_name_ovpn
cp /root/client-configs/files/$config_name-$vars_days_$cert_name_ovpn /etc/openvpn/ccd/$cert_name
