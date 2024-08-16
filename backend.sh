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




id expense &>>$LOG_FILE

if [ $? -ne 0 ]
then 
    useradd expense &>>$LOG_FILE
    VALIDATE $? "Expense user add"
else 
    echo -e "Already user present $Y SKIPPING $N"
fi        

mkdir -p /app &>>$LOG_FILE
VALIDATE $? "App direcoty"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOG_FILE
VALIDATE $? "Backend code in temp"


cd /app &>>$LOG_FILE
rm -rf /app/*
VALIDATE $? "Moving to App direcoty"

unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "Unzipping backend"


npm install &>>$LOG_FILE
VALIDATE $? "npm install"

cp -rf /home/ec2-user/expense-shell3/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE
VALIDATE $? "copying backend service"


systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "daemon-reload"


systemctl start backend &>>$LOG_FILE
VALIDATE $? "start backend"

systemctl enable backend &>>$LOG_FILE
VALIDATE $? "enable backend"

# dnf install mysql -y &>>$LOG_FILE
# VALIDATE $? "Install mysql client"

# mysql -h db.narendra.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOG_FILE
# VALIDATE $? "Install mysql client"

# systemctl restart backend &>>$LOG_FILE
# VALIDATE $? "restart backend"