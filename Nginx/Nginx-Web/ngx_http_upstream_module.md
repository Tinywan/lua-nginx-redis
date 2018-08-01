## 详解：Nginx 反向代理、后端检测模块

#### Nginx

```
shell > yum -y install gcc gcc-c++ make wget zlib-devel pcre-devel openssl-devel
shell > wget http://nginx.org/download/nginx-1.12.2.tar.gz
shell > tar zxf nginx-1.12.2.tar.gz; cd nginx-1.12.2
shell > ./configure --prefix=/usr/local/nginx-1.12.2 && make && make install
```
#### 后端服务器

```
shell > curl 192.168.10.24:8080
welcome to tomcat1
shell > curl 192.168.10.24:8081
welcome to tomcat2
shell > curl 192.168.10.24:8082
welcome to tomcat3
```
好了，三台后端服务器已经启动，分别监听 8080、8081、8082，分别返回 1、2、3

配置`ngx_http_proxy_module`和`ngx_http_upstream_module`模块


编辑配置文件`vim conf/nginx.conf`
```
user  nobody;
worker_processes  1;

pid        logs/nginx.pid;
events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    upstream ls {
        server 192.168.10.24:8080 weight=1 max_fails=3 fail_timeout=20s;
        server 192.168.10.24:8081 weight=2 max_fails=3 fail_timeout=20s;
        server 192.168.10.24:8082 weight=3 max_fails=3 fail_timeout=20s;
    }

    server {
        listen  80;

        location / {
            proxy_pass http://ls;
        }
    }
}
```
这是一个最简配的 Nginx 配置文件，定义了一个负载均衡池，池中有三台服务器，权重分别是 1、2、3 ( 越大越高 )

最大失败次数 3 次，超过 3 次失败后，20 秒内不检测。

当用户访问该 IP 的 80 端口时，被转发到后端的服务器。下面是一些反向代理的配置。

```
# 故障转移策略，当后端服务器返回如下错误时，自动负载到后端其余机器
proxy_next_upstream http_500 http_502 http_503 error timeout invalid_header;

# 设置后端服务器获取用户真实IP、代理者真实IP等
proxy_redirect off;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

# 用于指定客户端请求主体缓存区大小，可以理解成先保存到本地再传给用户
client_body_buffer_size 128k;

# 表示与后端服务器连接的超时时间，即发起握手等侯响应的超时时间
proxy_connect_timeout 90;

# 表示后端服务器的数据回传时间，即在规定时间之后端服务器必须传完所有的数据，否则 Nginx 将断开这个连接
proxy_send_timeout 90;

# 设置 Nginx 从代理的后端服务器获取信息的时间，表示连接建立成功后，Nginx 等待后端服务器的响应时间，其实是 Nginx 已经进入后端的排队中等候处理的时间
proxy_read_timeout 90;

# 设置缓冲区大小，默认该缓冲区大小等于指令 proxy_buffers 设置的大小
proxy_buffer_size 4k;

# 设置缓冲区的数量和大小。Nginx 从代理的后端服务器获取的响应信息，会放置到缓冲区
proxy_buffers 4 32k;

# 用于设置系统很忙时可以使用的 proxy_buffers 大小，官方推荐大小为 proxu_buffers 的两倍
proxy_busy_buffers_size 64k;

# 指定 proxy 缓存临时文件的大小
proxy_temp_file_write_size 64k;
shell > /usr/local/nginx-1.12.2/sbin/nginx -t
nginx: the configuration file /usr/local/nginx-1.12.2/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.12.2/conf/nginx.conf test is successful

shell > /usr/local/nginx-1.12.2/sbin/nginx

shell > i=0; while [ $i -lt 10 ];do curl localhost; let i++;done
welcome to tomcat2
welcome to tomcat3
welcome to tomcat3
welcome to tomcat2
welcome to tomcat1
welcome to tomcat3
welcome to tomcat2
welcome to tomcat3
welcome to tomcat3
welcome to tomcat2
```

总共请求10次，tomcat3 响应了5次，因为它的权重最高(weight=3)。

这样有一个问题，由于没有后端检测功能，当后端某一服务器无法提供服务时，该链接先被转发到这台机器，然后发现该机故障，而后才转发到其它机器。

导致资源浪费。

nginx_http_upstream_check_module

```
shell > git clone https://github.com/yaoweibin/nginx_upstream_check_module.git

shell > yum -y install patch

shell > cd /usr/local/src/nginx-1.12.2; patch -p1 < /usr/local/src/nginx_upstream_check_module/check_1.12.1+.patch
patching file src/http/modules/ngx_http_upstream_hash_module.c
patching file src/http/modules/ngx_http_upstream_ip_hash_module.c
patching file src/http/modules/ngx_http_upstream_least_conn_module.c
patching file src/http/ngx_http_upstream_round_robin.c
patching file src/http/ngx_http_upstream_round_robin.h
切换到 Nginx 源码目录，打补丁 ( 注意与自己的 Nginx 版本匹配 )

shell > ./configure --prefix=/usr/local/nginx-1.12.2 --add-module=/usr/local/src/nginx_upstream_check_module
shell > make && make install
```
重新编译、安装 Nginx，注意加上原来的编译参数

`vim /usr/local/nginx-1.12.2/conf/nginx.conf`
配置文件如下所示：
```
upstream ls {
    server 192.168.10.24:8080;
    server 192.168.10.24:8081;
    server 192.168.10.24:8082;

    check interval=3000 rise=2 fall=5 timeout=1000 type=http;
}

server {
    listen  80;

    location / {
        proxy_pass http://ls;
    }

    location /status {
        check_status;
        access_log off;
        # allow x.x.x.x;
        # deny all;
    }
}
```
去掉了权重值，注意：是可以同时存在的。

添加了一行，检测间隔3000毫秒，连续成功2次标记为UP，连续失败5次标记为DOWN，超时时间1000毫秒，检测类型HTTP。

```
shell > /usr/local/nginx-1.12.2/sbin/nginx -t
nginx: the configuration file /usr/local/nginx-1.12.2/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.12.2/conf/nginx.conf test is successful

shell > /usr/local/nginx-1.12.2/sbin/nginx -s stop
shell > /usr/local/nginx-1.12.2/sbin/nginx
```
直接 -s reload 貌似不行~

```
shell > curl localhost/status?format=json
{"servers": 
    {
      "total": 3,
      "generation": 1,
      "server": [
        {"index": 0, "upstream": "ls", "name": "192.168.10.24:8080", "status": "up", "rise": 20, "fall": 0, "type": "http", "port": 0},
        {"index": 1, "upstream": "ls", "name": "192.168.10.24:8081", "status": "up", "rise": 18, "fall": 0, "type": "http", "port": 0},
        {"index": 2, "upstream": "ls", "name": "192.168.10.24:8082", "status": "up", "rise": 19, "fall": 0, "type": "http", "port": 0}
      ]
    }
}
```
总共有三台机器，都属于负载均衡 ls 组，状态 up，连续成功次数等等。

```
shell > curl localhost/status?format=json
{"servers": 
    {
      "total": 3,
      "generation": 1,
      "server": [
        {"index": 0, "upstream": "ls", "name": "192.168.10.24:8080", "status": "up", "rise": 73, "fall": 0, "type": "http", "port": 0},
        {"index": 1, "upstream": "ls", "name": "192.168.10.24:8081", "status": "down", "rise": 0, "fall": 6, "type": "http", "port": 0},
        {"index": 2, "upstream": "ls", "name": "192.168.10.24:8082", "status": "up", "rise": 68, "fall": 0, "type": "http", "port": 0}
      ]
    }
}
```
关一台后端的话，就变成了这样！重启检测成功后，会被重新加入到负载均衡中！