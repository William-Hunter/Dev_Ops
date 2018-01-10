#!/bin/bash

DB_USER=????
DB_PSWD=******
DATE=`date +%Y-%m-%d-%H-%M-%S`

echo '======开始备份数据库======'
echo '正在创建文件夹:'$DATE
mkdir -p /home/backup/perHourMysql/$DATE
echo '正在备份数据库'$REPOS
mysqldump -u$DB_USER -p$DB_PSWD qyt > /home/backup/perHourMysql/$DATE/qyt.sql
mysqldump -u$DB_USER -p$DB_PSWD jeecg > /home/backup/perHourMysql/$DATE/jeecg.sql
mysqldump -u$DB_USER -p$DB_PSWD zmt > /home/backup/perHourMysql/$DATE/zmt.sql
mysqldump -u$DB_USER -p$DB_PSWD waterpump > /home/backup/perHourMysql/$DATE/waterpump.sql
mysqldump -u$DB_USER -p$DB_PSWD wsc > /home/backup/perHourMysql/$DATE/wsc.sql
echo '======备份项目完毕======'


