#!/bin/bash

source Components/common.sh
rm -f /tmp/roboshop.log

HEAD "Setup Mongodb yum repo\t"
echo '[mongodb-org-4,2]
name=Mongodb Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
STAT $?

HEAD "Install Mongodb\t\t"
yum install -y mongodb-org &>>/tmp/roboshop.log
STAT $?

HEAD "Update the Listen Address in config file"
Sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
STAT $?

HEAD "start Mongodb Service\t"
systemctl enable mongodb &>>/tmp/roboshop.log
systemctl start mongodb &>>/tmp/roboshop.log
STAT $?

HEAD "Download Schema from GitHub\t"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>/tmp/roboshop.log
STAT $?

HEAD "Extract Downloaded Archive\t"
cd /tmp
unzip mongodb.zip &>>/tmp/roboshop.log
STAT $?

HEAD "Load Schema\t"
cd mongodb-main
mongo < catalogue.js &>>/tmp/roboshop.log && mongo < users.js &>>/tmp/roboshop.log
STAT $?




