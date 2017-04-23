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
+ 相对路径总结（相对于nginx安装目录）
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
+ 绝对路径总结
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
                   