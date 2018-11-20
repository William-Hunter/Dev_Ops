#!/bin/bash

#定时备份mysql数据

DB_USER=****
DB_PSWD=****
DATE=`date +%Y-%m-%d-%H-%M-%S`
HOST=127.0.0.1
Path=/opt/backup/perHourMysql/$DATE

echo '======开始备份数据库======'
echo '正在创建文件夹:'$Path
mkdir -p $Path

function dump(){
	/bin/bash /opt/timeTask/exportDB.sh $1 $Path
}

dump qyt;
dump jeecg;
dump waterpump;
dump hkd;
dump xhmedicine;

echo '======备份数据库完毕======'


