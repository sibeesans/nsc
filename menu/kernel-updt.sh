#!/bin/bash
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$( curl https://bajek.000webhostapp.com/akses.php | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${NC}${GREEN}Permission Accepted...${NC}"
else
echo -e "${NC}${RED}Permission Denied!${NC}";
exit 0
fi 

clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m         • KERNEL UPDATE •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "[ \033[32mInfo\033[0m ] Start Updating Kernel"
echo -e ""
source /etc/os-release
OS=$ID
# Ubuntu Version
if [[ $OS == 'ubuntu' ]]; then
wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
install ubuntu-mainline-kernel.sh /usr/local/bin/
rm -f ubuntu-mainline-kernel.sh
ubuntu-mainline-kernel.sh -c

# Checking Version
if [ $ver == $now ]; then
echo "Your Kernel Is The Latest Version"A
rm -f /usr/bin/ubuntu-mainline-kernel.sh
exit 0
else
printf "y" | ubuntu-mainline-kernel.sh -i
rm -f /usr/bin/ubuntu-mainline-kernel.sh
fi

# Debian Version
elif [[ $OS == "debian" ]]; then
ver=(`apt-cache search linux-image | grep "^linux-image" | cut -d'-' -f 3-4 |tail -n1`)
now=$(uname -r | cut -d "-" -f 1-2)

# Checking Kernel
if [ $ver == $now ]; then
echo "Your Kernel Is The Latest Version"
exit 0
else
apt install linux-image-$ver-amd64
fi

# Other OS Check
elif [[ $OS == "centos" ]]; then
    echo "Not Supported For Centos!"
    exit 1
elif [[ $OS == "fedora" ]]; then
    echo "Not Supported For Fedora"
    exit 1
else
    echo "Your OS Not Support"
    exit 1
fi

# Done
echo -e   ""
echo -e "[ \033[32mInfo\033[0m ] DONE Updating Kernel"
echo -e   ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo "[ \033[32mInfo\033[0m ] Your VPS Will Be Reboot In 5s"
echo -e ""
sleep 5
reboot
