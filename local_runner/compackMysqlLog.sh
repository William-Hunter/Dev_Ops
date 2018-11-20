#!/bin/bash

#备份清理mysql的查询日志

DATE=`date +%Y-%m-%d-%H-%M-%S`
DAY=`date +%Y-%m-%d`
 
echo "正在复制log文件---- "
cp /var/log/mysql_general_log.log /var/log/mysql_general_backup.$DATE.log
echo "正在置空原log文件---- "
cat /dev/null > /var/log/mysql_general_log.log

