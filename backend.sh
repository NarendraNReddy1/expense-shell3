#!/bin/bash

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

echo "Db Password: ExpenseApp@1"
read -s mysql_root_password


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


dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Nodejs module disable"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enable node js"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installation of node jsr"



id = $(id expense)
echo $id

if [ $id -ne 0 ]
then 
    useradd expense &>>$LOG_FILE
    VALIDATE $? "Installation of node jsr"
else 
    echo "Already user present"
fi         
