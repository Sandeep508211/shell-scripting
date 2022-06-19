#!bin/bash

read -p "Enter Username:" username

if [ "$username" == "root" ];then
   echo "Hey,user $username is admin user"
else
   echo "Hey, user $username is Normal user"
fi

read -p "Enter filename:" filename

if [ -f "$filename" ];then
  echo "File is exists"
else
  echo "File Not Found"
fi