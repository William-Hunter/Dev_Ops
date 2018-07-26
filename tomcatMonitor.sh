#!/bin/bash

function action(){
	tomcat=$2
	port=$1
	tomcat_run=`/usr/sbin/lsof -i:$port|/usr/bin/awk 'NR==2{print $0}'`
	if [ "$tomcat_run" == "" ]; then
		DATE=`date +%Y-%m-%d-%H-%M-%S`
		echo $DATE '监控到端口'$port'无服务，执行命令重启tomcat' >> /var/log/heartbeat/tomcat_monitor.log
		/bin/bash /opt/tomcat.sh $tomcat start
	fi
}

action 87 hkd

#action 84 waterpump


