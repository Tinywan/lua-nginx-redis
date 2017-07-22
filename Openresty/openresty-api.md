#### <a name="Openresty_http_status_constants"/> ngx Lua APi 方法和常量  
+   ngx_lua 核心常量 
    ```lua
    ngx.OK (0)  
    ngx.ERROR (-1)  
    ngx.AGAIN (-2)  
    ngx.DONE (-4)  
    ngx.DECLINED (-5)  
    ngx.nil
    -- 指令常量
    ngx.arg[index]              #ngx指令参数，当这个变量在set_by_lua或者set_by_lua_file内使用的时候是只读的，指的是在配置指令输入的参数.  
    ngx.var.varname             #读写NGINX变量的值,最好在lua脚本里缓存变量值，避免在当前请求的生命周期内内存的泄漏  
    ngx.config.ngx_lua_version  #当前ngx_lua模块版本号  
    ngx.config.nginx_version    #nginx版本  
    ngx.worker.exiting          #当前worker进程是否正在关闭  
    ngx.worker.pid              #当前worker进程的PID  
    ngx.config.nginx_configure  #编译时的./configure命令选项  
    ngx.config.prefix           #编译时的prefix选项  
    ```
+   ngx_lua 方法 (#经常在ngx.location.catpure和ngx.location.capture_multi方法中被调用.)
    ```lua 
    ngx.HTTP_GET  
    ngx.HTTP_HEAD  
    ngx.HTTP_PUT  
    ngx.HTTP_POST  
    ngx.HTTP_DELETE  
    ngx.HTTP_OPTIONS    
    ngx.HTTP_MKCOL      
    ngx.HTTP_COPY        
    ngx.HTTP_MOVE       
    ngx.HTTP_PROPFIND   
    ngx.HTTP_PROPPATCH   
    ngx.HTTP_LOCK   
    ngx.HTTP_UNLOCK      
    ngx.HTTP_PATCH     
    ngx.HTTP_TRACE 
    ```
+   错误日志级别常量
    ```lua
    ngx.STDERR  
    ngx.EMERG  
    ngx.ALERT  
    ngx.CRIT  
    ngx.ERR  
    ngx.WARN  
    ngx.NOTICE  
    ngx.INFO  
    ngx.DEBUG 
    ```
+   API中的常用方法
    ```lua
    print()                         #与 ngx.print()方法有区别，print() 相当于ngx.log()  
    ngx.ctx                         #这是一个lua的table，用于保存ngx上下文的变量，在整个请求的生命周期内都有效,详细参考官方  
    ngx.location.capture()          #发出一个子请求，详细用法参考官方文档。  
    ngx.location.capture_multi()    #发出多个子请求，详细用法参考官方文档。  
    ngx.status                      #读或者写当前请求的相应状态. 必须在输出相应头之前被调用.  
    ngx.header.HEADER               #访问或设置http header头信息，详细参考官方文档。  
    ngx.req.set_uri()               #设置当前请求的URI,详细参考官方文档  
    ngx.set_uri_args(args)          #根据args参数重新定义当前请求的URI参数.  
    ngx.req.get_uri_args()          #返回一个LUA TABLE，包含当前请求的全部的URL参数  
    ngx.req.get_post_args()         #返回一个LUA TABLE，包括所有当前请求的POST参数  
    ngx.req.get_headers()           #返回一个包含当前请求头信息的lua table.  
    ngx.req.set_header()            #设置当前请求头header某字段值.当前请求的子请求不会受到影响.  
    ngx.req.read_body()             #在不阻塞ngnix其他事件的情况下同步读取客户端的body信息.[详细]  
    ngx.req.discard_body()          #明确丢弃客户端请求的body  
    ngx.req.get_body_data()         #以字符串的形式获得客户端的请求body内容  
    ngx.req.get_body_file()         #当发送文件请求的时候，获得文件的名字  
    ngx.req.set_body_data()         #设置客户端请求的BODY  
    ngx.req.set_body_file()         #通过filename来指定当前请求的file data。  
    ngx.req.clear_header()          #清求某个请求头  
    ngx.exec(uri,args)              #执行内部跳转，根据uri和请求参数  
    ngx.redirect(uri, status)       #执行301或者302的重定向。  
    ngx.send_headers()              #发送指定的响应头  
    ngx.headers_sent                #判断头部是否发送给客户端ngx.headers_sent=true  
    ngx.print(str)                  #发送给客户端的响应页面  
    ngx.say()                       #作用类似ngx.print，不过say方法输出后会换行  
    ngx.log(log.level,...)          #写入nginx日志  
    ngx.flush()                     #将缓冲区内容输出到页面（刷新响应）  
    ngx.exit(http-status)           #结束请求并输出状态码  
    ngx.eof()                       #明确指定关闭结束输出流  
    ngx.escape_uri()                #URI编码(本函数对逗号,不编码，而php的urlencode会编码)  
    ngx.unescape_uri()              #uri解码  
    ngx.encode_args(table)          #将tabel解析成url参数  
    ngx.decode_args(uri)            #将参数字符串编码为一个table  
    ngx.encode_base64(str)          #BASE64编码  
    ngx.decode_base64(str)          #BASE64解码  
    ngx.crc32_short(str)            #字符串的crs32_short哈希  
    ngx.crc32_long(str)             #字符串的crs32_long哈希  
    ngx.hmac_sha1(str)              #字符串的hmac_sha1哈希  
    ngx.md5(str)                    #返回16进制MD5  
    ngx.md5_bin(str)                #返回2进制MD5  
    ngx.today()                     #返回当前日期yyyy-mm-dd  
    ngx.time()                      #返回当前时间戳  
    ngx.now()                       #返回当前时间  
    ngx.update_time()               #刷新后返回  
    ngx.localtime()                 #返回 yyyy-mm-dd hh:ii:ss  
    ngx.utctime()                   #返回yyyy-mm-dd hh:ii:ss格式的utc时间  
    ngx.cookie_time(sec)            #返回用于COOKIE使用的时间  
    ngx.http_time(sec)              #返回可用于http header使用的时间        
    ngx.parse_http_time(str)        #解析HTTP头的时间  
    ngx.is_subrequest               #是否子请求（值为 true or false）  
    ngx.re.match(subject,regex,options,ctx)     #ngx正则表达式匹配，详细参考官网  
    ngx.re.gmatch(subject,regex,opt)            #全局正则匹配  
    ngx.re.sub(sub,reg,opt)         #匹配和替换（未知）  
    ngx.re.gsub()                   #未知  
    ngx.shared.DICT                 #ngx.shared.DICT是一个table 里面存储了所有的全局内存共享变量  
        ngx.shared.DICT.get    
        ngx.shared.DICT.get_stale      
        ngx.shared.DICT.set    
        ngx.shared.DICT.safe_set       
        ngx.shared.DICT.add    
        ngx.shared.DICT.safe_add       
        ngx.shared.DICT.replace    
        ngx.shared.DICT.delete     
        ngx.shared.DICT.incr       
        ngx.shared.DICT.flush_all      
        ngx.shared.DICT.flush_expired      
        ngx.shared.DICT.get_keys  
    ndk.set_var.DIRECTIVE          
    ```
+ Lua HTTP状态常量 
    ```Lua
   value = ngx.HTTP_CONTINUE (100) (first added in the v0.9.20 release)
   value = ngx.HTTP_SWITCHING_PROTOCOLS (101) (first added in the v0.9.20 release)
   value = ngx.HTTP_OK (200)
   value = ngx.HTTP_CREATED (201)
   value = ngx.HTTP_ACCEPTED (202) (first added in the v0.9.20 release)
   value = ngx.HTTP_NO_CONTENT (204) (first added in the v0.9.20 release)
   value = ngx.HTTP_PARTIAL_CONTENT (206) (first added in the v0.9.20 release)
   value = ngx.HTTP_SPECIAL_RESPONSE (300)
   value = ngx.HTTP_MOVED_PERMANENTLY (301)
   value = ngx.HTTP_MOVED_TEMPORARILY (302)
   value = ngx.HTTP_SEE_OTHER (303)
   value = ngx.HTTP_NOT_MODIFIED (304)
   value = ngx.HTTP_TEMPORARY_REDIRECT (307) (first added in the v0.9.20 release)
   value = ngx.HTTP_BAD_REQUEST (400)
   value = ngx.HTTP_UNAUTHORIZED (401)
   value = ngx.HTTP_PAYMENT_REQUIRED (402) (first added in the v0.9.20 release)
   value = ngx.HTTP_FORBIDDEN (403)
   value = ngx.HTTP_NOT_FOUND (404)
   value = ngx.HTTP_NOT_ALLOWED (405)
   value = ngx.HTTP_NOT_ACCEPTABLE (406) (first added in the v0.9.20 release)
   value = ngx.HTTP_REQUEST_TIMEOUT (408) (first added in the v0.9.20 release)
   value = ngx.HTTP_CONFLICT (409) (first added in the v0.9.20 release)
   value = ngx.HTTP_GONE (410)
   value = ngx.HTTP_UPGRADE_REQUIRED (426) (first added in the v0.9.20 release)
   value = ngx.HTTP_TOO_MANY_REQUESTS (429) (first added in the v0.9.20 release)
   value = ngx.HTTP_CLOSE (444) (first added in the v0.9.20 release)
   value = ngx.HTTP_ILLEGAL (451) (first added in the v0.9.20 release)
   value = ngx.HTTP_INTERNAL_SERVER_ERROR (500)
   value = ngx.HTTP_METHOD_NOT_IMPLEMENTED (501)
   value = ngx.HTTP_BAD_GATEWAY (502) (first added in the v0.9.20 release)
   value = ngx.HTTP_SERVICE_UNAVAILABLE (503)
   value = ngx.HTTP_GATEWAY_TIMEOUT (504) (first added in the v0.3.1rc38 release)
   value = ngx.HTTP_VERSION_NOT_SUPPORTED (505) (first added in the v0.9.20 release)
   value = ngx.HTTP_INSUFFICIENT_STORAGE (507) (first added in the v0.9.20 release)
    ```
+ 案列使用,get_string_md5.lua：
    ```Lua 
    local args = ngx.req.get_uri_args()
    local salt = args.salt
    if not salt then
            ngx.say(ngx.HTTP_BAD_REQUEST)
    end
    local string = ngx.md5(ngx.time()..salt)
    ngx.say(string)
    
    ```
+ curl 请求(-i 参数,输出时包括protocol头信息)：
    ```Bash 
    tinywan@tinywan:$ curl -i http://127.0.0.1/get_rand_string?salt=tinywan123
    HTTP/1.1 200 OK
    Server: openresty/1.11.2.1
    Date: Fri, 21 Apr 2017 14:27:16 GMT
    Content-Type: application/octet-stream
    Transfer-Encoding: chunked
    Connection: keep-alive
    ```    
#### <a name="Openresty_ngx_api_used"/> ngx Lua APi 介绍使用
+   强烈建议使用ngx Lua APi 接口`(非阻塞的)`，而不是Lua自身的API`(阻塞的)`,Lua 自身API会阻塞掉的
+   ngx_lua_api_test.lua 
    ```Lua 
    local json = require "cjson"    -- 引入cjson 扩展
    
    -- 同步读取客户端请求正文，而不会阻止Nginx事件循环
    ngx.req.read_body()
    local args = ngx.req.get_post_args()
    
    if not args or not args.info then
            ngx.say(ngx.HTTP_BAD_REQUEST)   -- ngx.HTTP_BAD_REQUEST (400)
    end
    
    local client_id = ngx.var.remote_addr
    local user_agent = ngx.req.get_headers()['user-agent'] or ""
    local info = ngx.decode_base64(args.info)
    
    local response = {}
    response.info = info
    response.client_id = client_id
    response.user_agent = user_agent
    
    ngx.say(json.encode(response))
    
    ```
+   CURL  Post 请求
    ```Lua 
    $ curl -i --data "info=b3ZlcmNvbWUud2FuQGdtYWlsLmNvbQ==" http://127.0.0.1/ngx_lua_api_test
    HTTP/1.1 200 OK
    Server: openresty/1.11.2.1
    Date: Sat, 22 Apr 2017 01:22:07 GMT
    Content-Type: application/octet-stream
    Transfer-Encoding: chunked
    Connection: keep-alive
    
    {"user_agent":"curl\/7.47.0","info":"overcome.wan@gmail.com","client_id":"127.0.0.1"}
    
    ```