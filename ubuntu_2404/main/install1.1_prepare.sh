#!/bin/bash
clear

#Disable IP6 in GRUB or SYSTEM_CONFIG
echo 'Disabel IPv6...'
sudo sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
sudo update-grub

#Chane timezone
echo 'Chane timezone for EET...'
timedatectl set-timezone EET

#Setup system
apt update --yes
apt full-upgrade --yes

#Additional installations
apt install --yes mc tmux htop iftop iotop

#Join AD doamin
clear
read -p 'Want join AD domain ? [y/N]: ' -n 1 -r
if [[ "$REPLY" =~ ^[yY]$ ]]; then
	apt install --yes krb5-user realmd libnss-sss libpam-sss sssd sssd-krb5 sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
	clear
	read -p 'Enter DA login: ' da_login
	realm join -v -U $da_login kernel.local
	pam-auth-update --enable mkhomedir
fi

#Enable root user
clear
echo 'Enable root and set password!!!'
passwd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#Reboot
reboot