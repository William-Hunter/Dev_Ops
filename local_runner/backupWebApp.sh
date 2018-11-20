#!/bin/bash

#定时备份web和sql

DB_USER=****
DB_PSWD=****
DB_HOST=127.0.0.1
DATE=`date +%Y-%m-%d-%H-%M-%S`
BACKUP_PATH=/opt/backup/perDayWebapp/$DATE

echo '正在创建文件夹'+$BACKUP_PATH
mkdir -p $BACKUP_PATH

function ZIP(){
	echo "正在压缩" $1
	/usr/bin/zip -r $BACKUP_PATH/$1.zip /opt/$1/
}

function dump(){
	echo "正在备份数据库" $1
	/bin/bash /opt/timeTask/exportDB.sh $1 $BACKUP_PATH
}



ZIP hkd;

dump xhMedicine;


