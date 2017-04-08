 
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
        - [ ] Nginx重写规则指南
    * 第五章   Gzip压缩
        - [ ] 测试一
    * 第六章   Rewrite 功能
        - [ ] 测试一
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
          > [1] 间接获取：`var = ngx.var `，如接受Nginx的变量` $a = 9`,则`lua_a = ngx.var.a -- lua_a = 9`   
          > [2] 直接获取：`var = ngx.var `，如接受Nginx的location的第二个变量890,` http://127.0.0.1/lua_request/123/890 `,则`lua_2 = ngx.var[2] -- lua_2 = 890`    

          + Lua脚本接受Nginx头部header：
          > [1] 返回一个包含所有当前请求标头的Lua表：`local headers = ngx.req.get_headers()`      
          > [2] 获取单个Host：`headers["Host"] 或者 ngx.req.get_headers()["Host"] `     
          > [3] 获取单个user-agent：`headers["user-agent"] 或者 headers.user_agent 或者 ngx.req.get_headers()['user-agent'] `    

          + Lua获取Get请求uri参数

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
        + **Lua脚本实现一个CDN的反向代理功能(智能查找CDN节点)**
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



