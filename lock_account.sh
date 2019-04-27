#!/bin/bash

##
# @Script: lock_account.sh
# @author: Doctype <ndieyplus@gmail.com>
# @Description: Script create users account
##

# Colors
blue='\e[0;34m'      # blue
noclr='\e[0m'        # Reset

clear

read -p "[Lock] Input Username: " USERNAME
passwd -l $USERNAME
echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${noclr}"
echo
