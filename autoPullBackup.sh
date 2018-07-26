#!/bin/bash

remoteHostIP=127.0.0.1
remoteUser=root
backupPath=$1
localStorePath=$2
DATE=`date +%Y-%m-%dT%H:%M:%S`

function remoteCopy()
{
        echo 'file name:'$1;
        echo $remoteUser@$remoteHostIP:$backupPath/$1 '====>>' $localStorePath/
        scp -r $remoteUser@$remoteHostIP:$backupPath/$1 $localStorePath/
	echo `date +%Y-%m-%dT%H:%M:%S` ' COPY FILE:' $remoteUser@$remoteHostIP:$backupPath/$1 '====>>' $localStorePath/ >> /var/log/crond-mission/mission_autoPullBackup.log
}

function remoteDelete()
{
	if [[ $backupPath -ne '' ]] && [[ $1 -ne '' ]]
	then
	        echo 'deleting......' $backupPath/$1
#       	ssh $remoteUser@$remoteHostIP 'rm -rf '$backupPath/$1
		echo `date +%Y-%m-%dT%H:%M:%S` ' DELETE:   ' $remoteUser@$remoteHostIP$backupPath/$1 >> /var/log/crond-mission/mission_autoPullBackup.log
	fi
}


echo 'The auto pull production backup file mission is started.'


mkdir -p /var/log/crond-mission
echo '########################################################' >> /var/log/crond-mission/mission_autoPullBackup.log
echo 'Date:' $DATE >> /var/log/crond-mission/mission_autoPullBackup.log

mkdir -p $localStorePath

command='ls -l '$backupPath' |grep "^d"|wc -l'
count=`ssh $remoteUser@$remoteHostIP $command`
echo 'folder number:'$count

command='ls '$backupPath
fileList=`ssh $remoteUser@$remoteHostIP $command`
#let level=count-5
let level=$count

index=0
for fileName in $fileList;  		
do 
	if [[ ${fileName:0:3} -ne "per" ]] 
	then	
		if [ $index -lt $level ] 
		then
			remoteCopy $fileName
			remoteDelete $fileName
		else
			remoteCopy $fileName 
			echo 'keep this file on disk for future purpose.'
		fi	
	fi
	let index=index+1
	echo '================第'$index'次执行完毕'
done

echo '########################################################' >> /var/log/crond-mission/mission_autoPullBackup.log

echo "Mission Completed!";  





