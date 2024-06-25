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

#apt install --yes krb5-user
apt install --yes mc

#Reboot
reboot
