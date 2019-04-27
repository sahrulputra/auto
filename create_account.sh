#!/bin/bash

##
# @Script: create_account.sh
# @author: Doctype <ndieyplus@gmail.com>
# @Description: Script create users account
##

# Colors
blue='\e[0;34m'      # blue
yellow='\e[0;33m'    # yellow
noclr='\e[0m'        # Reset

clear

IPADDR=$(wget -qO- ipv4.icanhazip.com);

echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo "Create: Account"
echo -e "${blue}――――――――――――――――――――――――――――――――――――――――${noclr}"

read -rp "Username: " USERNAME
read -rp "Password: " PASSWORD
read -rp "Expired [Day]: " EXPDAY
EXPDATE=$(date -d "$EXPDAY days" +"%Y-%m-%d");
useradd -e "$EXPDATE" -s /bin/false -M "$USERNAME"

clear

echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo "Account Details"
echo -e "${blue}――――――――――――――――――――――――――――――――――――――――${noclr}"

echo -e "Ip Address: ${yellow}$IPADDR${noclr}"
echo -e "Dropbear Port: ${yellow}4343${noclr}"
echo -e "OpenSSH Port: ${yellow}2020${noclr}"
echo -e "Squid Port: ${yellow}3128${noclr}"
echo -e "OpenVPN Config: ${yellow}http://$IPADDR/client.ovpn${noclr}"
echo -e "Username: ${yellow}$USERNAME${noclr}"
echo -e "Password: ${yellow}$PASSWORD${noclr}"
echo -e "Active Until: ${yellow}$EXPDATE${noclr}"
echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
