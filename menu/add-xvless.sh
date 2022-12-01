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
domain=$(cat /etc/v2ray/domain)
read -rp "User: " -e user
egrep -w "^### Vless $user" /etc/nginx/conf.d/vps.conf >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username Sudah Ada"
exit 0
fi
PORT=$((RANDOM + 10000))
read -p "Expired (days): " masaaktif
uuid=$(cat /proc/sys/kernel/random/uuid)
uid=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 14; echo;)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
now=`date +"%Y-%m-%d"`
cat> /usr/local/etc/xray/vless-$user.json<<END
{
  "log": {
        "access": "/var/log/xray/access.log",
        "error": "/var/log/xray/error.log",
        "loglevel": "warning"
    },
  "inbounds": [
    {
      "port":$PORT,
      "listen": "127.0.0.1", 
      "tag": "VLESS-in", 
      "protocol": "VLESS", 
      "settings": {
        "clients": [
          {
            "id": "$uuid"
          }
        ],
	    "decryption": "none"
      }, 
      "streamSettings": {
        "network": "ws", 
        "wsSettings": {
        "path":"/mrg@u=$user&p=$uid&"
        }
      }
    }
  ], 
  "outbounds": [
    {
      "protocol": "freedom", 
      "settings": { }, 
      "tag": "direct"
    }, 
    {
      "protocol": "blackhole", 
      "settings": { }, 
      "tag": "blocked"
    }
  ], 
  "dns": {
    "servers": [
      "https+local://1.1.1.1/dns-query",
	  "1.1.1.1",
	  "1.0.0.1",
	  "8.8.8.8",
	  "8.8.4.4",
	  "localhost"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "inboundTag": [
          "VLESS-in"
        ],
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
sed -i '$ i### Vless '"$user"' '"$exp"'' /etc/nginx/conf.d/vps.conf
sed -i '$ ilocation /worldssh@u='"$user"'&p='"$uid"'&' /etc/nginx/conf.d/vps.conf
sed -i '$ i{' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_pass http://127.0.0.1:'"$PORT"';' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/vps.conf
sed -i '$ i}' /etc/nginx/conf.d/vps.conf
vlesslink1="vless://${uuid}@${domain}:443/?tyepe=ws&encryption=none&host=bug.com&path=%2Fmrg@u%3D${user}%26p%3D${uid}%26&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:80?path=%2Fmrg@u%3D${user}%26p%3D${uid}%26&encryption=none&type=ws#${user}"
systemctl start xray@vless-$user
systemctl enable xray@vless-$user
#echo -e "\033[32m[Info]\033[0m Xray-Vless Start Successfully !"
sleep 0.5
systemctl reload nginx
clear
echo -e "=================================" | lolcat
echo -e "VPN TYPE       : XRAY - VLESS   "
echo -e "=================================" | lolcat
echo -e "Remarks        : ${user}"
echo -e "Domain         : ${domain}"
echo -e "Port TLS       : 443"
echo -e "Port NTLS      : 80"
echo -e "ID             : ${uuid}"
#echo -e "AlterId        :))
echo -e "Encryption     : none"
echo -e "Network        : ws"
echo -e "Path           : /mrg@u=${user}&p=${uid}&"
echo -e "=================================" | lolcat
echo -e "Link TLS       : ${vlesslink1}"
echo -e "=================================" | lolcat
echo -e "Link NTLS      : ${vlesslink2}"
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp"
echo -e "=================================" | lolcat
echo -e "~/.MRG"
