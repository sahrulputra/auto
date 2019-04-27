#!/bin/bash

##
# @Script: passwdChanger.sh
# @author: Doctype <ndieyplus@gmail.com>
# @Description: Script changing user password
##

# Colors
red='\e[0;31m'       # Red
green='\e[0;32m'     # Green
blue='\e[0;34m'      # Blue
yellow='\e[0;33m'    # Yellow
noclr='\e[0m'        # Reset

clear

echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo -e "Change User password"
echo -e "${blue}――――――――――――――――――――――――――――――――――――――――${noclr}"

read -p "Username: " USERNAME
egrep "^$USERNAME" /etc/passwd > /dev/null

if [ $? -eq 0 ]; then
	read -p "New Password [$USERNAME]: " NEWPASS
	read -p "Retype New Password [$USERNAME]: " RETYPEPASS
	if [[ $NEWPASS == $RETYPEPASS ]]; then
		echo "${green}Success Change Password${noclr}"
	else
		echo "${red}Fail Change Password${noclr}"
	fi
else
	echo "${yellow}Username not exist!${noclr}"
	exit 1
fi
echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo
