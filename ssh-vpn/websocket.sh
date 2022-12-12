#!/bin/bash
clear
echo Installing Websocket-SSH Python
cd
#Buat name user github dan nama folder
namafolder="websocket-python"

#Install system auto run
#System OpenSSH Websocket-SSH Python
cd
cd /etc/systemd/system/
wget -O /etc/systemd/system/ws-openssh.service https://raw.githubusercontent.com/sibeesans/nsc/main/ssh-vpn/ws-openssh.service
#System Dropbear Websocket-SSH Python
wget -O /etc/systemd/system/ws-dropbear.service https://raw.githubusercontent.com/sibeesans/nsc/main/ssh-vpn/ws-dropbear.service
#System SSL/TLS Websocket-SSH Python
wget -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/sibeesans/nsc/main/ssh-vpn/ws-stunnel.service
##System Websocket-OpenVPN Python
wget -O /etc/systemd/system/ws-ovpn.service https://raw.githubusercontent.com/sibeesans/nsc/main/ssh-vpn/ws-ovpn.service

#Install Script Websocket-SSH Python
cd
cd /usr/local/bin/
wget -O /usr/local/bin/ws-openssh https://raw.githubusercontent.com/sibeesans/nsc/main/ssh-vpn/ws-openssh
wget -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/sibeesans/nsc/main/ssh-vpn/ws-dropbear
wget -O /usr/local/bin/ws-stunnel https://raw.githubusercontent.com/sibeesans/nsc/main/ssh-vpn/ws-stunnel
wget -O /usr/local/bin/ws-ovpn https://raw.githubusercontent.com/sibeesans/nsc/main/ssh-vpn/ws-ovpn
#
chmod +x /usr/local/bin/ws-openssh
chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-stunnel
chmod +x /usr/local/bin/ws-ovpn
cd
#
cd
systemctl daemon-reload
#Enable & Start & Restart ws-openssh service
systemctl enable ws-openssh.service
systemctl start ws-openssh.service
systemctl restart ws-openssh.service

#Enable & Start & Restart ws-openssh service
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service

#Enable & Start & Restart ws-openssh service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service

#Enable & Start ws-ovpn service
systemctl enable ws-ovpn.service
systemctl start ws-ovpn.service
systemctl restart ws-ovpn.service
