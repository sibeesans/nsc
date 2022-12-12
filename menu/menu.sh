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


# VPS Information
#Domain
domain=$(cat /etc/v2ray/domain)
#Status certificate
#modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
#modifyTime1=$(date +%s -d "${modifyTime}")
#currentTime=$(date +%s)
#stampDiff=$(expr ${currentTime} - ${modifyTime1})
#days=$(expr ${stampDiff} / 86400)
#remainingDays=$(expr 90 - ${days})
#tlsStatus=${remainingDays}
#if [[ ${remainingDays} -le 0 ]]; then
#	tlsStatus="expired"
#fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Download
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
IPVPS=$(curl -s ipinfo.io/ip )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )

declare -A nama_hari
nama_hari[Monday]="Senin"
nama_hari[Tuesday]="Selasa"
nama_hari[Wednesday]="Rabu"
nama_hari[Thursday]="Kamis"
nama_hari[Friday]="Jumat"
nama_hari[Saturday]="Sabtu"
nama_hari[Sunday]="Minggu"
hari_ini=`date +%A`


declare -A nama_bulan
nama_bulan[Jan]="Januari"
nama_bulan[Feb]="Februari"
nama_bulan[Mar]="Maret"
nama_bulan[Apr]="April"
nama_bulan[May]="Mei"
nama_bulan[Jun]="Juni"
nama_bulan[Jul]="Juli"
nama_bulan[Aug]="Agustus"
nama_bulan[Sep]="September"
nama_bulan[Oct]="Oktober"
nama_bulan[Nov]="November"
nama_bulan[Dec]="Desember"
bulan_ini=`date +%b`

hari=${nama_hari[$hari_ini]}
jam=$(TZ='Asia/Jakarta' date +%R)
tnggl=$(date +"%d")
bln=${nama_bulan[$bulan_ini]}
thn=$(date +"%Y")
clear 


echo ""
echo ""
echo ""
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e "                    ~./MRG " | lolcat
echo -e "${red}══════════════════════════════════════════════════════════${NC}"p
echo -e " ${blue}Local TZ               :  Asia/Jakarta ${NC}"
echo -e " ${blue}Time                   :  $jam WIB ${NC}"
echo -e " ${blue}Day                    :  $hari ${NC}"
echo -e " ${blue}Date                   :  $tnggl $bln $thn ${NC}"
echo -e "${red}══════════════════════════════════════════════════════════${NC}"

echo -e "                  • SERVER INFO •                 " | lolcat
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e "${blue}>${NC}\e[33m CPU Model              \e[0m: $cname"
echo -e "${blue}>${NC}\e[33m CPU Frequency          \e[0m: $freq MHz"
echo -e "${blue}>${NC}\e[33m Number Of Cores        \e[0m:  $cores"
echo -e "${blue}>${NC}\e[33m CPU Usage              \e[0m:  $cpu_usage"
echo -e "${blue}>${NC}\e[33m Operating System       \e[0m:  "`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`	
echo -e "${blue}>${NC}\e[33m Kernel                 \e[0m:  `uname -r`"
echo -e "${blue}>${NC}\e[33m Total Amount Of RAM    \e[0m:  $tram MB"
echo -e "${blue}>${NC}\e[33m Used RAM               \e[0m:  $uram MB"
echo -e "${blue}>${NC}\e[33m Free RAM               \e[0m:  $fram MB"
echo -e "${blue}>${NC}\e[33m System Uptime          \e[0m:  $uptime "
echo -e "${blue}>${NC}\e[33m ISP Name               \e[0m:  $ISP"
echo -e "${blue}>${NC}\e[33m Domain                 \e[0m:  $domain"	
echo -e "${blue}>${NC}\e[33m IP Vps                 \e[0m:  $IPVPS"	
echo -e "${blue}>${NC}\e[33m City                   \e[0m:  $CITY"
echo -e "${blue}>${NC}\e[33m TimeZone               \e[0m:  $WKT"
echo -e "${blue}>${NC}\e[33m Day                    \e[0m:  $DAY ($hari)"
echo -e "${blue}>${NC}\e[33m Date                   \e[0m:  $DATE"
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e "\e[33m Traffic\e[0m        \e[33mToday       Yesterday      Month   "
echo -e "\e[33m Download\e[0m       $dtoday   $dyest   $dmon   \e[0m"
echo -e "\e[33m Upload\e[0m         $utoday   $uyest   $umon   \e[0m"
echo -e "\e[33m Total\e[0m  \033[0;36m        $ttoday   $tyest   $tmon  \e[0m "
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e "${red}══════════════════════════════════════════════════════════${NC}"

echo -e "                 • SSH MENU •                 " | lolcat
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e   ""
echo -e " 1 ⸩ Create SSH & OVPN"
echo -e " 2 ⸩ Trial SSH & OVPN"
echo -e " 3 ⸩ Renew SSH & OVPN"
echo -e " 4 ⸩ Delete SSH & OVPN"
echo -e " 5 ⸩ Check Login SSH & OVPN"
echo -e " 6 ⸩ Member SSH & OVPN"
echo -e " 7 ⸩ Delete User Expired"
echo -e " 8 ⸩ Sett Auto Kill"
echo -e " 9 ⸩ Check Multi Login"
echo -e " 10 ⸩ Restart SSH Service"
echo -e   ""
echo -e "${red}══════════════════════════════════════════════════════════${NC}"

echo -e "                 • XRAY MENU •                 " | lolcat
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e   ""
echo -e " 11 ⸩ Create XRay VMess"
echo -e " 12 ⸩ Delete XRay VMess"
echo -e " 13 ⸩ Renew XRay VMess"
echo -e ""
echo -e " 14 ⸩ Create XRay VLess"
echo -e " 15 ⸩ Delete XRay VLess"
echo -e " 16 ⸩ Renew XRay VLess"
echo -e ""
echo -e " 17 ⸩ Create XRay Trojan GFW"
echo -e " 18 ⸩ Delete XRay Trojan GFW"
echo -e " 19 ⸩ Renew XRay Trojan GFW"
echo -e ""
echo -e " 20 ⸩ Create XRay Trojan GO"
echo -e " 21 ⸩ Delete XRay Trojan GO"
echo -e " 22 ⸩ Renew XRay Trojan GO"
echo -e   ""
echo -e "${red}══════════════════════════════════════════════════════════${NC}"

echo -e "                 • SYSTEM •                 " | lolcat
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e   ""
echo -e " 23 ⸩ Add New Host"
echo -e " 24 ⸩ Restart All Service"
echo -e " 25 ⸩ Check Ram Usage"
echo -e " 26 ⸩ Check Bandwith Usage"
echo -e " 27 ⸩ Sett AutoReboot"
echo -e " 28 ⸩ Clear Log"
echo -e " 29 ⸩ Change SSH Banner"
echo -e " 30 ⸩ Kernel Update"
echo -e " 31 ⸩ Status Service"
echo -e ""
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e " 0 ⸩ Reboot"
echo -e " x ⸩ Exit"
echo -e "${red}══════════════════════════════════════════════════════════${NC}"
echo -e   ""
read -p " Select menu option :  "  opt
echo -e   ""
case $opt in
1) clear ; usernew ;;
2) clear ; trial ;;
3) clear ; renew ;;
4) clear ; deluser ;;
5) clear ; cek ;;
6) clear ; member ;;
7) clear ; delete ;;
8) clear ; autokill ;;
9) clear ; ceklim ;;
10) clear ; restart ;;
11) clear ; add-xr ;;
12) clear ; del-xr ;;
13) clear ; renewws ;;
14) clear ; add-xvless ;;
15) clear ; del-xvless ;;
16) clear ; renewvless ;;
17) clear ; add-tr ;;
18) clear ; del-tr ;;
19) clear ; renew-tr ;;
20) clear ; addtrgo ;;
21) clear ; deltrgo ;;
22) clear ; renew-trg ;;
23) clear ; add-host ;;
24) clear ; resett ;;
25) clear ; ram ;;
26) clear ; bw ;;
27) clear ; auto-reboot ;;
28) clear ; clear-log ;;
29) clear ; nano /etc/issue.net ;;
30) clear ; kernel-updt ;;
31) clear ; status ;;
0) clear ; reboot ;;
x) exit ;;
*) sleep 1; menu ;;
esac
