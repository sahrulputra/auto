function PreInstallCheck() {
  # Check if user is root
  if [ $(id -u) != "0" ]; then
    echo -n "Error: You must be root to run this script."
    exit 1
  fi

  # Check connectivity
  echo -n "Checking internet connection... "
  ping -q -c 3 www.google.com > /dev/null 2>&1

  if [ ! "$?" -eq 0 ]; then
    echo -e "${red}ERROR: Please check your internet connection.${noclr}"
    exit 1;
  fi

  # Check for already installed ispconfig version
  if [ -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
    echo "ISPConfig is already installed, can't go on."
	exit 1
  fi

  # Check source.list
  contrib=$(cat /etc/apt/sources.list | grep contrib | grep -v "cdrom")
  nonfree=$(cat /etc/apt/sources.list | grep non-free | grep -v "cdrom")
  if [ -z "$contrib" ]; then
    if [ -z "$nonfree" ]; then
      sed -i 's/main/main contrib non-free/' /etc/apt/sources.list;
    else
      sed -i 's/main/main contrib/' /etc/apt/sources.list;
    fi
  else
    if [ -z "$nonfree" ]; then
      sed -i 's/main/main non-free/' /etc/apt/sources.list;
    fi
  fi
  echo -e "${green} OK${NC}\n"
}
