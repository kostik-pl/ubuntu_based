#!/bin/bash

#Install 1C Enterprise server requirements from custom packages
#apt install --yes ttf-mscorefonts-installer
#Download form GOOGLE
curl "https://drive.usercontent.google.com/download?id=1bYzcBhFdA2wGeFtxfqYv__5V_bmLGTNu&confirm=xxx" -o msttcorefonts.tar.gz
tar -xf msttcorefonts.tar.gz -C /usr/share/fonts/truetype/msttcorefonts/
fc-cache –fv

# install 1C Enterprise requirements from repositories
add-apt-repository ppa:linuxuprising/libpng12
apt update
apt install --yes libpng12-0
apy install --yes libenchant1c2a

#Install 1C Enterprise server packages from work dir
#Download form GOOGLE
curl "https://drive.usercontent.google.com/download?id=194Gy41zfqAZD46mad-lmPuSQ_b7NLxSP&confirm=xxx" -o server64_8_3_21_1302.tar.gz
tar -xf server64_8_3_21_1302.tar.gz
chmod +x setup-full-8.3.21.1302-x86_64.run
#ATTENTION! Batch installation will always install the 1c client and, if missing, the trimmed GNOME
./setup-full-8.3.21.1302-x86_64.run --mode unattended --enable-components server,server_admin,ws,uk,ru
#Manual installation, if have GUI (GNOME), the process will run in it
#./setup-full-8.3.21.1302-x86_64.run

sed -i 's/Environment=SRV1CV8_DEBUG=/Environment=SRV1CV8_DEBUG=-debug/' /opt/1cv8/x86_64/8.3.21.1302/srv1cv8-8.3.21.1302@.service
sed -i 's/Environment=SRV1CV8_DATA=\/home\/usr1cv8\/.1cv8\/1C\/1cv8/Environment=SRV1CV8_DATA=\/_data\/srv1c_inf_log/' /opt/1cv8/x86_64/8.3.21.1302/srv1cv8-8.3.21.1302@.service

systemctl link /opt/1cv8/x86_64/8.3.21.1302/srv1cv8-8.3.21.1302@.service
systemctl link /opt/1cv8/x86_64/8.3.21.1302/ras-8.3.21.1302.service
systemctl enable srv1cv8-8.3.21.1302@default
systemctl enable ras-8.3.21.1302
systemctl start srv1cv8-8.3.21.1302@default
systemctl start ras-8.3.21.1302