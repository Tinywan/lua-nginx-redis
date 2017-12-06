
#### 基础配置文件
---
+ 完整基础配置nginx.conf 
```
user       www www;  ## Default: nobody
worker_processes  5;  ## Default: 1
error_log  logs/error.log;
pid        logs/nginx.pid;
worker_rlimit_nofile 8192;

events {
  worker_connections  4096;  ## Default: 1024
}

http {
  include    conf/mime.types;
  include    /etc/nginx/proxy.conf;
  include    /etc/nginx/fastcgi.conf;
  index    index.html index.htm index.php;

  default_type application/octet-stream;
  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log   logs/access.log  main;
  sendfile     on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts

  server { # php/fastcgi
    listen       80;
    server_name  domain1.com www.domain1.com;
    access_log   logs/domain1.access.log  main;
    root         html;

    location ~ \.php$ {
      fastcgi_pass   127.0.0.1:1025;
    }
  }

  server { # simple reverse-proxy
    listen       80;
    server_name  domain2.com www.domain2.com;
    access_log   logs/domain2.access.log  main;

    # serve static files
    location ~ ^/(images|javascript|js|css|flash|media|static)/  {
      root    /var/www/virtual/big.server.com/htdocs;
      expires 30d;
    }

    # pass requests for dynamic content to rails/turbogears/zope, et al
    location / {
      proxy_pass      http://127.0.0.1:8080;
    }
  }

  upstream big_server_com {
    server 127.0.0.3:8000 weight=5;
    server 127.0.0.3:8001 weight=5;
    server 192.168.0.1:8000;
    server 192.168.0.1:8001;
  }

  server { # simple load balancing
    listen          80;
    server_name     big.server.com;
    access_log      logs/big.server.access.log main;

    location / {
      proxy_pass      http://big_server_com;
    }
  }
}
```
+ proxy_conf 扩展参数
```
proxy_redirect          off;
proxy_set_header        Host            $host;
proxy_set_header        X-Real-IP       $remote_addr;
proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
client_max_body_size    10m;
client_body_buffer_size 128k;
proxy_connect_timeout   90;
proxy_send_timeout      90;
proxy_read_timeout      90;
proxy_buffers           32 4k;
```
+ fastcgi_conf 扩展参数
```
fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;
fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;

fastcgi_index  index.php;

fastcgi_param  REDIRECT_STATUS    200;         32 4k;
```
+ mime_types 扩展参数
```
types {
  text/html                             html htm shtml;
  text/css                              css;
  text/xml                              xml rss;
  image/gif                             gif;
  image/jpeg                            jpeg jpg;
  application/x-javascript              js;
  text/plain                            txt;
  text/x-component                      htc;
  text/mathml                           mml;
  image/png                             png;
  image/x-icon                          ico;
  image/x-jng                           jng;
  image/vnd.wap.wbmp                    wbmp;
  application/java-archive              jar war ear;
  application/mac-binhex40              hqx;
  application/pdf                       pdf;
  application/x-cocoa                   cco;
  application/x-java-archive-diff       jardiff;
  application/x-java-jnlp-file          jnlp;
  application/x-makeself                run;
  application/x-perl                    pl pm;
  application/x-pilot                   prc pdb;
  application/x-rar-compressed          rar;
  application/x-redhat-package-manager  rpm;
  application/x-sea                     sea;
  application/x-shockwave-flash         swf;
  application/x-stuffit                 sit;
  application/x-tcl                     tcl tk;
  application/x-x509-ca-cert            der pem crt;
  application/x-xpinstall               xpi;
  application/zip                       zip;
  application/octet-stream              deb;
  application/octet-stream              bin exe dll;
  application/octet-stream              dmg;
  application/octet-stream              eot;
  application/octet-stream              iso img;
  application/octet-stream              msi msp msm;
  audio/mpeg                            mp3;
  audio/x-realaudio                     ra;
  video/mpeg                            mpeg mpg;
  video/quicktime                       mov;
  video/x-flv                           flv;
  video/x-msvideo                       avi;
  video/x-ms-wmv                        wmv;
  video/x-ms-asf                        asx asf;
  video/x-mng                           mng;
}
```
+ 生产环境的完整配置nginx.conf 
```
user  www www;
worker_processes  2;
pid /var/run/nginx.pid;

# [ debug | info | notice | warn | error | crit ]
error_log  /var/log/nginx.error_log  info;

events {
  worker_connections   2000;
  # use [ kqueue | rtsig | epoll | /dev/poll | select | poll ] ;
  use kqueue;
}

http {
  include       conf/mime.types;
  default_type  application/octet-stream;

  log_format main      '$remote_addr - $remote_user [$time_local]  '
    '"$request" $status $bytes_sent '
    '"$http_referer" "$http_user_agent" '
    '"$gzip_ratio"';

  log_format download  '$remote_addr - $remote_user [$time_local]  '
    '"$request" $status $bytes_sent '
    '"$http_referer" "$http_user_agent" '
    '"$http_range" "$sent_http_content_range"';

  client_header_timeout  3m;
  client_body_timeout    3m;
  send_timeout           3m;

  client_header_buffer_size    1k;
  large_client_header_buffers  4 4k;

  gzip on;
  gzip_min_length  1100;
  gzip_buffers     4 8k;
  gzip_types       text/plain;

  output_buffers   1 32k;
  postpone_output  1460;

  sendfile         on;
  tcp_nopush       on;

  tcp_nodelay      on;
  send_lowat       12000;

  keepalive_timeout  75 20;

  # lingering_time     30;
  # lingering_timeout  10;
  # reset_timedout_connection  on;


  server {
    listen        one.example.com;
    server_name   one.example.com  www.one.example.com;

    access_log   /var/log/nginx.access_log  main;

    location / {
      proxy_pass         http://127.0.0.1/;
      proxy_redirect     off;

      proxy_set_header   Host             $host;
      proxy_set_header   X-Real-IP        $remote_addr;
      # proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;

      client_max_body_size       10m;
      client_body_buffer_size    128k;

      client_body_temp_path      /var/nginx/client_body_temp;

      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_send_lowat           12000;

      proxy_buffer_size          4k;
      proxy_buffers              4 32k;
      proxy_busy_buffers_size    64k;
      proxy_temp_file_write_size 64k;

      proxy_temp_path            /var/nginx/proxy_temp;

      charset  koi8-r;
    }

    error_page  404  /404.html;

    location /404.html {
      root  /spool/www;

      charset         on;
      source_charset  koi8-r;
    }

    location /old_stuff/ {
      rewrite   ^/old_stuff/(.*)$  /new_stuff/$1  permanent;
    }

    location /download/ {
      valid_referers  none  blocked  server_names  *.example.com;

      if ($invalid_referer) {
        #rewrite   ^/   http://www.example.com/;
        return   403;
      }

      # rewrite_log  on;
      # rewrite /download/*/mp3/*.any_ext to /download/*/mp3/*.mp3
      rewrite ^/(download/.*)/mp3/(.*)\..*$ /$1/mp3/$2.mp3 break;

      root         /spool/www;
      # autoindex    on;
      access_log   /var/log/nginx-download.access_log  download;
    }

    location ~* ^.+\.(jpg|jpeg|gif)$ {
      root         /spool/www;
      access_log   off;
      expires      30d;
    }

    location ~ \.php$ {
            fastcgi_pass unix:/var/run/php7.0.9-fpm.sock;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
    }

  }
}
```
          
