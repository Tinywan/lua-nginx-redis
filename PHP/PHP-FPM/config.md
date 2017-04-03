## PHP7中php.ini、php-fpm和www.conf的配置
+ 配置文件详解
    ```
    |Project_dir
    |
    |         |----nginx.conf      			-- 配置文件（PHP版本，适合WordPress、Typecho等）
    |--Nginx--|----nginx_pelican.conf      	        -- 配置文件（静态HTML版本，适合Pelican、HEXO等）
    |         |----nginx      			-- 服务控制脚本
    |
    |         |----php.ini      			-- php运行核心配置文件，文件所在目录：/opt/php-7.0.9/etc/
    |         |----php-fpm      			-- 服务控制脚本，文件所在目录：/opt/php-7.0.9/sbin/
    |---PHP---|
    |         |----php-fpm.conf      		-- 是 **php-fpm** 进程服务的配置文件，文件所在目录：/opt/php-7.0.9/etc/
    |		  |----www.conf      	        -- 是 php-fpm 进程服务的扩展配置文件，文件所在目录：/opt/php-7.0.9/etc/php-fpm.d/
    |
    |         |----my.cnf      			-- 配置文件
    |--MySql--|
    |         |----mysqld      			-- 服务控制脚本
    |
    |--nginx_log_backup.sh      			-- 每天切割Nginx服务产生的日志文件
    |
    |--README.md
    ```
+ PHP
    + 启动：`sudo /opt/php-7.0.9/sbin/php-fpm `
    + 重启：
        ```
        sudo kill -QUIT `cat /opt/php-7.0.9/var/run/php-fpm.pid`
        ```
    + 停止：
        ```
        sudo kill -QUIT `cat /opt/php-7.0.9/var/run/php-fpm.pid`

        sudo kill -9 `cat /opt/php-7.0.9/var/run/php-fpm.pid`
        ```        
    + php-fpm 主进程pid：`cat /opt/php-7.0.9/var/run/php-fpm.pid `
    + php-fpm 错误日志文件：`cat /opt/php-7.0.9/var/log/php-fpm.log `
    + php-fpm 的启动参数
    ```
        #测试php-fpm配置
        /usr/local/php/sbin/php-fpm -t
        /usr/local/php/sbin/php-fpm -c /usr/local/php/etc/php.ini -y /usr/local/php/etc/php-fpm.conf -t
        
        #启动php-fpm
        /usr/local/php/sbin/php-fpm
        /usr/local/php/sbin/php-fpm -c /usr/local/php/etc/php.ini -y /usr/local/php/etc/php-fpm.conf
        
        #关闭php-fpm
        kill -INT `cat /usr/local/php/var/run/php-fpm.pid`
        
        #重启php-fpm
        kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`
    ```
    + php.ini
    > [1] php 运行核心配置文件   
    > [2] 文件信息 

    ```
        ######避免PHP信息暴露在http头中
        expose_php = Off

        ######避免暴露php调用mysql的错误信息
        display_errors = Off

        ######在关闭display_errors后开启PHP错误日志（路径在php-fpm.conf中配置）
        log_errors = On

        ######设置PHP的扩展库路径
        extension_dir = "/usr/local/php7/lib/php/extensions/no-debug-non-zts-20141001/"

        ######设置PHP的opcache和mysql动态库
        zend_extension=opcache.so
        extension=mysqli.so
        extension=pdo_mysql.so

        ######设置PHP的时区
        date.timezone = PRC

        ######开启opcache
        [opcache]
        ; Determines if Zend OPCache is enabled
        opcache.enable=1

        ######设置PHP脚本允许访问的目录（需要根据实际情况配置）
        ;open_basedir = /usr/share/nginx/html;
    ```

    + php-fpm.conf
    > [1] 是php-fpm进程服务的配置文件  
    > [2] 文件信息 

    ```
        pid = run/php-fpm.pid
        #pid设置，默认在安装目录中的var/run/php-fpm.pid，建议开启
        
        error_log = log/php-fpm.log
        #错误日志，默认在安装目录中的var/log/php-fpm.log
        
        log_level = notice
        #错误级别. 可用级别为: alert（必须立即处理）, error（错误情况）, warning（警告情况）, notice（一般重要信息）, debug（调试信息）. 默认: notice.
        
        emergency_restart_threshold = 60
        emergency_restart_interval = 60s
        #表示在emergency_restart_interval所设值内出现SIGSEGV或者SIGBUS错误的php-cgi进程数如果超过 emergency_restart_threshold个，php-fpm就会优雅重启。这两个选项一般保持默认值。
        
        process_control_timeout = 0
        #设置子进程接受主进程复用信号的超时时间. 可用单位: s(秒), m(分), h(小时), 或者 d(天) 默认单位: s(秒). 默认值: 0.
        
        daemonize = yes
        #后台执行fpm,默认值为yes，如果为了调试可以改为no。在FPM中，可以使用不同的设置来运行多个进程池。 这些设置可以针对每个进程池单独设置。
        
        listen = 127.0.0.1:9000
        #fpm监听端口，即nginx中php处理的地址，一般默认值即可。可用格式为: 'ip:port', 'port', '/path/to/unix/socket'. 每个进程池都需要设置.
        
        listen.backlog = -1
        #backlog数，-1表示无限制，由操作系统决定，此行注释掉就行。backlog含义参考：http://www.3gyou.cc/?p=41
        
        listen.allowed_clients = 127.0.0.1
        #允许访问FastCGI进程的IP，设置any为不限制IP，如果要设置其他主机的nginx也能访问这台FPM进程，listen处要设置成本地可被访问的IP。默认值是any。每个地址是用逗号分隔. 如果没有设置或者为空，则允许任何服务器请求连接
        
        listen.owner = www
        listen.group = www
        listen.mode = 0666
        #unix socket设置选项，如果使用tcp方式访问，这里注释即可。
        
        user = www
        group = www
        #启动进程的帐户和组
        
        pm = dynamic #对于专用服务器，pm可以设置为static。
        #如何控制子进程，选项有static和dynamic。如果选择static，则由pm.max_children指定固定的子进程数。如果选择dynamic，则由下开参数决定：
        pm.max_children #，子进程最大数
        pm.start_servers #，启动时的进程数
        pm.min_spare_servers #，保证空闲进程数最小值，如果空闲进程小于此值，则创建新的子进程
        pm.max_spare_servers #，保证空闲进程数最大值，如果空闲进程大于此值，此进行清理
        
        pm.max_requests = 1000
        #设置每个子进程重生之前服务的请求数. 对于可能存在内存泄漏的第三方模块来说是非常有用的. 如果设置为 '0' 则一直接受请求. 等同于 PHP_FCGI_MAX_REQUESTS 环境变量. 默认值: 0.
        
        pm.status_path = /status
        #FPM状态页面的网址. 如果没有设置, 则无法访问状态页面. 默认值: none. munin监控会使用到
        
        ping.path = /ping
        #FPM监控页面的ping网址. 如果没有设置, 则无法访问ping页面. 该页面用于外部检测FPM是否存活并且可以响应请求. 请注意必须以斜线开头 (/)。
        
        ping.response = pong
        #用于定义ping请求的返回相应. 返回为 HTTP 200 的 text/plain 格式文本. 默认值: pong.
        
        request_terminate_timeout = 0
        #设置单个请求的超时中止时间. 该选项可能会对php.ini设置中的'max_execution_time'因为某些特殊原因没有中止运行的脚本有用. 设置为 '0' 表示 'Off'.当经常出现502错误时可以尝试更改此选项。
        
        request_slowlog_timeout = 10s
        #当一个请求该设置的超时时间后，就会将对应的PHP调用堆栈信息完整写入到慢日志中. 设置为 '0' 表示 'Off'
        
        slowlog = log/$pool.log.slow
        #慢请求的记录日志,配合request_slowlog_timeout使用
        
        rlimit_files = 1024
        #设置文件打开描述符的rlimit限制. 默认值: 系统定义值默认可打开句柄是1024，可使用 ulimit -n查看，ulimit -n 2048修改。
        
        rlimit_core = 0
        #设置核心rlimit最大限制值. 可用值: 'unlimited' 、0或者正整数. 默认值: 系统定义值.
        
        chroot =
        #启动时的Chroot目录. 所定义的目录需要是绝对路径. 如果没有设置, 则chroot不被使用.
        
        chdir =
        #设置启动目录，启动时会自动Chdir到该目录. 所定义的目录需要是绝对路径. 默认值: 当前目录，或者/目录（chroot时）
        
        catch_workers_output = yes
        #重定向运行过程中的stdout和stderr到主要的错误日志文件中. 如果没有设置, stdout 和 stderr 将会根据FastCGI的规则被重定向到 /dev/null . 默认值: 空.
    ```

    + www.conf
    > [1] 这是php-fpm进程服务的扩展配置文件  
    > [2] 文件信息 

    ```
        ######设置用户和用户组
        user = nginx
        group = nginx

        ######根据nginx.conf中的配置fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;设置PHP监听
        ; listen = 127.0.0.1:9000   #####不建议使用
        listen = /var/run/php-fpm/php-fpm.sock

        ######开启慢日志
        slowlog = /var/log/php-fpm/$pool-slow.log
        request_slowlog_timeout = 10s

        ######设置php的session目录（所属用户和用户组都是nginx）
        php_value[session.save_handler] = files
        php_value[session.save_path] = /var/lib/php/session
    ``     
+ php-fpm开机自动启动Shell脚本
    + [Nginx和PHP-FPM的开机自动启动服务脚本](http://www.jb51.net/article/58796.htm)
    + 在当前目录`(/home/tinywan)`新建一个`php-fpm.sh`文件，粘贴一下测试成功代码
    + 复制到开机就默认开启的服务脚本：`sudo cp php-fpm.sh  /etc/init.d/php-fpm`
    + 给予权限：`sudo chmod +x /etc/init.d/nginx`
    + [安装sysv-rc-conf管理服务](http://blog.csdn.net/gatieme/article/details/45251389)
    + 测试成功代码
    ```
    #! /bin/sh
    ### BEGIN INIT INFO
    # Provides:     php-fpm
    # Required-Start:  $remote_fs $network
    # Required-Stop:   $remote_fs $network
    # Default-Start:   2 3 4 5
    # Default-Stop:   0 1 6
    # Short-Description: starts php-fpm
    # Description:    starts the PHP FastCGI Process Manager daemon
    ### END INIT INFO

    prefix=/opt/php-7.0.9    # 只需要修改这里就可以里，这里是编译路径
    exec_prefix=${prefix}

    php_fpm_BIN=${exec_prefix}/sbin/php-fpm
    php_fpm_CONF=${prefix}/etc/php-fpm.conf
    php_fpm_PID=${prefix}/var/run/php-fpm.pid

    php_opts="--fpm-config $php_fpm_CONF --pid $php_fpm_PID"

    wait_for_pid () {
        try=0

        while test $try -lt 35 ; do

            case "$1" in
                'created')
                if [ -f "$2" ] ; then
                    try=''
                    break
                fi
                ;;

                'removed')
                if [ ! -f "$2" ] ; then
                    try=''
                    break
                fi
                ;;
            esac

            echo -n .
            try=`expr $try + 1`
            sleep 1

        done

    }
    case "$1" in
        start)
            echo -n "Starting php-fpm ... "

            $php_fpm_BIN --daemonize $php_opts

            if [ "$?" != 0 ] ; then
                echo " failed"
                exit 1
            fi

            wait_for_pid created $php_fpm_PID

            if [ -n "$try" ] ; then
                echo " failed"
                exit 1
            else
                echo "[OK]"
            fi
        ;;

        stop)
            echo -n "Gracefully shutting down php-fpm "

            if [ ! -r $php_fpm_PID ] ; then
                echo "warning, no pid file found - php-fpm is not running ?"
                exit 1
            fi

            kill -QUIT `cat $php_fpm_PID`

            wait_for_pid removed $php_fpm_PID

            if [ -n "$try" ] ; then
                echo " failed. Use force-quit"
                exit 1
            else
                echo "[OK]"
            fi
        ;;
        
        force-quit)
            echo -n "Terminating php-fpm "

            if [ ! -r $php_fpm_PID ] ; then
                echo "warning, no pid file found - php-fpm is not running ?"
                exit 1
            fi

            kill -TERM `cat $php_fpm_PID`

            wait_for_pid removed $php_fpm_PID

            if [ -n "$try" ] ; then
                echo " failed"
                exit 1
            else
                echo " [OK]"
            fi
        ;;

        restart)
            $0 stop
            $0 start
        ;;

        reload)

            echo -n "Reload service php-fpm "

            if [ ! -r $php_fpm_PID ] ; then
                echo "warning, no pid file found - php-fpm is not running ?"
                exit 1
            fi

            kill -USR2 `cat $php_fpm_PID`

            echo "[OK]"
        ;;

        *)
            echo "Usage: $0 {start|stop|force-quit|restart|reload}"
            exit 1
        ;;

    esac
```      
