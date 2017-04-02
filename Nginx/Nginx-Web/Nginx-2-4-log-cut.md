#### 脚本思路
+ 第一步就是重命名日志文件，不用担心重命名后nginx找不到日志文件而丢失日志。在你未重新打开原名字的日志文件前，nginx还是会向你重命名的文件写日志，linux是靠文件描述符而不是文件名定位文件。
+ 第二步向nginx主进程发送USR1信号。nginx主进程接到信号后会从配置文件中读取日志文件名称，重新打开日志文件(以配置文件中的日志名称命名)，并以工作进程的用户作为日志文件的所有者。重新打开日志文件后，nginx主进程会关闭重名的日志文件并通知工作进程使用新打开的日志文件。工作进程立刻打开新的日志文件并关闭重名名的日志文件。
+ 然后你就可以处理旧的日志文件了。
+ [Nginx日志切割shell脚本](http://www.jb51.net/article/47884.htm)
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

     + 发送 kill -USR1 信号给Nginx 主进程号，让Nginx 生成一个新的日志文件 `/usr/local/nginx/logs/access.log`        
     + 单日志备份Shell 脚本 `cut_nginx_log.sh` 
     ```
        #!/bin/bash
        # ======================================================================================
        # chmod u+x /opt/nginx/cut_nginx_log.sh
        # crontab -e
        # 0 0 * * * /home/tinywan/bin/cut_nginx_log.sh > /home/tinywan/bin/cut_nginx_log.log 2>&1
        # =======================================================================================

        LOGS_PATH="/usr/local/nginx/logs"
        YEAR=$(date -d "yesterday" "+%Y")
        MONTH=$(date -d "yesterday" "+%m")
        # 获取昨天的日期
        DATE=$(date -d "yesterday" "+%Y%m%d_%H%M%S")
        echo "YEAR : ${YEAR} MONTH : ${MONTH} DATE :${DATE}"
        # Nginx的master 主进程号 
        NGINX_PID="/var/run/nginx.pid"
        # -r 检测文件是否可读，如果是，则返回 true
        if [ -r ${NGINX_PID} ]; then
            mkdir -p "${LOGS_PATH}/${YEAR}/${MONTH}"
            mv "${LOGS_PATH}/access.log" "${LOGS_PATH}/${YEAR}/${MONTH}/access_${DATE}.log"
            kill -USR1 $(cat "/var/run/nginx.pid")
            sleep 1
            gzip "${LOGS_PATH}/${YEAR}/${MONTH}/access_${DATE}.log"
            echo 'Nginx Cut Log Success'
        else
            echo "Nginx might be down"
        fi
        # ==============================================================================
        # Clean up log files older than 100 days
        # ==============================================================================
        # Change HOUSEKEEPING=1 to enable clean up
        HOUSEKEEPING=0     
        KEEP_DAYS=100
        if [ $HOUSEKEEPING == 1 ]; then         # 删除日志开关，开关为1的时候才会去根据设置的天数删除压缩日志文件
            if [ -d "${LOGS_PATH}" ]; then
                find "${LOGS_PATH}" -type f -name "*.log.gz" -mtime +${KEEP_DAYS} -exec rm -f {} \;
            fi
        fi
     ```
     + Nginx 报错误日志,由于php-fpm没有启动，就会报错以下错误信息error.log中
        ```
        11 connect() to unix:/var/run/php7.0.9-fpm.sock failed (2: No such file or directory) while connecting to upstream
        ```
     + 多日志备份Shell 脚本 `cut_ multiple_nginx_log.sh` 
        ```
            #!/bin/bash
            # ======================================================================================
            # chmod u+x /opt/nginx/cut_multiple_nginx_log.sh
            # crontab -e
            # 0 0 * * * /home/tinywan/bin/cut_multiple_nginx_log.sh > /home/tinywan/bin/cut_nginx_log.log 2>&1
            # =======================================================================================

            LOGS_PATH="/usr/local/nginx/logs"     # 注意这里在路径末尾多个"/"
            YEAR=$(date -d "yesterday" "+%Y")
            MONTH=$(date -d "yesterday" "+%m")
            # 获取昨天的日期
            DATE=$(date -d "yesterday" "+%Y%m%d_%H%M%S")
            echo "YEAR : ${YEAR} MONTH : ${MONTH} DATE :${DATE}"
            # Nginx的master 主进程号 
            NGINX_PID="/var/run/nginx.pid"
            # -r 检测文件是否可读，如果是，则返回 true
            CUT_LOG(){
                if [ -r ${NGINX_PID} ]; then
                        mkdir -p "${LOGS_PATH}/${YEAR}/${MONTH}"
                        cd ${LOGS_PATH}
                        for i in $(ls *.log)                         # i = access.log/error.log/...等等
                        do
                            FILE_NAME=$(echo ${i} | sed 's/\.log//')  # FILE_NAME=access/error/...等等
                            echo ${FILE_NAME}
                            mv "${LOGS_PATH}/${i}" "${LOGS_PATH}/${YEAR}/${MONTH}/${FILE_NAME}_${DATE}.log"
                            sleep 1
                            gzip "${LOGS_PATH}/${YEAR}/${MONTH}/${FILE_NAME}_${DATE}.log"
                        done
                        kill -USR1 $(cat "/var/run/nginx.pid")
                        echo 'Nginx Cut Log Success'
                else
                    echo "Nginx might be down"
                    exit 1
                fi
            }
            CUT_LOG
            # ==============================================================================
            # Clean up log files older than 100 days
            # ==============================================================================
            # Change HOUSEKEEPING=1 to enable clean up
            HOUSEKEEPING=1
            KEEP_DAYS=100
            if [ $HOUSEKEEPING == 1 ]; then
                if [ -d "${LOGS_PATH}" ]; then
                    find "${LOGS_PATH}" -type f -name "*.log.gz" -mtime +${KEEP_DAYS} -exec rm -f {} \;
                fi
            fi
        ```
+ Linux命令之 ` find ` 命令中的 `-mtime` 参数
    + mtime参数的理解应该如下：
        + -mtime n 按照文件的更改时间来找文件，n为整数。
        + n表示文件更改时间距离为n天， -n表示文件更改时间距离在n天以内，+n表示文件更改时间距离在n天以前。
        + 例如：
            > -mtime 0 表示文件修改时间距离当前为0天的文件，即距离当前时间不到1天（24小时）以内的文件。   
            > -mtime 1 表示文件修改时间距离当前为1天的文件，即距离当前时间1天（24小时－48小时）的文件。   
            > -mtime＋1 表示文件修改时间为大于1天的文件，即距离当前时间2天（48小时）之外的文件   
            > -mtime -1 表示文件修改时间为小于1天的文件，即距离当前时间1天（24小时）之内的文件   

        + ` find "/usr/local/nginx/logs" -type f -name "*.log.gz" -mtime 0 `    
            > 查找距离当前时间不到1天（24小时）以内的文件的日志文件   
            >> 查找结果：   
                ```
                    root@tinywan:/usr/local/nginx/logs/2017/04# find "/usr/local/nginx/logs" -type f -name "*.log.gz" -mtime 0
                    /usr/local/nginx/logs/2017/04/error_20170401_224602.log.gz
                    /usr/local/nginx/logs/2017/04/access_20170401_224602.log.gz
                    /usr/local/nginx/logs/2017/04/host.access_20170401_224602.log.gz
                ``` 

    + 为什么-mtime＋1 表示文件修改时间为大于1天的文件，即距离当前时间48小时之外的文件，而不是24小时之外的呢？  
    + 因为n值只能是整数，即比1大的最近的整数是2,所有-mtime＋1不是比当前时间大于1天（24小时），而是比当前时间大于2天（48小时）。
    + ` find . -name "*ab*" -exec rm -f {}\; `   
        > 整句命令表示：在当前目录下查找以ab结尾的文件，并删除   
        > ` -name “*ab” ` 表示查找以ab结尾的文件或文件名   
        > `-exec` 表示执行什么命令。后面跟要执行的命令。此处是 `rm -f`，表示不确认删除   
        > `{} \;` 表示把查找到的结果发送到此来  




          
