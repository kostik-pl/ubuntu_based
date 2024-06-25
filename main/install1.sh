#!/bin/bash

#Enable root user
passwd root
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#Disable selinux
sed -i 's/enforcing/disabled/g' /etc/selinux/config

#Disable IP6 in GRUB or SYSTEM_CONFIG
sudo sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
sudo update-grub
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client

#Setup system
apt update --yes
apt full-upgrade --yes

#apt install --yes krb5-user
apt install --yes mc

#Reboot
reboot
