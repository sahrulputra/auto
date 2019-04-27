#!/bin/bash

##
# @Script: deleteAccount.sh
# @author: Doctype <ndieyplus@gmail.com>
# @Description: Script delete user account
##

# Colors
red='\e[0;31m'       # red
green='\e[0;32m'     # green
blue='\e[0;34m'      # blue
noclr='\e[0m'        # reset

clear

read -p "Username: " USERNAME
grep -E "^$USERNAME" /etc/passwd > /dev/null

if [ $UID -eq 0 ]; then
	read -rp "Are You Sure? [y/n]: " -e -i DELACC
	if [[ "$DELACC" = 'y' ]]; then
		passwd -l "$USERNAME"
		userdel "$USERNAME"
		echo -e "${green}Success Delete Account${noclr}"
	else
		echo -e "${red}Fail Delete Account${noclr}"
	fi
else
	echo -e "${red}Username Not Exist!${noclr}"
	exit 1
fi
echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo
