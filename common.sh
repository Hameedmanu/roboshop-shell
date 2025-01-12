log=/tmp/roboshop.log

func_apppreq() {
  echo -e "\e[33m>>>>>>>>>>  Create Application User <<<<<<<<<<\e[0m"
  useradd roboshop  &>>${log}

  echo -e "\e[33m>>>>>>>>>>  Remove Application Directory <<<<<<<<<<\e[0m"
  rm -rf /app  &>>${log}

  echo -e "\e[33m>>>>>>>>>>  Create Application Directory <<<<<<<<<<\e[0m"
  mkdir /app  &>>${log}

  echo -e "\e[33m>>>>>>>>>>  Download Application content <<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log}

  echo -e "\e[33m>>>>>>>>>>  Extract Application content <<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip  &>>${log}
  cd /app
}

func_systemd() {
  echo -e "\e[33m>>>>>>>>>> Start ${component} Service <<<<<<<<<<\e[0m"   | tee -a ${log}
  systemctl daemon-reload  &>>${log}
  systemctl enable ${component}  &>>${log}
  systemctl restart ${component} &>>${log}

}

func_nodejs() {
  log=/tmp/roboshop.log

    echo -e "\e[33m>>>>>>>>>>  Create ${component} Service <<<<<<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

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

    func_apppreq

    echo -e "\e[33m>>>>>>>>>>  Download NodeJS Dependencies <<<<<<<<<<\e[0m"
    npm install  &>>${log}

    echo -e "\e[33m>>>>>>>>>> Install MongoDB client  <<<<<<<<<<\e[0m"   | tee -a ${log}
    dnf install mongodb-org-shell -y  &>>${log}

    echo -e "\e[33m>>>>>>>>>>  Load ${component} Schema <<<<<<<<<<\e[0m"   | tee -a ${log}
    mongo --host mongodb.hmtechops.in </app/schema/${component}.js  &>>${log}

    func_systemd
}

func_java() {
    echo -e "\e[33m>>>>>>>>>>  Create ${component} Service <<<<<<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service  &>>${log}

    echo -e "\e[33m>>>>>>>>>>  Install Maven <<<<<<<<<<\e[0m"
    dnf install maven -y &>>${log}

    func_apppreq

    echo -e "\e[33m>>>>>>>>>>  Build ${component} Service <<<<<<<<<<\e[0m"
    mvn clean package
    mv target/${component}-1.0.jar ${component}.jar &>>${log}

    echo -e "\e[33m>>>>>>>>>>  Install MySQL Client <<<<<<<<<<\e[0m"
    dnf install mysql -y &>>${log}

    echo -e "\e[33m>>>>>>>>>>  Load Schema <<<<<<<<<<\e[0m"
    mysql -h mysql.hmtechops.in -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

    func_systemd
}