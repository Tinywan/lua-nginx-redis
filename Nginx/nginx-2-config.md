
## Nginx 编译安装以及参数详解
#### Nginx安装
```
# wget http://nginx.org/download/nginx-1.10.2.tar.gz
# tar xvf nginx-1.10.2.tar.gz -C /usr/local/src
# yum groupinstall "Development too
# yum -y install gcc wget gcc-c++ automake autoconf \
-- libtool libxml2-devel libxslt-devel perl-devel \
--perl-ExtUtils-Embed pcre-devel openssl-devel
# cd /usr/local/src/nginx-1.10.2
# ./configure \
--prefix=/usr/local/nginx \                         指向安装目录
--sbin-path=/usr/sbin/nginx \                       指向（执行）程序文件（nginx）
--conf-path=/etc/nginx/nginx.conf \                 指向配置文件（nginx.conf）
--error-log-path=/var/log/nginx/error.log \         指向错误日志目录
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \                     指向pid文件（nginx.pid）
--lock-path=/var/run/nginx.lock \                   指向lock文件（nginx.lock）（安装文件锁定，防止安装文件被别人利用，或自己误操作。）
--http-client-body-temp-path=/var/tmp/nginx/client \
--http-proxy-temp-path=/var/tmp/nginx/proxy \
--http-fastcgi-temp-path=/var/tmp/nginx/fcgi \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
--http-scgi-temp-path=/var/tmp/nginx/scgi \
--user=nginx \          指定程序运行时的非特权用户
--group=nginx \         指定程序运行时的非特权用户组
--with-pcre \           启用pcre库
--with-http_v2_module \
--with-http_ssl_module \        启用ngx_http_ssl_module支持（使支持https请求，需已安装openssl）
--with-http_realip_module \     启用ngx_http_realip_module支持（这个模块允许从请求标头更改客户端的IP地址值，默认为关）
--with-http_addition_module \
--with-http_sub_module \        启用ngx_http_sub_module支持（允许用一些其他文本替换nginx响应中的一些文本）
--with-http_dav_module \        启用ngx_http_dav_module支持（增加PUT,DELETE,MKCOL：创建集合,COPY和MOVE方法）默认情况下为关闭，需编译开启
--with-http_flv_module \        启用ngx_http_flv_module支持（提供寻求内存使用基于时间的偏移量文件）
--with-http_mp4_module \
--with-http_gunzip_module \         禁用ngx_http_gzip_module支持（该模块同-with-http_gzip_static_module功能一样）
--with-http_gzip_static_module \        启用ngx_http_gzip_static_module支持（在线实时压缩输出数据流）
--with-http_random_index_module \       启用ngx_http_random_index_module支持（从目录中随机挑选一个目录索引）
--with-http_secure_link_module \        启用ngx_http_secure_link_module支持（计算和检查要求所需的安全链接网址）
--with-http_stub_status_module \        启用ngx_http_stub_status_module支持（获取nginx自上次启动以来的工作状态）
--with-http_auth_request_module \       禁用ngx_http_auth_basic_module（该模块是可以使用用户名和密码基于http基本认证方法来保护你的站点或其部分内容）
-–without-http_access_module            禁用ngx_http_access_module支持（该模块提供了一个简单的基于主机的访问控制。允许/拒绝基于ip地址）
–-without-http_autoindex_module         禁用disable ngx_http_autoindex_module支持（该模块用于自动生成目录列表，只在ngx_http_index_module模块未找到索引文件时发出请求。）
–-without-http_geo_module               禁用ngx_http_geo_module支持（创建一些变量，其值依赖于客户端的IP地址
-–without-http_map_module                禁用ngx_http_map_module支持（使用任意的键/值对设置配置变量） 
–-without-http_split_clients_module     禁用ngx_http_split_clients_module支持（该模块用来基于某些条件划分用户。条件如：ip地址、报头、cookies等等） 
–-without-http_referer_module            禁用disable ngx_http_referer_module支持（该模块用来过滤请求，拒绝报头中Referer值不正确的请求） 
–-without-http_rewrite_module            禁用ngx_http_rewrite_module支持（该模块允许使用正则表达式改变URI，并且根据变量来转向以及选择配置
–-without-http_proxy_module              禁用ngx_http_proxy_module支持（有关代理服务器）
-–without-http_fastcgi_module            禁用ngx_http_fastcgi_module支持（该模块允许Nginx 与FastCGI 进程交互，并通过传递参数来控制FastCGI 进程工作。 ）FastCGI一个常驻型的公共网关接口。
–-without-http_upstream_ip_hash_module   禁用ngx_http_upstream_ip_hash_module支持（该模块用于简单的负载均衡） 
-–with-http_perl_module                  启用ngx_http_perl_module支持（该模块使nginx可以直接使用perl或通过ssi调用perl） 
–-with-perl_modules_path=                设定perl模块路径 
-–with-perl=                             设定perl库文件路径 
-–http-log-path=                    设定access log路径 
-–http-client-body-temp-path=           设定http客户端请求临时文件路径 
-–http-proxy-temp-path=             设定http代理临时文件路径 
-–http-fastcgi-temp-path=           设定http fastcgi临时文件路径 
-–http-uwsgi-temp-path=             设定http uwsgi临时文件路径 
–-http-scgi-temp-path=              设定http scgi临时文件路径 
--without-http                      禁用http server功能 
-–without-http-cache                禁用http cache功能 
-–with-mail                         启用POP3/IMAP4/SMTP代理模块支持 
-–with-mail_ssl_module              启用ngx_mail_ssl_module支持 
-–without-mail_pop3_module          禁用pop3协议
--with-file-aio \
--with-ipv6 \            启用ipv6支持
--with-http_v2_module \
--with-threads \
--with-stream \
-–with-libatomic=               指向libatomic_ops安装目录 
-–with-openssl=                 指向openssl安装目录 
-–with-openssl-opt              在编译时为openssl设置附加参数 
-–with-debug                    启用debug日志
--with-stream_ssl_module
# make && make install
# mkdir -pv /var/tmp/nginx/client
```

#### 启动关闭重置Nginx
*   启动：直接执行以下命令,nginx就启动了,不需要改任何配置文件
```
/usr/local/nginx -1.5.1/sbin/nginx
```
*   关闭
```
/usr/local/nginx -1.5.1/sbin/nginx -s stop
```
*   重启
```
/usr/local/nginx -1.5.1/sbin/nginx -s reload
```
C:\Program Files\Git\bin

#### nginx root&alias文件路径配置
nginx指定文件路径有两种方式root和alias，这两者的用法区别，使用方法总结了下，方便大家在应用过程中，快速响应。root与alias主要区别在于nginx如何解释location后面的uri，这会使两者分别以不同的方式将请求映射到服务器文件上。

```
location /abc/ {
    alias /home/html/def/;
}
```
alias会把location后面配置的路径丢弃掉，把当前匹配到的目录指向到指定的目录。如果一个请求的URI是/abc/a.ttlsa.com/favicon.jgp时，web服务器将会返回服务器上的/home/html/def/a.ttlsa.com/favicon.jgp的文件。

###### alias注意要点

> 1.使用alias时，目录名后面一定要加”/”`。

> 2.alias可以指定任何名称。 

> 3.alias在使用正则匹配时，必须捕捉要匹配的内容并在指定的内容处使用。 

> 4.alias只能位于location块中