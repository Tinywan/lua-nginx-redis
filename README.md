## <a name="index"/>目录
+   Nginx 教程 
    +   [Nginx基础知识](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-basic.md)
    +   [Nginx高性能WEB服务器详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-high-basic.md) 
        +   第一章   初探
        +   第二章   安装部署 
        +   第三章   架构初探 
        +   第四章   高级配置 
        +   第五章   Gzip压缩
        +   第六章   Rewrite 功能
        +   第七章   代理服务 
        +   第八章   缓存机制 
    +   [nginx 并发数问题思考](#Nginx_base_knowledge)
+   Lua 教程    
        +  [Lua 基础语法](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/lua-basic.md)
        +  [Lua 模块与包](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/openresty-resty-module.md) 
        +  [luajit 执行文件默认安装路径](#Nginx_base_knowledge) 
        +  [lua中self.__index = self 详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/oop/self__index.md)      
+   Redis 教程    
    +   [Redis基础知识](#Redis_base_knowledge) 
    +   [Redis 简易安装教程](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-install.md) 
    +   [Redis执行Lua脚本基本用法](#Redis_Run_Lua) 
    +   [Redis 开发与运维](#Redis-DevOps)
        -   [ ]   [第一章   初始Redis ](#Redis-DevOps-1) 
        -   [ ]   [第二章   API的理解和使用](#Redis-DevOps-2) 
        -   [ ]   [第三章   小功能大用处 ](#Redis-DevOps-3) 
        -   [ ]   [第四章   客户端 ](#Redis-DevOps-4) 
        -   [ ]   [第五章   持久化](#Redis-DevOps-5) 
        -   [ ]   [第六章   复制](#Redis-DevOps-6) 
        -   [ ]   [第七章   Redis 的恶魔 ](#Redis-DevOps-7) 
        -   [ ]   [第八章   理解内存 ](#Redis-DevOps-8)
+   Openresty 教程
    +   [安装默认配置信息](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-basic.md) 
    +   [扩展模块学习](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-resty-module.md) 
    +   [ngx_lua APi 方法和常量](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-resty-module.md) 
    +   [lua-resty-upstream-healthcheck使用](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-upstream-healthcheck.md) 
    +   [Openresty与Nginx_RTMP](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-rtmp.md) 
+   PHP 教程
    +   [PHP脚本](#PHP_base_knowledge) 
         +   [PHP脚本运行Redis](#PHP_Run_Redis)
         +   [PHP7中php.ini/php-fpm/www.conf的配置,Nginx和PHP-FPM的开机自动启动脚本](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/PHP/PHP-FPM/config.md)        
+   Shell 教程    
    +   Shell脚本 
        +   [编写快速安全Bash脚本的建议](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Shell/write-shell-suggestions.md) 
        +   [shell脚本实现分日志级别记录日志](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Shell_Log.sh)   
        +   [Nginx日志定时备份和删除](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Shell_Nginx_Log_cut.sh)   
        +   [SHELL脚本小技巧](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Shell_script.md)   
        +   [Mysql 自动备份脚本安全加锁机制](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/backup_mysql.sh)   
+   [流媒体视频直播、点播](#live_base_knowledge) 
+   [Copyright and License](#Copyright_and_License)    
## 开发过程记录
+   [解决 Visual Studio Code 向github提交代码不用输入帐号密码](#githubpush)
+   phase的意义：就是几个MR的一个集合，不定数目的MR job视为一个phase。一个请求经过nginx处理的过程中，会经过一系列的阶段（phases）    

## <a name="live_base_knowledge"/>  流媒体视频直播、点播
+ [Nginx配置Rtmp支持Hls的直播和点播功能](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/HLS-live-vod.md)
+ [HLS视频直播和点播的Nginx的Location的配置信息(成功)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/HLS-live-vod-locatiuon-config.md)     
## <a name="PHP_Run_Redis"/>  PHP脚本运行Redis]
+   [PHP 脚本执行一个Redis 订阅功能，用于监听键过期事件，返回一个回调，API接受改事件](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis-PHP/Php-Run-Redis-psubscribe/nohupRedisNotify.php)

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
        
        
## Redis、Lua、Nginx一起工作事迹
+   解决一个set_by_lua $sum 命令受上下文限制的解决思路，已完美解决
+   - [x] [API disabled in the context of set_by_lua](https://github.com/openresty/lua-nginx-module/issues/275)
+   解决2
+   解决3    
## Redis执行Lua脚本
## Lua 基本语法
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
## Lua 脚本
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
            ```javascript 
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
## <a name="githubpush"/> Visual Studio Code 向github提交代码不用输入帐号密码    
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
# 掘金爬虫

![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/github_good1.png)

# Lua-Ngx
![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Nginx-Phase.png)
# Live demo

Changes are automatically rendered as you type.

* Follows the [CommonMark](http://commonmark.org/) spec
* Renders actual, "native" React DOM elements
* Allows you to escape or skip HTML (try toggling the checkboxes above)
* If you escape or skip the HTML, no `dangerouslySetInnerHTML` is used! Yay!

## HTML block below

<blockquote>
    This blockquote will change based on the HTML settings above.
</blockquote>

## How about some code?
```js
var React = require('react');
var Markdown = require('react-markdown');

React.render(
    <Markdown source="# Your markdown here" />,
    document.getElementById('content')
);
```

Pretty neat, eh?

## More info?

Read usage information and more on [GitHub](//github.com/rexxars/react-markdown)

---------------

A component by [VaffelNinja](http://vaffel.ninja) / Espen Hovlandsdal

##  <a name="Linux_base_knowledge"/> Copyright and License

This module is licensed under the BSD license  

Copyright (C) 2017, by Wanshaobo "Tinywan".  