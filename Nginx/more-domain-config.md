##  Nginx 同一个IP上配置多个HTTPS主机
+   [Nginx 同一个IP上配置多个HTTPS主机](http://www.ttlsa.com/web/multiple-https-host-nginx-with-a-ip-configuration/)
+   域名列表

    | 序号 | 名称 | 域名  | HTTPS主机 | 
    | :--: |:--: |:---------------:| :-----| 
    | 1  | 官方域名 | www.tinywan.com | https://www.tinywan.com/ | 
    | 2  | 直播域名 | live.tinywan.com | https://live.tinywan.com/ |
    | 3  | 点播域名 | vod.tinywan.com | https://vod.tinywan.com/ |
    | 4  | 文档域名 | doc.tinywan.com | https://doc.tinywan.com/ |

+   Openresty 编译
    
    ```bash
    www@TinywanAliYun:~/DEMO/openresty-1.11.2.5$ 
    ./configure --prefix=/usr/local/openresty --with-luajit \
    --with-http_ssl_module --with-openssl=/usr/local/openssl \
    --with-openssl-opt="enable-tlsext" --without-http_redis2_module \
    --with-http_iconv_module --with-http_stub_status_module \
    --with-http_xslt_module --add-dynamic-module=/home/www/DEMO/nginx-ts-module \
    --add-dynamic-module=/home/www/DEMO/nginx-rtmp-module
    ...
    make
    sudo make install
    ```
    > 注意添加配置：`--with-openssl-opt="enable-tlsext" `,默认情况下是`TLS SNI support disabled`
+   `Nginx.conf`配置文件： 
    +   配置文件列表
    
        ```bash
        www@TinywanAliYun:/usr/local/openresty/nginx/conf/vhost$ ls
        doc.tinywan.com.conf  live_rtmp_hls.conf  live.tinywan.com.conf  
        main.conf  vod.tinywan.com.conf  www.tinywan.com.conf
        ```
    +   `nginx.conf`
        
        ```bash
        http {
            ...
            index  index.php index.html index.htm;
            include "/usr/local/openresty/nginx/conf/vhost/*.conf";
        }
        ```
    +   `main.conf`
        
        ```bash
        # 配置HTTP请求重定向
        server {
            listen       80;
            server_name  www.tinywan.com; #live.tinywan.com vod.tinywan.com;
            rewrite ^ https://$http_host$request_uri? permanent;   
        }
        ```       
    +   `www.tinywan.com.conf`
     
        ```bash
        server {
            #listen       80;
            listen       443 ssl;
            server_name  www.tinywan.com;
            set $root_path /home/www/web/go-study-line/public;
            root $root_path;
        
            ssl on;
            ssl_certificate      /etc/letsencrypt/live/www.tinywan.com/fullchain.pem;
            ssl_certificate_key  /etc/letsencrypt/live/www.tinywan.com//privkey.pem;
            server_tokens off;
        
            location / {
                #access_by_lua_file /usr/local/openresty/nginx/conf/lua_script/resty-limit-req.lua;
                if (!-e $request_filename) {
                    rewrite  ^(.*)$  /index.php?s=/$1  last;
                    break;
                }
            }
        
            location = /favicon.ico {
                log_not_found off;
            }
        
            location ~ \.php$ {
                #access_by_lua_file /usr/local/openresty/nginx/conf/lua_script/resty-limit-req.lua;
                fastcgi_pass   unix:/var/run/php7.1.8-fpm.sock;
                fastcgi_index  index.php;
                fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                include        fastcgi_params;
                fastcgi_buffer_size 128k;
                fastcgi_buffers 4 256k;
                fastcgi_busy_buffers_size 256k;
                fastcgi_connect_timeout 300;
                fastcgi_send_timeout 300;
                fastcgi_read_timeout 300;
            }
        }
        ```    
    +   `live.tinywan.com.conf`
     
        ```bash
        # live.tinywan.com
        server{
            listen       443 ssl;
            server_name  live.tinywan.com;
        
            root /home/www/web/live.tinywan.com;
        
            ssl on;
            ssl_certificate      /etc/letsencrypt/live/www.tinywan.com/fullchain.pem;
            ssl_certificate_key  /etc/letsencrypt/live/www.tinywan.com//privkey.pem;
            server_tokens off;
        
        }
        ```    
    +   `vod.tinywan.com.conf`
     
        ```bash
        # vod.tinywan.com
        server{
            listen       443 ssl;
            server_name  vod.tinywan.com;
        
            root /home/www/web/vod.tinywan.com;
        
            ssl on;
            ssl_certificate      /etc/letsencrypt/live/www.tinywan.com/fullchain.pem;
            ssl_certificate_key  /etc/letsencrypt/live/www.tinywan.com//privkey.pem;
            server_tokens off;
        
        }
        ```    
    +   `doc.tinywan.com.conf`
     
        ```bash
        # doc.tinywan.com
        server{
            listen       443 ssl;
            server_name  doc.tinywan.com;
        
            root /home/www/web/doc.tinywan.com;
        
            ssl on;
            ssl_certificate      /etc/letsencrypt/live/www.tinywan.com/fullchain.pem;
            ssl_certificate_key  /etc/letsencrypt/live/www.tinywan.com//privkey.pem;
            server_tokens off;
        
        }
        ```                    
   