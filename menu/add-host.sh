#!/bin/bash
RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'
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

read -p "Input New Domain : " domainbaru

#Validate
if [[ $domainbaru == "" ]]; then
echo "Please Input New Domain"
exit 1
fi

#Input To Domain
cat > /etc/v2ray/domain << END
$domainbaru
END
echo "$IP=$domainbaru" >> /var/lib/premium-script/ipvps.conf
clear 
echo "SUCCESS"
