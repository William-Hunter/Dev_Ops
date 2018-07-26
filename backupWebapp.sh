#!/bin/bash

DB_User=root
DB_Password=XXXXXXXXX
HOST=127.0.0.1
DATE=`date +%Y-%m-%d-%H-%M-%S`
backupPath=/opt/backup/perDayWebapp/$DATE

echo '正在创建文件夹'+$backupPath
mkdir $backupPath

function packgePorject(){
	echo '正在压缩' $1
	/usr/bin/zip -r $backupPath/$1.zip /opt/$1/
}

function packageSQL(){
	echo '======开始备份数据库' $1 '======'
	/usr/bin/mysqldump -R -u$DB_USER -p$DB_PSWD -h$HOST $1 > $backupPath/$1.sql
	echo '======备份数据库完毕' $1 '======'
}

packageProject hkd;
packageProject regionforum;
packageProject jeecg;

packageSQL qyt;
packageSQL jeecg;
packageSQL hkd;
packageSQL regionforum;
packageSQL zmt;
packageSQL waterpump;


