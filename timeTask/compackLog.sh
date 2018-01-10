#!/bin/bash

DATE=`date +%Y-%m-%d-%H-%M-%S`

mkdir -p /opt/tomcat8-jeecg/logs/history/
cp /opt/tomcat8-jeecg/logs/catalina.out /opt/tomcat8-jeecg/logs/history/$DATE-catalina.out
echo '' > /opt/tomcat8-jeecg/logs/catalina.out

mkdir -p /opt/tomcat8-qyt/logs/history/
cp /opt/tomcat8-qyt/logs/catalina.out /opt/tomcat8-qyt/logs/history/$DATE-catalina.out
echo '' > /opt/tomcat8-qyt/logs/catalina.out

mkdir -p /opt/tomcat8-waterpump/logs/history/
cp /opt/tomcat8-waterpump/logs/catalina.out /opt/tomcat8-waterpump/logs/history/$DATE-catalina.out
echo '' > /opt/tomcat8-waterpump/logs/catalina.out

mkdir -p /opt/tomcat8-zmt/logs/history/
cp /opt/tomcat8-zmt/logs/catalina.out /opt/tomcat8-zmt/logs/history/$DATE-catalina.out
echo '' > /opt/tomcat8-zmt/logs/catalina.out



