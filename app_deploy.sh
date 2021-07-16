#!/bin/bash
sudo apt update
sudo apt install nodejs npm apache2
git clone https://github.com/MohammadMRD/system-information.git
cd system-information
npm i
echo "<VirtualHost *:80>
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
    \n</VirtualHost>" > fumcloud.pro.conf