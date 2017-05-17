+   Nginx查看并发连接数
    +   编译添加选项：`--with-http_stub_status_module`
    +   Openresty编译:
        ```javascript
        ./configure --prefix=/opt/openresty 
        --with-http_iconv_module 
        --pid-path=/var/run/nginx.pid 
        --with-http_realip_module 
        --with-http_ssl_module 
        --with-http_stub_status_module
        ```
    +   配置文件
        ```javascript
            location /nginx_status {
              stub_status on;
              access_log off;
              allow 127.0.0.1;
              deny all;
            }
        ```    
    +   观看地址：`http://127.0.0.1/nginx_status`
    +   nginx status详解
        -   `active connections` – 活跃的连接数量
        -   `server accepts handled requests` — 总共处理了11989个连接 , 成功创建11989次握手, 总共处理了11991个请求
        -   `reading ` — 读取客户端的连接数.
        -   `writing ` — 响应数据到客户端的数量.
        -   `waiting ` — 开启 keep-alive 的情况下,这个值等于 active – (reading+writing), 意思就是 Nginx 已经处理完正在等候下一次请求指令的驻留连接.