## Redis 简易安装教程
#### 一、编译安装
+ 下载、解压   		
    ```javascript
    wget http://download.redis.io/releases/redis-3.2.8.tar.gz
    tar -zxvf redis-3.2.8.tar.gz
    cd  redis-3.2.8
    ```
+ make 编译
    + 编译之前  
    ```lua
    00-RELEASENOTES  BUGS  CONTRIBUTING  COPYING  deps  INSTALL  Makefile  MANIFESTO  README.md  redis.conf  runtest 
     runtest-cluster  runtest-sentinel  sentinel.conf  src  tests  utils
    ```  
    + 编译完成之后，可以看到解压文件redis-3.0.7 中会有对应的src、conf等文件       
    + 编译完成之后，可以看到解压文件redis-3.0.7 中会有对应的src、conf等文件       
    + 这和windows下安装解压的文件一样，大部分安装包都会有对应的类文件、配置文件和一些命令文件。
+ 进入src文件夹，执行make install进行Redis安装

    ```bash
    tinywan@tinywan:~/redis-3.2.8/src$ sudo make install 
    [sudo] tinywan 的密码： 
    
    Hint: It's a good idea to run 'make test' ;)
    
        INSTALL install
        INSTALL install
        INSTALL install
        INSTALL install
        INSTALL install
    ```		
#### 二、部署文件结构
+ 首先为了方便管理，将Redis文件中的conf配置文件和常用命令移动到统一文件中			
+ 创建以下文件目录
    ```bash
    ~/redis-3.2.8/src$ sudo mkdir -p /usr/local/redis/bin
    ~/redis-3.2.8/src$ sudo mkdir -p /usr/local/redis/etc
    ```
+ 切换到`redis-3.2.8`目录,移动`redis.conf`配置文件：
   ```javascript
   ~/redis-3.2.8/src$ cd ..
   ~/redis-3.2.8$ sudo mv /home/tinywan/redis-3.2.8/redis.conf /usr/local/redis/etc
   ```
+ 继续进入到`src`目录执行其他文件移动：
   ```javascript
   ~/redis-3.2.8$ cd src/
   sudo mv mkreleasehdr.sh redis-benchmark redis-check-aof redis-check-rdb redis-cli \
   redis-sentinel redis-server redis-trib.rb /usr/local/redis/bin
   ```
#### 三、配置和启动redis服务
+   编辑`redis.conf`
    ```
    cd /usr/local/redis/etc
    vi redis.conf
    ```
+   需要修改的参数  
    ```lua
    daemonize yes       --后台运行
    
    port 63700          --端口号
    
    bind 10.10.101.127  --和哪个网卡绑定，和客户端是什么网段没有关系，这里我绑定的是内网网卡, 
    
    -- AES("https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-install.md") 加密
    -- 结果：b6Pbc42gP8hXPNLzZaDnhREijtn1BSVSIYTkhTXw8SuPGpWZvN5kVpVeEVBdEQDw7M/+EZuDS6FxTOtgD2QrPe6014LPEdv2DY+YSUQZ4cE=
    
    dbfilename /usr/local/redis/etc/dump63700.rdb
    
    logfile "/usr/local/redis/etc/redis_63700.log"
    
    -- 安全考虑，添加以下命令
    rename-command FLUSHALL "tinywangithubFLUSHALL"
    
    rename-command CONFIG "tinywangithubCONFIG"
    
    rename-command SHUTDOWN "tinywangithubSHUTDOWN"
    
    rename-command DEBUG "tinywangithubDEBUG"
    ```
+ 再次启动redis服务，并指定启动服务配置文件	

    ```
    $ sudo /usr/local/redis/bin/redis-server /usr/local/redis/etc/redis63700.conf
    $ ps -aux | grep redis
    root      70764  0.6  0.1  38160      0:00 /usr/local/redis/bin/redis-server 127.0.0.1:63700
    tinywan   70768  0.0  0.0  15984      0:00 grep --color=auto redis
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











