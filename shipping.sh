cp shipping.service /etc/systemd/system/shipping.service

dnf install maven -y
useradd roboshop
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

dnf install mysql -y
mysql -h mysql.hmtechops.in -uroot -pRoboShop@1 < /app/schema/shipping.sql

sudo systemctl daemon-reload
sudo systemctl enable shipping
sudo systemctl restart shipping
