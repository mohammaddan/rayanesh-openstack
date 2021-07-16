#!/bin/bash
sudo apt update
sudo apt install nodejs npm apache2 -y
git clone https://github.com/MohammadMRD/system-information.git
git clone https://github.com/SayidHosseini/authentiq.git
cd system-information
npm i
cd ../authentiq
sed 's/authentiq-db/192.168.65.43/g' config/config.json
npm i
cd /etc/apache2/sites-available
sudo echo "<VirtualHost *:80>
    \nServerAdmin info@fumcloud.pro \
    \nServerName fumcloud.pro \
    \nProxyRequests Off \
    \n<Location /> \
    \n  ProxyPreserveHost On \
    \n  ProxyPass http://127.0.0.1:3000/ \
    \n  ProxyPassReverse http://127.0.0.1:3000/ \
    \n</Location> \
    \n</VirtualHost>" > fumcloud.pro.conf
echo "<VirtualHost *:80>
    \nServerAdmin info@api.fumcloud.pro \
    \nServerName api.fumcloud.pro \
    \nProxyRequests Off \
    \n<Location /> \
    \n  ProxyPreserveHost On \
    \n  ProxyPass http://127.0.0.1:2000/ \
    \n  ProxyPassReverse http://127.0.0.1:2000/ \
    \n</Location> \
    \n</VirtualHost>" > api.fumcloud.pro.conf
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2ensite fumcloud.pro.conf
sudo a2ensite api.fumcloud.pro.conf
sudo service apache2 restart

cd /etc/systemd/system
sudo echo "[Unit] \
           \n Description=system-info service. \
           \n[Service] \
           \n Type=simple \
           \n WorkingDirectory=/home/ubuntu/system-information \
           \n ExecStart=node ./server.js \
           \n[Install] \
           \n WantedBy=multi-user.target" > system-info.service
sudo echo "[Unit] \
           \n Description=authentiq service. \
           \n[Service] \
           \n Type=simple \
           \n WorkingDirectory=/home/ubuntu/authentiq \
           \n ExecStart=npm run dev \
           \n[Install] \
           \n WantedBy=multi-user.target" > authentiq.service
sudo systemctl enable system-info.service
sudo service system-info.service start
sudo systemctl enable authentiq
sudo service authentiq.service start