dnf install nginx -y
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
sudo rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

sudo systemctl enable nginx
sudo systemctl restart nginx