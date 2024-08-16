#!/bin/bash

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


if [ $USER_ID -ne 0 ]
then
    echo "Please be a super user"
    exit 1
else 
    echo "You are super user"
fi







dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "instllation of mysql server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "instllation of mysql server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "instllation of mysql server"

