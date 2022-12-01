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
domain=$(cat /etc/v2ray/domain);
clear
IP=$(wget -qO- ipinfo.io/ip);
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
MYIP=$(wget -qO- ipinfo.io/ip);
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
Login=Trial-`</dev/urandom tr -dc X-Z0-9 | head -c3`
hari="1"
Pass=`</dev/urandom tr -dc 0-9 | head -c3`

useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e "=================================" | lolcat
echo -e "VPN TYPE       : TRIAL SSH - WS"
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
echo -e "Port Squid     : $sqd"
echo -e "OHP SSH        : 8181"
echo -e "OHP Dropbear   : 8282"
#echo -e "OpenVPN        : TCP $ovpn http://$IP:81/client-tcp-$ovpn.ovpn"
#echo -e "OpenVPN        : UDP $ovpn2 http://$IP:81/client-udp-$ovpn2.ovpn"
#echo -e "OpenVPN        : SSL 442 http://$IP:81/client-tcp-ssl.ovpn"
echo -e "BadVPN         : 7100-7300"
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp"
echo -e "=================================" | lolcat
echo -e "~/.MRG"
echo -e ""
