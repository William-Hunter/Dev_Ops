#!/bin/zsh

#从内网服务器开始自动发布项目

REPOS=$1
SVN_USER=****
SVN_PASS=****
CODE_PATH=/opt/auto_deploy
DEPLOY_PATH=/opt
DB_USER=****
DB_PSWD=****
DATE=`date +%Y-%m-%d-%H-%M-%S`
nonce_String=$RANDOM
UPLOAD_PATH=/uploadZone


function backup(){
	echo '======开始备份项目======'
	echo '正在创建文件夹:'$DATE
	mkdir /home/backup/$DATE
	echo '正在压缩'$REPOS
	zip -r /home/backup/$DATE/$REPOS.zip /opt/$REPOS/
	echo '正在备份数据库'$REPOS
	mysqldump -u$DB_USER -p$DB_PSWD $REPOS > /home/backup/$DATE/$REPOS.sql
	echo '======备份项目完毕======'
}

function pullSvnCode(){
	echo '======开始更新代码======'
	cd $CODE_PATH/$REPOS/
	echo '定位代码库:'$CODE_PATH/$REPOS
	svn update --username=$SVN_USER --password=$SVN_PASS
	echo '======更新代码完毕======'
}

function mavenCompileCode(){
	echo '======开始maven编译======'
	cd $CODE_PATH/$REPOS/
	echo '移位到代码目录:'$CODE_PATH/$REPOS/
	/opt/apache-maven-3.5.2/bin/mvn clean install
	echo '======结束maven编译======'
}

function takeoutConfig(){
	mkdir -p $UPLOAD_PATH/conf_file/
	echo '==================开始提取配置文件=================='
	/bin/cp -rf $DEPLOY_PATH/$REPOS/WEB-INF/classes/sysConfig.properties 			$UPLOAD_PATH/conf_file/
	/bin/cp -rf $DEPLOY_PATH/$REPOS/WEB-INF/classes/dbconfig.properties 			$UPLOAD_PATH/conf_file/
	/bin/cp -rf $DEPLOY_PATH/$REPOS/WEB-INF/classes/fdfs_client.conf 			$UPLOAD_PATH/conf_file/
	/bin/cp -rf $DEPLOY_PATH/$REPOS/WEB-INF/classes/spring-redis-context.xml		$UPLOAD_PATH/conf_file/
	/bin/cp -rf $DEPLOY_PATH/$REPOS/WEB-INF/classes/spring-rabbitmq-context.xml		$UPLOAD_PATH/conf_file/
	/bin/cp -rf $DEPLOY_PATH/$REPOS/WEB-INF/classes/jeecg/jeecg_database.properties		$UPLOAD_PATH/conf_file/
	/bin/cp -rf $DEPLOY_PATH/$REPOS/wechat/common/js/baseURL.js				$UPLOAD_PATH/conf_file/
	echo '==================提取配置文件完毕=================='	
}

function putbackConfig(){
	echo '==================开始回置配置文件=================='
	/bin/cp -rf $UPLOAD_PATH/conf_file/sysConfig.properties			$DEPLOY_PATH/$REPOS/WEB-INF/classes/
	/bin/cp -rf $UPLOAD_PATH/conf_file/dbconfig.properties			$DEPLOY_PATH/$REPOS/WEB-INF/classes/
	/bin/cp -rf $UPLOAD_PATH/conf_file/fdfs_client.conf 			$DEPLOY_PATH/$REPOS/WEB-INF/classes/
	/bin/cp -rf $UPLOAD_PATH/conf_file/spring-redis-context.xml		$DEPLOY_PATH/$REPOS/WEB-INF/classes/
	/bin/cp -rf $UPLOAD_PATH/conf_file/spring-rabbitmq-context.xml		$DEPLOY_PATH/$REPOS/WEB-INF/classes/
	/bin/cp -rf $UPLOAD_PATH/conf_file/jeecg_database.properties		$DEPLOY_PATH/$REPOS/WEB-INF/classes/jeecg/
	/bin/cp -rf $UPLOAD_PATH/conf_file/baseURL.js				$DEPLOY_PATH/$REPOS/wechat/common/js/
	echo '==================配置文件回置结束=================='
	rm -rf $UPLOAD_PATH/conf_file/*	
}

function mergeFolder(){
	takeoutConfig;
	echo '=====开始合并覆盖文件夹====='	
	rm -rf $DEPLOY_PATH/$REPOS/*
	echo $CODE_PATH/$REPOS/target/$REPOS/'=====>'$DEPLOY_PATH/$REPOS/
	/bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/* $DEPLOY_PATH/$REPOS/	
	echo '=====合并覆盖文件夹结束====='
	putbackConfig;
}


#jeecg等项目内有图片，只能精确的用文件覆盖的方式去完成，
function copyFile(){
        takeoutConfig;

        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/index.jsp $DEPLOY_PATH/$REPOS/index.jsp
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/context $DEPLOY_PATH/$REPOS/context
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/export $DEPLOY_PATH/$REPOS/export
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/images $DEPLOY_PATH/$REPOS/images
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/META-INF $DEPLOY_PATH/$REPOS/META-INF
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/plug-in $DEPLOY_PATH/$REPOS/plug-in
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/resources $DEPLOY_PATH/$REPOS/resouces
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/swftools $DEPLOY_PATH/$REPOS/swftools
        rm -rf $DEPLOY_PATH/$REPOS/WEB-INF/*
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/WEB-INF/* $DEPLOY_PATH/$REPOS/WEB-INF/
        rm -rf $DEPLOY_PATH/$REPOS/webpage/*
        /bin/cp -rf $CODE_PATH/$REPOS/target/$REPOS/webpage/* $DEPLOY_PATH/$REPOS/webpage/

        putbackConfig;
}


function restartTomcat(){
	echo '=====开始重启tomcat====='
	/opt/tomcat.sh $REPOS restart
	echo '=====重启tomcat完毕====='
}

gulp_work_dir=/opt/auto_deploy/web_code/$REPOS

function gulpWork(){
	echo '======开始构建前端代码======'
	cd $gulp_work_dir;
	svn update --username=$SVN_USER --password=$SVN_PASS
#	gulp;
#	/bin/rm -rf $CODE_PATH/$REPOS/src/main/webapp/wechat
#	/bin/rm -rf $CODE_PATH/$REPOS/src/main/webapp/yb
#   /bin/cp -fr ./dist/* $CODE_PATH/$REPOS/src/main/webapp/
    /bin/cp -fr ./wechat $CODE_PATH/$REPOS/src/main/webapp/
    /bin/cp -fr ./yb $CODE_PATH/$REPOS/src/main/webapp/
	echo '======前端代码构建完毕======'
}


mkdir -p $UPLOAD_PATH
case $1 in
'qyt')
	pullSvnCode && mavenCompileCode;
	copyFile;
	restartTomcat;
;;
'waterpump')
	pullSvnCode && mavenCompileCode;
	copyFile;
	restartTomcat;
;;
'xhMedicine')
	pullSvnCode && mavenCompileCode;
	mergeFolder;
	restartTomcat;
;;
'jeecg')
	pullSvnCode && mavenCompileCode;
	copyFile;
	restartTomcat;
;;
'hkd')
	pullSvnCode;
	gulpWork;
	mavenCompileCode;
	mergeFolder;
	restartTomcat;
;;
*)
	echo '你输入的项目名有误或存不在'
	exit 1
;;
esac

