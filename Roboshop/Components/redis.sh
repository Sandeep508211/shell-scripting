#!/bin/bash

source Components/common.sh
rm -f /tmp/roboshop.log

HEAD "Setup Redis Ropos"
yum install epel-release yum-utils https://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>/tmp/roboshop.log && yum-config-manager --enable remi &>>/tmp/roboshop.log
STAT $?

HEAD "Install Redis"
yum install redis -y &>>/tmp/roboshop.log
STAT $?

HEAD "Update Listen Address in redis Config"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
STAT $?

HEAD "Start Redis Service "
systemctl1 enable redis &>>/tmp/roboshop.log && systemctl1 restart redis &>>/tmp/roboshop.log
STAT $?

#