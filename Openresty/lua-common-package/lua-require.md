![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/nginx-hls-locations.png)
### Lua require 相对路径
+ [Lua require 相对路径 博客园详解](http://www.cnblogs.com/smallboat/p/5552407.html)
+ 亲自试验总结
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
            content_by_lua_file  /opt/openresty/nginx/conf/Lua/main.lua;
        }
        ```  
    + CURL 请求结果
        ```
        root@tinywan:/opt/openresty/nginx/conf/Lua# curl '127.0.0.1:80/api'
        Hello
        102
        ```           