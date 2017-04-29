## Redis 简易安装教程
#### 一、编译安装
+ 下载、解压   		
    ```javascript
    wget http://download.redis.io/releases/redis-3.2.8.tar.gz
    tar -zxvf redis-3.2.8.tar.gz
    cd  redis-3.2.8
    ```
+ make 编译
    + 编译完成之后，可以看到解压文件redis-3.0.7 中会有对应的src、conf等文件       
    + 这和windows下安装解压的文件一样，大部分安装包都会有对应的类文件、配置文件和一些命令文件。
+ 进入src文件夹，执行make install进行Redis安装
    ```
    make install
    ```		
#### 二、配置部署

+ 首先为了方便管理，将Redis文件中的conf配置文件和常用命令移动到统一文件中			
+ 创建以下文件目录
    ```bash
    mkdir -p /usr/local/redis/bin
    mkdir -p /usr/local/redis/etc
    ```
+ 执行Linux文件移动命令：
   ```
   sudo mv /home/tinywan/redis-3.2.8/redis.conf /usr/local/redis/etc
   cd /home/tinywan/redis-3.2.8/src
   mv mkreleasdhdr.sh redis-benchmark redis-check-aof redis-check-dump redis-cli redis-server /usr/local/redis/bin
   ```
#### 三、后台启动redis服务
+ 1、首先编辑conf文件，将daemonize属性改为yes（表明需要在后台运行）
    ```
    cd /usr/local/redis/etc
    vi redis.conf
    ```
+ 2、再次启动redis服务，并指定启动服务配置文件	

    ```
    /usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf
    ```
+ 3、检测运行端口	
    ```
    tinywan@tinywan:/usr/local/redis/etc$ ps -aux | grep redis
    tinywan   43725  0.1  0.3  38160  6272 ?        Ssl  09:11   0:00 /usr/local/redis/bin/redis-server *:63790
    tinywan   43730  0.0  0.0  15984  1060 pts/4    S+   09:11   0:00 grep --color=auto redis
    ```
+ 4、redis-cli启动
    ```
    tinywan@tinywan:/usr/local/redis/etc$ redis-cli -h 127.0.0.1 -p 63790
    127.0.0.1:63790> set name tinywan
    OK
    127.0.0.1:63790> get name
    "tinywan"
    127.0.0.1:63790> 
    ```

#### 五、配置conf文件，设置密码、支持键过期事件

+ 设置密码

    ```
    requirepass redis_tinywan  #注意这里的特殊符号没有限制的
    ```
+ 指定数据库文件名

    ```
    dbfilename dump.rdb
    ```
+ 指定本地数据库文件名，默认为dump.rdb，我改成dump638989.rdb（表示638989的数据库文件）
    ```
    rdbcompression yes   -- 存储本地数据库时是否启用压缩，默认yes
    ```

+  默认端口 6379 

    ```
    port 6379898
    ```

+ redis启动后的进程ID保存文件 
    ```
    pidfile /usr/local/redis/etc/redis_63790.pid
    ```

+ 日志文件指定路径

    ```
    logfile "/usr/local/redis/etc/redis_63790.log"
    ```

+ 日志级别
    ```
    loglevel verbose
    ```

+ 版本号查看
    ```
    redis-cli -h 127.0.0 .1 -p 63789 -a 123  info | grep 'redis_version'
    ```











