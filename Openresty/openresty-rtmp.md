#### <a name="Openresty_connent_cache"/> OpenResty缓存    
+   指令：`lua_shared_dict`
    +   纯内存的操作，多个worker之间共享的(比如nginx开启10个Worker,则每个worker之间是共享该内存的)
    +   同一份数据在多个worker之间是共享的，只要存储一份数据就可以了
    +   锁的竞争（数据原子性）

#### <a name="Openresty_rtmp_share"/> Openresty和Nginx_RTMP 模块共存问题   
+   RTMP 流的状态（stat.xsl）不生效Bug 问题
    -   1.  修改完nginx.conf 配置文件
    -   1.  ~~执行：`nginx -s reload` 会不起作用~~
    -   2.  一定要执行以下命令：杀掉所有nginx进程`sudo killall nginx ` 重启即可`sbin/nignx`
#### <a name="Openresty_rtmp_more_worker"/> 配置RTMP模块的多worker直播流
+   配置文件,[Multi-worker live streaming官方文档](https://github.com/arut/nginx-rtmp-module/wiki/Directives#multi-worker-live-streaming)
    ```Shell
    user www www;
    worker_processes  auto;
    error_log  logs/error.log debug;
    
    pid /var/run/nginx.pid;
    events {
        use epoll;
        worker_connections  1024;
        multi_accept on;
    }
   
    rtmp_auto_push on;
    rtmp_auto_push_reconnect 1s;
    rtmp_socket_dir /var/sock;
    rtmp {
        server {
            listen 1935;
            application live {
                live on;
            }
        }
    }
    ```