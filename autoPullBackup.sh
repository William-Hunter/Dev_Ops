#!/bin/bash

remoteHostIP=127.0.0.1
remoteUser=root
backupPath=/opt/backup
localStorePath=/root/local

command='ls -l '$backupPath' |grep "^d"|wc -l'
count=`ssh $remoteUser@$remoteHostIP $command`
echo 'folder number:'$count

command='ls '$backupPath
fileList=`ssh $remoteUser@$remoteHostIP $command`
let level=count-3
index=0

for fileName in $fileList;  
do  
	if [ $index -lt $level ] 
	then
		echo 'file name:'$fileName;  
		echo $remoteUser@$remoteHostIP:$backupPath/$fileName '====>>' $localStorePath/
		scp -r $remoteUser@$remoteHostIP:$backupPath/$fileName $localStorePath/
		echo '已经复制到本地'

		echo 'deleting......' $backupPath/$fileName
		ssh $remoteUser@$remoteHostIP 'rm -rf '$backupPath/$fileName
		echo '已经删除远程备份'
	else 
		echo $fileName;
                echo $remoteUser@$remoteHostIP:$backupPath/$fileName '====>>' $localStorePath/
                scp -r $remoteUser@$remoteHostIP:$backupPath/$fileName $localStorePath/
                echo '已经复制到本地'

	fi	
	let index=index+1
	echo '================第'$index'次执行完毕'
done  
   
echo "DONE";  



