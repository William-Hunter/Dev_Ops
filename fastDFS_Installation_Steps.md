
## 安装分布式文件系统
----------------

#### step 1 安装时间库
```
yum -y install libevent
```


#### step 2 获取libfastcommon
```
git clone https://github.com/happyfish100/libfastcommon.git
cd libfastcommon
./make.sh
./make.sh install
```

#### step 3 fastdfs
```
git clone https://github.com/happyfish100/fastdfs.git
cd fastdfs
./make.sh
./make.sh install
```
安装完成后在/usr/bin/目录下有以fdfs开头的文件都是编译出来的。

#### step 4 把解压目录目录下的conf文件夹下的文件都复制到/etc/fdfs下
```
cp ./fastdfs/conf/* /etc/fdfs
```

#### step 5  配置fastFDS的tracker

配置tracker服务。修改/etc/fdfs/tracker.conf文件
```
base_path=/home/yuqing/fastdfs								文件存储路径
```
将该路径改为自己定义的路径，该路径必须存在，用于存放数据和日志文件。

#### step 6  配置fastFDS的storage

配置storage服务。修改/etc/fdfs/storage.conf文件
```
base_path=/home/yuqing/fastdfs 									storage服务日志存放路径，该路径必须存在
store_path0=/home/yuqing/fastdfs 								图片的保存路径，该路径必须存在
tracker_server=192.168.25.133:22122 							指定tracker服务器的ip和端口
```

#### step 7 启动tracker
```
启动：/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf
重启：/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
```


#### step 8 启动storage
```
启动：/usr/bin/fdfs_storaged /etc/fdfs/storage.conf
重启：/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
```

#### step 9 修改防火墙设置，添加规则
修改防火墙命令：vim /etc/sysconfig/iptables
```
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 23000 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22122 -j ACCEPT
service iptables restart
```


#### step 10 使用自带的client进行测试
配置客户端设置/etc/fdfs/client.conf
```
base_path=/home/fastdfs/client 								客户端日志文件保存路径
tracker_server=192.168.25.133:22122 						指定tracker的ip和端口
```
测试
```
/usr/bin/fdfs_test /etc/fdfs/client.conf upload /root/test.jpg 			在linux内部进行图片上传
```


##  搭建Nginx提供Http外网访问

#### step 1 获取fastdfs对nginx模组支持的源代码
```
git clone https://github.com/happyfish100/fastdfs-nginx-module.git
```
复制到fasts整合的配置文件
```
cp ./fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/
```

配置模组的设置  /etc/fdfs/mod_fastdfs.conf

```
base_path=/tmp 												日志存放位置
tracker_server=192.168.3.254:22122 							tracerServer的服务器地址
url_have_group_name = true 									是否包含组名group
group_name=group1 											此台storage server所属的服务器组名
store_path0=/home/fastdfs/storage							图片保存路径，就是包含data的那个路径，这个别弄错了
```

nginx获取文件需要一个客户端，将这个文件复制到lib库上
```
cp /usr/lib64/libfdfsclient.so /usr/lib/ 
```

#### step 2 重新编译支持mod的nginx
获取nginx源代码
```
wget http://nginx.org/download/nginx-1.13.8.tar.gz
```
解压后进入文件夹
```
tar -zxvf nginx-1.13.8.tar.gz
cd nginx
```
首先获取现有nginx的编译参数
```
nginx -V
```
配置nginx 的编译参数，参数末尾里新增fastdfs的模组参数，等于号右边是这个fast支持nginx模块所在的路径
```
./configure .........   --add-module=/root/fastdfs-nginx-module/src
```
编译nginx
```
make
make install
```
生成的ngixn在objs这个文件夹里面

#### step 2 配置nginx
修改nginx访问配置
```
server {
    listen       80;
    server_name  localhost;
    location ~/group([0-9])/M00/{
        root /文件data路径;
        ngx_fastdfs_module;
    }
}
```


## 设置开机自动启动（可选）
```
vim /etc/rc.d/rc.local
添加tracker服务器启动命令
/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
添加storage服务器启动命令
/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
```
