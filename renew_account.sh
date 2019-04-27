#!/bin/bash

##
# @Script: renew_account.sh
# @author: Doctype <ndieyplus@gmail.com>
# @Description: Script renew account expire date
##

clear

# Colors
red='\e[0;31m'       # Red
blue='\e[0;34m'      # Blue
yellow='\e[0;33m'    # Yellow
noclr='\e[0m'        # Reset

echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo -e "Expand Expired Date Account  "
echo -e "${blue}――――――――――――――――――――――――――――――――――――――――${noclr}"
read -p "Username: " USERNAME
egrep "^$USERNAME" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	read -p "Username [$USERNAME] Active Until: " expDay
	EXPDATE=$(chage -l $USERNAME | grep "Account expires" | awk -F": " '{print $2}')
	TODAYDATE=$(date -d "$EXPDATE" +"%Y-%m-%d")
	EXPACC=$(date -d "$TODAYDATE + $EXPDAY days" +"%Y-%m-%d")
	chage -E "$EXPACC" $USERNAME
	passwd -u $USERNAME
else
	echo -e "${red}Username Not Exist!${noclr}"
	exit 1
fi
echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo
