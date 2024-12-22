echo -e "\e[33m>>>>>>>>>>  Create Catalouge Service <<<<<<<<<<\e[0m"
cp catalouge.service /etc/systemd/system/catalouge.service

echo -e "\e[33m>>>>>>>>>>  Create MongoDB Repo <<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m>>>>>>>>>>  Install NodeJS Repos <<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[33m>>>>>>>>>>  Disable NodeJS <<<<<<<<<<\e[0m"
dnf module disable nodejs -y

echo -e "\e[33m>>>>>>>>>>  Enable NodeJS Module<<<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y

echo -e "\e[33m>>>>>>>>>>  Install NodeJS <<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[33m>>>>>>>>>>  Create Application User <<<<<<<<<<\e[0m"
useradd roboshop


echo -e "\e[33m>>>>>>>>>>  Remove Application Directory <<<<<<<<<<\e[0m"
rm -rf /app

echo -e "\e[33m>>>>>>>>>>  Create Application Directory <<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[33m>>>>>>>>>>  Download Application content <<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[33m>>>>>>>>>>  Extract Application content <<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[33m>>>>>>>>>>  Download NodeJS Dependencies <<<<<<<<<<\e[0m"
npm install

echo -e "\e[33m>>>>>>>>>> Install MongoDB client  <<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[33m>>>>>>>>>>  Load Catalouge Schema <<<<<<<<<<\e[0m"
mongo --host mongodb.hmtechops.in </app/schema/catalogue.js

echo -e "\e[33m>>>>>>>>>> Start Catalouge Service <<<<<<<<<<\e[0m"
sudo systemctl daemon-reload
sudo systemctl enable catalogue
sudo systemctl restart catalogue
