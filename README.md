 
![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Nginx-Phase.png)
## 开发过程记录

+   [解决 Visual Studio Code 向github提交代码不用输入帐号密码](#githubpush)
+   phase的意义：就是几个MR的一个集合，不定数目的MR job视为一个phase。一个请求经过nginx处理的过程中，会经过一系列的阶段（phases）

## <a name="index"/>目录
+ [**NGINX 所有 Modules**](https://www.nginx.com/resources/wiki/modules/)
+ [**agentzh的Nginx教程（版本2016.07.21）**](https://openresty.org/download/agentzh-nginx-tutorials-en.html#00-foreword01)
+ [**Nginx的11个Phases**](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-phases.md)
+ [**Nginx配置Rtmp支持Hls的直播和点播功能**](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/HLS-live-vod.md)
+ [**Nginx 陷阱和常见错误**](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-1-config.md)
+ [**PHP7中php.ini/php-fpm/www.conf的配置,Nginx和PHP-FPM的开机自动启动脚本**](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/PHP/PHP-FPM/config.md)
+ [**shell脚本实现分日志级别记录日志**](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Shell_Log.sh)
+ **Redis基础知识**
    + [Redis 简易安装教程](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-install.md)
+ **Lua网络编程基础知识**
    * Lua基础
    * Lua进阶
+ **Nginx开发从入门到精通**
    + [Nginx 编译安装以及参数详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)
    + NGINX变量详解
        - [x] [nginx变量使用方法详解笔记(1)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/notes-1.md)
        - [x] [nginx变量使用方法详解笔记(2)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/notes-2.md)
        - [ ] [nginx变量使用方法详解笔记(3)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)
        - [ ] [nginx变量使用方法详解笔记(4)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)    
        - [ ] [nginx变量使用方法详解笔记(5)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)
    + Nginx指令执行顺序
        - [x] [Nginx指令执行命令（01）](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/command-order-01.md)
        - [x] [nginx变量使用方法详解笔记(2)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/command-order-02.md)
        - [ ] [nginx变量使用方法详解笔记(3)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/command-order-03.md)
        - [ ] [nginx变量使用方法详解笔记(4)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/command-order-04.md)    
        - [ ] [nginx变量使用方法详解笔记(5)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/command-order-05.md)   
+ **Nginx高性能WEB服务器详解**
    + 第一章   初探
        - [x] [Nginx的历史](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)
    + 第二章   安装部署
        - [X] [基于域名、IP的虚拟主机配置](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-all-config.md)
        - [X] [完整、标准配置实际示列](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-basic-config.md)
        - [X] [日志文件配置与切割](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-log-cut.md)
        - [ ] C213
    * 第三章   架构初探
        - [ ] 测试一
    * 第四章   高级配置
        - [x] [Perl 正则表达式参考](http://www.runoob.com/perl/perl-regular-expressions.html)
        - [x] 正则表达式 (Regular expression) 匹配location
            - [1]   `location ~* \.(gif|jpg|jpeg)$ { }`：匹配所有以 gif,jpg或jpeg 结尾的请求
            - [2]   `location ~ /documents/Abc { }`：匹配任何以 /documents/ 开头的地址，匹配符合以后，还要继续往下搜索
            - [3] **目录匹配：**
                1. 可以匹配静态文件目录`(static/lib)`
                1. HLS直播目录`(/home/HLS/stream123/index.m3u8)`   
                1. HLS/MP4/FLV点播视频目录`(/home/HLS/stream123.m3u8)`   
                1. 匹配URL地址：`http://127.0.0.1/live/stream123/index.m3u8` 
                1. nginx.conf 配置信息 
                    ```
                    location ^~ /live/ {
                                    root /home/tinywan/HLS/;
                    }
                    ```

            - **[4] 后缀匹配：**
                1. 可以后缀文件名`gif|jpg|jpeg|png|css|js|ico|m3u8|ts`
                1. TS 文件匹配`http://127.0.0.1/live/stream123/11.ts`
                1. M3U8 文件匹配`http://127.0.0.1/live/stream123/index.m3u8`
                1. 匹配URL地址：`http://127.0.0.1/hls/123.m3u8` 
                1. nginx.conf 配置信息  
                    ```
                    location ~* \.(gif|jpg|jpeg|png|css|js|ico|m3u8|ts)$ {
                            root /home/tinywan/HLS/;
                    }
                    ```    

        - [x] [nginx配置location总结及rewrite规则写法](http://seanlook.com/2015/05/17/nginx-location-rewrite/)
    * 第五章   Gzip压缩
        - [ ] 测试一
    * 第六章   Rewrite 功能
        - [x] Rewrite 常用全局变量
            > 请求案例： `curl -G -d "name=Tinywan&age=24" http://127.0.0.1/rewrite_var/1192/index.m3u8`    

            | 变量 | 值          |描述 |
            | --------- | ----------- |----------- |
            | $args      | name=Tinywan&age=24 |存放URL 请求的指令 |
            | $content_length      | 0 | 请求头中的Content-length字段|
            | $content_type      | 0 |请求头中的Content-Type字段 |
            | $document_root      | /opt/openresty/nginx/html | 当前请求在root指令中指定的值 |
            | $document_uri      | /rewrite_var/1192/index.m3u8 | 与$uri相同 |
            | $host      | 127.0.0.1 |请求主机头字段，否则为服务器名称 |
            | $http_user_agent      | curl/7.47.0 | 客户端agent信息|
            | $http_cookie      | 0 | COOKIE变量的值|
            | $limit_rate      | 0 | 限制连接速率|
            | $request_body_file      | null | 客户端请求主体信息的临时文件名|
            | $request_method      | GET | 客户端请求的动作，通常为GET或POST |
            | $remote_addr      |  127.0.0.1 |客户端的IP地址 |
            | $remote_port      | 33516 |客户端端口|
            | $remote_user      | 0 | 已经经过Auth Basic Module验证的用户名|
            | $request_filename      |  /opt/openresty/nginx/html/rewrite_var/1192/index.m3u8 |当前请求的文件路径 |
            | $request_uri      |  /rewrite_var/1192/index.m3u8?name=Tinywan&age=24  |包含请求参数的原始URI，不包含主机名 |
            | $query_string      |  name=Tinywan&age=24   | 与$args相同|
            | $scheme      |  http |HTTP方法（如http，https |
            | $server_protocol      |  HTTP/1.1  |请求使用的协议，通常是HTTP/1.0或HTTP/1.1 |
            | $server_addr      |  127.0.0.1  |服务器地址 |
            | $server_name      | localhost  | 服务器名称|
            | $server_port      | 80  |请求到达服务器的端口号 |
            | $uri      | /rewrite_var/1192/index.m3u8  | 不带请求参数的当前URI|

        - [x] Rewrite 正则匹配` uri `参数接收
            > 请求案例：`curl http://192.168.18.143/live/tinywan123/index.m3u8`
            > Nginx.conf配置文件   
            ```
            location ~* ^/live/(\w+)/(\D+)\.(m3u8|ts)$ {
                set $num $2;
                set $arg1 $1;
                echo "args === ${arg1}";
                echo "1==$1 2==$2 3==$3";
                echo "Total_numbser :: $num";
                echo "URI $uri";
            }

            ```
            > 输出结果
            ```
               args === tinywan123
               $1==tinywan123 $2==index $3==m3u8
               Total_numbser :: index
               URI /live/tinywan123/index.m3u8
               Total_numbser :: 
            ``` 
            > $1 为正则匹配多个英文字母或数字的字符串 `(\w+)`   
              $2 为正则匹配多个非数字 `(\D+)`    
              $3 为正则匹配的第一个值 `(m3u8|ts)`  
              `.` 需要用转义字符转义`\.`    
    * 第七章   代理服务
        - [ ] [正向代理和反向代理的概念](#title)
        - [ ] [正向代理服务](#title)
        - [ ] [反向代理的服务](#title)
        - [x] [Nginx日志服务](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-Log.md)
        * 负载均衡
            * HTTP负载均衡
                - [x] [简单的负载平衡](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-7-Proxy-1.md)
                - [x] [负载均衡五个配置实例](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-7-Proxy.md)
            * TCP负载均衡   
                - [ ] [负载均衡](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-8-tcp-Proxy.md)      
    * 第八章   缓存机制
        - [ ] 测试一
    * 第九章   Nginx初探1
        - [ ] 测试一
    * 第十章   Nginx初探1
        - [ ] 测试一     
+ Lua脚本开发Nginx
    * 普通文本
    * 单行文本2
* [Lua脚本运行Redis](#line)

* [PHP脚本运行Redis](#line)
    * [PHP 脚本执行一个Redis 订阅功能，用于监听键过期事件，返回一个回调，API接受改事件](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis-PHP/Php-Run-Redis-psubscribe/nohupRedisNotify.php)
    * 单行文本1

+ **openresty 学习**
    +   [默认配置信息](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/default-config.md)
    +   开发入门
        + 参数总结
          + Lua脚本接受Nginx变量：
            > [1] 间接获取：`var = ngx.var `，如接受Nginx的变量` $a = 9`,则`lua_a = ngx.var.a --lua_a = 9`   
            > [2] 直接获取：`var = ngx.var `，如接受Nginx的location的第二个变量890,` http://127.0.0.1/lua_request/123/890 `,则`lua_2 = ngx.var[2] --lua_2 = 890`    

          + Lua 脚本接受 Nginx 头部 header：
            > [1] 返回一个包含所有当前请求标头的Lua表：`local headers = ngx.req.get_headers()`      
            > [2] 获取单个Host：`headers["Host"] 或者 ngx.req.get_headers()["Host"] `     
            > [3] 获取单个user-agent：
            >>[01]`headers["user-agent"]`      
            >>[02]`headers.user_agent `  
            >>[03]`ngx.req.get_headers()['user-agent']  `     

          + Lua 脚本 Get 获取请求uri参数
            > linux curl Get方式提交数据语法：`curl -G -d "name=value&name2=value2" https://github.com/Tinywan `  
            > 返回一个包含所有当前请求URL查询参数的Lua表：`local get_args = ngx.req.get_uri_args()`   
            > 请求案例：`curl -G -d "name=Tinywan&age=24" http://127.0.0.1/lua_request/123/789`      
            > Lua Get 方式获取提交的name参数的值：`get_args['name'] 或者 ngx.req.get_uri_args()['name']`   
            >>[01]`get_args['name']`      
            >>[02]`ngx.req.get_uri_args()['name']`    

          + Lua 脚本 Post 获取请求uri参数
            > linux curl Post方式提交数据语法：
            >> [01] `curl -d "name=value&name2=value2" https://github.com/Tinywan `     
            >> [02] `curl -d a=b&c=d&txt@/tmp/txt https://github.com/Tinywan `     

            > 返回一个包含所有当前请求URL查询参数的Lua表：`local post_args = ngx.req.get_post_args()`      
            > 请求案例：`curl -G -d "name=Tinywan&age=24" http://127.0.0.1/lua_request/123/789`      
            > Lua Post 方式获取提交的name参数的值：
            >>[01]`post_args['name']`   
            >>[02]`ngx.req.get_post_args()['name']` 

          + Lua 脚本请求的http协议版本：`ngx.req.http_version()`
          + Lua 脚本请求方法：`ngx.req.get_method()`
          + Lua 脚本原始的请求头内容：`ngx.req.raw_header()`
          + Lua 脚本请求的body内容体：`ngx.req.get_body_data()`

        + [接收请求:获取如请求参数、请求头、Body体等信息]()
        + [接收请求:输出响应需要进行响应状态码、响应头和响应内容体的输出]()

    +   luajit 执行文件默认安装路径：`/opt/openresty/luajit/bin/luajit`,这样我们直接可以这样运行一个Lua文件：`luajit test.lua `
        + luajit 运行测试案例：   
        ```
        tinywan@tinywan:~/Lua$ luajit test.lua    
        The man name is Tinywan            
        The man name is Phalcon
        ```
    + lua-resty-redis 扩展
        + 代码引入：`lua_package_path "/opt/openresty/nginx/lua/lua-resty-redis/lib/?.lua;;";`
        + **Lua脚本实现一个CDN的反向代理功能(智能查找CDN节点)(测试成功,可上线)**
            + nginx.conf 配置信息
            ```
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
        + **Lua脚本结合 Nginx+Lua+Local Redis+Mysql服务器缓存**
            + Nginx+Lua+Local Redis+Mysql集群架构   
            ![Nginx+Lua+Local Redis+Mysql](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Nginx+Lua+Local_Redis+Mysql.png)    
            + [Lua脚本Nginx+Lua+Redis+Mysql.lua](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-redis/Nginx+Lua+Redis+Mysql.lua)
            + [Nginx.conf配置文件Nginx+Lua+Redis+Mysql.conf](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-redis/Nginx+Lua+Redis+Mysql.conf)
            + [HELP](http://jinnianshilongnian.iteye.com/blog/2188113)
        + **Lua脚本结合 Redis 统计直播流播放次数、链接次数等等信息**
            + nginx.conf 
            ```
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
            ``` 
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

    +  lua-resty-websocket 扩展
        + 代码引入：`lua_package_path "/opt/openresty/nginx/lua/lua-resty-websocket/lib/?.lua;;";`
        + **Lua脚本实现一个websocket连接(测试成功,可上线)**
            + nginx.conf 配置信息
            ```
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
    +  lua-cjson 扩展   
        + 基本用法
            + nginx.conf
            ```
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
            ```
            root@tinywan:/opt/openresty/nginx/conf# curl http://127.0.0.1/cjson
            {"some_object":{"tel":13669313112,"age":24},"name":"tinywan","some_array":[]}
            ```       
        + [lua对象到字符串、字符串到lua对象](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-cjson/cjson-str-obj.lua)            

## Redis、Lua、Nginx一起工作事迹
* 解决一个set_by_lua $sum 命令受上下文限制的解决思路，已完美解决
    - [x] [API disabled in the context of set_by_lua](https://github.com/openresty/lua-nginx-module/issues/275)
* 解决2
* 解决3    

## Redis执行Lua脚本示例
### Lua 基本语法
---
*   Hello, Lua!

    > 我们的第一个Redis Lua 脚本仅仅返回一个字符串，而不会去与redis 以任何有意义的方式交互   

    ```
    local msg = "Hello, world!"
    return msg
    ```

    > 这是非常简单的，第一行代码定义了一个本地变量msg存储我们的信息， 第二行代码表示 从redis 服务端返回msg的值给客户端。 保存这个文件到Hello.lua，像这样去运行: 
    
    ```
    www@iZ239kcyg8rZ:~/lua$ redis-cli EVAL "$(cat Hello.lua)" 0
    "Hello, world!"
    ```

    > 运行这段代码会打印"Hello,world!", EVAL在第一个参数是我们的lua脚本， 这我们用cat命令从文件中读取我们的脚本内容。第二个参数是这个脚本需要访问的Redis 的键的数字号。我们简单的 “Hello Script" 不会访问任何键，所以我们使用0
    
### Lua知识
---
##### 基本语法
* redis.call() 与 redis.pcall()的区别

    * 他们唯一的区别是当redis命令执行结果返回错误时
    * redis.call()将返回给调用者一个错误.
    * redis.pcall()会将捕获的错误以Lua表的形式返回.
    *  redis.call() 和 redis.pcall() 两个函数的参数可以是任意的 Redis 命令

* Lua网络编程

### Redis执行Lua脚本基本用法
---
*  基本语法   
    ```
    EVAL script numkeys key [key ...] arg [arg ...]
    ```
*  通过lua脚本获取指定的key的List中的所有数据 
    
    ```
        local key=KEYS[1]
        local list=redis.call("lrange",key,0,-1);
        return list;
    ```
*  根据外面传过来的IDList 做“集合去重”的lua脚本逻辑：     
     ```
         local result={};
         local myperson=KEYS[1];
         local nums=ARGV[1];
         
         local myresult =redis.call("hkeys",myperson);
         
         for i,v in ipairs(myresult) do
            local hval= redis.call("hget",myperson,v);
            redis.log(redis.LOG_WARNING,hval);
            if(tonumber(hval)<tonumber(nums)) then
               table.insert(result,1,v);
            end
         end
         
         return  result;
     ```
### <a name="githubpush"/> 13.解决 Visual Studio Code 向github提交代码不用输入帐号密码    
+   在命令行输入以下命令
    ```
    git config --global credential.helper store
    ```

    > 这一步会在用户目录下的.gitconfig文件最后添加:

    ```
    [credential]
    helper = store
    ```
+   push 代码

    > push你的代码 (git push), 这时会让你输入用户名和密码, 这一步输入的用户名密码会被记住, 下次再push代码时就不用输入用户名密码!这一步会在用户目录下生成文件.git-credential记录用户名密码的信息。

+   Markdown 的超级链接技术

    > 【1】需要链接的地址：

        ```
        [解决向github提交代码不用输入帐号密码](#githubpush)  
        ```

    > 【2】要链接到的地方：

        ``` 
        <a name="githubpush"/> 解决向github提交代码不用输入帐号密码
        ```
        
    > 通过【1】和【2】可以很完美的实现一个连接哦！

### Lua 脚本
+   [1] Lua 实现简单封装
    >man.lua   

    ```
        local _name = "Tinywan"
        local man = {}

        function man.GetName()
            return _name
        end

        function man.SetName(name)
            _name = name    
        end

        return man 
    ```

    >测试封装,test.lua   

    ```
        local man = require('man')
        print("The man name is "..man.GetName())
        man.SetName("Phalcon")
        print("The man name is "..man.GetName())
    ```

### Linux 命令
+ find 命令
    + 查找超出7天前的flv的文件进行删除：
        + `find ./ -mindepth 1 -maxdepth 3 -type f -name "*.flv" -mmin +10080 | xargs rm -rf `
        + `-type f` 按类型查找
        + `-mmin +10080` 7天之前的文件
        + xargs与-exec功能类似,` find ~ -type f | xargs ls -l `
        + -r 就是向下递归，不管有多少级目录，一并删除
        + -f 就是直接强行删除，不作任何提示的意思
    + 查找当前目录下.p文件中，最近30分钟内修改过的文件：
        + `find . -name '*.p' -type f -mmin -30`   
    + 查找当前目录下.phtml文件中，最近30分钟内修改过的文件，的详细情况加上ls：
        + `find . -name '*.phtml' -type f -mmin -30 -ls`  
    + 查找当前目录下，最近1天内修改过的常规文件：`find . -type f -mtime -1`  
    + 查找当前目录下，最近1天前（2天内）修改过的常规文件：`find . -type f -mtime +1`            



