#!/bin/bash
domain=$(cat /root/domain)
apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date
mkdir -p /etc/trojan/
touch /etc/trojan/akun.conf
# install v2ray
wget https://raw.githubusercontent.com/sibeesans/nsc/main/trojan/go.sh && chmod +x go.sh && ./go.sh
rm -f /root/go.sh
bash -c "$(wget -O- https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
#cert
mail=$(</dev/urandom tr -dc a-z0-9 | head -c4)
email=${mail}@gmail.com
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --register-account -m $email
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc
service squid start
uuid=$(cat /proc/sys/kernel/random/uuid)
cat <<EOF > /etc/trojan/config.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "password"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/v2ray/v2ray.crt",
        "key": "/etc/v2ray/v2ray.key",
        "key_password": "",
        "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 81
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": false,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "",
        "key": "",
        "cert": "",
        "ca": ""
    }
}
EOF
cat <<EOF> /etc/systemd/system/trojan.service
[Unit]
Description=Trojan
Documentation=https://trojan-gfw.github.io/trojan/

[Service]
Type=simple
ExecStart=/usr/local/bin/trojan -c /etc/trojan/config.json -l /var/log/trojan.log
Type=simple
KillMode=process
Restart=no
RestartSec=42s

[Install]
WantedBy=multi-user.target

EOF

cat <<EOF > /etc/trojan/uuid.txt
$uuid
EOF

iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl restart trojan
systemctl enable trojan
systemctl restart v2ray
systemctl enable v2ray
cd /usr/bin
wget -O cekws "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/cekws.sh"
wget -O cekvless "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/cekvless.sh"
wget -O renewws "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/renewws.sh"
wget -O renewvless "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/renewvless.sh"
wget -O renew-tr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/renew-tr.sh"
wget -O xp-ws "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/xp-ws.sh"
wget -O xp-vless "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/xp-vless.sh"
wget -O certv2ray "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/cert.sh"
wget -O add-tr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/add-tr.sh"
wget -O del-tr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/del-tr.sh"
wget -O cek-tr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/cek-tr.sh"
wget -O add-trg "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/addtrgo.sh"
wget -O del-trg "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/deltrgo.sh"
wget -O renew-trg "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/renew-trg.sh"

wget -O renew-trg "https://raw.githubusercontent.com/sibeeesans/nsc/main/menu/xp-tr.sh"
chmod +x del-tr
chmod +x cek-tr
chmod +x add-trg
chmod +x del-trg
chmod +x renew-trg
chmod +x xp-tr
chmod +x cekws
chmod +x cekvless
chmod +x renewws
chmod +x renew-tr
chmod +x renewvless
chmod +x xp-ws
chmod +x xp-vless
chmod +x certv2ray

wget -O add-xr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/add-xr.sh"
wget -O add-xvless "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/add-xvless.sh"
wget -O del-xr "https://raw.githubusercontent.com/sibeesans/nscw-sc/main/menu/del-xr.sh"
wget -O del-xvless "https://raw.githubusercontent.com/sibeesans/nscw-sc/main/menu/del-xvless.sh"
wget -O cekws "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/cekws.sh"
wget -O cekvless "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/cekvless.sh"
wget -O renewws "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/renewws.sh"
wget -O renewvless "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/renewvless.sh"
wget -O renewtr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/renewtr.sh"
wget -O xp-xr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/xp-xr.sh"
wget -O xp-xvless "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/xp-xvless.sh"
wget -O certv2ray "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/cert.sh"
wget -O add-tr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/add-tr.sh"
wget -O del-tr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/del-tr.sh"
wget -O cek-tr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/cek-tr.sh"
wget -O xp-tr "https://raw.githubusercontent.com/sibeesans/nsc/main/menu/xp-tr.sh"
chmod +x add-tr
chmod +x del-tr
chmod +x cek-tr
chmod +x xp-tr
chmod +x xp-trgo
chmod +x add-xr
chmod +x add-xvless
chmod +x del-xr
chmod +x del-xvless
chmod +x cekws
chmod +x cekvless
chmod +x renewws
chmod +x renewtr
chmod +x renewvless
chmod +x xp-xr
chmod +x xp-xvless
chmod +x certv2ray



#enc
shc -r -f add-tr -o add-tr
shc -r -f del-tr -o del-tr
shc -r -f cek-tr -o cek-tr
shc -r -f add-trg -o add-trg
shc -r -f del-trg -o del-trg
shc -r -f renew-trg -o cek-trg
shc -r -f xp-tr -o xp-tr
shc -r -f delws -o delws
shc -r -f delvless -o delvless
shc -r -f cekws -o cekws
shc -r -f cekvless -o cekvless
shc -r -f renewws -o renewws
shc -r -f renew-tr -o renew-tr
shc -r -f renew-vless -o renewvless
shc -r -f xp-ws -o xp-ws
shc -r -f xp-vless -o xp-vless
shc -r -f certv2ray -o certv2ray



cd
mv /root/domain /etc/v2ray
echo "59 23 * * * root xp-xr" >> /etc/crontab
echo "59 23 * * * root xp-ws" >> /etc/crontab
echo "59 23 * * * root xp-trgo" >> /etc/crontab
echo "59 23 * * * root xp-vless" >> /etc/crontab
echo "59 23 * * * root xp" >> /etc/crontab
echo "0 0 * * * root clear-log reboot" >> /etc/crontab

