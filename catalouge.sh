cp catalouge.service /etc/systemd/system/catalouge.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
useradd roboshop
mkdir /app
 curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
 cd /app
 unzip /tmp/catalogue.zip
 cd /app
 npm install

dnf install mongodb-org-shell -y
mongo --host mongodb.hmtechops.in </app/schema/catalogue.js

sudo systemctl daemon-reload
sudo systemctl enable catalogue
sudo systemctl restart catalogue
