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
    +   php-fpm.conf 重要参数详解
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
##  php-fpm.conf 重要参数详解

+   常用参数解释
    
     ```php
     1）pm = dynamic #对于专用服务器，pm可以设置为static。
     #如何控制子进程，选项有static和dynamic。如果选择static，则由pm.max_children指定固定的子进程数。如果选择dynamic，则由pm.max_children、pm.start_servers、pm.min_spare_servers、pm.max_spare_servers 参数决定：
     2）pm.max_children
     
     在同一时间最大的进程数
     
     pm.max_children = 120
     
     3）pm.start_servers
     
     php-fpm启动时开启的等待请求到来的进程数，默认值为：min_spare_servers + (max_spare_servers - min_spare_servers) / 2
     
     pm.start_servers = 80
     
     4）pm.min_spare_servers
     在空闲状态下，运行的最小进程数，如果小于此值，会创建新的进程
     pm.min_spare_servers = 60
     
     5）pm.max_spare_servers
     在空闲状态下，运行的最大进程数，如果大于此值，会kill部分进程
     pm.max_spare_servers = 120
     
     6）pm.process_idle_timeout
     空闲多少秒之后进程会被kill，默认为10s
     pm.process_idle_timeout = 10s
     
     7）pm.max_requests
     每个进程处理多少个请求之后自动终止，可以有效防止内存溢出，如果为0则不会自动终止，默认为0#设置每个子进程重生之前服务的请求数. 对于可能存在内存泄漏的第三方模块来说是非常有用的. 如果设置为 '0' 则一直接受请求. 等同于 PHP_FCGI_MAX_REQUESTS 环境变量. 默认值: 0.
     pm.max_requests = 5000
     
     8）pm.status_path
     注册的URI，以展示php-fpm状态的统计信息
          pm.status_path = /status
          其中统计页面信息有：
          pool 进程池名称
          process manager 进程管理器名称（static, dynamic or ondemand）
          start time php-fpm启动时间
          start since php-fpm启动的总秒数
          accepted conn 当前进程池接收的请求数
          listen queue 等待队列的请求数
          max listen queue 自启动以来等待队列中最大的请求数
          listen queue len 等待连接socket队列大小
          idle processes 当前空闲的进程数
          active processes 活动的进程数
          total processes 总共的进程数（idle+active）
          max active processes 自启动以来活动的进程数最大值
          max children reached 达到最大进程数的次数
     
     9）ping.path
     ping url，可以用来测试php-fpm是否存活并可以响应
     ping.path = /ping
     
     10）ping.response
     ping url的响应正文返回为 HTTP 200 的 text/plain 格式文本. 默认值: pong.
     ping.response = pong
     
     
     11）pid = run/php-fpm.pid
     #pid设置，默认在安装目录中的var/run/php-fpm.pid，建议开启
      
     12）error_log = log/php-fpm.log
     #错误日志，默认在安装目录中的var/log/php-fpm.log
      
     13）log_level = notice
     #错误级别. 可用级别为: alert（必须立即处理）, error（错误情况）, warning（警告情况）, notice（一般重要信息）, debug（调试信息）. 默认: notice.
      
     14）emergency_restart_threshold = 60
     emergency_restart_interval = 60s
     #表示在emergency_restart_interval所设值内出现SIGSEGV或者SIGBUS错误的php-cgi进程数如果超过 emergency_restart_threshold个，php-fpm就会优雅重启。这两个选项一般保持默认值。
      
     15）process_control_timeout = 0
     #设置子进程接受主进程复用信号的超时时间. 可用单位: s(秒), m(分), h(小时), 或者 d(天) 默认单位: s(秒). 默认值: 0.
      
     16）daemonize = yes
     #后台执行fpm,默认值为yes，如果为了调试可以改为no。在FPM中，可以使用不同的设置来运行多个进程池。 这些设置可以针对每个进程池单独设置。
      
     17）listen = 127.0.0.1:9000
     #fpm监听端口，即nginx中php处理的地址，一般默认值即可。可用格式为: 'ip:port', 'port', '/path/to/unix/socket'. 每个进程池都需要设置.
      
     18）listen.backlog = -1
     #backlog数，-1表示无限制，由操作系统决定，此行注释掉就行。 19）listen.allowed_clients = 127.0.0.1
     #允许访问FastCGI进程的IP，设置any为不限制IP，如果要设置其他主机的nginx也能访问这台FPM进程，listen处要设置成本地可被访问的IP。默认值是any。每个地址是用逗号分隔. 如果没有设置或者为空，则允许任何服务器请求连接
     listen.owner = www
     listen.group = www
     listen.mode = 0666
     
     20)#unix socket设置选项，如果使用tcp方式访问，这里注释即可。
     user = www
     group = www
     #启动进程的帐户和组
      
     21）request_terminate_timeout = 0
     #设置单个请求的超时中止时间. 该选项可能会对php.ini设置中的'max_execution_time'因为某些特殊原因没有中止运行的脚本有用. 设置为 '0' 表示 'Off'.当经常出现502错误时可以尝试更改此选项。
      
     22）request_slowlog_timeout = 10s
     #当一个请求该设置的超时时间后，就会将对应的PHP调用堆栈信息完整写入到慢日志中. 设置为 '0' 表示 'Off'
      
     23）slowlog = log/$pool.log.slow
     #慢请求的记录日志,配合request_slowlog_timeout使用
      
     24）rlimit_files = 1024
     #设置文件打开描述符的rlimit限制. 默认值: 系统定义值默认可打开句柄是1024，可使用 ulimit -n查看，ulimit -n 2048修改。
      
     25）rlimit_core = 0
     #设置核心rlimit最大限制值. 可用值: 'unlimited' 、0或者正整数. 默认值: 系统定义值.
      
     26）chroot =
     #启动时的Chroot目录. 所定义的目录需要是绝对路径. 如果没有设置, 则chroot不被使用.
      
     27）chdir =
     #设置启动目录，启动时会自动Chdir到该目录. 所定义的目录需要是绝对路径. 默认值: 当前目录，或者/目录（chroot时）
      
     28）catch_workers_output = yes
     #重定向运行过程中的stdout和stderr到主要的错误日志文件中. 如果没有设置, stdout 和 stderr 将会根据FastCGI的规则被重定向到 /dev/null . 默认值: 空.
     ```
+   二、php对子进程的三种管理方式

    ```php
    tatic:
    表示在php-fpm运行时直接fork出 pm.max_chindren个子进程
    dynamic:
    表示，运行时fork出pm.start_servers个进程，随着负载的情况，动态的调整，最多不超过pm.max_children个进程。同时，保证闲置进程数不少于pm.min_spare_servers数量，否则新的进程会被创建，当然也不是无限制的创建，最多闲置进程不超过pm.max_spare_servers数量，超过则一些闲置进程被清理。
    ondemand: 
    当有请求时，创建进程，启动不创建，最多不超过pm.max_chindren进程数，当进程闲置会在pm.process_idle_timeout秒后被及时释放。
    ```
    
+   三、重要参数的理解与设置

    ```php
    【重要一】
    request_terminate_timeout = 120
    #表示等待120秒后，结束那些没有自动结束的php脚本，以释放占用的资源。
    当PHP运行在php-fpm模式下，php.ini配置的max_execute_time是无效的，需要在php-fpm.conf中配置另外一个配置项:request_terminate_timeout;以下是官方文档的说明：
    
    
    set_time_limit()和max_execution_time只影响脚本本身执行的时间。（这两个参数在php.ini中）任何发生在诸如使用system()的系统调用，流操作，数据库操作等的脚本执行的最大时间不包括其中.
    
    
    下面4个参数的意思分别为：
    pm.max_children：静态方式下开启的php-fpm进程数量。
    pm.start_servers：动态方式下的起始php-fpm进程数量。
    pm.min_spare_servers：动态方式下的最小php-fpm进程数量。
    pm.max_spare_servers：动态方式下的最大php-fpm进程数量。
    
    如果dm设置为static，那么其实只有pm.max_children这个参数生效。系统会开启设置数量的php-fpm进程。
    如果dm设置为 dynamic，那么pm.max_children参数失效，后面3个参数生效。 
    系统会在php-fpm运行开始 的时候启动pm.start_servers个php-fpm进程，然后根据系统的需求动态在pm.min_spare_servers和 pm.max_spare_servers之间调整php-fpm进程数。
    
    比如说512M的VPS，建议pm.max_spare_servers设置为20。至于pm.min_spare_servers，则建议根据服 
    务器的负载情况来设置，比较合适的值在5~10之间。
    
    
    pm = dynamic模式非常灵活，也通常是默认的选项。但是，dynamic模式为了最大化地优化服务器响应，会造成更多内存使用，因为这种模式只会杀掉超出最大闲置进程数（pm.max_spare_servers）的闲置进程，
    比如最大闲置进程数是30，然后网站经历了一次访问高峰，高峰期时共动态开启了50个进程全部忙碌，0个闲置进程数，接着过了高峰期，可能没有一个请求，于是会有50个闲置进程，但是此时php-fpm只会杀掉20个
    子进程，始终剩下30个进程继续作为闲置进程来等待请求，这可能就是为什么过了高峰期后即便请求数大量减少服务器内存使用却也没有大量减少，也可能是为什么有些时候重启下服务器情况就会好很多，因为重启
    后，php-fpm的子进程数会变成最小闲置进程数，而不是之前的最大闲置进程数。
    
    
    第三种就是文章中提到的pm = ondemand模式，这种模式和pm = dynamic相反，把内存放在第一位，他的工作模式很简单，每个闲置进程，在持续闲置了pm.process_idle_timeout秒后就会被杀掉，有了这个模式，到了服务器低峰期内存自然会降下来，如果服务器长时间没有请求，就只会有一个php-fpm主进程，当然弊端是，
    遇到高峰期或者如果pm.process_idle_timeout的值太短的话，无法避免服务器频繁创建进程的问题，因此pm = dynamic和pm = ondemand谁更适合视实际情况而定。
    
    
    【重要二】
    pm.max_requests = 500
    设置每个子进程重生之前服务的请求数. 对于可能存在内存泄漏的第三方模块来说是非常有用的. 如果设置为 ’0′ 则一直接受请求. 等同于 PHP_FCGI_MAX_REQUESTS 环境变量. 默认值: 0.这段配置的意思是，当一个 PHP-CGI 进程处理的请求数累积到 500 个后，自动重启该进程。
    
    但是为什么要重启进程呢？
    一般在项目中，我们多多少少都会用到一些 PHP 的第三方库，这些第三方库经常存在内存泄漏问题，如果不定期重启 PHP-CGI 进程，势必造成内存使用量不断增长。因此 PHP-FPM 作为 PHP-CGI 的管理器，提供了这么一项监控功能，对请求达到指定次数的 PHP-CGI 进
    程进行重启，保证内存使用量不增长。
    【一些问题及网上解决办法】
    正是因为这个机制，在高并发的站点中，经常导致 502 错误，我猜测原因是 PHP-FPM 对从 NGINX 过来的请求队列没处理好。不过我目前用的还是 PHP 5.3.2，不知道在 PHP 5.3.3 中是否还存在这个问题。
    
    目前我们的解决方法是，把这个值尽量设置大些，尽可能减少 PHP-CGI 重新 SPAWN 的次数，同时也能提高总体性能。在我们自己实际的生产环境中发现，内存泄漏并不明显，因此我们将这个值设置得非常大（204800）。大家要根据自己的实际情况设置这个值，不能盲目
    地加大。
    ```
        
##  HELP
+   [php-fpm - 启动参数及重要配置详解](http://www.4wei.cn/archives/1002061)        
+   [php-fpm backlog参数潜在问题](http://blog.csdn.net/willas/article/details/11634825)        
+   [Adjusting child processes for PHP-FPM (Nginx)](https://myshell.co.uk/blog/2012/07/adjusting-child-processes-for-php-fpm-nginx/)     
+   [Nginx的worker_processes优化](http://blog.chinaunix.net/uid-26000296-id-3987521.html)
+   [php-fpm.conf重要参数详解](http://blog.csdn.net/sinat_22991367/article/details/73431269)
    
