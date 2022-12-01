#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);

clear
echo "Start Update"
cd /usr/bin
wget -O add-xr "https://raw.githubusercontent.com/Rega23/new-sc/main/menu/add-xr.sh"
wget -O add-xvless "https://raw.githubusercontent.com/Rega23/new-sc/main/menu/add-xvless.sh"
wget -O del-xr "https://raw.githubusercontent.com/Rega23/new-sc/main/menu/del-xr.sh"
wget -O del-xvless "https://raw.githubusercontent.com/Rega23/new-sc/main/menu/del-xvless.sh"
wget -O xp-xr "https://raw.githubusercontent.com/Rega23/new-sc/main/menu/xp-xr.sh"
wget -O xp-xvless "https://raw.githubusercontent.com/Rega23/new-sc/main/menu/xp-xvless.sh"
wget -O menu "https://raw.githubusercontent.com/Rega23/new-sc/main/menu/menu.sh"
chmod +x add-xr
chmod +x add-xvless
chmod +x del-xr
chmod +x del-xvless
chmod +x xp-xr
chmod +x xp-xvless
chmod +x menu
#enc
shc -r -f add-xr -o add-xr
shc -r -f add-xvless -o add-xvless
shc -r -f del-xr -o del-xr
shc -r -f del-xvless -o del-xvless
shc -r -f xp-xr -o xp-xr
shc -r -f xp-xvless -o xp-xvless
shc -r -f xp-xvless -o menu
echo "0 0 * * * root xp-xr" >> /etc/crontab
echo "0 0 * * * root xp-xvless" >> /etc/crontab
clear
echo " Fix minor Bugs"
echo " Now You Can Change Port Of Some Services"
echo " Reboot 5 Sec"
sleep 5
rm -f update.sh
reboot
