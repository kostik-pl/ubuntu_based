#!/bin/bash

#Add POSTGRES GROUP and USER same as in container
groupadd -r postgres --gid=9999
useradd -r -M -g postgres --uid=9999 postgres

#Change access rights
if [ ! -d "/_data/pg_backup" ] ; then
    mkdir /_data/pg_backup
fi
if [ ! -d "/_data/pg_data" ] ; then
    mkdir /_data/pg_data
fi
chown -R postgres:postgres /_data/pg_backup
chmod -R 666 /_data/pg_backup
chown -R postgres:postgres /_data/pg_data
chmod -R 700 /_data/pg_data

#Start POSTGRESPRO container
#Change the image name to the desired image. Example kostikpl/ol9:pgpro_1c_13 > kostikpl/rhel8:pgpro_std_13
HOSTNAME=`hostname`
podman run --name pgpro --hostname $HOSTNAME -dt -p 5432:5432 -v /_data:/_data docker.io/kostikpl/ubuntu_24.04:pgpro_std_13
podman generate systemd --new --name pgpro > /etc/systemd/system/pgpro.service
systemctl daemon-reload
systemctl enable pgpro
systemctl start pgpro
sleep 15s
PG_PASSWD='RheujvDhfub72'
podman exec -ti pgpro psql -c "ALTER USER postgres WITH PASSWORD '$PG_PASSWD';"
#srv1c_PASSWD = '\$GitybwZ - ZxvtyM\$' # $GitybwZ - ZxvtyM$
#podman exec -ti pgpro psql -c "ALTER USER srv1c WITH PASSWORD '$srv1c_PASSWD';"
