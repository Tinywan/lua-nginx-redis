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
   sudo mv mkreleasehdr.sh redis-benchmark redis-check-aof redis-check-rdb redis-cli  
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
    --后台运行
    daemonize yes
           
    --端口号
    port 63700          
    
    --和哪个网卡绑定，和客户端是什么网段没有关系，这里我绑定的是内网网卡,
    bind 10.10.101.127   
    
    -- AES("https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-install.md") 加密
    -- 结果：b6Pbc42gP8hXPNLzZaDnhREijtn1BSVSIYTkhTXw8SuPGpWZvN5kVpVeEVBdEQDw7M/+EZuDS6FxTOtgD2QrPe6014LPEdv2DY+YSUQZ4cE=
    
    requirepass b6Pbc42gP8hXPNLzZaDnhREijtn1BSVSIYTkhTXw8SuPGpWZvN5kVpVeEVBdEQDw7M/+EZuDS6FxTOtgD2QrPe6014LPEdv2DY+YSUQZ4cE=
    
    -- db文件名
    dbfilename dump63700.rdb
    
    -- log 日志文件路径
    logfile "/usr/local/redis/etc/redis_63700.log"
    
    -- 安全考虑，rename-command 配置以下命令
    rename-command FLUSHALL "tinywangithubFLUSHALL"
    
    rename-command CONFIG "tinywangithubCONFIG"
    
    rename-command SHUTDOWN "tinywangithubSHUTDOWN"
    
    rename-command DEBUG "tinywangithubDEBUG"
    ```
+   启动redis服务，并指定启动服务配置文件，检测运行端口	
    ```java
    $ sudo /usr/local/redis/bin/redis-server /usr/local/redis/etc/redis63700.conf
    $ ps -aux | grep redis
    root      70764  0.6  0.1  38160      0:00 /usr/local/redis/bin/redis-server 127.0.0.1:63700
    tinywan   70768  0.0  0.0  15984      0:00 grep --color=auto redis
    ```
+   redis-cli启动、检测重置命令是否生效（结果：配置文件已经OK）
    ```lua
    $ redis-cli -h 127.0.0.1 -p 63700 -a b6Pbc42gP8hXPNLzZaDnhREijtn1BSVSIYTkhTXw8SuPGpWZvN5kVpVeEVBdEQDw7M/+EZuDS6FxTOtgD2QrPe6014LPEdv2DY+YSUQZ4cE= 
      127.0.0.1:63700> set username tinywan
      OK
      127.0.0.1:63700> get username
      "tinywan"
      127.0.0.1:63700> SHUTDOWN
      (error) ERR unknown command 'SHUTDOWN'
      127.0.0.1:63700> FLUSHALL
      (error) ERR unknown command 'FLUSHALL'
      127.0.0.1:63700> tinywangithubFLUSHALL
      OK
      127.0.0.1:63700> get username
      (nil)
      127.0.0.1:63700>
    ```
+   远程链接出现的错误：
    + 错误信息
    
    ```lua
    DENIED Redis is running in protected mode because protected mode is enabled, 
    no bind address was specified, no authentication password is requested to    clients.......  
    ```
    +   修改配置文件：`protected-mode yes` 修改为`protected-mode no `  
+   查看远程Redis服务器的版本 `redis-cli -h 192.168.1.3 info | grep 'redis_version'`










