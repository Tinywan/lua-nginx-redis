##  如何配置proxy_cache模块
+  [官方：ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) 
+  主`Http`模块配置文件
```bash
user  www;
worker_processes  1;

error_log  logs/error.log  error;

pid /run/nginx.pid;

worker_rlimit_nofile 204800;

events {
    worker_connections  65535;
    multi_accept on;
    use epoll;
}

http {
    lua_package_path '/usr/local/openresty/lualib/?.lua;/usr/local/openresty/nginx/conf/waf/?.lua;';
    lua_package_cpath '/usr/local/openresty/lualib/?.so;;';

    init_by_lua_file  "/usr/local/openresty/nginx/conf/waf/init.lua";
    access_by_lua_file "/usr/local/openresty/nginx/conf/waf/waf.lua";

    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"'
                      '"$upstream_cache_status"'; # nginx cache命中率统计

    charset UTF-8;
    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;

    client_header_timeout 100;
    client_body_timeout 100;
    client_max_body_size 800m;
    client_body_buffer_size 512k;
    reset_timedout_connection on;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;

    keepalive_timeout  75 20;

    proxy_connect_timeout   5;
    proxy_send_timeout      5;
    proxy_read_timeout      60;
    # 是否启用或者关闭 proxy_buffer,默认为 on
    proxy_buffering         on;
    # 设置缓存大小，默认4KB、8KB 保持与 proxy_buffers 指令中size变量相同或者更小
    proxy_buffer_size       16k;
    # proxy_buffer个数和Buffer大小（一般设置为内存页大小）
    proxy_buffers           4 64k;
    # 限制处于 BUSY 状态的 proxy_buffer 的总大小
    proxy_busy_buffers_size 128k;
    # 所有临时文件总体积大小，磁盘上的临时文件不能超过该配置
    proxy_max_temp_file_size 500MB;
    # 配置同时写入临时文件的数据量的总大小
    proxy_temp_file_write_size 128k;

    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 64k;
    gzip_http_version 1.1;
    gzip_comp_level 6;
    gzip_types text/plain application/x-javascript text/css application/javascript text/javascript image/jpeg image/gif image/png application/xml application/json;
    gzip_vary on;
    gzip_disable "MSIE [1-6].(?!.*SV1)";

    # 文件路径，临时存放代理服务器的大体积响应数据
    proxy_temp_path /home/www/data/nginx/tmp-test;
    # 设置WEB缓存区名称为 cache_one ，内存缓存空间大小为100M，一天清理一次，硬盘缓存空间大小为10G
    proxy_cache_path /home/www/data/nginx/cache-test levels=1:2 keys_zone=cache_one:100m inactive=1d max_size=10g;

    index  index.php index.html index.htm;
    include "/usr/local/openresty/nginx/conf/vhost/*.conf";
}

```
+  具体虚拟主机`Server`配置文件

    ```bash
    server {
        listen       8087;
        server_name  localhost;
    
        location / {
            #  如果后端的服务器返回500 502 503 504 执行超时等错误，将请求转发到另外一台服务器
            proxy_next_upstream     http_500 http_502 http_503 http_504 error timeout invalid_header;
            #  定义用于缓存的共享内存区域
            proxy_cache cache_one;
            #  针对不同的HTTP状态码设置不同的缓存时间
            proxy_cache_valid 200 304 1h;
            proxy_cache_valid 404 1m;
            # WEB缓存的Key值域名、URI、参数组成
            proxy_cache_key $host$uri$is_args$args;
            proxy_set_header        Host            $host;
            proxy_set_header        X-Real-IP       $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            # 显示缓存的状态
            add_header  Nginx-Cache "$upstream_cache_status";
            # 可以禁用一个或多个响应头字段的处理 [Nginx不缓存,可以添加以下语句] 
            proxy_ignore_headers X-Accel-Expires Expires Cache-Control Set-Cookie;
            proxy_pass http://www.tinywan.com;
            expires 1d;
        }
    }
    ```
+   `$upstream_cache_status` 包含以下几种状态 

    ```bash
    ·MISS 未命中，请求被传送到后端
    ·HIT 缓存命中
    ·EXPIRED 缓存已经过期请求被传送到后端
    ·UPDATING 正在更新缓存，将使用旧的应答
    ·STALE 后端将得到过期的应答
    ```
    
+   `nginx cache`命中率统计 

    ```bash
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"'
                      '"$upstream_cache_status"';
    ```
    > 命中率统计方法：用HIT的数量除以日志总量得出缓存命中率
    > `awk '{if($NF==""HIT"") hit++} END {printf "%.2f%",hit/NR}' access.log`
    
+   通过crontab脚本将每天的命中率统计到一个日志中，以备查看

    ```bash
    #!/bin/bash
    LOG_FILE='/usr/local/nginx/logs/access.log.1'
    LAST_DAY=$(date +%F -d "-1 day")
    awk '{if($NF==""HIT"") hit++} END {printf "'$LAST_DAY': %d %d %.2f%n", hit,NR,hit/NR}' $LOG_FILE
    ```
+   帮助文档
    +   [Nginx proxy_cache 缓存配置](http://blog.csdn.net/dengjiexian123/article/details/53386586)    
    +   [Nginx Proxy Cache原理和最佳实践](http://www.jianshu.com/p/625c2b15dad5)    
    +   [nginx缓存设置proxy_cache(PHP)](https://www.cnblogs.com/zlingh/p/5879988.html)    