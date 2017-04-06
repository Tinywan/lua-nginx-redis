
#### rewrite 重写
---

+   重写中用到的指令 
    +   if  (条件) {}  设定条件,再进行重写 
        + If  语法格式
            ```
            If 空格 (条件) {
                重写模式
            }
            ```
         + 配置案例一：禁止某一个IP地址访问
            ```
            location / {
                if ( $remote_addr = 192.168.127.129 ){      # 注意：这里的if和（）之间是有个空格的 
                    return 403;
                }
                root   html;
            }
            ```   
        + 配置案例二：正则表达式的用法
            ```
            # 这个没有添加break 则会一直循环重定向,服务器会相应 500
            rewrite_log on;
            if ($http_user_agent ~ Mozilla){
                rewrite ^.*$ /ie.html;
             }
            # nginx 日志记录()：rewrite or internal redirection cycle while processing "/404.html",
            # 这里要开启重写日志：rewrite_log on

            # 正确配置信息 ，服务器会输出ie.html 中的内容
            rewrite_log on;
            if ($http_user_agent ~ Mozilla){
                rewrite ^.*$ /ie.html;
                break;
             }
            ```     

    +   set #设置变量 
    +   return #返回状态码 
    +   break #跳出rewrite
    +   rewrite #重写 

+ Nginx 全局应用的变量文件路径：root@tinywan:/usr/local/nginx/conf# cat fastcgi.conf
    ```
    fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;   -- 脚本文件请求的路径
    fastcgi_param  QUERY_STRING       $query_string;     -- 请求的参数;如?app=123
    fastcgi_param  REQUEST_METHOD     $request_method;      -- 请求的方法(GET,POST)
    fastcgi_param  CONTENT_TYPE       $content_type;        -- 请求头中的Content-Type字段   
    fastcgi_param  CONTENT_LENGTH     $content_length;      -- 请求头中的Content-length字段

    fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;         -- 脚本名称
    fastcgi_param  REQUEST_URI        $request_uri;             -- 请求的地址不带参数
    fastcgi_param  DOCUMENT_URI       $document_uri;            -- 与$uri相同
    fastcgi_param  DOCUMENT_ROOT      $document_root;           -- 网站的根目录。在server配置中root指令中指定的值
    fastcgi_param  SERVER_PROTOCOL    $server_protocol;         -- 请求使用的协议，通常是HTTP/1.0或HTTP/1.1
    fastcgi_param  REQUEST_SCHEME     $scheme;                  -- 
    fastcgi_param  HTTPS              $https if_not_empty;      -- 

    fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
    fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

    fastcgi_param  REMOTE_ADDR        $remote_addr;     -- 客户端IP
    fastcgi_param  REMOTE_PORT        $remote_port;     -- 客户端端口
    fastcgi_param  SERVER_ADDR        $server_addr;     -- 服务器IP地址
    fastcgi_param  SERVER_PORT        $server_port;     -- 服务器端口
    fastcgi_param  SERVER_NAME        $server_name;     -- 服务器名，域名在server配置中指定的server_name

    PHP ： fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    ```

**二、错误日志**

*   错误日志主要记录客户端访问Nginx出错时的日志，格式不支持自定义。通过错误日志，你可以得到系统某个服务或server的性能瓶颈等。因此，将日志好好利用，你可以得到很多有价值的信息。错误日志由指令error_log来指定`  


          
