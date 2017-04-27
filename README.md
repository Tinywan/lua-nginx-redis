 
![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Nginx-Phase.png)
## 开发过程记录
+   [解决 Visual Studio Code 向github提交代码不用输入帐号密码](#githubpush)
+   phase的意义：就是几个MR的一个集合，不定数目的MR job视为一个phase。一个请求经过nginx处理的过程中，会经过一系列的阶段（phases）
## <a name="index"/>目录
+   [Nginx基础知识](#Nginx_base_knowledge) 
+   [Linux基础知识](#Linux_base_knowledge) 
+   [Redis基础知识](#Redis_base_knowledge) 
+   [PHP脚本](#PHP_base_knowledge) 
+   [Shell脚本](#Shell_base_knowledge) 
+   [Lua基础知识](#Lua_base_knowledge) 
+   [流媒体视频直播、点播](#live_base_knowledge) 
+   [Nginx高性能WEB服务器详解](#Nginx_Web_knowledge) 
    +   [第一章   初探 ](#Nginx_Web1_knowledge) 
    +   [第二章   安装部署](#Nginx_Web2_knowledge) 
    +   [第三章   架构初探 ](#Nginx_Web3_knowledge) 
    +   [第四章   高级配置 ](#Nginx_Web4_knowledge) 
    +   [第五章   Gzip压缩](#Nginx_Web5_knowledge) 
    +   [第六章   Rewrite 功能](#Nginx_Web6_knowledge) 
    +   [第七章   代理服务 ](#Nginx_Web7_knowledge) 
    +   [第八章   缓存机制 ](#Nginx_Web8_knowledge) 
+   [PHP脚本运行Redis](#PHP_Run_Redis) 
+   [Openresty 学习](#Openresty_web_knowledge) 
    +   [安装](#Openresty_install_knowledge) 
    +   [默认配置信息](#Openresty_config_knowledge) 
    +   [Lua require 绝对和相对路径(已经解决)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-common-package/lua-require.md)
    +   [luajit 执行文件默认安装路径](#Openresty_web_knowledge) 
    +   [lua-resty-redis 扩展](#Openresty_resty-redis) 
    +   [lua-resty-websocket 扩展](#Openresty_resty-websocket) 
    +   [lua-cjson 扩展](#Openresty_resty-cjson) 
    +   [Lua 权限验证](#Openresty_resty-access) 
    +   [lua-resty-string 扩展](#Openresty_resty-string) 
    +   [lua-resty-http 扩展 ](#Openresty_resty-http) 
    +   [lua-resty-mysql 扩展](#Openresty_resty-mysql) 
    +   [openresty扫描代码全局变量](#Openresty_all-var) 
    +   [Lua HTTP状态常量](#Openresty_http_status_constants) 
    +   [ngx Lua APi 介绍使用](#Openresty_ngx_api_used) 
    +   [连接数据库](#Openresty_connent_redis) 
    +   [OpenResty缓存](#Openresty_connent_cache) 
    +   [lua-resty-upstream-healthcheck 使用](#Openresty_lua_resty_upstream_healthcheck) 
    +   [Openresty和Nginx_RTMP 模块共存问题](#Openresty_rtmp_share) 
    +   [Openresty配置RTMP模块的多worker直播流](#Openresty_rtmp_more_worker) 
+   [luajit 执行文件默认安装路径](#Nginx_base_knowledge) 
+   [Redis执行Lua脚本基本用法](#Redis_Run_Lua) 
+   [Ngx_lua 写入Redis数据，通过CURL请求](#Ngx_lua_write_Redis) 
### <a name="Nginx_base_knowledge"/>  Nginx基础知识
+   [NGINX 所有 Modules](https://www.nginx.com/resources/wiki/modules/)
+   [agentzh的Nginx教程（版本2016.07.21）](https://openresty.org/download/agentzh-nginx-tutorials-en.html#00-foreword01)
+   [Nginx的11个Phases](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-phases.md)
+   [Nginx 陷阱和常见错误](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-1-config.md)

### <a name="Redis_base_knowledge"/>    Redis基础知识
+   [Redis 简易安装教程](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-install.md)
### <a name="PHP_base_knowledge"/>    PHP脚本
+   [PHP7中php.ini/php-fpm/www.conf的配置,Nginx和PHP-FPM的开机自动启动脚本](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/PHP/PHP-FPM/config.md)
### <a name="Shell_base_knowledge"/>  Shell脚本
+   [编写快速安全Bash脚本的建议](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Shell/write-shell-suggestions.md) 
+   [shell脚本实现分日志级别记录日志](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Shell_Log.sh)   
### <a name="Lua_base_knowledge"/>  Lua基础知识
+ 控制结构
    + [if-elseif-end 语句](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/chapter-one/if-else-example.lua)
    + [for 语句](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/chapter-one/for-example.lua)
    + [Lua 只有一个容器，那就是table](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/chapter-one/container-table.lua)
+ [引入多个Lua文件,直接引用Lua文件名就可以了](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/more-file/another.lua)
+ [引入多个Lua文件,直接引用Lua文件名就可以了](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/more-file/another.lua)
+ [Lua 实现简单封装](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/function1.lua)
### <a name="live_base_knowledge"/>  流媒体视频直播、点播
+ [Nginx配置Rtmp支持Hls的直播和点播功能](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/HLS-live-vod.md)
+ [HLS视频直播和点播的Nginx的Location的配置信息(成功)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/HLS-live-vod-locatiuon-config.md)     
 
### <a name="Nginx_Web_knowledge"/>  Nginx高性能WEB服务器详解
#### <a name="Nginx_Web1_knowledge"/>  第一章   初探
+ [Nginx 编译安装以及参数详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)
+ NGINX变量详解
    - [x] [nginx变量使用方法详解笔记(1)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/notes-1.md)
    - [x] [nginx变量使用方法详解笔记(2)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/notes-2.md)
    - [x] [nginx变量使用方法详解笔记(3)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)
+ Nginx指令执行顺序
    - [x] [Nginx指令执行命令（01）](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/command-order-01.md)
#### <a name="Nginx_Web2_knowledge"/>  第二章   安装部署   
+   [基于域名、IP的虚拟主机配置](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-all-config.md)
+   [完整、标准配置实际示列](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-basic-config.md)
+   [日志文件配置与切割](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-log-cut.md)
+   alias 和 root 在location 下的应用
   - 通过alias 实现别名功能
       ``` 
       location /live {  
           alias /home/tinywan/HLS/;
       }
       ```
   - curl 请求结果
       ``` 
      tinywan@tinywan:~/HLS$ cat index.html 
      alias /home/tinywan/HLS/index.html
      tinywan@tinywan:~/HLS$ curl http://127.0.0.1/live/index.html
      alias /home/tinywan/HLS/index.html
       ```
   - 结论：
       1. cul 请求 `/live/index.html`,那么Nginx将会在服务器上查找`/home/tinywan/HLS/index.html` 文件
       1. 请求的`url` 中的`location`后面的部分会被追加到`alias `指定的目录后面，而`location`后面的`/live`路径将会别自动抛弃 
   - 类似案例[2]：
       - config配置信息
           ``` 
            location ~ ^/live/(.*)$ {  
                 alias /home/tinywan/HLS/$1;
            }
           ```
       - curl 请求结果
           ``` 
           tinywan@tinywan:~/HLS$ pwd
           /home/tinywan/HLS
           tinywan@tinywan:~/HLS$ cat txt.txt 
           txt file
           tinywan@tinywan:~/HLS$ curl http://127.0.0.1/live/txt.txt
           txt file
           ```
       -  如果url请求`/live/txt.txt`那么Nginx将会在服务器上查找`/home/tinywan/HLS/txt.txt` 文件   
   - **与root 功能的差别**：
       - config配置信息，注意：一下的`alias` 换成 `root `
           ``` 
            location ~ ^/live/(.*)$ {  
                 root /home/tinywan/HLS/$1;
            }
           ```
       - curl 请求结果
           ``` 
          tinywan@tinywan:~/HLS$ curl http://127.0.0.1/live/txt.txt
          <html>
          <head><title>404 Not Found</title></head>
          <body bgcolor="white">
          <center><h1>404 Not Found</h1></center>
          <hr><center>openresty/1.11.2.1</center>
          </body>
          </html>
           ```
       -  日志文件信息(打开Nginx的rewrite日志:rewrite_log on;)：
          ``` 
          /home/tinywan/HLS/txt.txt/live/txt.txt
          ```   
       - **二者的区别**
           1. `alias` 指定的目录是当前目录
           1. `root`  指定的是根目录
                1. 一般建议的`location /`中通过`root`命令配置目录，其他目录匹配的位置使用`alias`命令   
   - 案例[3]：
      - config配置信息
          ``` 
           location ~ ^/live/(\w+)/(.*) {
               alias /home/tinywan/HLS/live/$1/$2;
           }
          ```
      - curl 请求结果
          ``` 
          tinywan@tinywan:~/HLS/live/stream123$ pwd
          /home/tinywan/HLS/live/stream123
          tinywan@tinywan:~/HLS/live/stream123$ cat index.m3u8 
          12312312312
          tinywan@tinywan:~/HLS/live/stream123$ curl "http://127.0.0.1/live/stream123/index.m3u8?token=1234&api=009132"
          12312312312
          ```         
#### <a name="Nginx_Web3_knowledge"/>  第三章   架构初探
- [ ] 测试一
#### <a name="Nginx_Web4_knowledge"/>  第四章   高级配置
+   基本语法：location [=|~|~*|^~] /uri/ { … }   
     1. `= `：严格匹配。如果这个查询匹配，那么将停止搜索并立即处理此请求。
     2. `~ `：为区分大小写匹配(可用正则表达式) 
     3. `!~ `：为区分大小写不匹配
     4. `!~*`：为不区分大小写不匹配
     5. ` ^~ `：如果把这个前缀用于一个常规字符串,那么告诉nginx 如果路径匹配那么不测试正则表达式    
+   [Perl 正则表达式参考](http://www.runoob.com/perl/perl-regular-expressions.html)
+   正则中需要转义的特殊字符小结
     - [1] ` $`     匹配输入字符串的结尾位置。如果设置了 RegExp 对象的 Multiline 属性，则 $ 也匹配 ‘\n' 或 ‘\r'。要匹配 $ 字符本身，请使用 \$。   
     - [2] ` ( )`   标记一个子表达式的开始和结束位置。子表达式可以获取供以后使用。要匹配这些字符，请使用 和。   
     - [3] ` * `    匹配前面的子表达式零次或多次。要匹配 * 字符，请使用 \*。   
     - [4] ` +`     匹配前面的子表达式一次或多次。要匹配 + 字符，请使用 \+。   
     - [5] `  . `   匹配除换行符 \n之外的任何单字符。要匹配 .，请使用 \。  
     - [6] ` [ ]`   标记一个中括号表达式的开始。要匹配 [，请使用 \[。   
     - [7] ` ?  `   匹配前面的子表达式零次或一次，或指明一个非贪婪限定符。要匹配 ? 字符，请使用 \?。   
     - [8] ` \ `    将下一个字符标记为或特殊字符、或原义字符、或向后引用、或八进制转义符。例如， ‘n' 匹配字符 ‘n'。'\n' 匹配换行符。序列 ‘\\' 匹配 “\”，而 ‘\(' 则匹配 “(”。  
     - [9] `  ^  `  匹配输入字符串的开始位置，除非在方括号表达式中使用，此时它表示不接受该字符集合。要匹配 ^ 字符本身，请使用 \^。
     - [10] ` { }`   标记限定符表达式的开始。要匹配 {，请使用 \{。
     - [11] ` |  `   指明两项之间的一个选择。要匹配 |，请使用 \|。

+   正则表达式 (Regular expression) 匹配location
    - [1]   `location ~* \.(gif|jpg|jpeg)$ { }`：匹配所有以 gif,jpg或jpeg 结尾的请求
    - [2]   `location ~ /documents/Abc { }`：匹配任何以 /documents/ 开头的地址，匹配符合以后，还要继续往下搜索
    - [3] **目录匹配：**
        1. 可以匹配静态文件目录`(static/lib)`
        2. HLS直播目录`(/home/HLS/stream123/index.m3u8)`   
        3. HLS/MP4/FLV点播视频目录`(/home/HLS/stream123.m3u8)`   
        4. 匹配URL地址：`http://127.0.0.1/live/stream123/index.m3u8` 
        5. nginx.conf 配置信息 
            ```
            # 匹配任何以/live/ 开头的任何查询并且停止搜索。任何正则表达式将不会被测试
            location ^~ /live/ {  
                            root /home/tinywan/HLS/;
            }
            # 以上匹配成功后的组合：/home/tinywan/HLS/live/....
            ```
+   后缀匹配
    1. 匹配任何后缀文件名`gif|jpg|jpeg|png|css|js|ico|m3u8|ts` 结尾的请求
    2. TS 文件匹配`http://127.0.0.1/live/stream123/11.ts`
    3. M3U8 文件匹配`http://127.0.0.1/live/stream123/index.m3u8`
    4. 匹配URL地址：`http://127.0.0.1/hls/123.m3u8` 
    5. nginx.conf 配置信息  
        ```
        location ~* \.(gif|jpg|jpeg|png|css|js|ico|m3u8|ts)$ {
                root /home/tinywan/HLS/;
        }
        ```
+   HSL直播目录匹配实际案例（请测试上线）        
    1. 可以后缀文件名：`http://127.0.0.1/live/stream123/index.m3u8`
        ```
        location ^~ /live/ {
                root /home/tinywan/HLS/;
        }
        ```          

+   [nginx配置location总结及rewrite规则写法](http://seanlook.com/2015/05/17/nginx-location-rewrite/)
#### <a name="Nginx_Web5_knowledge"/>  第五章   Gzip压缩
+   测试一
#### <a name="Nginx_Web6_knowledge"/>   第六章   Rewrite 功能
+   Rewrite 常用全局变量
    +   请求案例： `curl -G -d "name=Tinywan&age=24" http://127.0.0.1/rewrite_var/1192/index.m3u8`    
    +   接受结果：
    
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
    
    + uri 介绍 **(Nginx中的URI是相对的URI)**
        + URL：`https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/config.md`
        + 绝对URI:`https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/config.md`
        + 相对URI:`/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/config.md`
        ![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/URI-URL-Image.jpg)
        
+   Rewrite 正则匹配` uri `参数接收
    1.  请求案例：`curl http://192.168.18.143/live/tinywan123/index.m3u8`   
    2.  Nginx.conf配置文件       
        ```Lua
        location ~* ^/live/(\w+)/(\D+)\.(m3u8|ts)$ {
            set $num $2;
            set $arg1 $1;
            echo "args === ${arg1}";
            echo "1==$1 2==$2 3==$3";
            echo "Total_numbser :: $num";
            echo "URI $uri";
        }
    
        ```
    3.  输出结果
        ```
           args === tinywan123
           $1==tinywan123 $2==index $3==m3u8
           Total_numbser :: index
           URI /live/tinywan123/index.m3u8
           Total_numbser :: 
        ``` 
    4.  $1为正则匹配多个英文字母或数字的字符串 `(\w+)`   
      $2 为正则匹配多个非数字 `(\D+)`    
      $3 为正则匹配的第一个值 `(m3u8|ts)`  
      `.` 需要用转义字符转义`\.`    
#### <a name="Nginx_Web7_knowledge"/>  第七章   代理服务
+   [正向代理和反向代理的概念](#title)
+   [正向代理服务](#title)
+   [反向代理的服务](#title)
+   [Nginx日志服务](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-Log.md)
+   负载均衡
+   HTTP负载均衡
    - [x] [简单的负载平衡](http://nginx.org/en/docs/http/ngx_http_core_module.html?&_ga=1.179030369.49817296.1480411319#http)
    - [x] [简单的负载平衡](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-7-Proxy-1.md)
    - [x] [负载均衡五个配置实例](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-7-Proxy.md)
    - [x] [Openresty-Lua动态修改upstream后端服务](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/openresty-nginx-lua-Proxy.md)
+   TCP负载均衡   
        - [x] [Module ngx_stream_core_module](http://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream)      
        - [x] [负载均衡](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-8-tcp-Proxy.md)      
#### <a name="Nginx_Web8_knowledge"/>  第八章   缓存机制
+   测试一
#### <a name="Nginx_Web9_knowledge"/>  第九章   Nginx初探1
+   测试一
#### <a name="Nginx_Web10_knowledge"/>  第十章   Nginx初探1
+   测试一     
### <a name="PHP_Run_Redis"/>  PHP脚本运行Redis]
+   [PHP 脚本执行一个Redis 订阅功能，用于监听键过期事件，返回一个回调，API接受改事件](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis-PHP/Php-Run-Redis-psubscribe/nohupRedisNotify.php)
+   单行文本1
### <a name="Openresty_web_knowledge"/>  Openresty 学习  
+   <a name="Openresty_install_knowledge"/>[安装信息](http://www.cnblogs.com/tinywan/p/6647587.html)
+   [默认配置信息](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/default-config.md)
+   开发入门
    + Nginx与Lua的整体目录关系
        ```Bash
        .
        ├── conf
        │   ├── nginx.conf                  -- Nginx 配置文件
        ├── logs
        │   ├── error.log                   -- Nginx 错误日子
        │   └── nginx.pid
        ├── lua
        │   ├── m3u8_redis_access.lua       -- M3U8地址权限验证文件
        │   ├── business_redis.lua          -- 业务 Redis 处理文件
        │   ├── http-lua-test.lua           -- http lua demo
        │   ├── ...
        │   └── resty                       -- 存放Lua 的所有公共、封装好的库目录
        │       └── redis_iresty.lua        -- Redis 接口的二次封装
        │       └── param.lua               -- 参数过滤库
        └── sbin
            └── nginx
        ```
    + 参数总结
      + Lua脚本接受Nginx变量：
        >   [1] 间接获取：`var = ngx.var `，如接受Nginx的变量` $a = 9`,则`lua_a = ngx.var.a --lua_a = 9`   
            [2] 直接获取：`var = ngx.var `，如接受Nginx的location的第二个变量890,` http://127.0.0.1/lua_request/123/890 `,则`lua_2 = ngx.var[2] --lua_2 = 890`    
      + Lua 脚本接受 Nginx 头部 header：
        >   [1] 返回一个包含所有当前请求标头的Lua表：`local headers = ngx.req.get_headers()`      
            [2] 获取单个Host：`headers["Host"] 或者 ngx.req.get_headers()["Host"] `     
            [3] 获取单个user-agent：
        >>  [01]`headers["user-agent"]`      
            [02]`headers.user_agent `  
            [03]`ngx.req.get_headers()['user-agent']  `     
      + Lua 脚本 Get 获取请求uri参数
        >   linux curl Get方式提交数据语法：`curl -G -d "name=value&name2=value2" https://github.com/Tinywan `  
            返回一个包含所有当前请求URL查询参数的Lua表：`local get_args = ngx.req.get_uri_args()`   
            请求案例：`curl -G -d "name=Tinywan&age=24" http://127.0.0.1/lua_request/123/789`      
            Lua Get 方式获取提交的name参数的值：`get_args['name'] 或者 ngx.req.get_uri_args()['name']`   
        >>  [01]`get_args['name']`      
            [02]`ngx.req.get_uri_args()['name']`    
      + Lua 脚本 Post 获取请求uri参数
        >   linux curl Post方式提交数据语法：
        >>  [01] `curl -d "name=value&name2=value2" https://github.com/Tinywan `     
            [02] `curl -d a=b&c=d&txt@/tmp/txt https://github.com/Tinywan `     
        >   返回一个包含所有当前请求URL查询参数的Lua表：`local post_args = ngx.req.get_post_args()`      
            请求案例：`curl -G -d "name=Tinywan&age=24" http://127.0.0.1/lua_request/123/789`      
            Lua Post 方式获取提交的name参数的值：
        >>  [01]`post_args['name']`   
            [02]`ngx.req.get_post_args()['name']` 
      + Lua 脚本请求的http协议版本：`ngx.req.http_version()`
      + Lua 脚本请求方法：`ngx.req.get_method()`
      + Lua 脚本原始的请求头内容：`ngx.req.raw_header()`
      + Lua 脚本请求的body内容体：`ngx.req.get_body_data()`
    + [接收请求:获取如请求参数、请求头、Body体等信息]()
    + [接收请求:输出响应需要进行响应状态码、响应头和响应内容体的输出](
+   luajit 执行文件默认安装路径：`/opt/openresty/luajit/bin/luajit`,这样我们直接可以这样运行一个Lua文件：`luajit test.lua `
    + luajit 运行测试案例：   
        ```Bash
        tinywan@tinywan:~/Lua$ luajit test.lua    
        The man name is Tinywan            
        The man name is Phalcon
        ```
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
#### <a name="Openresty_http_status_constants"/> Lua HTTP状态常量  
+ 所有常量列表
    ```Lua
   value = ngx.HTTP_CONTINUE (100) (first added in the v0.9.20 release)
   value = ngx.HTTP_SWITCHING_PROTOCOLS (101) (first added in the v0.9.20 release)
   value = ngx.HTTP_OK (200)
   value = ngx.HTTP_CREATED (201)
   value = ngx.HTTP_ACCEPTED (202) (first added in the v0.9.20 release)
   value = ngx.HTTP_NO_CONTENT (204) (first added in the v0.9.20 release)
   value = ngx.HTTP_PARTIAL_CONTENT (206) (first added in the v0.9.20 release)
   value = ngx.HTTP_SPECIAL_RESPONSE (300)
   value = ngx.HTTP_MOVED_PERMANENTLY (301)
   value = ngx.HTTP_MOVED_TEMPORARILY (302)
   value = ngx.HTTP_SEE_OTHER (303)
   value = ngx.HTTP_NOT_MODIFIED (304)
   value = ngx.HTTP_TEMPORARY_REDIRECT (307) (first added in the v0.9.20 release)
   value = ngx.HTTP_BAD_REQUEST (400)
   value = ngx.HTTP_UNAUTHORIZED (401)
   value = ngx.HTTP_PAYMENT_REQUIRED (402) (first added in the v0.9.20 release)
   value = ngx.HTTP_FORBIDDEN (403)
   value = ngx.HTTP_NOT_FOUND (404)
   value = ngx.HTTP_NOT_ALLOWED (405)
   value = ngx.HTTP_NOT_ACCEPTABLE (406) (first added in the v0.9.20 release)
   value = ngx.HTTP_REQUEST_TIMEOUT (408) (first added in the v0.9.20 release)
   value = ngx.HTTP_CONFLICT (409) (first added in the v0.9.20 release)
   value = ngx.HTTP_GONE (410)
   value = ngx.HTTP_UPGRADE_REQUIRED (426) (first added in the v0.9.20 release)
   value = ngx.HTTP_TOO_MANY_REQUESTS (429) (first added in the v0.9.20 release)
   value = ngx.HTTP_CLOSE (444) (first added in the v0.9.20 release)
   value = ngx.HTTP_ILLEGAL (451) (first added in the v0.9.20 release)
   value = ngx.HTTP_INTERNAL_SERVER_ERROR (500)
   value = ngx.HTTP_METHOD_NOT_IMPLEMENTED (501)
   value = ngx.HTTP_BAD_GATEWAY (502) (first added in the v0.9.20 release)
   value = ngx.HTTP_SERVICE_UNAVAILABLE (503)
   value = ngx.HTTP_GATEWAY_TIMEOUT (504) (first added in the v0.3.1rc38 release)
   value = ngx.HTTP_VERSION_NOT_SUPPORTED (505) (first added in the v0.9.20 release)
   value = ngx.HTTP_INSUFFICIENT_STORAGE (507) (first added in the v0.9.20 release)
    ```
+ 案列使用,get_string_md5.lua：
    ```Lua 
    local args = ngx.req.get_uri_args()
    local salt = args.salt
    if not salt then
            ngx.say(ngx.HTTP_BAD_REQUEST)
    end
    local string = ngx.md5(ngx.time()..salt)
    ngx.say(string)
    
    ```
+ curl 请求(-i 参数,输出时包括protocol头信息)：
    ```Bash 
    tinywan@tinywan:$ curl -i http://127.0.0.1/get_rand_string?salt=tinywan123
    HTTP/1.1 200 OK
    Server: openresty/1.11.2.1
    Date: Fri, 21 Apr 2017 14:27:16 GMT
    Content-Type: application/octet-stream
    Transfer-Encoding: chunked
    Connection: keep-alive
    ```    
#### <a name="Openresty_ngx_api_used"/> ngx Lua APi 介绍使用
+   强烈建议使用ngx Lua APi 接口`(非阻塞的)`，而不是Lua自身的API`(阻塞的)`,Lua 自身API会阻塞掉的
+   ngx_lua_api_test.lua 
    ```Lua 
    local json = require "cjson"    -- 引入cjson 扩展
    
    -- 同步读取客户端请求正文，而不会阻止Nginx事件循环
    ngx.req.read_body()
    local args = ngx.req.get_post_args()
    
    if not args or not args.info then
            ngx.say(ngx.HTTP_BAD_REQUEST)   -- ngx.HTTP_BAD_REQUEST (400)
    end
    
    local client_id = ngx.var.remote_addr
    local user_agent = ngx.req.get_headers()['user-agent'] or ""
    local info = ngx.decode_base64(args.info)
    
    local response = {}
    response.info = info
    response.client_id = client_id
    response.user_agent = user_agent
    
    ngx.say(json.encode(response))
    
    ```
+   CURL  Post 请求
    ```Lua 
    $ curl -i --data "info=b3ZlcmNvbWUud2FuQGdtYWlsLmNvbQ==" http://127.0.0.1/ngx_lua_api_test
    HTTP/1.1 200 OK
    Server: openresty/1.11.2.1
    Date: Sat, 22 Apr 2017 01:22:07 GMT
    Content-Type: application/octet-stream
    Transfer-Encoding: chunked
    Connection: keep-alive
    
    {"user_agent":"curl\/7.47.0","info":"overcome.wan@gmail.com","client_id":"127.0.0.1"}
    
    ```
#### <a name="Openresty_connent_cache"/> OpenResty缓存    
+   指令：`lua_shared_dict`
    +   纯内存的操作，多个worker之间共享的(比如nginx开启10个Worker,则每个worker之间是共享该内存的)
    +   同一份数据在多个worker之间是共享的，只要存储一份数据就可以了
    +   锁的竞争（数据原子性）
#### <a name="Openresty_lua_resty_upstream_healthcheck"/> lua-resty-upstream-healthcheck使用 
+   health.txt 在每个upstream 服务器组的root 目录下创建这个文件，目录结构如下所示
    ```Lua
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
#### <a name="Openresty_rtmp_share"/> Openresty和Nginx_RTMP 模块共存问题   
+   RTMP 流的状态（stat.xsl）不生效Bug 问题
    -   1.  修改完nginx.conf 配置文件
    -   1.  ~~执行：`nginx -s reload` 会不起作用~~
    -   2.  一定要执行以下命令：杀掉所有nginx进程`sudo killall nginx ` 重启即可`sbin/nignx`
#### <a name="Openresty_rtmp_more_worker"/> 配置RTMP模块的多worker直播流
+   配置文件,[Multi-worker live streaming官方文档](https://github.com/arut/nginx-rtmp-module/wiki/Directives#multi-worker-live-streaming)
    ```Shell
    user www www;
    worker_processes  auto;
    error_log  logs/error.log debug;
    
    pid /var/run/nginx.pid;
    events {
        use epoll;
        worker_connections  1024;
        multi_accept on;
    }
   
    rtmp_auto_push on;
    rtmp_auto_push_reconnect 1s;
    rtmp_socket_dir /var/sock;
    rtmp {
        server {
            listen 1935;
            application live {
                live on;
            }
        }
    }
    ```
+   [nginx 并发数问题思考：worker_connections,worker_processes与 max clients](http://liuqunying.blog.51cto.com/3984207/1420556?utm_source=tuicool)
    +   从用户的角度，http 1.1协议下，由于浏览器默认使用两个并发连接,因此计算方法：
        1. nginx作为http服务器的时候：  
        `max_clients = worker_processes * worker_connections/2`
        1. nginx作为反向代理服务器的时候：  
        `max_clients = worker_processes * worker_connections/4`
    +   从一般建立连接的角度,客户并发连接为1：
        1. nginx作为http服务器的时候：  
        `max_clients = worker_processes * worker_connections`
        1. nginx作为反向代理服务器的时候：  
        `max_clients = worker_processes * worker_connections/2`    
    +   nginx做反向代理时，和客户端之间保持一个连接，和后端服务器保持一个连接
    +   clients与用户数  
        同一时间的clients(客户端数)和用户数还是有区别的，当一个用户请求发送一个连接时这两个是相等的，但是当一个用户默认发送多个连接请求的时候，clients数就是用户数*默认发送的连接并发数了。    
        
        
### Redis、Lua、Nginx一起工作事迹
+   解决一个set_by_lua $sum 命令受上下文限制的解决思路，已完美解决
+   - [x] [API disabled in the context of set_by_lua](https://github.com/openresty/lua-nginx-module/issues/275)
+   解决2
+   解决3    
### Redis执行Lua脚本
#### Lua 基本语法
---
+   Hello, Lua!

    > 我们的第一个Redis Lua 脚本仅仅返回一个字符串，而不会去与redis 以任何有意义的方式交互   

    ```Lua
    local msg = "Hello, world!"
    return msg
    ```

    > 这是非常简单的，第一行代码定义了一个本地变量msg存储我们的信息， 第二行代码表示 从redis 服务端返回msg的值给客户端。 保存这个文件到Hello.lua，像这样去运行: 
    
    ```Bash
    www@iZ239kcyg8rZ:~/lua$ redis-cli EVAL "$(cat Hello.lua)" 0
    "Hello, world!"
    ```

    > 运行这段代码会打印"Hello,world!", EVAL在第一个参数是我们的lua脚本， 这我们用cat命令从文件中读取我们的脚本内容。第二个参数是这个脚本需要访问的Redis 的键的数字号。我们简单的 “Hello Script" 不会访问任何键，所以我们使用0
    
+   redis.call() 与 redis.pcall()的区别

    * 他们唯一的区别是当redis命令执行结果返回错误时
    * redis.call()将返回给调用者一个错误.
    * redis.pcall()会将捕获的错误以Lua表的形式返回.
    *  redis.call() 和 redis.pcall() 两个函数的参数可以是任意的 Redis 命令
+   Lua网络编程    
#### Lua 脚本
+   Lua 实现简单封装
    +   man.lua
        ```Lua
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
    +   测试封装,test.lua   

        ```Lua
            local man = require('man')
            print("The man name is "..man.GetName())
            man.SetName("Phalcon")
            print("The man name is "..man.GetName())
        ```  
#### <a name="Redis_Run_Lua"/>   Redis执行Lua脚本基本用法
+   EVAL命令格式
    +   基本语法 
        ```
        EVAL script numkeys key [key ...] arg [arg ...]
        ```
    +   语义
        1. script即为lua脚本或lua脚本文件
        1. key一般指lua脚本操作的键，在lua脚本文件中，通过KEYS[i]获取
        1. arg指外部传递给lua脚本的参数，可以通过ARGV[i]获取
    +   eval命令的用法
        ``` 
        127.0.0.1:6379>  eval "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 first second
        1) "key1"
        2) "key2"
        3) "first"
        4) "second"
        ```
        > 这个示例中lua脚本为一个return语句，返回了lua一个数组，这个数组四个元素分别是通过外部传入lua脚本。
          因为redis内嵌了Lua虚拟机，因此redis接收到这个lua脚本之后，然后交给lua虚拟机执行。
          当lua虚拟机执行结束，即将执行结果返回给redis，redis将结果按自己的协议转换为返回给客户端的回复，最后再通过TCP将回复发回给客户端
    +   lua脚本参数的接受
        + 键值：`KEYS[i]` 来获取外部传入的键值
        + 参数：`ARGV[i]` 来获取外部传入的参数
+   案例介绍
    +   通过Redis命令`EVAL`执行一个简单的Lua脚本文件
        + 给Redis添加测试数据(通过有序集合和哈希对应的集合信息)
            ``` 
            127.0.0.1:6379> ZADD WEB 1 google
            (integer) 1
            127.0.0.1:6379> ZADD WEB 2 apple
            (integer) 1
            127.0.0.1:6379> ZADD WEB 3 baidu
            (integer) 1
            127.0.0.1:6379> ZRANGE WEB 0 3
            1) "google"
            2) "apple"
            3) "baidu"
            127.0.0.1:6379> hmset google domain_name www.google.com ip 192.168.1.100 
            OK
            127.0.0.1:6379> hmset baidu domain_name www.baidu.com ip 192.168.1.200 
            OK
            127.0.0.1:6379> hmset apple domain_name www.apple.com ip 192.168.1.300 
            OK
            127.0.0.1:6379> hgetall google
            1) "domain_name"
            2) "www.google.com"
            3) "ip"
            4) "192.168.1.100"
            127.0.0.1:6379> hgetall apple
            1) "domain_name"
            2) "www.apple.com"
            3) "ip"
            4) "192.168.1.300"
            127.0.0.1:6379> hgetall baidu
            1) "domain_name"
            2) "www.baidu.com"
            3) "ip"
            4) "192.168.1.200"
            ```
        +  Lua脚本,lua_get_redis.lua 文件
           ```Lua 
           -- 获取键值/参数
           local key,offset,limit = KEYS[1], ARGV[1], ARGV[2]
           -- 通过ZRANGE获取键为key的有序集合元素，偏移量为offset，个数为limit，即所有WEB信息 
           local names = redis.call('ZRANGE', key, offset, limit)
           -- infos table 存储所有WEB信息
           local infos = {}
           -- 遍历所有WEB信息
           for i=1,#names do
                   local ck = names[i]
               -- 通过HGETALL命令获取每WEB的信息
                   local info = redis.call('HGETALL',ck)
               -- 并且在WEB信息中插入对应的集合信息
                   table.insert(info,'HOST_NAME')
                   table.insert(info,names[i])
                   --table.insert(info,'author',"Tinywan")
               -- 插入infos中
                   infos[i] = info
           end
           -- 将结果返回给redis
           return infos
           ```
           1. redis.call() 函数的参数可以是任意的 Redis 命令
           1. table.insert(table, pos, value)
                > [1]table.insert()函数在table的数组部分指定位置(pos)插入值为value的一个元素. pos参数可选, 默认为数组部分末尾
        + 执行结果：
           ``` 
           tinywan@:~/Lua$ sudo redis-cli --eval /home/tinywan/Lua/lua_get_redis.lua WEB , 0 2
           1) 1) "domain_name"
              2) "www.google.com"
              3) "ip"
              4) "192.168.1.100"
              5) "HOST_NAME"
              6) "google"
           2) 1) "domain_name"
              2) "www.apple.com"
              3) "ip"
              4) "192.168.1.300"
              5) "HOST_NAME"
              6) "apple"
           3) 1) "domain_name"
              2) "www.baidu.com"
              3) "ip"
              4) "192.168.1.200"
              5) "HOST_NAME"
              6) "baidu"
           ```
           + 注意：`lua_get_redis.lua WEB , 0 2` 之间的空格，不然会提示错误
           + 错误：`(error) ERR Error running script command arguments must be strings or integers`
    +   <a name="Ngx_lua_write_Redis"/>  Ngx_lua 写入Redis数据，通过CURL请求 
        + curl_get_redis.lua 文件内容
            ```Lua 
            local json = require("cjson")
            local redis = require("resty.redis")
            local red = redis:new()
            
            red:set_timeout(1000)
            
            local ip = "127.0.0.1"
            local port = 6379
            local ok, err = red:connect(ip, port)
            if not ok then
                    ngx.say("connect to redis error : ", err)
                    return ngx.exit(500)
            end
            
            local key = ngx.var[1]
            local new_timer = ngx.localtime()   -- 本地时间：2017-04-16 15:56:59
            local value = key.."::"..new_timer
            local ok , err = red:set(key,value)
            if not ok then
               ngx.say("failed to set "..key, err)
               return
            end
            ngx.say("set result: ", ok)
            
            local res, err = red:get(key)
            if not res then
                    ngx.say("get from redis error : ", err)
                    return
            end
            if res == ngx.null then
                    ngx.say(key.."not found.")
                    return
            end
            red:close()
            ngx.say("Success get Redis Data",json.encode({content=res}))
            ```
        + nginx.conf
            ```Lua 
            location ~* /curl_insert_redis/(\w+)$ {
                default_type 'text/html';
                lua_code_cache off;
                content_by_lua_file /opt/openresty/nginx/conf/Lua/curl_get_redis.lua;
            }
            ```
        + curl 和浏览器请求结果（查询Redis数据库，数据已经插入成功）
           ```Lua 
              root@tinywan:# curl http://127.0.0.1/curl_insert_redis/Tinywan1227
              set result: OK
              Success get Redis Data{"content":"Tinywan1227::2017-04-16 15:57:56"}
           ```
    +   通过lua脚本获取指定的key的List中的所有数据 
        ```Lua
        local key=KEYS[1]
        local list=redis.call("lrange",key,0,-1);
        return list;
        ```
    +   根据外面传过来的IDList 做“集合去重”的lua脚本逻辑：     
         ```Lua
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
### <a name="githubpush"/> Visual Studio Code 向github提交代码不用输入帐号密码    
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

## <a name="Linux_base_knowledge"/> Linux 基础知识
+   检查网卡是否正确工作
    1.  检查系统路由表信息是否正确
    1.  [Linux route命令详解和使用示例](http://www.jb51.net/LINUXjishu/152385.html)
    1.  案例介绍：
        ```  
        www@ubuntu1:/var/log$ route
        Kernel IP routing table
        Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
        default         122.11.11.161 0.0.0.0         UG    0      0        0 em1
        10.10.101.0     *               255.255.255.0   U     0      0        0 em2
        122.11.11.160 *               255.255.255.224 U     0      0        0 em1
        ```
        +   默认路由为：`122.11.11.161`,绑定在`em1` 网卡上
        +   而`10.10.101.0` 段的IP仅供局域网主机之间共享数据，没对外连接访问权限,因而外界是没办法通过`10`段网络连接到服务器的
        +   如果需要`10.10.101.0` 段可以让外网放完的,则需要删除`122.11.11.161` 的默认路由，需要在`em2`网卡上添加`10`段的默认路由即可
        +   具体步骤：
            ``` 
            www@ubuntu1:/var/log$   route delete defaul
            www@ubuntu1:/var/log$   route add defaul gw 10.10.101.1
            ```
        +   此时外界就可以通过`ssh www@10.10.101.2`连接到服务器了    
+ find 命令
    + 查找超出7天前的flv的文件进行删除：
        + 命令：
        ```Bash
        find ./ -mindepth 1 -maxdepth 3 -type f -name "*.flv" -mmin +10080 | xargs rm -rf 
        ```
        + `-type f` 按类型查找
        + `-mmin +10080` 7天之前的文件
        + xargs与-exec功能类似,` find ~ -type f | xargs ls -l `
        + -r 就是向下递归，不管有多少级目录，一并删除
        + -f 就是直接强行删除，不作任何提示的意思
    + 查找当前目录下.p文件中，最近30分钟内修改过的文件：
        + `find . -name '*.p' -type f -mmin -30`   
    + 查找当前目录下.phtml文件中，最近30分钟内修改过的文件，的详细de情况加上ls：
        + `find . -name '*.phtml' -type f -mmin -30 -ls`  
    + 查找当前目录下，最近1天内修改过的常规文件：`find . -type f -mtime -1`  
    + 查找当前目录下，最近1天前（2天内）修改过的常规文件：`find . -type f -mtime +1`            



