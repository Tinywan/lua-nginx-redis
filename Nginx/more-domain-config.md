##  Nginx单IP多域名配置

+  域名列表

| 序号 | 域名  | 根目录 | 
| :------------ |:---------------:| :-----| 
| 1    | www.tinywan.com | https://www.tinywan.com/ | 
| 2    | www.tinywan.com | https://www.tinywan.com/ |
| 3    | www.tinywan.com | https://www.tinywan.com/ |

./configure --prefix=/opt/openresty --with-luajit --with-http_ssl_module \
--with-openssl=/usr/local/openssl --with-openssl-opt="enable-tlsext" \
--without-http_redis2_module --with-http_iconv_module \ 
--with-http_stub_status_module --with-http_xslt_module \
--add-dynamic-module=/home/www/DEMO/nginx-ts-module \
--add-dynamic-module=/home/www/DEMO/nginx-rtmp-module