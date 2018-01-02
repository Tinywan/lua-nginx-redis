## 高并发系统内核优化
+   [Socket优化](#Socket)
    +   Nginx
    +   系统内核
+   [文件优化](#file)
    +   Nginx
    +   系统内核    
+   [配置文件优化](#config-file)
    +   Nginx配置文件
    +   内核配置文件      
    +   PHP7配置文件      
    +   PHP-FPM配置文件      
###  <a name="Socket"/> Socket优化
#### Nginx 
+   子进程允许打开的连接数：`worker_connections`
#### 系统内核 
+   [内核参数的优化](http://blog.csdn.net/moxiaomomo/article/details/19442737)  
+   实践优化配置
    +  编辑： `vim /etc/sysctl.conf`
    +  配置结果
    
        ```bash
        net.ipv4.tcp_max_tw_buckets = 6000
        net.ipv4.ip_local_port_range = 1024    65000
        net.ipv4.tcp_tw_recycle = 1
        net.ipv4.tcp_tw_reuse = 1
        net.ipv4.tcp_syncookies = 1
        net.core.somaxconn = 262144
        net.core.netdev_max_backlog = 262144
        net.ipv4.tcp_max_orphans = 262144
        net.ipv4.tcp_max_syn_backlog = 262144
        net.ipv4.tcp_syn_retries = 1
        net.ipv4.tcp_fin_timeout = 1
        net.ipv4.tcp_keepalive_time = 30
        ```
    +   执行命令使之生效：`/sbin/sysctl -p`       
###   <a name="file"/> 文件优化
#### Nginx 
+   指当一个nginx进程打开的最多文件描述符数目：`worker_rlimit_nofile 100000;`
#### 系统内核 
+   系统限制其最大进程数：`ulimit -n`
+   编辑文件：`/etc/security/limits.conf`

    ```conf
    # End of file
    root soft nofile 65535
    root hard nofile 65535
    * soft nofile 65535
    * hard nofile 65535
    ```       
###  <a name="config-file"/> 配置文件优化
+   Nginx配置文件

    ```lua
    user  www www;
    worker_processes 8;
    worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000;
    error_log  /www/log/nginx_error.log  crit;
    pid        /usr/local/nginx/nginx.pid;
    worker_rlimit_nofile 204800;
    
    events
    {
      use epoll;
      worker_connections 204800;
    }
    
    http
    {
      include       mime.types;
      default_type  application/octet-stream;
    
      charset  utf-8;
    
      server_names_hash_bucket_size 128;
      client_header_buffer_size 2k;
      large_client_header_buffers 4 4k;
      client_max_body_size 8m;
    
      sendfile on;
      tcp_nopush     on;
    
      keepalive_timeout 60;
    
      fastcgi_cache_path /usr/local/nginx/fastcgi_cache levels=1:2
      keys_zone=TEST:10m
      inactive=5m;
      fastcgi_connect_timeout 300;
      fastcgi_send_timeout 300;
      fastcgi_read_timeout 300;
      fastcgi_buffer_size 64k;
      fastcgi_buffers 8 64k;
      fastcgi_busy_buffers_size 128k;
      fastcgi_temp_file_write_size 128k;
      fastcgi_cache TEST;
      fastcgi_cache_valid 200 302 1h;
      fastcgi_cache_valid 301 1d;
      fastcgi_cache_valid any 1m;
      fastcgi_cache_min_uses 1;
      fastcgi_cache_use_stale error timeout invalid_header http_500;
    
      open_file_cache max=204800 inactive=20s;
      open_file_cache_min_uses 1;
      open_file_cache_valid 30s;
      tcp_nodelay on;
    
      #gzip  on;
      gzip on;
      gzip_min_length 1k;
      gzip_buffes 16 64k;
      gzip_http_version 1.1;
      gzip_comp_level 6;
      gzip_types text/plain application/x-javascript text/css application/javascript text/javascript image/jpeg image/gif image/png application/xml application/json;
      gzip_vary on;
      gzip_disable "MSIE [1-6].(?!.*SV1)";
      
      index  index.php index.html index.htm;
      
      server
      {
          listen       8080;
          server_name  backup.aiju.com;
          root  /www/html/;  #这里的位置很重要，不要写在其它指令里面，我曾经就调试了好久才发现这个问题的
    
          location /status
          {
            stub_status on;
          }
      
          location ~ .*\.(html|htm|gif|jpg|jpeg|bmp|png|ico|txt|js|css)$ {
                  #root /home/www/sansan-web/public;
                  expires      3d;
          }
  
          location ~ ^/(status|ping)$
          {
                  include fastcgi_params;
                  fastcgi_pass unix:/var/run/php7.0.22-fpm.sock;
                  fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
          }
  
          location = /favicon.ico {
              access_log off;
          }
  
          error_page  400 401 402 403 404  /40x.html;
          #location = /40x.html {
          #        root   html;
          #}
  
          error_page   500 501 502 503 504  /50x.html;
          location = /50x.html {
                  root   html;
          }
      
          # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
          location ~ \.php$ {
                fastcgi_pass   unix:/var/run/php7.0.22-fpm.sock;
                fastcgi_index  index.php;
                fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                include        fastcgi_params;
                fastcgi_buffer_size 128k;
                fastcgi_buffers 4 256k;
                fastcgi_busy_buffers_size 256k;
                fastcgi_connect_timeout 300;
                fastcgi_send_timeout 300;
                fastcgi_read_timeout 300;
           }

          location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|js|css)$
          {
            expires      30d;
          }
    
          log_format  access  '$remote_addr - $remote_user [$time_local] "$request" '
          '$status $body_bytes_sent "$http_referer" '
          '"$http_user_agent" $http_x_forwarded_for';
          access_log  /www/log/access.log  access;
      }
    } 
    ```
+   完整的内核优化配置

    ```lua
    net.ipv4.ip_forward = 0
    net.ipv4.conf.default.rp_filter = 1
    net.ipv4.conf.default.accept_source_route = 0
    kernel.sysrq = 0
    kernel.core_uses_pid = 1
    net.ipv4.tcp_syncookies = 1
    kernel.msgmnb = 65536
    kernel.msgmax = 65536
    kernel.shmmax = 68719476736
    kernel.shmall = 4294967296
    net.ipv4.tcp_max_tw_buckets = 6000
    net.ipv4.tcp_sack = 1
    net.ipv4.tcp_window_scaling = 1
    net.ipv4.tcp_rmem = 4096        87380   4194304
    net.ipv4.tcp_wmem = 4096        16384   4194304
    net.core.wmem_default = 8388608
    net.core.rmem_default = 8388608
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    net.core.netdev_max_backlog = 262144
    net.core.somaxconn = 262144
    net.ipv4.tcp_max_orphans = 3276800
    net.ipv4.tcp_max_syn_backlog = 262144
    net.ipv4.tcp_timestamps = 0
    net.ipv4.tcp_synack_retries = 1
    net.ipv4.tcp_syn_retries = 1
    net.ipv4.tcp_tw_recycle = 1
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_mem = 94500000 915000000 927000000
    net.ipv4.tcp_fin_timeout = 1
    net.ipv4.tcp_keepalive_time = 30
    net.ipv4.ip_local_port_range = 1024    65000
    ```    
####   PHP.ini配置文件优化(PHP7)
+   启用Zend Opcache,php.ini配置文件中加入

    ```bash
    opcache.enable=1
    zend_extension=opcache.so
    opcache.memory_consumption=128
    opcache.interned_strings_buffer=8
    opcache.max_accelerated_files=4000
    opcache.revalidate_freq=60
    opcache.fast_shutdown=1
    opcache.enable_cli=1
    opcache.huge_code_pages=1
    opcache.file_cache=/tmp
    ```
+  缓存文件记录

    ```bash
    www@TinywanAliYun:/tmp$ tree -L 6
    .
    ├── 8fc9c56d14b6542c6ff7147207730f6b
    │   └── home
    │       └── www
    │           └── web
    │               └── go-study-line
    │                   ├── application
    │                   ├── config
    │                   ├── public
    │                   ├── runtime
    │                   ├── thinkphp
    │                   └── vendor
    ```
+  使用新的编译器,使用新一点的编译器, 推荐GCC 4.8以上, 因为只有GCC 4.8以上PHP才会开启Global Register for opline and execute_data支持, 这个会带来5%左右的性能提升
+   开启HugePages,然后开启Opcache的huge_code_pages
    +   系统中开启HugePages  
    
        ```bash
        sudo sysctl vm.nr_hugepages=512
        ```
    +   分配512个预留的大页内存
    
        ```bash
        $ cat /proc/meminfo  | grep Huge
        AnonHugePages:    106496 kB
        HugePages_Total:     512
        HugePages_Free:      504
        HugePages_Rsvd:       27
        HugePages_Surp:        0
        Hugepagesize:       2048 kB
        ```
    +   然后在php.ini中加入，`opcache.huge_code_pages=1`
+   开启Opcache File Cache,`opcache.file_cache=/tmp`   
+   启用Zend Opcache
####   PHP-FPM优化
+   结构

    ```bash
          +---> php.ini         PHP配置文件
          |
    PHP-->|---> php-fpm         服务控制脚本
          +---> php-fpm.conf    进程服务主配置文件
                |
                +---> www.conf  进程服务扩展配置文件
    ```
+   `php.ini`

    ```php
    # 设置错误日志的路径
    error_log = /var/log/php-fpm/error.log
     
    # 引入www.conf文件中的配置
    include=/usr/local/php7/etc/php-fpm.d/*.conf
     
    # 设置主进程打开的最大文件数
    rlimit_files = 102400
    ```
        
+   `php-fpm.conf` 进程服务主配置文件
    
    ```php
    pid = run/php-fpm.pid
    # 设置错误日志的路径
    error_log = /var/log/php-fpm/error.log
     
    # 引入www.conf文件中的配置
    include=/usr/local/php7/etc/php-fpm.d/*.conf
     
    # 设置主进程打开的最大文件数
    rlimit_files = 65535
    ```
    
+   `www.conf` 进程服务扩展配置文件 
    
    ```php
    # 设置启动进程的帐户和组
    user = www
    group = www
     
    # 设置php监听方式,注意这里要设置PHP套接字文件的权限，默认是root，Nginx无法访问
    # listen = 127.0.0.1:9000 
    listen = /var/run/php-fpm/php-fpm.sock
    
    #backlog数，-1表示无限制，由操作系统决定，此行注释掉就行。backlog含义参考：http://www.3gyou.cc/?p=41
     
    listen.allowed_clients = 127.0.0.1
    # 允许访问FastCGI进程的IP，设置any为不限制IP，如果要设置其他主机的nginx也能访问这台FPM进程，
    # listen处要设置成本地可被访问的IP。默认值是any。每个地址是用逗号分隔.
    # 如果没有设置或者为空，则允许任何服务器请求连接

    #backlog数，-1表示无限制，由操作系统决定，此行注释掉就行。backlog含义参考：http://www.3gyou.cc/?p=41
    listen.backlog = 4096
    
    # unix socket设置选项，如果使用tcp方式访问，这里注释即可。
    listen.owner = www
    listen.group = www
    listen.mode = 0660
    
    # 开启慢日志
    slowlog = /var/log/php-fpm/php-slow.log  
    request_slowlog_timeout = 10s  

    # 如果客户端请求出现502请修改以下配置参数,默认值：0,如果执行shell脚本,建议默认就可以。
    request_terminate_timeout = 30   
    
    #对于专用服务器，pm可以设置为static。
    pm = dynamic 
    
    # 设置工作进程数(根据实际情况设置)
    pm.max_children = 50
    
    # pm.start_servers不能小于pm.min_spare_servers,推荐为最大的pm.max_children的%10
    pm.start_servers = 8
    pm.min_spare_servers = 5
    pm.max_spare_servers = 10
    pm.max_requests = 10240
    
    # cat  /usr/local/php-5.5.10/etc/php-fpm.conf | grep status_path
    pm.status_path = /status

    # 设置扩展配置主进程打开的最大文件数
    rlimit_files = 65535
    
    # 设置php的session目录（所属用户和用户组都是www）
    php_value[session.save_handler] = files
    php_value[session.save_path] = /var/tmp/php/session
    ```
    
+   调整PHP-FPM（Nginx）的子进程
    +   日志中出现以下警告消息,这意味着没有足够的PHP-FPM进程
    
        ```php
        [19-Aug-2017 01:02:20] WARNING: [pool www] seems busy (you may need to increase pm.start_servers, or pm.min/max_spare_servers)
        [19-Aug-2017 01:02:21] WARNING: [pool www] server reached pm.max_children setting (256), consider raising it
        ```
    
    +   根据系统内存量来计算和更改这些值，` /etc/php-fpm.d/www.conf`
        
        ```php
        pm.max_children = 50
        pm.start_servers = 5
        pm.min_spare_servers = 5
        pm.max_spare_servers = 35
        ```
        
    +   以下命令将帮助我们确定每个（PHP-FPM）子进程使用的内存：
        > RSS列显示PHP-FPM进程的未交换的物理内存使用量，单位为千字节
        > 平均每个PHP-FPM进程在我的机器上占用大约75MB的RAM
            
        ```php
        ps -ylC php-fpm --sort:rss
        ```
        
    +   pm.max_children的适当值可以计算为:
        
        ```php
        pm.max_children = Total RAM dedicated to the web server / Max child process size 
        ```
        
    +   在我的情况下是56MB,服务器有16GB的RAM，所以：    
        >我留下了一些记忆，让系统呼吸。在计算内存使用情况时，您需要考虑计算机上运行的任何其他服务。
        
        ```php
        pm.max_children = 15806MB / 56MB = 282
        #  Tinywan 计算方式(实战) 
        #  pm.max_children = (15806MB - 1024MB) / 57MB = 259
        ```
        
    +   已经改变了如下设置
        >请注意，非常高的价值并不意味着任何好处
        
        ```php
        pm.max_children = 256
        pm.start_servers = 32
        pm.min_spare_servers = 32
        pm.max_spare_servers = 128
        pm.max_requests = 65535
        ```
        
    +   您可以使用此方便的命令检查单个PHP-FPM进程的平均内存使用情况
        
        ```php
        ps --no-headers -o "rss,cmd" -C php-fpm | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"M") }'
        ```
     
+   HELP
    +   [php-fpm - 启动参数及重要配置详解](http://www.4wei.cn/archives/1002061)        
    +   [php-fpm backlog参数潜在问题](http://blog.csdn.net/willas/article/details/11634825)        
    +   [Adjusting child processes for PHP-FPM (Nginx)](https://myshell.co.uk/blog/2012/07/adjusting-child-processes-for-php-fpm-nginx/)     
    +   [Nginx的worker_processes优化](http://blog.chinaunix.net/uid-26000296-id-3987521.html)
    
