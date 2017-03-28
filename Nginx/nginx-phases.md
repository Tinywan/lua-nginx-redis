## nginx的11个phases
+   一个请求经过nginx处理的过程中，会经过一系列的阶段（phases），下面这个表格列出了nginx的所有phases，每个阶段可选的退出方式，包含的模块和对应的指令

    | Phases | modules / directives  | description |
    | :------------ |:---------------:| -----:|
    | NGX_HTTP_POST_READ_PHASE     | HttpRealIpModule | 读取请求内容阶段 |
    | NGX_HTTP_SERVER_REWRITE_PHASE <br/> Location ( server rewrite )     | HttpRewriteModule <br/> rewrite    |   请求地址重写阶段|
    | NGX_HTTP_FIND_CONFIG_PHASE<br/> Location ( location selection )      |    HttpCoreModule <br/> location |配置查找阶段|
    | NGX_HTTP_REWRITE_PHASE <br/> Location ( location rewrite )      |    HttpLuaModule <br/> set_by_lua、rewrite_by_lua  |请求地址重写阶段|
    | NGX_HTTP_POST_REWRITE_PHASE      |    不注册其他模块 |请求地址重写提交阶段|
    | NGX_HTTP_PREACCESS_PHASE <br/>( location selection )      |    degradation <br/> NginxHttpLimitZoneModule / limit_zone<br/> HttpLimitReqModule / limit req |访问权限检查准备阶段|
    | NGX_HTTP_ACCESS_PHASE      |    HttpAccessModule <br/> allow, deny<br/>NginxHttpAuthBasicModule <br/> HttpLuaModule <br/> access_by_lua |访问权限检查阶段|
    | NGX_HTTP_POST_ACCESS_PHASE      |    该指令可以用于控制access阶段的指令彼此之间的协作方式 |访问权限检查提交阶段|
    | NGX_HTTP_TRY_FILES_PHASE     |    HttpCoreModule <br/> try_files |配置项try_files处理阶段|
    | NGX_HTTP_CONTENT_PHASE     |    HttpProxyModule / proxy <br/> HttpLuaModule / content_by_lua<br/>HttpCoreModule / proxy_pass<br/>HttpFcgiModule / FastCGI |内容产生阶段|
    | NGX_HTTP_TRY_FILES_PHASE     |    HttpLogModuel / access_log |日志模块处理阶段|

+   各个phase说明
    +   post read phase
        > nginx读取并解析完请求头之后就进入了post_read 阶段，它位于uri被重写之前，这个阶段允许nginx改变请求头中ip地址的值，相关模块HttpRealIpModule

    +   server_rewrite phase
        > 这个阶段主要进行初始化全局变量，或者server级别的重写。如果把重写指令放到 server 中，那么就进入了server rewrite 阶段。（重写指令见rewrite phase）   

    +   find config phase
        > 这个阶段使用重写之后的uri来查找对应的location，值得注意的是该阶段可能会被执行多次，因为也可能有location级别的重写指令。这个阶段并不支持 Nginx 模块注册处理程序，而是由 Nginx 核心来完成当前请求与 location 配置块之间的配对工作
    
    +   rewrite phase：
        > 如果把重写指令放到 location中，那么就进入了rewrite phase，这个阶段是location级别的uri重写阶段，重写指令也可能会被执行多次  

        > 有`HttpRewriteModule` 的set指令、rewrite指令      

        > HttpLuaModule的 set_by_lua指令,   

        > ngx_set_misc模块的set_unescape_uri指令   

        > 另外HttpRewriteModule的几乎所有指令都属于rewrite阶段。
+   结论：作用域为同一个phase的不同modules的指令，如果modules之间做了特殊的兼容，则它们按照指令在配置文件中出现的顺序依次执行下来
+   HttpLuaModule 模块指令
    +   init_by_lua
        > 在nginx重新加载配置文件时，运行里面lua脚本，常用于全局变量的申请。例如lua_shared_dict共享内存的申请，只有当nginx重起后，共享内存数据才清空，这常用于统计。  

    +   set_by_lua
        > 设置一个变量，常用与计算一个逻辑，然后返回结果,该阶段不能运行Output API、Control API、Subrequest API、Cosocket API

    +   rewrite_by_lua
        > 在access阶段前运行，主要用于rewrite

    +   access_by_lua
        > 主要用于访问控制，能收集到大部分变量，类似status需要在log阶段才有。这条指令运行于nginx access阶段的末尾，因此总是在 allow 和 deny 这样的指令之后运行，虽然它们同属 access 阶段。

    +   content_by_lua 
        > 阶段是所有请求处理阶段中最为重要的一个，运行在这个阶段的配置指令一般都肩负着生成内容（content）并输出HTTP响应。    

    +   header_filter_by_lua
        > 一般只用于设置Cookie和Headers等,该阶段不能运行Output API、Control API、Subrequest API、Cosocket API

    +   body_filter_by_lua
        > 一般会在一次请求中被调用多次, 因为这是实现基于 HTTP 1.1 chunked 编码的所谓“流式输出”的,该阶段不能运行Output API、Control API、Subrequest API、Cosocket API

    +   log_by_lua 
        > 该阶段总是运行在请求结束的时候，用于请求的后续操作，如在共享内存中进行统计数据,如果要高精确的数据统计，应该使用body_filter_by_lua                                