#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$( curl https://bajek.000webhostapp.com/akses.php | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${NC}${GREEN}Permission Accepted...${NC}"
else
echo -e "${NC}${RED}Permission Denied!${NC}";
exit 0
fi 

domain=$(cat /etc/v2ray/domain)
read -rp "Username: " -e user
egrep -w "^### $user" /usr/local/etc/xray/trojanws.json >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username Sudah Ada"

exit 0
fi
clear
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/trojanws.json
systemctl restart xray@trojanws
trojanlink="trojan-go://${uuid}@${domain}:443/?sni=${domain}&type=ws&host=${domain}&path=/WorldSSH&encryption=none#${user}"
echo -e "### $user $exp" >> /etc/trojan/trojango.conf
clear
echo -e "=================================" | lolcat
echo -e "VPN TYPE       : TROJAN GO"
echo -e "=================================" | lolcat
echo -e "Remarks        : ${user}"
echo -e "Host           : ${domain}"
echo -e "Port           : 443"
echo -e "Key            : ${uuid}"
echo -e "Network        : ws"
echo -e "Encryption     : none"
echo -e "Path           : /mrg"
echo -e "=================================" | lolcat
echo -e "Link           : ${trojanlink}"
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp"
echo -e "=================================" | lolcat
echo -e "~/.MRG"
echo -e ""
