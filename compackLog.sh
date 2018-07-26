#!/bin/bash

DATE=`date +%Y-%m-%d-%H-%M-%S`

function move(){
	mkdir -p /opt/tomcat8-$1/logs/history/
	/bin/cp /opt/tomcat8-$1/logs/catalina.out /opt/tomcat8-$1/logs/history/$DATE-catalina.out
	echo '' > /opt/tomcat8-$1/logs/catalina.out
}

move jeecg

move zmt



