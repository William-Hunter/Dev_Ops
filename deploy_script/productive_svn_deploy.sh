#!/bin/zsh

REPOS=$1
SVN_USER=****
SVN_PASS=****
CODE_PATH=/opt/auto_deploy
DEPLOY_PATH=/opt
DATE=`date +%Y-%m-%d-%H-%M-%S`
nonce_String=$RANDOM
REMOTE_ADDRESS_TCKJ=127.0.0.1
REMOTE_ADDRESS_MEM=127.0.0.1
REMOTE_UPLOAD_PATH=/uploadZone


function pullSvnCode()
{
	echo '======开始更新代码======'
	cd $CODE_PATH/$REPOS/
	echo '定位代码库:'$CODE_PATH/$REPOS
	svn update --username=$SVN_USER --password=$SVN_PASS
	echo '======更新代码完毕======'
}


function mavenCompileCode()
{
	echo '======开始maven编译======'
	cd $CODE_PATH/$REPOS/
	echo '移位到代码目录:'$CODE_PATH/$REPOS/
	/opt/apache-maven-3.5.2/bin/mvn clean install
	if [ $? -eq 0 ]; then
		echo '======maven编译成功======'
		return 0
    else
		echo '======maven编译失败======'
		return 1
    fi
}


function transformFile()
{
	echo '======开始传输文件======'
	echo $CODE_PATH/$REPOS/target/$REPOS.war '=====>>' root@$1:$REMOTE_UPLOAD_PATH
	scp -r $CODE_PATH/$REPOS/target/$REPOS.war root@$1:$REMOTE_UPLOAD_PATH
	echo '======传输文件完毕======'
}

function executeScript()
{
	echo '======调用远程服务器脚本======'
	echo 'root@'$1 '/opt/apply.sh '$REPOS
	ssh root@$1 '/opt/apply.sh '$REPOS
	echo '======调用结束======'
}


function keepDB()
{       
        echo '======调用远程服务器脚本======'
        echo 'root@'$1 '/opt/backupDB.sh '$REPOS
        ssh root@$1 '/opt/apply.sh '$REPOS
        echo '======调用结束======'
}

gulp_work_dir=/opt/auto_deploy/web_code/$REPOS

function gulpWork(){
	echo '======开始构建前端代码======'
	cd $gulp_work_dir;
	svn update --username=$SVN_USER --password=$SVN_PASS
#	gulp;
#	/bin/rm -rf $CODE_PATH/$REPOS/src/main/webapp/wechat
#	/bin/rm -rf $CODE_PATH/$REPOS/src/main/webapp/yb
#       /bin/cp -fr ./dist/* $CODE_PATH/$REPOS/src/main/webapp/
        /bin/cp -fr ./wechat $CODE_PATH/$REPOS/src/main/webapp/
	/bin/cp -fr ./yb $CODE_PATH/$REPOS/src/main/webapp/
	echo '======前端代码构建完毕======'
}

case $1 in
'qyt')
	pullSvnCode;
	mavenCompileCode;
	transformFile $REMOTE_ADDRESS_MEM;
	executeScript $REMOTE_ADDRESS_MEM;
	keepDB $REMOTE_ADDRESS_TCKJ;
;;
'waterpump')
	pullSvnCode;
	mavenCompileCode;
	transformFile $REMOTE_ADDRESS_MEM;
	executeScript $REMOTE_ADDRESS_MEM;
	keepDB $REMOTE_ADDRESS_TCKJ;
;;
'xhMedicine')
	pullSvnCode;
	mavenCompileCode;
	transformFile $REMOTE_ADDRESS_MEM;
	executeScript $REMOTE_ADDRESS_MEM;
	keepDB $REMOTE_ADDRESS_TCKJ;
;;
'jeecg')
	pullSvnCode;
	mavenCompileCode;
	transformFile $REMOTE_ADDRESS_TCKJ;
	executeScript $REMOTE_ADDRESS_TCKJ;
;;
'hkd')
	pullSvnCode;
	gulpWork;
	mavenCompileCode;
	transformFile $REMOTE_ADDRESS_TCKJ;
	transformFile $REMOTE_ADDRESS_MEM;
#	executeScript $REMOTE_ADDRESS_TCKJ;
#	executeScript $REMOTE_ADDRESS_MEM;
;;
*)
	echo '你输入的项目名有误或存不在'
	exit 1
;;
esac

