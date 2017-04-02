
#### 日志
---
+ 日志格式允许包含的变量注释
    ```
    $remote_addr, $http_x_forwarded_for（反向）         --记录客户端IP地址
    $remote_user                                       --记录客户端用户名称
    $request                                           --记录请求的URL和HTTP协议
    $status                                            --记录请求状态
    $body_bytes_sent            --发送给客户端的字节数，不包括响应头的大小； 该变量与Apache模块mod_log_config里的“%B”参数兼容。
    $bytes_sent                 --发送给客户端的总字节数。
    $connection                 --连接的序列号。
    $connection_requests        --当前通过一个连接获得的请求数量。
    $msec                       --日志写入时间。单位为秒，精度是毫秒。
    $pipe                       --如果请求是通过HTTP流水线(pipelined)发送，pipe值为“p”，否则为“.”。
    $http_referer               --记录从哪个页面链接访问过来的
    $http_user_agent            --记录客户端浏览器相关信息(注意：个别浏览器是空的)
    $request_length             --请求的长度（包括请求行，请求头和请求正文）。
    $request_time               --请求处理时间，单位为秒，精度毫秒； 从读入客户端的第一个字节开始，直到把最后一个字符发送给客户端后进行日志写入为止。
    $time_iso8601               --ISO8601标准格式下的本地时间。
    $time_local                 --通用日志格式下的本地时间。
    ```
+ Nginx位于负载均衡器，squid，nginx反向代理之后，web服务器无法直接获取到客户端真实的IP地址 
    + $remote_addr获取反向代理的IP地址。反向代理服务器在转发请求的http头信息中，可以增加X-Forwarded-For信息，用来记录 客户端IP地址和客户端请求的服务器地址
+ 日志文件的切割 
    + 查看主进程号( master process )：`cat /var/run/nginx.pid`
    + 停止
        + 配置了pid文件存放路径则,QUIT向NGINX主进程发送(优雅关机)信号的方法：`kill -QUIT $(cat /usr/local/nginx/logs/nginx.pid )`
        + 从容停止: `kill -QUIT 主进程号`  
        + 快速停止：`kill -TERM 主进程号` 
        + 强制停止：`kill -9 主进程号`
    + 重启
        + 验证配置文件是否正确： `/usr/local/nginx/sbin/nginx -t` 
        + 重启方式一：`kill -HUP 主进程号`  
            >[1] 配置重新加载   
            >[2] 使用新配置启动新的工作进程  
            >[3] 正常关闭旧的工作进程     
            
        + 重启方式二：`/usr/local/nginx/sbin/nginx -s reload`
            > `-s ` 参数包含四个命令分别是 `stop/quit/reopen/reload` (发送信号到主进程：停止，退出，重新打开，重新加载)


          
