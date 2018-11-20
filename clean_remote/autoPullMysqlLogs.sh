#!/bin/bash

#自动拉取mysql日志

host_tckj=127.0.0.1
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

backupPath=/home/remoteBackup/mysql_logs

mkdir -p $backupPath
remoteCopy $host_tckj  '/var/log/mysql_general_backup.*.log' $backupPath/
remoteDelete $host_tckj '/var/log/mysql_general_backup.*.log'










