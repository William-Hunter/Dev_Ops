#!/bin/bash

DB_USER=root
DB_PSWD=TongChuangHui2017
DATE=`date +%Y-%m-%d-%H-%M-%S`
HOST=127.0.0.1

function dump(){
	echo '======正在备份数据库' $1 '======'
	/usr/bin/mysqldump -R -u$DB_USER -p$DB_PSWD -h$HOST $1 > /opt/backup/perHourMysql/$DATE/$1.sql
	echo '======备份数据库完毕' $1 '======'
}

echo '======开始备份数据库======'
echo '正在创建文件夹:'$DATE
mkdir -p /opt/backup/perHourMysql/$DATE

dump qyt;
dump jeecg;
dump zmt;
dump waterpump;
dump regionforum;
dump hkd;




