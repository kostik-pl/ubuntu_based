#!/bin/bash
clear

#Install PODMAN
apt install --yes podman 

#Check disk & chane FSTAB
clear
if [ -L '/dev/disk/by-label/_data' ]
then
	echo 'Disk labeled as [/dev/disk/by-label/_data] found...'
	if ! grep -q '/_data' /etc/fstab
	then
		echo 'Addind [/dev/disk/by-label/_data] to fstab.'
		printf '/dev/disk/by-label/_data /_data auto nosuid,nodev,nofail,x-gvfs-show 0 0' >> /etc/fstab
	fi
else
	echo 'Partition labeled as [_data] not found...'
	read -p 'Continue ? [y/N]: ' -n 1 -r
	echo
	case $REPLY in 
		[yY] ) 
			echo 'Ok, we will proceed...'
			disk_sdb=( $(lsblk -o KNAME | grep 'sdb') )
			if [ ! -z ${disk_sdb+x} ]
			then
				read -p 'Disk [/dev/sdb] exist, want to use it for mapping [/_data] ? [Y/n]: ' -n 1 -r
				echo
				if [[ "$REPLY" =~ ^[yY]$ ]]; then
					disk_sdb1=( $(lsblk -o KNAME | grep 'sdb1') )
					disk_sdb2=( $(lsblk -o KNAME | grep 'sdb2') )
					if [ ! -z ${disk_sdb1+x} -a ! -z ${disk_sdb2+x} ]
					then
						echo 'Disk [sdb] has more than one partition...'
						echo 'Exiting...'; exit 1
					elif [ -z ${disk_sdb1+x} -a -z ${disk_sdb2+x} ]; then
						echo 'Disk [sdb] has no partition...'
						echo 'Exiting...'; exit 1
					else
						disk_sdb1_xfs=( $(lsblk -o KNAME,FSTYPE | grep -E 'sdb1.+xfs') )
						if [ ! -z ${disk_sdb1_xfs+x} ]
						then
							echo 'Make label [_data] for partition [sdb1].'
							xfs_admin -L _data /dev/sdb1
							if ! grep -q '/_data' /etc/fstab
							then
								echo 'Addind [/dev/disk/by-label/_data] to fstab.'
								printf '/dev/disk/by-label/_data /_data auto nosuid,nodev,nofail,x-gvfs-show 0 0' >> /etc/fstab
							fi
						else
							echo 'Partition [sdb] is not XFS...'
							echo 'Exiting...'; exit 1
						fi
					fi
				fi
			else
				echo 'Disk [sdb] not found'
				echo 'Exiting...'; exit 1
			fi
		;;
		* )
			echo 'Break scrip!!!'
			echo 'Exiting...'; exit 1
		;;
	esac
fi

#Mount disk from FSTAB
if [ ! -d '/_data' ] ; then
	echo 'Make folder [/_data]...'
	mkdir /_data
fi
echo 'Change owner and permisions for [/_data]...'
chown root:root /_data
chmod 777 /_data
systemctl daemon-reload
sleep 15s
echo 'Mount [/_data]...'
mount -a