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
domain=$(cat /etc/v2ray/domain)
read -rp "User: " -e user
egrep -w "^### Vless $user" /etc/nginx/conf.d/xray.conf >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username Sudah Ada"
exit 0
fi
read -p "Expired (days): " masaaktif
uuid=$(cat /proc/sys/kernel/random/uuid)
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
      "port": "vless",
      "listen": "127.0.0.1", 
      "tag": "VLESS-in", 
      "protocol": "14016",
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
        "path":"/vless"
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
sed -i '$ i### Vless '"$user"' '"$exp"'' /etc/nginx/conf.d/xray.conf
sed -i '$ ilocation /worryfree' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:14016;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf
vlesslink1="vless://${uuid}@${domain}:443/?type=ws&encryption=none&host=bug.com&path=/vless&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:80?path=/vless&encryption=none&type=ws#${user}"
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
echo -e "Encryption     : none"
echo -e "Network        : ws"
echo -e "Path           : /worryfree"
echo -e "=================================" | lolcat
echo -e "Link TLS       : ${vlesslink1}"
echo -e "=================================" | lolcat
echo -e "Link NTLS      : ${vlesslink2}"
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp"
echo -e "=================================" | lolcat
echo -e "~/.MRG"
