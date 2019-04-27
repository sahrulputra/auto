function InstallBasePhp(){
  echo -n "Installing basic php modules for ispconfig..."
  apt-get -yqq install php5-cli php5-mysql php5-mcrypt mcrypt > /dev/null 2>&1
  echo -e "[${green}DONE${NC}]\n"
}
