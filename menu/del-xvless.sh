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
NUMBER_OF_CLIENTS=$(grep -c -E "^### Vless " "/etc/nginx/conf.d/vps.conf")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### Vless " "/etc/nginx/conf.d/vps.conf" | cut -d ' ' -f 3-4 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^### Vless " "/etc/nginx/conf.d/vps.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### Vless " "/etc/nginx/conf.d/vps.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### Vless $user $exp/,/^}/d" /etc/nginx/conf.d/vps.conf
systemctl disable xray@vless-$user
systemctl stop xray@vless-$user
rm -f /usr/local/etc/xray/vless-$user.json
systemctl reload nginx
clear
echo " VLESS berhasil dihapus"
echo " =========================="
echo " Client Name : $user"
echo " Expired On  : $exp"
echo " =========================="
echo ""
