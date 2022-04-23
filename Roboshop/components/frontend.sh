#!/bin/bash


source Components/common.sh
rm -f /tmp/roboshop.log

HEAD "Installing Nginx/t"
yum install ngnix -y &>>/tmp/roboshop.log
STAT $?

HEAD "Download from Github"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STAT $?

HEAD "Delete old HTML Docs\t"
rm -rf /usr/share/nginx/html/|*
STAT $?

HEAD "Extract Download Content"
unzip -d /usr/share/nginx/html /tmp/frontend.zip &>> /tmp/roboshop.log
mv /usr/share/nginx/html/frontend-main/* /usr/share/nginx/html/ , &>>/tmp/roboshop.log
mv /usr/share/nginx/html/static/* /usr/share/nginx/html/ . &>>/tmp/roboshop.log
STAT $?

HEAD "Update Nginx Configuration"
mv /usr/share/nginx/html/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT $?

HEAD "Start Nginx\t\t"
systemctl restart nginx &>>/tmp/roboshop.log
systemctl enable nginx &>>/tmp/roboshop.log
STAT $?
