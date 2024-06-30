#!/bin/bash

#Enable root user
chpasswd <<< 'root:a1502EMC2805'
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#Disable selinux
#sed -i 's/enforcing/disabled/g' /etc/selinux/config

#Disable IP6 in GRUB or SYSTEM_CONFIG
sudo sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
sudo update-grub

#Setup system
apt update --yes
apt full-upgrade --yes

apt install --yes mc
read -p "Check packet for manual update later. Press enter to continue"

#Umcoment if want join AD doamin
#apt install --yes krb5-user realmd libnss-sss libpam-sss sssd sssd-krb5 sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
#realm join -v kernel.local
#pam-auth-update --enable mkhomedir

#Reboot
reboot
