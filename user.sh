cp user.service /etc/systemd/system/user.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
useradd roboshop
mkdir /app
 curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
 cd /app
 unzip /tmp/user.zip
 cd /app
 npm install

dnf install mongodb-org-shell -y
mongo --host mongodb.hmtechops.in </app/schema/user.js

sudo systemctl daemon-reload
sudo systemctl enable user
sudo systemctl restart user