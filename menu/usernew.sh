#!/bin/bash
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
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
IP=$(wget -qO- ipinfo.io/ip);
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e "=================================" | lolcat
echo -e "VPN TYPE       : SSH - WS"
echo -e "=================================" | lolcat
echo -e "Username       : $Login "
echo -e "Password       : $Pass"
echo -e "=================================" | lolcat
echo -e "Domain         : ${domain}"
echo -e "Host/IP        : $IP"
echo -e "ISP            : $ISP"
echo -e "CITY           : $CITY"
echo -e "OpenSSH        : 22"
echo -e "Dropbear       : 109, 143"
echo -e "SSL/TLS        : $ssl"
echo -e "SSH WS CDN     : 8880, 2095"
echo -e "TLS WS CDN     : 443"
#echo -e "OVPN CDN       : 2082"
echo -e "Port Squid     : $sqd"
echo -e "OHP SSH        : 8181"
echo -e "OHP Dropbear   : 8282"
#echo -e "OHP OVPN       : 8383"
#echo -e "OpenVPN        : TCP $ovpn http://$domain:81/client-tcp-$ovpn.ovpn"
#echo -e "OpenVPN        : UDP $ovpn2 http://$domain:81/client-udp-$ovpn2.ovpn"
#echo -e "OpenVPN        : SSL 442 http://$domain:81/client-tcp-ssl.ovpn"
echo -e "BadVPN         : 7100-7300"
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp"
echo -e "=================================" | lolcat
echo -e "~/.MRG"
echo -e ""
