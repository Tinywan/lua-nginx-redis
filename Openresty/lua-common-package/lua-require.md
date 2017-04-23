![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/nginx-hls-locations.png)
### 整体目录
+ 整体目录
    ```
    .
    ├── conf
    │   ├── nginx.conf                  -- Nginx 配置文件
    ├── logs
    │   ├── error.log                   -- Nginx 错误日子
    │   └── nginx.pid
    ├── lua
    │   ├── access_check.lua            -- 权限验证文件
    │   ├── business_redis.lua          -- 业务 Redis 处理文件
    │   ├── redis.lua                   -- 直接使用Lua的redis以及别的函数库
    │   ├── ...
    │   └── resty                       -- 存放Lua 的所有公共、封装好的库
    │       └── redis_iresty.lua        -- Redis 接口的二次封装
    │       └── param.lua               -- 参数过滤库
    └── sbin
        └── nginx
    ```
+ [Lua require 相对路径 博客园详解](http://www.cnblogs.com/smallboat/p/5552407.html)
#### 相对路径总结（相对于nginx安装目录）
+ **当前目录** ：`/opt/openresty/nginx/conf/Lua`
    + 注意:如果在当前没有了，以下的代码运行是没有问题的
    + 就是所有的lua脚本代码全部写在Lua文件夹下面去
    + 拼接路径：`package.path = package.path ..';..\\?.lua';`
    + require 直接这样应用就是`Lua.functions`
+ 目录结构
    ```
    root@tinywan:/opt/openresty/nginx/conf/Lua# pwd
    /opt/openresty/nginx/conf/Lua
    root@tinywan:/opt/openresty/nginx/conf/Lua# ls
    cjosn01.lua  functions.lua  lua-01.lua  main.lua
    ```
+ 可以看出在Lua文件夹下面有多个Lua文件，我们拿main.lua和functions.lua 文件来测试包的进入
+ 规则 在main.lua中引入functions.lua 文件
+ main.lua 文件内容
    ```
    package.path = package.path ..';..\\?.lua';
    require("Lua.functions")
    ngx.say("Hello")
    ngx.say(MathFun.Add(12,90))
    ```
+ functions.lua 文件内容
    ```
    -- 全局的表package
    MathFun = {}
    -- 以下把所有的函数放在这个全局表中
    -- +
    function MathFun.Add(a,b)
        return a+b
    end

    -- -
    function MathFun.Minus(a,b)
        return a-b
    end

    -- *
    function MathFun.Multi(a,b)
        return a*b
    end
    -- /
    function MathFun.Div(a,b)
        return a/b
    end
    ```
+ nginx.conf 配置文件
    ```
    location /api {
        lua_code_cache off;
        content_by_lua_file   /opt/openresty/nginx/conf/Lua/main.lua; # 绝对路径
        #content_by_lua_file  conf/Lua/main.lua;         # 相对路径（相对于nginx安装目录）
    }
    ```  
+ CURL 请求结果
    ```
    root@tinywan:/opt/openresty/nginx/conf/Lua# curl '127.0.0.1:80/api'
    Hello
    102
    ```
#### 绝对路径总结
+ 目录结果：`/opt/openresty/nginx/lua/resty`
+ 包路径：`package.path = package.path ..'/opt/openresty/nginx/lua/resty/?.lua;/opt/openresty/lualib/?.lua';`                                   
+ 加载绝对路径的Redis的二次封装库,redis_iresty.lua文件：
  ``` 
    package.path = package.path ..'/opt/openresty/nginx/lua/resty/?.lua;/opt/openresty/lualib/?.lua';
    local redis_c = require "resty.redis"
    local ok, new_tab = pcall(require, "table.new")
    if not ok or type(new_tab) ~= "function" then
        new_tab = function (narr, nrec) return {} end
    end
  ```   
+ Redis的二次封装库的应用，test_redis2.lua文件：
  ``` 
    package.path = '/opt/openresty/nginx/lua/?.lua;' -- 注意：这个最好是修改掉最好
    local redis = require("resty.redis_iresty")
    local red = redis:new()
    local ok, err = red:set("Redis1999", "Redis is an animal 1999")
    if not ok then
        ngx.say("failed to set dog: ", err)
        return
    end
  ```                                  
+ nginx.conf 配置文件(注意以下的目录路径和上面的不一样)
    ```
    location /api {
        lua_code_cache off;
        content_by_lua_file /opt/openresty/nginx/lua/test_redis2.lua;
    }
    ```  
+ CURL 请求结果
    ```
    root@tinywan:/opt/openresty/nginx/conf/Lua# curl '127.0.0.1:80/api'
    Hello
    102
    ```      
 + Redis 数据库结果
    ```
    127.0.0.1:6379> keys *
    1) "dog"
    2) "Redis2222222222"
    3) "Redis1999"
    ```                                
#### 项目实战目录介绍
+   公共配置nginx.conf `(/opt/openresty/nginx/conf/nginx.conf)`
    ```Lua
    worker_processes  2;
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
+   项目结构图
    ```Lua
    tinywan@tinywan:~/Openresty_Protect$ pwd
    /home/tinywan/Openresty_Protect
    tinywan@tinywan:~/Openresty_Protect$ tree -L 3
    .
    └── First_Protect
        ├── lua
        │   ├── functions.lua
        │   ├── get_redis_iresty.lua
        │   ├── get_redis.lua
        │   ├── main.lua
        │   └── test.lua
        ├── lualib
        │   ├── cjson.so
        │   ├── ngx
        │   ├── rds
        │   ├── redis
        │   └── resty
        └── nginx_first.conf
    ```
##### [1]单独项目配置文件
+   在这里我的所有项目放在`/home/tinywan/Openresty_Protect` 这个目录下面
+   这里我们拿第一个项目做测试，项目名称：`First_Protect`

+   nginx_first.conf 配置文件
    ```Lua 
    server {
        listen       80;
        server_name  _;
    
        location /lua {
            default_type 'text/html';
            lua_code_cache off;
            content_by_lua_file /home/tinywan/Openresty_Protect/First_Protect/lua/test.lua;
        }
    }
    ```
+   test.lua 文件内容：`ngx.say("Hello! First_Protect")`
+   CURL  请求测试结果：
    ```Lua 
    tinywan@tinywan:/opt/openresty/nginx/conf$ curl http://127.0.0.1/lua
    Hello! First_Protect
    ```
##### [2]测试引入官方库文件
+   get_redis.lua
    ```Lua
    local json = require("cjson")
    local redis = require("resty.redis")
    local red = redis:new()
    local get_args = ngx.req.get_uri_args()
    
    red:set_timeout(1000)
    
    local ip = "127.0.0.1"
    local port = 6379
    local ok, err = red:connect(ip, port)
    if not ok then
            ngx.say("connect to redis error : ", err)
            return ngx.exit(500)
    end
    
    local key = get_args["name"]
    local new_timer = ngx.localtime()
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
    ngx.say("First_Protect Success get Redis Data",json.encode({content=res}))
    ```
+   nginx_first.conf 配置文件
    ```Lua 
    server {
        listen       80;
        server_name  _;
    
        location /lua {
            default_type 'text/html';
            lua_code_cache off;
            content_by_lua_file /home/tinywan/Openresty_Protect/First_Protect/lua/get_redis.lua;
        }
    }
    ``` 
+   CURL 请求测试结果： 
    ```Lua 
    tinywan@$ curl -G -d  "name=Tinywan_github" http://127.0.0.1/lua_get_redis
    set result: OK
    First_Protect Success get Redis Data{"content":"Tinywan_github::2017-04-23 19:53:24"}
    ```      
##### [3]自己调用自己分装好的文件
+   Redis 接口的二次封装 redis_iresty.lua (路径：`/home/tinywan/Openresty_Protect/First_Protect/lualib/resty`) 
    ```Lua
    -- file name: resty/redis_iresty.lua
    local redis_c = require "resty.redis"
    
    local ok, new_tab = pcall(require, "table.new")
    if not ok or type(new_tab) ~= "function" then
        new_tab = function (narr, nrec) return {} end
    end
    
    local _M = new_tab(0, 155)
    _M._VERSION = '0.01'
    
    local commands = {
        "append",            "auth",              "bgrewriteaof",
        "bgsave",            "bitcount",          "bitop",
        "blpop",             "brpop",
        "brpoplpush",        "client",            "config",
        "dbsize",
        "debug",             "decr",              "decrby",
        "del",               "discard",           "dump",
        "echo",
        "eval",              "exec",              "exists",
        "expire",            "expireat",          "flushall",
        "flushdb",           "get",               "getbit",
        "getrange",          "getset",            "hdel",
        "hexists",           "hget",              "hgetall",
        "hincrby",           "hincrbyfloat",      "hkeys",
        "hlen",
        "hmget",              "hmset",      "hscan",
        "hset",
        "hsetnx",            "hvals",             "incr",
        "incrby",            "incrbyfloat",       "info",
        "keys",
        "lastsave",          "lindex",            "linsert",
        "llen",              "lpop",              "lpush",
        "lpushx",            "lrange",            "lrem",
        "lset",              "ltrim",             "mget",
        "migrate",
        "monitor",           "move",              "mset",
        "msetnx",            "multi",             "object",
        "persist",           "pexpire",           "pexpireat",
        "ping",              "psetex",            "psubscribe",
        "pttl",
        "publish",      --[[ "punsubscribe", ]]   "pubsub",
        "quit",
        "randomkey",         "rename",            "renamenx",
        "restore",
        "rpop",              "rpoplpush",         "rpush",
        "rpushx",            "sadd",              "save",
        "scan",              "scard",             "script",
        "sdiff",             "sdiffstore",
        "select",            "set",               "setbit",
        "setex",             "setnx",             "setrange",
        "shutdown",          "sinter",            "sinterstore",
        "sismember",         "slaveof",           "slowlog",
        "smembers",          "smove",             "sort",
        "spop",              "srandmember",       "srem",
        "sscan",
        "strlen",       --[[ "subscribe",  ]]     "sunion",
        "sunionstore",       "sync",              "time",
        "ttl",
        "type",         --[[ "unsubscribe", ]]    "unwatch",
        "watch",             "zadd",              "zcard",
        "zcount",            "zincrby",           "zinterstore",
        "zrange",            "zrangebyscore",     "zrank",
        "zrem",              "zremrangebyrank",   "zremrangebyscore",
        "zrevrange",         "zrevrangebyscore",  "zrevrank",
        "zscan",
        "zscore",            "zunionstore",       "evalsha"
    }
    
    local mt = { __index = _M }
    
    local function is_redis_null( res )
        if type(res) == "table" then
            for k,v in pairs(res) do
                if v ~= ngx.null then
                    return false
                end
            end
            return true
        elseif res == ngx.null then
            return true
        elseif res == nil then
            return true
        end
    
        return false
    end
    
    -- change connect address as you need
    function _M.connect_mod( self, redis )
        redis:set_timeout(self.timeout)
        return redis:connect("127.0.0.1", 6379)
    end
    
    function _M.set_keepalive_mod( redis )
        -- put it into the connection pool of size 100, with 60 seconds max idle time
        return redis:set_keepalive(60000, 1000)
    end
    
    function _M.init_pipeline( self )
        self._reqs = {}
    end
    
    function _M.commit_pipeline( self )
        local reqs = self._reqs
    
        if nil == reqs or 0 == #reqs then
            return {}, "no pipeline"
        else
            self._reqs = nil
        end
    
        local redis, err = redis_c:new()
        if not redis then
            return nil, err
        end
    
        local ok, err = self:connect_mod(redis)
        if not ok then
            return {}, err
        end
    
        redis:init_pipeline()
        for _, vals in ipairs(reqs) do
            local fun = redis[vals[1]]
            table.remove(vals , 1)
    
            fun(redis, unpack(vals))
        end
    
        local results, err = redis:commit_pipeline()
        if not results or err then
            return {}, err
        end
    
        if is_redis_null(results) then
            results = {}
            ngx.log(ngx.WARN, "is null")
        end
        -- table.remove (results , 1)
    
        self.set_keepalive_mod(redis)
    
        for i,value in ipairs(results) do
            if is_redis_null(value) then
                results[i] = nil
            end
        end
    
        return results, err
    end
    
    function _M.subscribe( self, channel )
        local redis, err = redis_c:new()
        if not redis then
            return nil, err
        end
    
        local ok, err = self:connect_mod(redis)
        if not ok or err then
            return nil, err
        end
    
        local res, err = redis:subscribe(channel)
        if not res then
            return nil, err
        end
    
        res, err = redis:read_reply()
        if not res then
            return nil, err
        end
    
        redis:unsubscribe(channel)
        self.set_keepalive_mod(redis)
    
        return res, err
    end
    
    local function do_command(self, cmd, ... )
        if self._reqs then
            table.insert(self._reqs, {cmd, ...})
            return
        end
    
        local redis, err = redis_c:new()
        if not redis then
            return nil, err
        end
    
        local ok, err = self:connect_mod(redis)
        if not ok or err then
            return nil, err
        end
    
        local fun = redis[cmd]
        local result, err = fun(redis, ...)
        if not result or err then
            -- ngx.log(ngx.ERR, "pipeline result:", result, " err:", err)
            return nil, err
        end
    
        if is_redis_null(result) then
            result = nil
        end
    
        self.set_keepalive_mod(redis)
    
        return result, err
    end
    
    for i = 1, #commands do
        local cmd = commands[i]
        _M[cmd] =
                function (self, ...)
                    return do_command(self, cmd, ...)
                end
    end
    
    function _M.new(self, opts)
        opts = opts or {}
        local timeout = (opts.timeout and opts.timeout * 1000) or 1000
        local db_index= opts.db_index or 0
    
        return setmetatable({
                timeout = timeout,
                db_index = db_index,
                _reqs = nil }, mt)
    end
    
    return _M
    ```
+   nginx_first.conf 配置文件
    ```Lua 
    server {
        listen       80;
        server_name  _;
    
        location /get_redis_iresty {
                default_type 'text/html';
                lua_code_cache off;
                content_by_lua_file /home/tinywan/Openresty_Protect/First_Protect/lua/get_redis_iresty.lua;
        }
    }
    ``` 
+   调用示例代码 get_redis_iresty.lua：
    ```Lua
    local redis = require "resty.redis_iresty"
    local red = redis:new()
    
    local ok, err = red:set("TinyAiAI", "an Boby")
    if not ok then
        ngx.say("failed to set: ", err)
        return
    end
    
    ngx.say("set result: ", ok)
    ``` 
+   CURL 请求测试结果： 
    ```Lua 
    tinywan@$ curl http://127.0.0.1/get_redis_iresty
    set result: OK
    ```              