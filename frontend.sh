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


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else 
        echo -e "$2...$G SUCCESS $N"
    fi
}


dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Install nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Delete html"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
VALIDATE $? "Delete html"


cd /usr/share/nginx/html &>>$LOG_FILE
VALIDATE $? "Copy code to html"

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzip"


systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "unzip"

