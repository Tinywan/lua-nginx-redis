## Redis 简易安装教程
#### 一、安装编译
+ 下载、解压   		

```
wget http://download.redis.io/releases/redis-3.2.8.tar.gz
tar -zxvf redis-3.2.8.tar.gz 
```

+ make 编译

    + 编译完成之后，可以看到解压文件redis-3.0.7 中会有对应的src、conf等文件夹，这和windows下安装解压的文件一样，大部分安装包都会有对应的类文件、配置文件和一些命令文件。

+ 进入src文件夹，执行make install进行Redis安装

```
make install
```

+ 安装完成后界面			

#### 二、配置部署

+ 1、首先为了方便管理，将Redis文件中的conf配置文件和常用命令移动到统一文件中			
>>[success] a)创建bin和redis.conf文件
```
mkdir -p/usr/local/redis/bin
mkdir -p/usr/local/redis/ect
```
>>[success] b)执行Linux文件移动命令：

```
mv /lamp/redis-3.0.7/redis.conf /usr/local/redis/etc
cd /lamp/redis-3.0.7/src
mv mkreleasdhdr.sh redis-benchmark redis-check-aof redis-check-dump redis-cli redis-server /usr/local/redis/bin
```
#### 三、后台启动redis服务
>[success] 1、首先编辑conf文件，将daemonize属性改为yes（表明需要在后台运行）
~~~
cd etc/
vi redis.conf
~~~
>[success] 2、再次启动redis服务，并指定启动服务配置文件	

```
redis-server /usr/local/redis/etc/redis.conf
```
>[success] 3、检测运行端口	

```
ps -aux | grep redis
```
![](image/screenshot_1490074239239.png)

#### 四、执行redis-cli启动Redis 客户端

```
root@iZbp18hr71r9nm5mvtahngZ:/home/www# redis-cli 
127.0.0.1:6379>
```

#### 五、配置conf文件，设置密码、支持键过期事件

>[info] 设置密码

```
requirepass redis_tinywan  #注意这里的特殊符号没有限制的
```
>[info] 指定数据库文件名

```
dbfilename dump.rdb
```
*	指定本地数据库文件名，默认为dump.rdb，我改成dump638989.rdb（表示638989的数据库文件）

>[info] 存储本地数据库时是否启用压缩，默认yes

```
rdbcompression yes
```

>[info]  默认端口 6379 

```
port 6379898
```

>[info] redis启动后的进程ID保存文件 
~~~
pidfile /usr/local/redis/etc/redis_63790.pid
~~~

>[info] 日志文件指定路径

~~~
logfile "/usr/local/redis/etc/redis_63790.log"
~~~

>[info] 日志级别
~~~
loglevel verbose
~~~

>[info] 版本号查看
~~~
redis-cli -h 127.0.0 .1 -p 63789 -a 123  info | grep 'redis_version'
~~~











