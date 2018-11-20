#!/bin/bash

#自动拉取web和sql备份文件

host_qyt=127.0.0.1
host_tckj=127.0.0.1
host_mem=127.0.0.1
remoteUser=****
DATE=`date +%Y-%m-%dT%H:%M:%S`

function remoteCopy(){
	echo "IP:"$1  " origin:" $2 "  gone:" $3
	echo $remoteUser@$1:$2 '====>>' $3
	scp -r $remoteUser@$1:$2 $3
	echo `date +%Y-%m-%dT%H:%M:%S` ' COPY FILE:' $remoteUser@$1:$2 '====>>' $3 >> /var/log/crond-mission/mission_autoPullBackup.log
}

function remoteDelete(){
	echo 'deleting......IP:' $1 ' path:' $2
      	ssh $remoteUser@$1 '/bin/rm -rf '$2
	echo `date +%Y-%m-%dT%H:%M:%S` ' DELETE:   ' $remoteUser@$1 $2 >> /var/log/crond-mission/mission_autoPullBackup.log
}


mkdir -p /var/log/crond-mission
echo '########################################################' >> /var/log/crond-mission/mission_autoPullBackup.log
echo 'Date:' $DATE >> /var/log/crond-mission/mission_autoPullBackup.log

mysqlBackupPath=/home/remoteBackup/perHourMysql
webBackupPath=/home/remoteBackup/perDayWebapp

function move(){	
	remoteCopy $1  $2 $3
	remoteDelete $1 $2
}


mkdir -p $mysqlBackupPath
move $host_tckj '/opt/backup/perHourMysql/*' $mysqlBackupPath/

mkdir -p $webBackupPath/$host_tckj/
move $host_tckj '/opt/backup/perDayWebapp/*' $webBackupPath/$host_tckj/

mkdir -p $webBackupPath/$host_mem/
move $host_mem '/opt/backup/perDayWebapp/*' $webBackupPath/$host_mem/




