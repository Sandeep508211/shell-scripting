#!/bin/bash

disable-auto-shutdown

HEAD()  {
  echo -n -e "\e[1m $1 \e[0m \t\t ..."
}

STAT () {
  if [ $1 -eq 0 ] ; then
    echo -e "\e[1;32m done\e[0m"
    else
      echo -e "\e[1;31m fail\e[0m"
      echo -e "\e[1;33m Check the log for more detail ... Log-File : /tmp/roboshop.log\e[0m"
      exit 1
      fi
      }

      App-user-ADD() {
        HEAD "Add RoboShop App User\t\t"
        id roboshop &>>/tmp/roboshop.log
        if [ $? -eq 0 ] ; then
          echo User is already there, So Skipping the user creation &>>/tmp/roboshop.log
          STAT $?
          else
            useradd roboshop &>>/tmp/roboshop.log
            STAT $?
            fi
            }

            SETUP-SYSTEM() {
              HEAD "Setup SystemD Service\t\t"
              sed -i -e 's/MONGO-DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO-ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE-ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internel/' -e 's/DBSHOST/mysql.roboshop.internal/' /home/roboshop/$1/systemd.service && mv /home/roboshop/$1/systemd.service /etc/system/system/$1.service
              STAT $?

              HEAD "start $1 Service\t"
              systemctl daemon-reload && systemctl enable $1 &>> /tmp/roboshop.log && systemctl restart $1 &>>/tmp/roboshop.log
              STAT $?
              }

              DOWNLOAD_FROM_GITHUB() {
                HEAD "Download App from GitHub\t"
                curl -s -L -o /tmp/$1.zip "https://github.com/roboshop-devops-project/$1/archieve/main.zip" &>>/tmp/roboshop.log
                STAT $?
                HEAD "Download App from GitHub\t"
                cd /home/roboshop && rm -rf $1 && unzip /tmp/$1.zip &>>/tmp/roboshop.log && mv $1-main $1
                STAT $?
                }

                FIX_APP_CONTENT_PERM() {
                  HEAD "Fix Permission to App Content"
                  chown roboshop:roboshop /home/roboshop -R
                  STAT $?
                  }
                  NODEJS() {
                    HEAD "Install Nodejs\t\t\t"
                    yum install nodejs make gcc-c++ -y &>>/tmp/roboshop.log
                    STAT $?

                    APP_USER_ADD
                    DOWNLOAD_FROM_GITHUB $1

                    HEAD "Install NodeJS Dependencies\t"
                    cd /home/roboshop/$1 && npm install --unsafe-perm &>>/tmp/roboshop.log
                    STAT $?

                    FIX_APP_CONTENT_PERM

                    SETUP_SystemD"$1"
                    }

                    MAVEN() {
                      HEAD "Install Maven"
                      yum install maven -y &>> /tmp/roboshop.log
                      STAT $?

                      APP_USER_ADD
                      DOWNLOAD_FROM_GITHUB $1

                      HEAD "Make Application Package"
                      cd /home/roboshop/$1 && mvn clean package &>> /tmp/roboshop.log && mv target/$1-1.0.jar &>>/tmp/roboshop.log
                      STAT $?

                      FIX FIX_APP_CONTENT_PERM

                      SETUP-SYSTEMD "$1"
                      }

                      PYTHON3() {
                        HEAD "Install python3"
                        yum install python36 gcc python3-devel -y&>>/tmp/roboshop.log
                        STAT $?

                        APP_USER_ADD
                        DOWNLOAD_FROM_GITHUB $1

                        HEAD "Install Python Deps
                        cd /home/roboshop/$1 && pip3 -r requirement.txt &>>/tmp/roboshop.log
                        STAT $?

                        USER_ID=$(id -u roboshop)
                        GROUP_ID=$(id -g roboshop)

                        HEAD "Update App Configuration"
                        sed -i -e "/uid/ c uid=$(USER_ID)" -e "/gid/ c gid=$(GROUP_ID)" /home/roboshop/$1/$1.ini
                        STAT $?

                        SETUP_SYSTEMD "$1"
                        }




















}