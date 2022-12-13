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
source /var/lib/premium-script/ipvps.conf
domain=$(cat /etc/v2ray/domain)
read -rp "Username: " -e user
egrep -w "^### Vmess $user" /etc/nginx/conf.d/vps.conf >/dev/null
if [ $? -eq 0 ]; then
echo "Username already used"
exit 0
fi
PORT=$((RANDOM + 10000))
read -p "Expired (days): " masaaktif
uuid=$(cat /proc/sys/kernel/random/uuid)
uid=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 14; echo;)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
now=`date +"%Y-%m-%d"`
cat> /usr/local/etc/xray/vmess-$user.json<<END
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
      "tag": "vmess-in",
      "protocol": "vmess",
      "settings": {
        "clients": [
        {
            "id": "${uuid}",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path":"/worryfree"
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
          "vmess-in"
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
sed -i '$ i### Vmess '"$user"' '"$exp"'' /etc/nginx/conf.d/xray.conf
sed -i '$ ilocation /worryfree' /etc/nginx/conf.d/xray.conff
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:'"$PORT"';' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/vps.conf
tls=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/worryfree",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
none=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/worryfree",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
}
EOF`
tls2=`cat<<EOF
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/worryfree",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`

vmesslink1="vmess://$(echo $tls | base64 -w 0)"
vmesslink2="vmess://$(echo $none | base64 -w 0)"
vmesslink2="vmess://$(echo $tls2 | base64 -w 0)"


systemctl start xray@vmess-$user
systemctl enable xray@vmess-$user
systemctl reload nginx
clear
echo -e "=================================" | lolcat
echo -e "VPN TYPE       : XRAY - VMESS"
echo -e "=================================" | lolcat
echo -e "Remarks        : ${user}"
echo -e "Domain         : ${domain}"
echo -e "Port TLS       : 443"
echo -e "Port NTLS      : 80"
echo -e "ID             : ${uuid}"
echo -e "alterId        : 0"
echo -e "Security       : auto"
echo -e "Metwork        : ws"
echo -e "Path           : /worryfree"
echo -e "=================================" | lolcat
echo -e "Link TLS       : ${vmesslink1}"
echo -e "=================================" | lolcat
echo -e "Link NTLS      : ${vmesslink2}"
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp"
echo -e "=================================" | lolcat
echo -e "~/.MRG"
echo -e ""
