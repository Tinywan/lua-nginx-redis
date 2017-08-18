##  在Ubuntu 16.04中如何从源代码编译Nginx
+   NGINX可用作HTTP / HTTPS服务器，反向代理服务器，邮件代理服务器，负载均衡器，TLS终结器或缓存服务器。它是相当模块化的设计。它具有由社区创建的本机模块和第三方模块。以C编程语言编写，它是一个非常快速和轻便的软件。
####    从源头构建NGINX的要求,强制性要求：
+   OpenSSL库版本介于1.0.2 - 1.1.0之间
+   Zlib库版本介于1.1.3 - 1.2.11之间
+   PCRE库版本在4.4 - 8.40之间
+   GCC编译器
####    可选要求：
+   PERL
+   LIBATOMIC_OPS
+   LibFD
+   MaxMind GeoIP
+   libxml2的
+   libxslt
####    开始之前
+   创建普通用户`sudo`访问。
+   切换到新用户：`su - <username>`
+   更新系统：`sudo apt update && sudo apt upgrade -y`
####    从源代码构建NGINX
+   1、NGINX是用C编写的程序，所以我们需要安装C编译器（GCC）。

    sudo apt install build-essential -y
    
+   2、下载最新版本的NGINX源代码并解压缩：

    wget https://nginx.org/download/nginx-1.13.1.tar.gz && tar zxvf nginx-1.13.1.tar.gz
    
+   3、下载NGINX依赖项的源代码并解压缩
    > NGINX依赖于3个库：PCRE，zlib和OpenSSL：
    
    # PCRE version 4.4 - 8.40
    wget https://ftp.pcre.org/pub/pcre/pcre-8.40.tar.gz && tar xzvf pcre-8.40.tar.gz
    
    # zlib version 1.1.3 - 1.2.11
    wget http://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz
    
    # OpenSSL version 1.0.2 - 1.1.0
    wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz && tar xzvf openssl-1.1.0f.tar.gz
    
+   4、删除所有.tar.gz文件。我们不再需要了

    wget https://nginx.org/download/nginx-1.13.1.tar.gz && tar zxvf nginx-1.13.1.tar.gz

+   5、转到NGINX源目录：``

    cd ~/nginx-1.13.1

+   6、有关帮助，您可以通过运行以下列出可用的配置开关

    ./configure --help

+   7、配置，编译和安装NGINX：

    ./configure --prefix=/usr/share/nginx \
                --sbin-path=/usr/sbin/nginx \
                --modules-path=/usr/lib/nginx/modules \
                --conf-path=/etc/nginx/nginx.conf \
                --error-log-path=/var/log/nginx/error.log \
                --http-log-path=/var/log/nginx/access.log \
                --pid-path=/run/nginx.pid \
                --lock-path=/var/lock/nginx.lock \
                --user=www-data \
                --group=www-data \
                --build=Ubuntu \
                --http-client-body-temp-path=/var/lib/nginx/body \
                --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
                --http-proxy-temp-path=/var/lib/nginx/proxy \
                --http-scgi-temp-path=/var/lib/nginx/scgi \
                --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
                --with-openssl=../openssl-1.1.0f \
                --with-openssl-opt=enable-ec_nistp_64_gcc_128 \
                --with-openssl-opt=no-nextprotoneg \
                --with-openssl-opt=no-weak-ssl-ciphers \
                --with-openssl-opt=no-ssl3 \
                --with-pcre=../pcre-8.40 \
                --with-pcre-jit \
                --with-zlib=../zlib-1.2.11 \
                --with-compat \
                --with-file-aio \
                --with-threads \
                --with-http_addition_module \
                --with-http_auth_request_module \
                --with-http_dav_module \
                --with-http_flv_module \
                --with-http_gunzip_module \
                --with-http_gzip_static_module \
                --with-http_mp4_module \
                --with-http_random_index_module \
                --with-http_realip_module \
                --with-http_slice_module \
                --with-http_ssl_module \
                --with-http_sub_module \
                --with-http_stub_status_module \
                --with-http_v2_module \
                --with-http_secure_link_module \
                --with-mail \
                --with-mail_ssl_module \
                --with-stream \
                --with-stream_realip_module \
                --with-stream_ssl_module \
                --with-stream_ssl_preread_module \
                --with-debug \
                --with-cc-opt='-g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security 
                -Wdate-time -D_FORTIFY_SOURCE=2' \
                --with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now'
    make 
    sudo make install
    
+   8、从主目录中删除所有下载的文件，在这种情况下/home/username：

     cd ~
     rm -r nginx-1.13.1/ openssl-1.1.0f/ pcre-8.40/ zlib-1.2.11/

+   9、检查NGINX版本和编译时间选项：
    ```bash
     sudo nginx -v && sudo nginx -V
     
     # nginx version: nginx/1.13.0 (Ubuntu)
     # built by gcc 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4)
     # built with OpenSSL 1.1.0f  25 May 2017
     # TLS SNI support enabled
     # configure arguments: --prefix=/etc/nginx . . .
     # . . .
     # . . .  
    ``` 
+   10、检查语法和潜在错误：
    ```bash
    sudo nginx -t
    # Will throw this error nginx: [emerg] mkdir() "/var/lib/nginx/body" failed (2: No such file or directory)
    # Just create directory
    mkdir -p /var/lib/nginx && sudo nginx -t
    ```
+   11、为NGINX创建systemd单元文件：
    ```bash
    sudo vim /etc/systemd/system/nginx.service
    ```
+   12、复制/粘贴以下内容：
    > 注意：根据NGINX的编译方式，PID文件和NGINX二进制文件的位置可能不同。
    ```bash
    [Unit]
    Description=A high performance web server and a reverse proxy server
    After=network.target
    
    [Service]
    Type=forking
    PIDFile=/run/nginx.pid
    ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
    ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
    ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
    ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
    TimeoutStopSec=5
    KillMode=mixed
    
    [Install]
    WantedBy=multi-user.target
    ```
+   13、启动并启用NGINX服务：
    ```bash
    sudo systemctl start nginx.service && sudo systemctl enable nginx.service
    ```
+   14、检查NGINX是否在重启后启动：
    ```bash
    sudo systemctl is-enabled nginx.service
    # enabled
    ```
+   15、检查NGINX是否正在运行：
    ```bash
    sudo systemctl status nginx.service
    ps aux | grep nginx
    curl -I 127.0.0.1
    ```
+   16、重新启动Ubuntu VPS以验证NGINX是否自动启动：
    ```bash
    sudo shutdown -r now
    ```
+   17、创建UFW NGINX应用程序配置文件：    
    ```bash
    sudo vim /etc/ufw/applications.d/nginx
    ```
+   18、复制/粘贴以下内容：   
    ```bash
    [Nginx HTTP]
    title=Web Server (Nginx, HTTP)
    description=Small, but very powerful and efficient web server
    ports=80/tcp
    
    [Nginx HTTPS]
    title=Web Server (Nginx, HTTPS)
    description=Small, but very powerful and efficient web server
    ports=443/tcp
    
    [Nginx Full]
    title=Web Server (Nginx, HTTP + HTTPS)
    description=Small, but very powerful and efficient web server
    ports=80,443/tcp
    ```
+   19、现在，验证UFW应用配置文件是否被创建和识别：
    ```bash
    sudo ufw app list
    
    # Available applications:
      # Nginx Full
      # Nginx HTTP
      # Nginx HTTPS
      # OpenSSH
    ```
### Build

cd to NGINX source directory & run this:

    ./configure --add-module=/path/to/nginx-rtmp-module
    make
    make install    