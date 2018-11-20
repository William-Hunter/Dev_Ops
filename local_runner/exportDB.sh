#!/bin/bash

#到出数据库文件为sql

DB_USER=****
DB_PSWD=****
DATE=`date +%Y-%m-%d-%H-%M-%S`
HOST=127.0.0.1


echo "正在备份数据库"$1 
/usr/bin/mysqldump -u$DB_USER -p$DB_PSWD -h$HOST -R $1 > $2/$1.sql


