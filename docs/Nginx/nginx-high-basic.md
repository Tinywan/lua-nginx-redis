# <a name="Nginx_Web_knowledge"/>  Nginx高性能WEB服务器详解
---
## <a name="Nginx_Web1_knowledge"/>  第一章   初探

+ [Nginx 编译安装以及参数详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)

+ NGINX变量详解

    * [nginx变量使用方法详解笔记(1)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/notes-1.md)
    
    * [nginx变量使用方法详解笔记(2)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/notes-2.md)
    
    * [nginx变量使用方法详解笔记(3)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-2-config.md)
    
+ Nginx指令执行顺序

  * [Nginx指令执行命令（01）](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Develop/command-order-01.md)
    
## <a name="Nginx_Web2_knowledge"/>  第二章   安装部署 

+   启动错误：`Nginx [emerg]: bind() to 0.0.0.0:80 failed (98: Address already in use)`,执行：`sudo fuser -k 80/tcp`
  
+   [基于域名、IP的虚拟主机配置](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-all-config.md)

+   [完整、标准配置实际示列](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-basic-config.md)

+   [日志文件配置与切割](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-2-4-log-cut.md)

+   alias 和 root 在location 下的应用  

    +   通过alias 实现别名功能

        ```bash
        location /live {  
           alias /home/tinywan/HLS/;
        }
        ```
    +   curl 请求结果
   
        ```bash
        tinywan@tinywan:~/HLS$ cat index.html 
        alias /home/tinywan/HLS/index.html
        tinywan@tinywan:~/HLS$ curl http://127.0.0.1/live/index.html
        alias /home/tinywan/HLS/index.html
        ```
   +    结论：
   
        1. cul 请求 `/live/index.html`,那么Nginx将会在服务器上查找`/home/tinywan/HLS/index.html` 文件
        
        1. 请求的`url` 中的`location`后面的部分会被追加到`alias `指定的目录后面，而`location`后面的`/live`路径将会别自动抛弃 
       
   - 类似案例[2]：
   
       - config配置信息
       
        ```bash
        location ~ ^/live/(.*)$ {  
             alias /home/tinywan/HLS/$1;
        }
        ```
       - curl 请求结果
       
        ```bash
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
       
        ```bash
        location ~ ^/live/(.*)$ {  
             root /home/tinywan/HLS/$1;
        }
        ```
           
       - curl 请求结果
       
        ```bash
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
    | $binary_remote_addr       | 乱码  | 二进制格式的客户端地址|
    
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
## <a name="Nginx_Web7_knowledge"/>  第七章   代理服务

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

+   proxy_pass 代理的URL总结
   
    +   在nginx中配置proxy_pass时，当在后面的url加上了/，相当于是绝对根路径，则nginx不会把location中匹配的路径部分代理走;如果没有/，则会把匹配的路径部分也给代理走。
   
    +   将url中以/wap/开头的请求转发到后台对应的某台server上,注意最后的?$args，表明把原始url最后的get参数也给代理到后台
        ```bash 
        location ~* /wap/(\d+)/(.+)
        {
            proxy_pass http://mx$1.test.com:6601/$2?$args;
        }
        ```
    
    +   第一种配置,访问:`http://127.0.0.1/proxy/index.html` 会被代理到:`http://127.0.0.1:8000/index.html`
        ```bash
        location /proxy/ {
                proxy_pass   http://127.0.0.1:8000/;
        }
        ```
   
    +   第二种配置,访问:`http://127.0.0.1/proxy/index.html` 会被代理到:`http://127.0.0.1:8000/proxy/index.html`
        ```bash
        location /proxy/ {
                proxy_pass   http://127.0.0.1:8000;
        }
        ```
   
    +   第三种配置,访问:`http://127.0.0.1/proxy/index.html` 会被代理到:`http://127.0.0.1:8000/video/index.html`
        ```bash
        location /proxy/ {
                proxy_pass   http://127.0.0.1:8000/video/;
        }
        ```
   
    +   第四种配置,访问:`http://127.0.0.1/proxy/index.html` 会被代理到:`http://127.0.0.1:8000/videoindex.html`
        ```bash
        location /proxy/ {
                proxy_pass   http://127.0.0.1:8000/video;
        }
        ```

+   location 直接访问：
    
    +   以下配置，当访问：`http://127.0.0.1:8000/proxy/index.html` 会被匹配到：`/usr/local/nginx/html/proxy/index.html`
        ```bash
        location /proxy/ {
            root /usr/local/nginx/html;
            index  index.html index.htm;
        }
        ```   
            
## <a name="Nginx_Web8_knowledge"/>  第八章   缓存机制

+   [Proxy Cache 缓存机制](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-8-proxy_cache.md)

## <a name="Nginx_Web9_knowledge"/>  第九章   Nginx初探1

+   测试一

## <a name="Nginx_Web10_knowledge"/>  第十章   Nginx初探1

+   测试一     
