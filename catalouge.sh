echo ">>>>>>>>>>  Create Catalouge Service <<<<<<<<<<<"
cp catalouge.service /etc/systemd/system/catalouge.service

echo ">>>>>>>>>>  Create MongoDB Repo <<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>>>>>>  Install NodeJS Repos <<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo ">>>>>>>>>>  Disable NodeJS <<<<<<<<<<<"
dnf module disable nodejs -y

echo ">>>>>>>>>>  Enable NodeJS Module<<<<<<<<<<<"
dnf module enable nodejs:18 -y

echo ">>>>>>>>>>  Install NodeJS <<<<<<<<<<<"
dnf install nodejs -y

echo ">>>>>>>>>>  Create Application User <<<<<<<<<<<"
useradd roboshop

echo ">>>>>>>>>>  Create Application Directory <<<<<<<<<<<"
mkdir /app

echo ">>>>>>>>>>  Download Application content <<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo ">>>>>>>>>>  Extract Application content <<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>>>>>>  Download NodeJS Dependencies <<<<<<<<<<<"
npm install

echo ">>>>>>>>>> Install MongoDB client  <<<<<<<<<<<"
dnf install mongodb-org-shell -y

echo ">>>>>>>>>>  Load Catalouge Schema <<<<<<<<<<<"
mongo --host mongodb.hmtechops.in </app/schema/catalogue.js

echo ">>>>>>>>>> Start Catalouge Service <<<<<<<<<<<"
sudo systemctl daemon-reload
sudo systemctl enable catalogue
sudo systemctl restart catalogue
