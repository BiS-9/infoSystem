#!/usr/bin/env bash
#			 ___  _
#			| . ><_> ||_
#			| . \| |<_-<
#			|___/|_|/__/
#				 	 ||
#
#---------------------------------------------------------------------------------
# Script     : infoSystem.sh
# Description: Show OS information.
# Version    : 0.1
# Author     : Bi$ https://github.com//bis-9
# Date       : 2021-11-13
# License    : GNU/GPL v3.0
#---------------------------------------------------------------------------------
# Use        : ./infoSystem.sh or /PATH/infoSystem.sh
#---------------------------------------------------------------------------------

# Colours
b=$'\e[0;30'    # Black
R=$'\e[0;31m'   # Red
G=$'\e[0;32m'   # Green
Y=$'\e[0;33m'   # Yellow
B=$'\e[0;34m'   # Blue
P=$'\e[0;35m'   # Purple
C=$'\e[0;36m'   # Cyan
W=$'\e[0;37m'   # White
NC=$'\e[0m'     # No colour

Bold colours
bB=$'\e[1;30'   # Black
RB=$'\e[1;31m'  # Red
GB=$'\e[1;32m'  # Green
YB=$'\e[1;33m'  # Yellow
BB=$'\e[1;34m'  # Blue
PB=$'\e[1;35m'  # Purple
CB=$'\e[1;36m'  # Cyan
WB=$'\e[1;37m'  # White
NC=$'\e[0m'     # No colour

#---------------------------------------------------------------------------------

clear

# Include (source) os-release to paste a variable PRETTY_NAME.
. /etc/*-release

# Public IP
pIP=$(curl ifconfig.me)
publicIP(){
        if [ "$pIP" ]; then
                echo "$pIP"
        else
                echo "Disconected"
        fi
}

# Private IP
PIP=$(ip addr | grep 'state UP' -A2 | head -n1 | awk -F ":" '{print $2}')
privateIP(){
        if [ "$PIP" ]; then
                echo -e "$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/') $CB$PIP$NC"
        else
                echo "Disconected"
        fi
}

# VPN Status
IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')
vpnStatus(){
        if [ "$IFACE" == "tun0" ]; then
                "$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')"
        else
                echo "Disconected"
        fi
}

# Main program
echo -e "
$YB - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n$NC
$GB User@Hostname:$NC\t $USER@$HOSTNAME
$GB Public IP:$NC\t $(publicIP)
$GB Local IP:$NC\t $(privateIP)
$GB VPN Status:$NC\t $(vpnStatus)
$YB \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n$NC
$GB OS:$NC\t\t $PRETTY_NAME
$GB Version:$NC\t $VERSION
$GB Kernel:$NC\t $(uname -rm)
$GB Packages:$NC\t $(dpkg -l | wc -l)
$GB Shell:$NC\t\t $($SHELL --version | awk '{print $1,$2}')
$GB Desktop:$NC\t $XDG_CURRENT_DESKTOP
$GB Session:$NC\t $DESKTOP_SESSION
$GB Resolution:$NC\t $(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
$GB Theme:$NC\t\t $(awk '/ThemeName/' /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml |awk 'NR==1 {print}' | awk -F "=" '{print $NF}' | sed 's/"\/>//' | tr -d '"')
$GB Icon Theme:$NC\t $(awk '/IconThemeName/' /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml |awk 'NR==1 {print}' | awk -F "=" '{print $NF}' | sed 's/"\/>//' | tr -d '"')
$GB Font:$NC\t\t $(awk '/FontName/' /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml |awk 'NR==1 {print}' | awk -F "=" '{print $NF}' | sed 's/"\/>//' | tr -d '"')
$YB \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n$NC
$GB CPU:$NC\t\t $(lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1')
$GB GPU 1:$NC\t\t $(lspci | grep 'VGA' | awk 'NR==1 {print}' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
$GB GPU 2:$NC\t\t $(lspci | grep 'VGA' | awk 'NR==2 {print}' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
$GB Audio 1:$NC\t $(lspci | grep 'Audio device' | awk 'NR==1 {print}' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
$GB Audio 2:$NC\t $(lspci | grep 'Audio device' | awk 'NR==2 {print}' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
$GB Ethernet:$NC\t $(lspci | grep 'Ethernet' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
$GB WiFi:$NC\t\t $(lspci | grep 'Network' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
$GB RAM:$NC\t\t $(free --giga | grep "Mem:" | awk '{print $2}') Gb
$GB SWAP:$NC\t\t  $(free --giga | grep "Swap:" | awk '{print $2}') Gb
$YB \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n$NC
$GB STORAGE:$NC\t SIZE\tUSE\tAVAI\tUS%
$GB /:$NC\t\t $(df -h | grep 'nvme0n1p4' | awk '{print $2"\t"$3"\t"$4"\t"$5}')
$GB HOME:$NC\t\t $(df -h | grep 'nvme0n1p5' | awk '{print $2"\t"$3"\t"$4"\t"$5}')
$GB TERA1:$NC\t\t $(df -h | grep 'sda1' | awk '{print $2"\t"$3"\t"$4"\t"$5}')
$GB TERA2:$NC\t\t $(df -h | grep 'sda2' | awk '{print $2"\t"$3"\t"$4"\t"$5}')
$YB \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n$NC
$GB Timezone:$NC\t $(cat /etc/timezone)
$YB \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$NC
"
