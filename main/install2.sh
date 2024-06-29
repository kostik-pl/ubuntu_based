#!/bin/bash

#Check disk & chane FSTAB
FILE1="/dev/disk/by-label/_data"
DISK1="/dev/disk/by-label/_data /_data auto nosuid,nodev,nofail,x-gvfs-show 0 0"

if [ ! -L "$FILE1" ]
then
    echo "Disk labeled as $FILE1 not found"
    read -p "Continue [y/N]? " -n 1 -r
	echo
	case $REPLY in 
		[yY] ) echo ok, we will proceed...; break;;
		* ) echo exiting...; exit 1;;
	esac
else
    echo "Disk labeled as $FILE1 found"
    if ! grep -q '/_data' /etc/fstab
    then
        echo "Addind $FILE1 to fstab"
        printf "$DISK1\n" >> /etc/fstab
    fi
fi

#Mount disk from FSTAB
if [ ! -d "/_data" ] ; then
    mkdir /_data
fi
mount -a
