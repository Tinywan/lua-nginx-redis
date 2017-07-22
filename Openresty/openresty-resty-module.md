+   [Lua require 绝对和相对路径(已经解决)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-common-package/lua-require.md)
+   [luajit 执行文件默认安装路径](#Openresty_web_knowledge) 
+   [lua-resty-redis 扩展](#Openresty_resty-redis) 
+   [lua-resty-websocket 扩展](#Openresty_resty-websocket) 
+   [lua-cjson 扩展](#Openresty_resty-cjson) 
+   [lua-dkjson 扩展](https://github.com/Tinywan/lua_project_v0.01) 
+   [Lua 权限验证](#Openresty_resty-access) 
+   [lua-resty-string 扩展](#Openresty_resty-string) 
+   [lua-resty-http 扩展 ](#Openresty_resty-http) 
+   [lua-resty-mysql 扩展](#Openresty_resty-mysql) 
+   [lua-resty-shell 扩展](http://www.cnblogs.com/tinywan/p/6809879.html) 
+   [lua-resty-template 扩展](https://github.com/Tinywan/lua_project_v0.01) 
+   [lua-resty-template 扩展](https://github.com/Tinywan/lua_project_v0.01) 
+   [openresty扫描代码全局变量](#Openresty_all-var) 
+   [ngx Lua APi 方法和常量](#Openresty_http_status_constants)   
    +   ngx_lua 核心常量 
    +   ngx_lua 方法 
    +   Lua HTTP状态常量
    +   错误日志级别常量
    +   API中的常用方法
+   [ngx Lua APi 介绍使用](#Openresty_ngx_api_used) 
+   [连接数据库](#Openresty_connent_redis) 
+   [OpenResty缓存](#Openresty_connent_cache) 
+   [lua-resty-upstream-healthcheck 使用](#Openresty_lua_resty_upstream_healthcheck) 
+   [Openresty和Nginx_RTMP 模块共存问题](#Openresty_rtmp_share) 
+   [Openresty配置RTMP模块的多worker直播流](#Openresty_rtmp_more_worker) 
+   [Openresty配置RTMP模块的推流地址鉴权实例](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Openresty_rtmp_obs_push.md) 
+   [Ngx_lua 写入Redis数据，通过CURL请求](#Ngx_lua_write_Redis) 
+   [Nginx编写的Lua接口使用URL过期和签名验证机制过滤非法访问接口](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Openresty_rtmp_obs_push_auth.md) 
+   [Nginx查看并发连接数](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/nginx_status.md)  
#### <a name="Openresty_resty-redis"/> lua-resty-redis 扩展 (是openresty下操作redis的模块)
+ 代码引入：`lua_package_path "/opt/openresty/nginx/lua/lua-resty-redis/lib/?.lua;;";`   
+ Lua脚本实现一个CDN的反向代理功能(智能查找CDN节点)(测试成功,可上线)    
    + nginx.conf 配置信息
    ```Lua
    http {
        lua_package_path "/opt/openresty/nginx/lua/lua-resty-redis/lib/?.lua;;";
        server {
            listen 80;
            server_name  localhost;
            location ~ \/.+\/.+\.(m3u8|ts) {
                if ($uri ~ \/([a-zA-Z0-9]+)\/([a-zA-Z0-9]+)(|-).*\.(m3u8|ts)) {
                        set $app_name $1;
                        set $a $2;
                }
                set $stream_id "";
                default_type 'text/html';
                rewrite_by_lua_file  /opt/openresty/nginx/lua/proxy_pass_cdn.lua;
                proxy_connect_timeout       10;
                proxy_send_timeout          30;
                proxy_read_timeout          30;
                proxy_pass                  $stream_id;
            }

        }
    }
    ```
    + [Lua脚本proxy_pass_cdn.lua](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-redis/proxy_pass_cdn.lua)
    + [lua-nginx-module 贡献代码](https://github.com/openresty/lua-nginx-module/issues/275)
        
+ Lua脚本结合 Nginx+Lua+Local Redis+Mysql服务器缓存  
    + Nginx+Lua+Local Redis+Mysql集群架构   
    + ![Nginx+Lua+Local Redis+Mysql](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Nginx+Lua+Local_Redis+Mysql.png)       
    + [Lua脚本Nginx+Lua+Redis+Mysql.lua](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-redis/Nginx+Lua+Redis+Mysql.lua)   
    + [Nginx.conf配置文件Nginx+Lua+Redis+Mysql.conf](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-redis/Nginx+Lua+Redis+Mysql.conf)   
    + [HELP](http://jinnianshilongnian.iteye.com/blog/2188113)
        
    + Lua脚本结合 Redis 统计直播流播放次数、链接次数等等信息
        + nginx.conf 
            ```Lua
            server {            # 配置虚拟服务器80
                 listen 80;
                 server_name  127.0.0.1:8088;
                 location ~* /live/(\w+)/ {
                        set $total_numbers "";
                        set $stream_name $1;
                        lua_code_cache off;
                        rewrite_by_lua_file /opt/openresty/nginx/conf/Lua/total_numbers.lua;
                        proxy_pass                  http://127.0.0.1:8088;
                  }
            }      
             ```
        + 代理服务器
            ```Lua 
             server {            # 配置虚拟服务器8088
                 listen 8088;
                 server_name  127.0.0.1:8088;
                 location /live {
                    add_header  Cache-Control no-cache;
                    add_header 'Access-Control-Allow-Origin' '*' always;
                    add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
                    add_header 'Access-Control-Allow-Headers' 'Range';
                    types{
                        application/dash+xml mpd;
                        application/vnd.apple.mpegurl m3u8;
                        video/mp2t ts;
                    }
                 alias /home/tinywan/HLS/live/;
                }
              }
    
            ```
        + CURL请求地址：`http://192.168.18.143/live/tinywan123/index.m3u8`
        + [Lua 脚本](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-redis/Hls-Line-Number-Total.lua)

#### <a name="Openresty_resty-websocket"/> lua-resty-websocket 扩展
+ 代码引入：`lua_package_path "/opt/openresty/nginx/lua/lua-resty-websocket/lib/?.lua;;";`
+ **Lua脚本实现一个websocket连接(测试成功,可上线)**
    + nginx.conf 配置信息
    ```Lua
    http {
            lua_package_path "/opt/openresty/nginx/lua/lua-resty-websocket/lib/?.lua;;";
            server {
                listen 80 so_keepalive=2s:2s:8;  #为了防止半开TCP连接，最好在Nginx监听配置指令中启用TCP keepalive：
                server_name  localhost;
                location /ws {
                    lua_socket_log_errors off;
                    lua_check_client_abort on;
                    lua_code_cache off; # 建议测试的时候最好关闭缓存
                    content_by_lua_file /opt/openresty/nginx/conf/Lua/websocket.lua;
                }
            }
    }
    ```
    + [WebSockets服务器Lua脚本websocket.lua](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-websocket/websocket.lua)
    + [websockets.html客户端代码,代码路径：/usr/local/openresty/nginx/html](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-websocket/websocket.html)
    + 然后打开启用了WebSocket支持的浏览器，然后打开以下url：   
    ![websockt-lua](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/websocket_lua01.png) 
#### <a name="Openresty_resty-cjson"/> lua-cjson 扩展   
+ 基本用法
    + nginx.conf
        ```Lua
        location /cjson {
            content_by_lua_block {
                local cjson = require "cjson"
                local json = cjson.encode({
                        foo = "bar",
                        some_object = {},
                        some_array = cjson.empty_array
                })
                ngx.say(json)
            }
        }
        ```  
    + curl 请求
        ```Bash
        root@tinywan:/opt/openresty/nginx/conf# curl http://127.0.0.1/cjson
        {"some_object":{"tel":13669313112,"age":24},"name":"tinywan","some_array":[]}
        ```       
+ [lua对象到字符串、字符串到lua对象](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-cjson/cjson-str-obj.lua) 
#### <a name="Openresty_resty-session"/> lua-resty-session 扩展  
+ OpenResty 引用第三方 resty 库非常简单，只需要将相应的文件拷贝到 resty 目录下即可
+ 我服务器OpenResty 的 resty 路径：`/opt/openresty/lualib/resty`
+ 下载第三方 resty 库：git clone lua-resty-session 文件路径以及内容：
    ```Bash 
    tinywan@tinywan:/opt/openresty/nginx/lua/lua-resty-session/lib/resty$ ls
    session  session.lua
    ```
+ 特别注意：这里拷贝的时候要要把session文件和session.lua 文件同时吧、拷贝过去，否则会报错误：
    ```Bash 
    /opt/openresty/lualib/resty/session.lua:34: in function 'prequire'
    /opt/openresty/lualib/resty/session.lua:211: in function 'new'
    /opt/openresty/lualib/resty/session.lua:257: in function 'open'
    /opt/openresty/lualib/resty/session.lua:320: in function 'start'
    ```
+  拷贝完毕后`/opt/openresty/lualib/resty` OpenResty 引用第三方 resty 的所有库文件
  ```Bash 
  tinywan@tinywan:/opt/openresty/lualib/resty$ ls
  aes.lua  core.lua  http_headers.lua  lock.lua  lrucache.lua  memcached.lua  random.lua  session      sha1.lua    sha256.lua  sha512.lua  string.lua  upstream
  core     dns       http.lua          lrucache  md5.lua       mysql.lua      redis.lua   session.lua  sha224.lua  sha384.lua  sha.lua     upload.lua  websocket
  ```
+ 基本用法
  ```Lua 
   location /start {
      content_by_lua_block {
          local session = require "resty.session".start()
          session.data.name = "OpenResty Fan Tinywan"
          session:save()
          ngx.say("<html><body>Session started. ",
                  "<a href=/test>Check if it is working</a>!</body></html>")
          ngx.say(session.data.name,"Anonymous")
      }
   }
  ```
+ curl 请求
    ```Bash
    tinywan@tinywan:/opt/openresty/nginx/conf$ curl http://192.168.18.143/start
    <html><body>Session started. <a href=/test>Check if it is working</a>!</body></html>
    OpenResty Fan Tinywan Anonymous
    ```   
#### <a name="Openresty_ngx_api_auth"/> Lua 权限验证
+ Lua 一个HLS的简单地址访问权限验证
    + Nginx.conf 配置
        ```Lua 
        location ^~ /live/ {
            add_header Cache-Control no-cache;
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Credentials' 'true';
            add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
            add_header 'Access-Control-Allow-Headers' 'Range';

            types{
                application/dash+xml mpd;
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            if ( $uri ~ \.m3u8 ) {
                lua_code_cache off;
                access_by_lua_file /opt/openresty/nginx/lua/access.lua;
            }
            root /home/tinywan/HLS;
         }
        ```    
    + access.lua 文件内容
         ```Lua 
         if ngx.req.get_uri_args()["wsSecret"] ~= "e65e6a01cf26523e206d5bb0e2a8a95a" then  
            return ngx.exit(403)  
         end
         ```                    
#### <a name="Openresty_resty-string"/> lua-resty-string 扩展   
+ MD5加密的简单基本用法 md5.lua
    ```Lua
    local resty_md5 = require "resty.md5"
    local md5 = resty_md5:new()
    if not md5 then
        ngx.say("failed to create md5 object")
        return
    end
    local ok = md5:update("hello")
    if not ok then
        ngx.say("failed to add data")
        return
    end
    local digest = md5:final()
    -- ngx.say("md5",digest)                ---注意:这样直接输出是乱码
    local str = require "resty.string"
    ngx.say("md5: ", str.to_hex(digest))    ---注意:必须通过字符串转码方可打印输出
        -- yield "md5: 5d41402abc4b2a76b9719d911017c592"
    ```  
#### <a name="Openresty_resty-http"/> lua-resty-http 扩展 （ngx_lua的HTTP客户端cosocket驱动程序）
+ [简单测试：lua-http-test.lua](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-http/lua-http-test.lua)         
#### <a name="Openresty_resty-mysql"/> lua-resty-mysql 扩展 
+ [简单测试：lua-msyql-test.lua](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-mysql/lua-msyql-test.lua)          
#### <a name="Openresty_resty-srcache"/> srcache-nginx-module 扩展 ([nginx下的一个缓存模块](https://github.com/openresty/srcache-nginx-module))
+ [openresty–redis–srcache缓存的应用](http://www.xtgxiso.com/openresty-redis-srcache-nginx-module%e7%bc%93%e5%ad%98%e7%9a%84%e5%ba%94%e7%94%a8/)
#### <a name="Openresty_ngx_adddd"/> openresty扫描代码全局变量
+   在OpenResty中需要避免全局变量的使用，为此春哥写了一个perl工具，可以扫描openresty lua代码的全局变量
+   [https://github.com/openresty/openresty-devel-utils/blob/master/lua-releng](https://github.com/openresty/openresty-devel-utils/blob/master/lua-releng) 
+   用法相当简单  
    1. 将代码保存成lua-releng文件
    2.  更改lua-releng的权限，chmod 777 lua-releng
    3.  假设有一个源码文件为test.lua
    4.  执行./lua-releng test.lua，则会扫描test.lua文件的全局变量，并在屏幕打印结果