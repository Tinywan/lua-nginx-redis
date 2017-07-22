#### <a name="Openresty_lua_resty_upstream_healthcheck"/> lua-resty-upstream-healthcheck使用 
+   health.txt 在每个upstream 服务器组的root 目录下创建这个文件，目录结构如下所示
    ```javascript
    ├── html
    │   ├── 50x.html
    │   ├── index.html
    │   ├── websocket001.html
    │   └── websocket02.html
    ├── html81
    │   ├── 50x.html
    │   ├── health.txt
    │   └── index.html
    ├── html82
    │   ├── 50x.html
    │   ├── health.txt
    │   └── index.html
    ├── html83
    │   ├── 50x.html
    │   ├── health.txt
    │   └── index.html
    ├── html84
    │   ├── 50x.html
    │   └── index.html
    ```
+   nginx.conf
    ```Lua
    worker_processes  8;
    
    error_log  logs/error.log;
    pid        logs/nginx.pid;
    
    events {
        use epoll;
        worker_connections  1024;
    }
    
    http {
        include       mime.types;
        default_type  text/html;
        #lua模块路径，其中”;;”表示默认搜索路径，默认到/usr/servers/nginx下找  
        lua_package_path "/home/tinywan/Openresty_Protect/First_Protect/lualib/?.lua;;";  #lua 模块  
        lua_package_cpath "/home/tinywan/Openresty_Protect/First_Protect/lualib/?.so;;";  #c模块  
        include /home/tinywan/Openresty_Protect/First_Protect/nginx_first.conf;
    }
    
    ```
+ nginx_first.conf
    ```Lua
    upstream tomcat {
        server 127.0.0.1:8081;
        server 127.0.0.1:8082;
        server 127.0.0.1:8083;
        server 127.0.0.1:8084 backup;
    }
    
    lua_shared_dict healthcheck 1m;
    
    lua_socket_log_errors off;
    
    init_worker_by_lua_block {
        local hc = require "resty.upstream.healthcheck"
        local ok, err = hc.spawn_checker{
                shm = "healthcheck",  -- defined by "lua_shared_dict"
                upstream = "tomcat", -- defined by "upstream"
                type = "http",
    
                http_req = "GET /health.txt HTTP/1.0\r\nHost: tomcat\r\n\r\n",
                        -- raw HTTP request for checking
    
                interval = 2000,  -- run the check cycle every 2 sec
                timeout = 1000,   -- 1 sec is the timeout for network operations
                fall = 3,  -- # of successive failures before turning a peer down
                rise = 2,  -- # of successive successes before turning a peer up
                valid_statuses = {200, 302},  -- a list valid HTTP status code
                concurrency = 10,  -- concurrency level for test requests
            }
    }
    
    server {
        listen       80;
        server_name  localhost;
        
        location / {
            proxy_pass          http://tomcat;
         }
    
        location /server/status {
            access_log off;
            allow 127.0.0.1;

            default_type text/plain;
            content_by_lua_block {
                local hc = require "resty.upstream.healthcheck"
                ngx.say("Nginx Worker PID: ", ngx.worker.pid())
                ngx.print(hc.status_page())
            }
        }
    }
    
    server {
        listen       8081;
        server_name  localhost;
    
        location / {
            root   html81;
            index  index.html index.htm;
        }
    
        location /health_status {
    
        }
    }
    
    server {
        listen       8082;
        server_name  localhost;
    
        location / {
            root   html82;
            index  index.html index.htm;
        }
    
        location /health_status {
    
        }
    }
    
    server {
        listen       8083;
        server_name  localhost;
    
        location / {
            root   html83;
            index  index.html index.htm;
        }
    
        location /health_status {
    
        }
    }
    
    server {
        listen       8084;
        server_name  localhost;
    
        location / {
            root   html84;
            index  index.html index.htm;
        }
    }
    
    ```
+   状态查看,通过访问:`http://127.0.0.1/server/status`
    ![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Openresty_lua-resty-upstream-healthcheck.png)