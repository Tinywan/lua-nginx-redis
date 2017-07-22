+   <a name="Openresty_install_knowledge"/>[安装信息](http://www.cnblogs.com/tinywan/p/6647587.html)
+   [默认配置信息](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/default-config.md)
+   开发入门
    + Nginx与Lua的整体目录关系
        ```javascript
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
            请求案例：`curl -d "name=Tinywan&age=24" http://127.0.0.1/lua_request/123/789`      
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