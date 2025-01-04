log=${log}

echo -e "\e[33m>>>>>>>>>>  Create Catalouge Service <<<<<<<<<<\e[0m"
cp catalouge.service /etc/systemd/system/catalouge.service &>>${log}

echo -e "\e[33m>>>>>>>>>>  Create MongoDB Repo <<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Install NodeJS Repos <<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Disable NodeJS <<<<<<<<<<\e[0m"
dnf module disable nodejs -y  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Enable NodeJS Module<<<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Install NodeJS <<<<<<<<<<\e[0m"
dnf install nodejs -y  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Create Application User <<<<<<<<<<\e[0m"
useradd roboshop  &>>${log}


echo -e "\e[33m>>>>>>>>>>  Remove Application Directory <<<<<<<<<<\e[0m"
rm -rf /app  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Create Application Directory <<<<<<<<<<\e[0m"
mkdir /app  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Download Application content <<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Extract Application content <<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip  &>>${log}
cd /app

echo -e "\e[33m>>>>>>>>>>  Download NodeJS Dependencies <<<<<<<<<<\e[0m"
npm install  &>>${log}

echo -e "\e[33m>>>>>>>>>> Install MongoDB client  <<<<<<<<<<\e[0m"   | tee -a ${log}
dnf install mongodb-org-shell -y  &>>${log}

echo -e "\e[33m>>>>>>>>>>  Load Catalouge Schema <<<<<<<<<<\e[0m"   | tee -a ${log}
mongo --host mongodb.hmtechops.in </app/schema/catalogue.js  &>>${log}

echo -e "\e[33m>>>>>>>>>> Start Catalouge Service <<<<<<<<<<\e[0m"   | tee -a ${log}
systemctl daemon-reload  &>>${log}
systemctl enable catalogue  &>>${log}
systemctl restart catalogue &>>${log}
