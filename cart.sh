cp cart.service /etc/systemd/system/cart.service

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
useradd roboshop
mkdir /app
 curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
 cd /app
 unzip /tmp/cart.zip
 cd /app
 npm install

sudo systemctl daemon-reload
sudo systemctl enable cart
sudo systemctl restart cart