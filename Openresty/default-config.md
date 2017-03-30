## dasd 

## 安装配置信息

+   配置信息

```
sudo ./configure --prefix=/opt/openresty 
--with-luajit 
--without-http_redis2_module 
--with-http_iconv_module 
--with-stream 
--with-stream_ssl_module 
--with-http_ssl_module 
--add-module=../stream-lua-nginx-module
```
+   默认安装的模块为
```
--prefix=/opt/openresty/nginx 
--with-cc-opt=-O2                                           -- 默认安装
--add-module=../ngx_devel_kit-0.3.0                         -- 默认安装
--add-module=../iconv-nginx-module-0.14                     -- NO
--add-module=../echo-nginx-module-0.60                      -- 默认安装
--add-module=../xss-nginx-module-0.05                       -- 默认安装
--add-module=../ngx_coolkit-0.2rc3                          -- 默认安装
--add-module=../set-misc-nginx-module-0.31 
--add-module=../form-input-nginx-module-0.12 
--add-module=../encrypted-session-nginx-module-0.06 
--add-module=../srcache-nginx-module-0.31 
--add-module=../ngx_lua-0.10.6 
--add-module=../ngx_lua_upstream-0.06 
--add-module=../headers-more-nginx-module-0.31 
--add-module=../array-var-nginx-module-0.05 
--add-module=../memc-nginx-module-0.17 
--add-module=../redis-nginx-module-0.3.7 
--add-module=../rds-json-nginx-module-0.14 
--add-module=../rds-csv-nginx-module-0.07 
--with-ld-opt=-Wl,-rpath,/opt/openresty/luajit/lib 
--with-stream 
--with-stream_ssl_module 
--with-http_ssl_module 
--add-module=/home/tinywan/openresty-1.11.2.1/../stream-lua-nginx-module
```

#### Nginx.conf 配置选项详解
+   `--with-http_realip_module` 选项
    > 通过这个模块允许我们改变客户端请求头中客户端IP地址值(例如，X-Real-IP 或 X-Forwarded-For)   

    > 配置示例
         
    ```
    set_real_ip_from   192.168.1.0/24;
    set_real_ip_from   192.168.2.1;
    real_ip_header     X-Real-IP;
    ```
    > [--with-http_realip_module 选项（后台Nginx服务器记录原始客户端的IP地址 ）](http://blog.csdn.net/cscrazybing/article/details/50789234)
