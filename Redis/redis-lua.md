#### <a name="Redis_Run_Lua"/>   Redis执行Lua脚本基本用法
## 基本语法
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
    * redis.call() 和 redis.pcall() 两个函数的参数可以是任意的 Redis 命令
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