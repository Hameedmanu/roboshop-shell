echo -e "\e[33m>>>>>>>>>>  Create Catalouge Service <<<<<<<<<<\e[0m"
cp catalouge.service /etc/systemd/system/catalouge.service &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Create MongoDB Repo <<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Install NodeJS Repos <<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Disable NodeJS <<<<<<<<<<\e[0m"
dnf module disable nodejs -y  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Enable NodeJS Module<<<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Install NodeJS <<<<<<<<<<\e[0m"
dnf install nodejs -y  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Create Application User <<<<<<<<<<\e[0m"
useradd roboshop  &>/roboshop.log


echo -e "\e[33m>>>>>>>>>>  Remove Application Directory <<<<<<<<<<\e[0m"
rm -rf /app  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Create Application Directory <<<<<<<<<<\e[0m"
mkdir /app  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Download Application content <<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Extract Application content <<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip  &>/roboshop.log
cd /app

echo -e "\e[33m>>>>>>>>>>  Download NodeJS Dependencies <<<<<<<<<<\e[0m"
npm install  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>> Install MongoDB client  <<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>>  Load Catalouge Schema <<<<<<<<<<\e[0m"
mongo --host mongodb.hmtechops.in </app/schema/catalogue.js  &>/roboshop.log

echo -e "\e[33m>>>>>>>>>> Start Catalouge Service <<<<<<<<<<\e[0m"
sudo systemctl daemon-reload  &>/roboshop.log
sudo systemctl enable catalogue  &>/roboshop.log
sudo systemctl restart catalogue &>/roboshop.log
