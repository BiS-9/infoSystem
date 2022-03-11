#!/usr/bin/env bash
#                        ___  _
#                       | . ><_> ||_
#                       | . \| |<_-<
#                       |___/|_|/__/
#                                ||
#
#---------------------------------------------------------------------------------
# Script Name: infoSystem.sh
# Description: Show system information
# Version    : 0.1
# Author     : Bi$ https://github.com/BiS-9
# Date       : 2021-09-07
# License    : GNU/GPL v3.0
#---------------------------------------------------------------------------------
# Use        : ./infoSystem.sh or ./PATH/infoSystem.sh
#---------------------------------------------------------------------------------

# Colours
# b=$'\e[0;30'    # Black
# R=$'\e[0;31m'   # Red
# G=$'\e[0;32m'   # Green
# Y=$'\e[0;33m'   # Yellow
# B=$'\e[0;34m'   # Blue
# P=$'\e[0;35m'   # Purple
# C=$'\e[0;36m'   # Cyan
# W=$'\e[0;37m'   # White
# NC=$'\e[0m'     # No colour

# Bold colours
# bB=$'\e[1;30'   # Black
# RB=$'\e[1;31m'  # Red
GB=$'\e[1;32m'  # Green
YB=$'\e[1;33m'  # Yellow
# BB=$'\e[1;34m'  # Blue
# PB=$'\e[1;35m'  # Purple
CB=$'\e[1;36m'  # Cyan
# WB=$'\e[1;37m'  # White
NC=$'\e[0m'     # No colour
#---------------------------------------------------------------------------------

clear

# Include (source) os-release to paste a variable PRETTY_NAME.
. /etc/os-release

# Public IP
pIP=$(dig whoami.akamai.net. @ns1-1.akamaitech.net. +short 2>/dev/null)
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
                echo -e "$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/') ${CB}$PIP${NC}"
        else
                echo "Disconected"
        fi
}

# VPN Status
IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')
vpnStatus(){
        if [ "$IFACE" == "tun0" ]; then
                echo -e "$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')"
        else
                echo "Disconected"
        fi
}

# Variable
UserHostname=$USER@$HOSTNAME
PublicIP=$(publicIP)
PrivateIP=$(privateIP)
VPN=$(vpnStatus)
KERNEL=$(uname -rm)
PACK=$(dpkg -l | wc -l)
Shell=$($SHELL --version | awk '{print $1,$2}')
Desktop=$XDG_CURRENT_DESKTOP
Session=$DESKTOP_SESSION
RESOLUTION=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
THEME=$(awk '/ThemeName/' /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml |awk 'NR==1 {print}' | awk -F "=" '{print $NF}' | sed 's/"\/>//' | tr -d '"')
ITHEME=$(awk '/IconThemeName/' /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml |awk 'NR==1 {print}' | awk -F "=" '{print $NF}' | sed 's/"\/>//' | tr -d '"')
FONT=$(awk '/FontName/' /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml |awk 'NR==1 {print}' | awk -F "=" '{print $NF}' | sed 's/"\/>//' | tr -d '"')
CPU=$(lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1')
GPU1=$(lspci | grep 'VGA' | awk 'NR==1 {print}' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
GPU2=$(lspci | grep 'VGA' | awk 'NR==2 {print}' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
AUDIO1=$(lspci | grep 'Audio device' | awk 'NR==1 {print}' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
AUDIO2=$(lspci | grep 'Audio device' | awk 'NR==2 {print}' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
ETH=$(lspci | grep 'Ethernet' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
WIFI=$(lspci | grep 'Network' | cut -f3- -d ":" | sed 's/^[[:space:]]*//')
RAM=$(free --giga | grep "Mem:" | awk '{print $2}')
SWAP=$(free --giga | grep "Swap:" | awk '{print $2}')
ROOT=$(df -h | grep 'nvme0n1p4' | awk '{print $2"\t"$3"\t"$4"\t"$5}')
Home=$(df -h | grep 'nvme0n1p5' | awk '{print $2"\t"$3"\t"$4"\t"$5}')
TERA1=$(df -h | grep 'sda1' | awk '{print $2"\t"$3"\t"$4"\t"$5}')
TERA2=$(df -h | grep 'sda2' | awk '{print $2"\t"$3"\t"$4"\t"$5}')
TMZ=$(cat /etc/timezone)

# Main program
echo -e "
${YB}- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n${NC}
${CB} ${NC}${GB} User@Host:${NC}\t $UserHostname
${CB}爵${NC}${GB} Public IP:${NC}\t $PublicIP
${CB} ${NC}${GB} Local IP:${NC}\t $PrivateIP
${CB}廬${NC}${GB} VPN Status:${NC}\t $VPN
${YB} \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n${NC}
${CB}漣${NC}${GB} OS:${NC}\t\t $PRETTY_NAME
${CB} ${NC}${GB} Version:${NC}\t $VERSION
${CB} ${NC}${GB} Kernel:${NC}\t $KERNEL
${CB} ${NC}${GB} Packages:${NC}\t $PACK
${CB} ${NC}${GB} Shell:${NC}\t $Shell
${CB} ${NC}${GB} Desktop:${NC}\t $Desktop
${CB} ${NC}${GB} Session:${NC}\t $Session
${CB}ﬕ ${NC}${GB} Resolution:${NC}\t $RESOLUTION
${CB} ${NC}${GB} Theme:${NC}\t $THEME
${CB} ${NC}${GB} Icon Theme:${NC}\t $ITHEME
${CB} ${NC}${GB} Font:${NC}\t $FONT
${YB} \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n${NC}
${CB} ${NC}${GB} CPU:${NC}\t\t $CPU
${CB} ${NC}${GB} GPU 1:${NC}\t $GPU1
${CB} ${NC}${GB} GPU 2:${NC}\t $GPU2
${CB} ${NC}${GB} Audio 1:${NC}\t $AUDIO1
${CB}V ${NC}${GB} Audio 2:${NC}\t $AUDIO2
${CB} ${NC}${GB} Ethernet:${NC}\t $ETH
${CB}直${NC}${GB} WiFi:${NC}\t $WIFI
${CB}﬙ ${NC}${GB} RAM:${NC}\t\t $RAM Gb
${CB} ${NC}${GB} SWAP:${NC}\t  $SWAP Gb
${YB} \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n${NC}
${CB}${NC}${GB} STORAGE:${NC}\t ${CB}SIZE${NC}\t${CB}USE${NC}\t${CB}AVAI${NC}\t${CB}US%${NC}
${CB} ${NC}${GB} /:${NC}\t\t $ROOT
${CB} ${NC}${GB} HOME:${NC}\t $Home
${CB} ${NC}${GB} TERA1:${NC}\t $TERA1
${CB} ${NC}${GB} TERA2:${NC}\t $TERA2
${YB} \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n${NC}
${CB} ${NC}${GB} Timezone:${NC}\t $TMZ
${YB} \n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -${NC}
"
