# Nginx 高并发系统内核优化
## socket 优化
#### Nginx 优化
+   子进程允许打开的连接数：`worker_connections`
#### 系统内核 优化
+   [内核参数的优化](http://blog.csdn.net/moxiaomomo/article/details/19442737)  
+   实践优化配置
    +  编辑： `vim /etc/sysctl.conf`
    +  配置结果
        ```bash
        net.ipv4.tcp_max_tw_buckets = 6000
        net.ipv4.ip_local_port_range = 1024    65000
        net.ipv4.tcp_tw_recycle = 1
        net.ipv4.tcp_tw_reuse = 1
        net.ipv4.tcp_syncookies = 1
        net.core.somaxconn = 262144
        net.core.netdev_max_backlog = 262144
        net.ipv4.tcp_max_orphans = 262144
        net.ipv4.tcp_max_syn_backlog = 262144
        net.ipv4.tcp_syn_retries = 1
        net.ipv4.tcp_fin_timeout = 1
        net.ipv4.tcp_keepalive_time = 30
        ```
    +   执行命令使之生效：`/sbin/sysctl -p`       
## 文件 优化
#### Nginx 优化
+   指当一个nginx进程打开的最多文件描述符数目：`worker_rlimit_nofile 100000;`
#### 系统内核 优化
+   系统限制其最大进程数：`ulimit -n`
+   编辑文件：`/etc/security/limits.conf`
    ```conf
    # End of file
    root soft nofile 65535
    root hard nofile 65535
    * soft nofile 65535
    * hard nofile 65535
    ```
## 优化配置文件
+   nginx优化配置文件
    ```lua
    user  www www;
    worker_processes 8;
    worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000;
    error_log  /www/log/nginx_error.log  crit;
    pid        /usr/local/nginx/nginx.pid;
    worker_rlimit_nofile 204800;
    
    events
    {
      use epoll;
      worker_connections 204800;
    }
    ```
+   完整的内核优化配置
    ```lua
    net.ipv4.tcp_max_tw_buckets = 6000
    net.ipv4.ip_local_port_range = 1024    65000
    net.ipv4.tcp_tw_recycle = 1
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_syncookies = 1
    net.core.somaxconn = 262144
    net.core.netdev_max_backlog = 262144
    net.ipv4.tcp_max_orphans = 262144
    net.ipv4.tcp_max_syn_backlog = 262144
    net.ipv4.tcp_syn_retries = 1
    net.ipv4.tcp_fin_timeout = 1
    net.ipv4.tcp_keepalive_time = 30
    ```    