#!/usr/bin/env bash

##
# IntKSetup system installer
#
# Script: install.sh
# Version: I.1.IV
# Author: Doctype <doct.knowledge@gmail.com>
# Description: This script will install all the packages needed to install
#              IntKSetup on your server.
##

# global variable
PWD=$(pwd);

ipaddr=""
default=$(curl -4 icanhazip.com);
read -p "Enter IP address [$default]: " ipaddr
ipaddr=${ipaddr:-$default}

source /root/Debian-9/sources/colors

# clear terminal screen
clear

echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "'||'  '|' '||''|.   .|'''.|    +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+"
echo -e " '|.  .'   ||   ||  ||..  '    |K| |n| |o| |w| |l| |e| |d| |g| |e|"
echo -e "  ||  |    ||...|'   ''|||.    +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+"
echo -e "   |||     ||      .     '||  ${grey}Dicipta oleh Doctype${noclr}"
echo -e "    |     .||.     |'....|'   ${grey}Dikuasai oleh VPS.Knowledge${noclr}"
echo -e "   Linux Debian-9 [32Bit]     ${grey}2019, Hak cipta terpelihara.${noclr}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check if user is root
if [[ "$UID" -ne 0 ]] ; then
    echo "${red}You need to run script as root!${noclr}"
    exit 1
fi

# Check connectivity
echo -n "Checking internet connection... "
ping -q -c 3 www.google.com
if [ ! "$?" -eq 0 ] ; then
    echo -e "${red}ERROR: Please check your internet connection${NC}"
    exit 1;
fi

# Prompt user to continue with installation
echo "Skrip akan kemas kini, menaik taraf, memasang dan mengkonfigurasi"
echo "semua perisian yang diperlukan untuk menjalankan IntKSetup."
read -p 'Anda pasti ingin teruskan [y/N]? ' choose
if ! [[ "$choose" == "y" || "$choose" == "Y" ]] ; then
    exit 1
fi

echo -n "Remove unused packages service..."
apt-get -qqy purge samba*;
apt-get -qqy purge apache2*;
apt-get -qqy purge sendmail*;
apt-get -qqy purge bind9*;
apt-get -qqy autoremove
echo -e "[${green}DONE${noclr}]"

echo -n "Updating apt and upgrading currently installed packages... "
apt-get -qq update > /dev/null 2>&1
apt-get -qqy upgrade > /dev/null 2>&1
apt-get -y build-essensitial > /dev/null 2>&1
echo -e "[${green}DONE${noclr}]"

echo "Installing basic packages... "
apt-get -y install autoconf automake cmake screen debconf-utils binutils git lsb-release > /dev/null 2>&1

echo -n "Reconfigure dash... "
echo "dash dash/sh boolean false" | debconf-set-selections
dpkg-reconfigure -f noninteractive dash > /dev/null 2>&1
echo -e "[${green}DONE${noclr}]"

ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

# openssh
echo "Configure openssh conf... "
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart
echo -e "[${green}DONE${noclr}]"

# dropbear
echo -n "Installing dropbear package... "
apt-get -qqy install dropbear > /dev/null 2>&1
echo -e "[${green}DONE${noclr}]"

echo "Configure dropbear conf... "
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=442/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart
echo -e "[${green}DONE${noclr}]"

# openvpn
echo -n "Installing openvpn package... "
apt-get -qqy install openvpn easy-rsa > /dev/null 2>&1
echo -e "[${green}DONE${noclr}]"

echo "Configure openvpn package... "
cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys

sed -i 's/export KEY_COUNTRY="US"/export KEY_COUNTRY="MY"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_PROVINCE="CA"/export KEY_PROVINCE="Sabah"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_CITY="SanFrancisco"/export KEY_CITY="Tawau"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_ORG="Fort-Funston"/export KEY_ORG="VPS-Knowledge"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_EMAIL="me@myhost.mydomain"/export KEY_EMAIL="doct.knowledge@gmail.com"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_OU="MyOrganizationalUnit"/export KEY_OU="KnowledgeVPS"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_NAME="EasyRSA"/export KEY_NAME="KnowledgeRSA"/' /etc/openvpn/easy-rsa/vars

cd /etc/openvpn/easy-rsa
. ./vars
./clean-all
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*

export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server

export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client

openssl dhparam -out /etc/openvpn/dh2048.pem 2048

cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn/server.crt
cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn/server.key
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/ca.crt

cat > /etc/openvpn/server.conf << EOF
local 0.0.0.0
port 1194
proto tcp
dev tun
ca /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/server.crt
key /etc/openvpn/keys/server.key
dh /etc/openvpn/keys/dh2048.pem
plugin /usr/lib/openvpn/openvpn-auth-pam.so /etc/pam.d/login
client-cert-not-required
username-as-common-name
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
duplicate-cn
cipher AES-256-CBC
keepalive 10 120
user nobody
group nogroup
persist-key
persist-tun
status vpn-status.log
log vpn-log.log
comp-lzo
verb 3
mute 20
EOF

cat > /etc/openvpn/client.ovpn << EOF
client
dev tun
proto tcp
remote $ipaddr 1194
resolv-retry infinite
ns-cert-type server
nobind
user nobody
group nogroup
persist-key
persist-tun
;http-proxy-retry
;http-proxy [squid] [port]
;http-proxy-option CUSTOM-HEADER Host [host]
;http-proxy-option CUSTOM-HEADER X-Online-Host [host]
cipher AES-256-CBC
mute-replay-warnings
auth-user-pass
comp-lzo
verb 3
mute 20
EOF

echo '' >> /etc/openvpn/client.ovpn
echo '<ca>' >> /etc/openvpn/client.ovpn
cat /etc/openvpn/keys/ca.crt >> /etc/openvpn/client.ovpn
echo '</ca>' >> /etc/openvpn/client.ovpn

cp /etc/openvpn/client.ovpn /home/www/html/

/etc/init.d/openvpn restart
service openvpn start
service openvpn status
echo -e "[${green}DONE${noclr}]"

# squid3
echo "Installing openvpn package... "
apt-get -y install squid3 > /dev/null 2>&1
echo -e "[${green}DONE${noclr}]"

echo "Configure openvpn package... "
cat > /etc/squid3/squid.conf << EOF
# NETWORK OPTIONS.
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
# local Networks.
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl VPS dst $ipaddr/32
# squid Port
http_port 3128
http_port 8080
# Minimum configuration.
http_access allow VPS
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access allow localnet
http_access deny all
# Add refresh_pattern.
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname proxy.vps-knowledge
EOF

service squid3 restart
echo -e "[${green}DONE${noclr}]"

# badvpn-udpgw
echo -n "Downloading badvpn package from source..."
wget -O /usr/bin/badvpn-udpgw "https://github.com/sahrulputra/auto/master/badvpn-udpgw"
echo -e "[${green}DONE${noclr}]"

echo -n "Configure badvpn package... "
chmod +x /usr/bin/badvpn-udpgw
badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300
echo -e "[${green}DONE${noclr}]"

# stunnel4
echo -n "Installing stunnel4 package... "
apt-get -qqy install stunnel4 > /dev/null 2>&1
echo -e "[${green}DONE${noclr}]"

echo -n "Configure stunnel4 package... "
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -sha256 -subj '/CN=127.0.0.1/O=localhost/C=MY' -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem

cat > /etc/stunnel/stunnel.conf << EOF
sslVersion = all
pid = /stunnel.pid
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
client = no
[dropbear]
accept = $ipaddr:443
connect = 127.0.0.1:442
cert = /etc/stunnel/stunnel.pem
EOF

service stunnel4 restart
echo -e "[${green}DONE${noclr}]"

# fail2ban
echo -n "Installing fail2ban package... "
apt-get -qqy install fail2ban > /dev/null 2>&1
service fail2ban restart
echo -e "[${green}DONE${noclr}]"

# iptables
echo -n "Installing iptables package... "
apt-get -qqy install iptables > /dev/null 2>&1
echo -e "[${green}DONE${noclr}]"

echo "Configure iptables package... "
cat > /etc/iptables.up.rules << EOF
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o eth0 -j MASQUERADE
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A INPUT -p tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
-A INPUT -p tcp --dport 22 -j ACCEPT
-A INPUT -p tcp --dport 2020 -j ACCEPT
-A INPUT -p tcp --dport 4343 -j ACCEPT
-A INPUT -p tcp --dport 1194 -j ACCEPT
-A INPUT -p tcp --dport 3128 -j ACCEPT
-A INPUT -p tcp --dport 8888 -j ACCEPT
-A INPUT -p tcp --dport 7300 -j ACCEPT
-A INPUT -p tcp --dport 10000 -j ACCEPT
COMMIT
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
EOF

iptables-restore < /etc/iptables.up.rules
echo -e "[${green}DONE${noclr}]"

# command script
wget -O /usr/local/bin/menu "/root/auto/master/main_menu.sh"
wget -O /usr/local/bin/01 "/root/auto/master/trial_account.sh"
wget -O /usr/local/bin/02 "/root/auto/master/create_account.sh"
wget -O /usr/local/bin/03 "/root/auto/master/renew_account.sh"
wget -O /usr/local/bin/04 "/root/auto/master/change_password.sh"
wget -O /usr/local/bin/05 "/root/auto/master/lock_account.sh"
wget -O /usr/local/bin/06 "/root/auto/master/unlock_account.sh"
wget -O /usr/local/bin/07 "/root/auto/master/delete_account.sh"
wget -O /usr/local/bin/08 "/root/auto/master/list_account.sh" #Error!
wget -O /usr/local/bin/09 "/root/auto/master/online_account.sh" #Error!
wget -O /usr/local/bin/10 "/root/auto/master/speedtest_cli.py"
wget -O /usr/local/bin/11 "/root/auto/master/system_info.sh"

chmod +x /usr/local/bin/menu
chmod +x /usr/local/bin/01
chmod +x /usr/local/bin/02
chmod +x /usr/local/bin/03
chmod +x /usr/local/bin/04
chmod +x /usr/local/bin/05
chmod +x /usr/local/bin/06
chmod +x /usr/local/bin/07
chmod +x /usr/local/bin/08
chmod +x /usr/local/bin/09
chmod +x /usr/local/bin/10
chmod +x /usr/local/bin/11

# restart pakages service
service ssh restart
service openvpn restart
service dropbear restart
service squid3 restart
service badvpn-udpgw restart
service stunnel4 restart
service fail2ban restart

# final step
echo "You need [reboot] server to complete this setup."
