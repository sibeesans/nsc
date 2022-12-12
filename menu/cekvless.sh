#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$( curl ipinfo.io/ip | grep $MYIP )
if [ $MYIP = $MYIP ]; then
echo -e "${NC}${GREEN}Permission Accepted...${NC}"
else
echo -e "${NC}${RED}Permission Denied!${NC}";
echo -e "${NC}${LIGHT}Fuck You!!"
exit 0
fi

clear
data=( `cat /etc/nginx/conf.d/vps.conf | grep '^### Vless' | cut -d ' ' -f 3`);
echo "-------------------------------";
echo "-----=[ Vless User Login ]=-----";
echo "-------------------------------";
for akun in "${data[@]}"
do
data2=( `lsof -n | grep ESTABLISHED | grep nginx | awk '{print $9}' | cut -d'>' -f2 | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/nginx/access.log | grep -w $ip | awk '{print $7}' | cut -d@ -f2 | grep -w $akun | sort | uniq)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
echo "$jum : $ip";
echo "-------------------------------";
fi
done
done
