#!/bin/bash

#备份清理tomcat的日志文件

DATE=`date +%Y-%m-%d-%H-%M-%S`
DAY=`date +%Y-%m-%d`

function move(){
        if [[ $1 != *$DAY* ]];then
                mv $2/$1 $2/history/
        fi
}

function mov(){
	echo "正在创建文件夹---- /opt/$1/logs/history/"
	mkdir -p /opt/$1/logs/history/
	echo "正在复制log文件---- "
	cp /opt/$1/logs/catalina.out /opt/$1/logs/history/$DATE-128_catalina.out
	echo "正在置空原log文件---- "
	cat /dev/null > /opt/$1/logs/catalina.out

	locate=/opt/$1/logs
	cd $locate
	file_list=`ls localhost_access_log.*.txt`
	for file_name in $file_list
	do
        	move $file_name $locate
	done

        file_list=`ls catalina.*.log`
        for file_name in $file_list
        do
                move $file_name $locate
        done    
        
        file_list=`ls host-manager.*.log`
        for file_name in $file_list
        do
                move $file_name $locate
        done    
        
        file_list=`ls localhost.*.log`
        for file_name in $file_list
        do
                move $file_name $locate
        done    
        
        file_list=`ls manager.*.log`
        for file_name in $file_list
        do
                move $file_name $locate
        done    
}

mov tomcat8-hkd;
#mov tomcat8-regionforum;
mov tomcat8-jeecg;



