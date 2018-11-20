#!/bin/bash

#拉取tomcat的日志信息

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
      	ssh $remoteUser@$1 '/bin/rm -rf /opt/'$2'/logs/history/*'
	echo `date +%Y-%m-%dT%H:%M:%S` ' DELETE:   ' $remoteUser@$1 '/opt/'$2'/logs/history/*' >> /var/log/crond-mission/mission_autoPullBackup.log
}


mkdir -p /var/log/crond-mission
echo '########################################################' >> /var/log/crond-mission/mission_autoPullBackup.log
echo 'Date:' $DATE >> /var/log/crond-mission/mission_autoPullBackup.log

backupPath=/home/remoteBackup/tomcat-logs


function move(){
	mkdir -p $backupPath/$2/$1/
	remoteCopy $1  '/opt/'$2'/logs/history/*' $backupPath/$2/$1/
	remoteDelete $1 $2
}

mkdir -p $backupPath

move $host_tckj tomcat8-hkd
move $host_mem tomcat8-hkd

move $host_tckj tomcat8-jeecg
move $host_mem tomcat8-qyt
move $host_mem tomcat8-xhMedicine
move $host_mem tomcat8-waterpump






