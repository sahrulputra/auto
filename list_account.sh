#!/bin/bash

##
# @Script: list_account.sh
# @author: Doctype <ndieyplus@gmail.com>
# @Description: Script create user account
##

# Colors
red='\e[0;31m'       # red
blue='\e[0;34m'      # blue
noclr='\e[0m'        # reset

clear

echo "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo "PID    Username    Expired    "
echo "${blue}――――――――――――――――――――――――――――――――――――――――${noclr}"
while read EXPUSER ; do
	USERACC="$(echo $EXPUSER | cut -d: -f1)"
	USERID="$(echo $EXPUSER | grep -v nobody | cut -d: -f3)"
	EXPDATE="$(chage -l $USERACC | grep "Account expires" | awk -F": " '{print $2}')"
	if [[ $USERID -ge 1000 ]]; then
		printf "%-17s %2s\n" "$USERACC" "$EXPDATE"
	fi
done < /etc/passwd

TOTALACC="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo "${blue}――――――――――――――――――――――――――――――――――――――――${noclr}"
echo "Total Account: $TOTALACC user"
echo "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo
