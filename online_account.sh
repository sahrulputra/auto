#!/bin/bash

##
# @Script: online_account.sh
# @author: Doctype <ndieyplus@gmail.com>
# @Description: Script Online Account List
##

clear

data=(`ps aux | grep -i dropbear | awk '{print $2}'`);
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "DropBear"
echo "――――――――――――――――――――――――――――――――――――――――"
for PID in "${data[@]}" ; do
	AUTHUSER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
	USERNAME=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
	IPADDR=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
	if [ $AUTHUSER -eq 1 ]; then
		echo "$PID - $USERNAME - $IPADDR";
	fi
done

data=(`ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SecureShell"
echo "――――――――――――――――――――――――――――――――――――――――"
for PID in "${data[@]}" ; do
	AUTHUSER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
	USERNAME=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
	IPADDR=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
	if [ $authUser -eq 1 ]; then
		echo "$PID - $USERNAME - $IPADDR";
	fi
done
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
