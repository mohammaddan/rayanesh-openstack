#!/bin/bash
sudo apt update
sudo apt --assume-yes install nodejs npm apache2
cd /home/ubuntu
git clone https://github.com/MohammadMRD/system-information.git
git clone https://github.com/SayidHosseini/authentiq.git
cd system-information
npm i
cd ../authentiq
sed 's/authentiq-db/192.168.65.53/g' config/config.json
npm i
cd /etc/apache2/sites-available
sudo echo "<VirtualHost *:80>
ServerAdmin info@fumcloud.pro
ServerName fumcloud.pro 
ProxyRequests Off 
<Location /> 
  ProxyPreserveHost On 
  ProxyPass http://127.0.0.1:3000/ 
  ProxyPassReverse http://127.0.0.1:3000/ 
</Location> 
</VirtualHost>" | sudo tee fumcloud.pro.conf
sudo echo "<VirtualHost *:80>
ServerAdmin info@api.fumcloud.pro 
ServerName api.fumcloud.pro 
ProxyRequests Off 
<Location /> 
  ProxyPreserveHost On 
  ProxyPass http://127.0.0.1:2000/ 
  ProxyPassReverse http://127.0.0.1:2000/ 
</Location> 
</VirtualHost>" | sudo tee api.fumcloud.pro.conf
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2ensite fumcloud.pro.conf
sudo a2ensite api.fumcloud.pro.conf
sudo service apache2 restart

cd /etc/systemd/system
sudo echo "[Unit]
 Description=system-info service. 
[Service] 
 Type=simple 
 WorkingDirectory=/home/ubuntu/system-information 
 ExecStart=node ./server.js 
[Install] 
 WantedBy=multi-user.target" | sudo tee system-info.service
sudo echo "[Unit]
 Description=authentiq service. 
[Service] 
 Type=simple 
 WorkingDirectory=/home/ubuntu/authentiq 
 ExecStart=npm run dev 
[Install] 
 WantedBy=multi-user.target" | sudo tee authentiq.service
sudo systemctl enable system-info
sudo service system-info start
sudo systemctl enable authentiq
sudo service authentiq start