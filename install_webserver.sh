function InstallWebServer() {
  	echo -n "Installing NGINX and Modules... "
  	apt-get -yqq install nginx > /dev/null 2>&1
  	service nginx start
  	apt-get -yqq install php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-imap php7.0-cli php7.0-cgi php-pear php7.0-mcrypt php7.0-curl php7.0-intl php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl php7.0-zip php7.0-mbstring php7.0-imap php7.0-mcrypt php7.0-snmp php7.0-xmlrpc php7.0-xsl > /dev/null 2>&1
  	#Need to check if soemthing is asked before suppress messages
  	apt-get -y install php7.0-fpm
  	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
  	sed -i "s/;date.timezone =/date.timezone=\"Europe\/Rome\"/" /etc/php/7.0/fpm/php.ini
  	echo -n "Installing needed Programs for PHP and NGINX... "
  	apt-get -yqq install mcrypt imagemagick memcached curl tidy snmp > /dev/null 2>&1
  	service php7.0-fpm reload
  	apt-get -yqq install fcgiwrap

    if [ $CFG_PHPMYADMIN == "yes" ]; then
    	echo -n "Installing phpMyAdmin... "
    	apt-get -y install phpmyadmin
    	echo -e "[${green}DONE${noclr}]\n"
    fi

    if [ $CFG_PHP56 == "yes" ]; then
  		echo "Installing PHP 5.6"
  		apt-get -yqq install apt-transport-https
  		curl https://packages.sury.org/php/apt.gpg | apt-key add -  > /dev/null 2>&1
  		echo 'deb https://packages.sury.org/php/ stretch main' > /etc/apt/sources.list.d/deb.sury.org.list
  		apt-get update  > /dev/null 2>&1
  		apt-get -yqq install php5.6 php5.6-common php5.6-gd php5.6-mysql php5.6-imap php5.6-cli php5.6-cgi php5.6-mcrypt php5.6-curl php5.6-intl php5.6-pspell php5.6-recode php5.6-sqlite3 php5.6-tidy php5.6-xmlrpc php5.6-xsl php5.6-zip php5.6-mbstring php5.6-fpm
  		echo -e "Package: *\nPin: origin packages.sury.org\nPin-Priority: 100" > /etc/apt/preferences.d/deb-sury-org
    fi
  	echo -n "Installing Lets Encrypt... "
  	apt-get -yqq install certbot > /dev/null 2>&1
  	echo -e "[${green}DONE${noclr}]\n"

  	echo -n "Install PHP Opcode Cache "
    apt-get -yqq install php7.0-opcache php-apcu > /dev/null 2>&1
  	echo -e "[${green}DONE${noclr}]\n"
    echo -e "[${green}DONE${noclr}]\n"
    if [ $CFG_PHP56 == "yes" ]; then
    	echo -e "${red}Attention!!! You had installed php7 and php 5.6, to make php 5.6 work you had to configure the following in ISPConfig ${noclr}"
    	echo -e "${red}Path for PHP FastCGI binary: /usr/bin/php-cgi5.6 ${noclr}"
    	echo -e "${red}Path for php.ini directory: /etc/php/5.6/cgi ${noclr}"
    	echo -e "${red}Path for PHP-FPM init script: /etc/init.d/php5.6-fpm ${noclr}"
    	echo -e "${red}Path for php.ini directory: /etc/php/5.6/fpm ${noclr}"
    	echo -e "${red}Path for PHP-FPM pool directory: /etc/php/5.6/fpm/pool.d ${noclr}"
    fi
}
