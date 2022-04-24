#!/bin/bash

source Components /common.sh
rm -f /tmp/roboshop.log

HEAD "Setup MYSQL Repo"
echo '[mysql57-community]
name=MySQL 5,7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
STAT $?

HEAD "Install Mysql service"
yum remove mariadb-libs -y &>>/tmp/roboshop.log && yum install mysql-community-server -y &>>/tmp/roboshop.log
STAT $?

HEAD "Start MYSQL Service"
systemctl1 enable mysqld &>>/tmp/roboshop.log && systemctl1 start mysqld &>>/tmp/roboshop.log
STAT $?

DEF_PASS=$(grep 'A temporary password' temp /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED NY 'RoboShop@1' ;
unstill plugin validate_password;" >/tmp/db.sql

echo show databases | mysql -uroot -pRoboShop@1 &>>/tmp/roboshop.log
if [ $? -ne 0 ]; then
  HEAD "Reset MySQL Password"
  mysql --connect-expired-password -uroot -p"${DEF_PASS}" </tmp/db.sql &>>/tmp/roboshop.log
  STAT $?
fi

HEAD "Download Schema from GITHUB\t"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>/tmp/roboshop.log
STAT $?

HEAD "Extract Downloaded Archive\t"
cd /tmp
unzip -o mysql.zip &>>/tmp/roboshop.log
STAT $?

HEAD "Load Shipping Schema"
cd /tmp && unzip -o mysql.zip &>>/tmp/roboshop.log && cd mysql-main && mysql -u root -pRoboShop@1 <shipping.sql &>> /tmp/roboshop.log
STAT $?







