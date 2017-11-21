##  服务启动、停止和重启脚本
+   [Ubuntu 14.04.2 LTS 启动脚本](#Ubuntu14)
    +  PHP-FPM 服务
    +  Nginx 服务
+   [Ubuntu 16.04.2 LTS 启动脚本](#Ubuntu16)
    +  PHP-FPM 服务
    +  Nginx 服务
##  <a name="Ubuntu14"/>  Ubuntu 14.04.2 LTS 启动脚本
### PHP-FPM 服务
+ 下载文件[php-fpm.sh](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/PHP/PHP-FPM/php-fpm.sh)
+ 注意配置文件：`sudo vim /usr/local/php-7.2/etc/php-fpm.conf`
  > 务必开启配置文件的pid路径：`pid = run/php-fpm.pid`
    否则会报错：`no pid file found - php-fpm is not running ?` 
+ CP到默认开启的服务脚本：

    ```
    sudo cp php-fpm.sh  /etc/init.d/php-fpm
    ``` 
+ 给予权限：

    ```
    sudo chmod +x /etc/init.d/php-fpm
    ```
+ 使用`sysv-rc-conf`安装，[如何安装sysv-rc-conf管理服务](http://blog.csdn.net/gatieme/article/details/45251389)

  ![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/nginx_start_script.png)
+ `php-fpm.sh`代码

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
            echo -n "Starting PHP-FPM Server ... "
    
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
            echo -n "Stopping PHP-FPM Server ... "
    
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
                echo "                          [OK]"
            fi
        ;;
        
        force-quit)
            echo -n "Terminating PHP-FPM "
    
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
                echo "                          [OK]"
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
+   运行效果

    ```bash
    www@tinywan:~$ sudo service php-fpm restart
    Stopping PHP-FPM Server ...             [OK]
    Starting PHP-FPM Server ...             [OK]
    ```
###  <a name="Nginx"/> Nginx 服务

+   第一种安装方式
    +   查看当前nginx是否已经在开机启动项里面: 
    
        ```bash
        ls /etc/rc*
        ```
    +   如何安装
    
        ```bash
        #使用wget -O 下载并以不同的文件名保存 
        sudo wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
        # 给与权限   
        sudo chmod +x /etc/init.d/nginx
        # 设置为启动项
        sudo update-rc.d nginx defaults
        ```
    +   需要修改的地方：  
        +   1、`NGINXPATH=${NGINXPATH:-/opt/openresty/nginx}` 修改为自己的路径   
        +   2、`PIDSPATH=${PIDSPATH:-$NGINXPATH/logs}`  pid文件路径
            > 如果在配置文件修改为：`pid /run/nginx.pid;`  
              PIDSPATH=${PIDSPATH:-$NGINXPATH/logs}修改为：PIDSPATH="/run"
+   第二种安装方式
    +   和PHP-FPM一样，`nginx.sh`代码

        ```bash
        #! /bin/sh
        ### BEGIN INIT INFO
        # Provides:          nginx
        # Required-Start:    $remote_fs $syslog
        # Required-Stop:     $remote_fs $syslog
        # Default-Start:     2 3 4 5
        # Default-Stop:      0 1 6
        # Short-Description: nginx init.d dash script for Ubuntu or other *nix.
        # Description:       nginx init.d dash script for Ubuntu or other *nix.
        ### END INIT INFO
        #------------------------------------------------------------------------------
        # nginx - this Debian Almquist shell (dash) script, starts and stops the nginx
        #         daemon for Ubuntu and other *nix releases.
        #
        # description:  Nginx is an HTTP(S) server, HTTP(S) reverse \
        #               proxy and IMAP/POP3 proxy server.  This \
        #               script will manage the initiation of the \
        #               server and it's process state.
        #
        # processname: nginx
        # config:      /usr/local/nginx/conf/nginx.conf
        # pidfile:     /usr/local/nginx/logs/nginx.pid
        # Provides:    nginx
        
        #------------------------------------------------------------------------------
        #                               Functions
        #------------------------------------------------------------------------------
        LSB_FUNC=/lib/lsb/init-functions
        
        # Test that init functions exists
        test -r $LSB_FUNC || {
            echo "$0: Cannot find $LSB_FUNC! Script exiting." 1>&2
            exit 5
        }
        
        . $LSB_FUNC
        
        #------------------------------------------------------------------------------
        #                               Consts
        #------------------------------------------------------------------------------
        # Include nginx defaults if available
        if [ -f /etc/default/nginx ]; then
            . /etc/default/nginx
        fi
        
        # Minimize path
        PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
        
        PS=${PS:-"nginx"}                             # process name
        DESCRIPTION=${DESCRIPTION:-"Nginx Server..."} # process description
        NGINXPATH=${NGINXPATH:-/opt/openresty/nginx}      # root path where installed
        DAEMON=${DAEMON:-$NGINXPATH/sbin/nginx}       # path to daemon binary
        NGINX_CONF_FILE=${NGINX_CONF_FILE:-$NGINXPATH/conf/nginx.conf} # config file path
        PIDNAME=${PIDNAME:-"nginx"}                   # lets you do $PS-slave
        PIDFILE=${PIDFILE:-$PIDNAME.pid}              # pid file
        PIDSPATH=${PIDSPATH:-$NGINXPATH/logs}         # default pid location, you should change it
        RUNAS=${RUNAS:-root}                          # user to run as
        SCRIPT_OK=0           # ala error codes
        SCRIPT_ERROR=1        # ala error codes
        TRUE=1                # boolean
        FALSE=0               # boolean
        
        #------------------------------------------------------------------------------
        #                               Simple Tests
        #------------------------------------------------------------------------------
        
        # Test if nginx is a file and executable
        test -x $DAEMON || {
            echo "$0: You don't have permissions to execute nginx." 1>&2
            exit 4
        }
        
        # You can also set your conditions like so:
        # set exit condition
        # set -e
        
        #------------------------------------------------------------------------------
        #                               Functions
        #------------------------------------------------------------------------------
        
        setFilePerms(){
            if [ -f $PIDSPATH/$PIDFILE ]; then
                chmod 400 $PIDSPATH/$PIDFILE
            fi
        }
        
        configtest() {
            $DAEMON -t -c $NGINX_CONF_FILE
        }
        
        getPSCount() {
            return `pgrep -f $PS | wc -l`
        }
        
        isRunning() {
            if [ $1 ]; then
                pidof_daemon $1
                PID=$?
        
                if [ $PID -gt 0 ]; then
                    return 1
                else
                    return 0
                fi
            else
                pidof_daemon
                PID=$?
        
                if [ $PID -gt 0 ]; then
                    return 1
                else
                    return 0
                fi
            fi
        }
        
        #courtesy of php-fpm
        wait_for_pid () {
            try=0
        
            while test $try -lt 35 ; do
                case "$1" in
                    'created')
                    if [ -f "$2" ]; then
                        try=''
                        break
                    fi
                    ;;
        
                    'removed')
                    if [ ! -f "$2" ]; then
                        try=''
                        break
                    fi
                    ;;
                esac
        
                try=`expr $try + 1`
                sleep 1
            done
        }
        
        status(){
            isRunning
            isAlive=$?
        
            if [ "${isAlive}" -eq $TRUE ]; then
                log_warning_msg "$DESCRIPTION found running with processes:  `pidof $PS`"
                rc=0
            else
                log_warning_msg "$DESCRIPTION is NOT running."
                rc=3
            fi
        
            return
        }
        
        removePIDFile(){
            if [ $1 ]; then
                if [ -f $1 ]; then
                    rm -f $1
                fi
            else
                #Do default removal
                if [ -f $PIDSPATH/$PIDFILE ]; then
                    rm -f $PIDSPATH/$PIDFILE
                fi
            fi
        }
        
        start() {
            log_daemon_msg "Starting $DESCRIPTION"
        
            isRunning
            isAlive=$?
        
            if [ "${isAlive}" -eq $TRUE ]; then
                log_end_msg $SCRIPT_ERROR
                rc=0
            else
                start-stop-daemon --start --quiet --chuid \
                $RUNAS --pidfile $PIDSPATH/$PIDFILE --exec $DAEMON \
                -- -c $NGINX_CONF_FILE
                status=$?
                setFilePerms
        
                if [ "${status}" -eq 0 ]; then
                    log_end_msg $SCRIPT_OK
                    rc=0
                else
                    log_end_msg $SCRIPT_ERROR
                    rc=7
                fi
            fi
        
            return
        }
        
        stop() {
            log_daemon_msg "Stopping $DESCRIPTION"
        
            isRunning
            isAlive=$?
        
            if [ "${isAlive}" -eq $TRUE ]; then
                start-stop-daemon --stop --quiet --pidfile $PIDSPATH/$PIDFILE
        
                wait_for_pid 'removed' $PIDSPATH/$PIDFILE
        
                if [ -n "$try" ]; then
                    log_end_msg $SCRIPT_ERROR
                    rc=0 # lsb states 1, but under status it is 2 (which is more prescriptive). Deferring to standard.
                else
                    removePIDFile
                    log_end_msg $SCRIPT_OK
                    rc=0
                fi
            else
                log_end_msg $SCRIPT_ERROR
                rc=7
            fi
        
            return
        }
        
        reload() {
            configtest || return $?
        
            log_daemon_msg "Reloading (via HUP) $DESCRIPTION"
        
            isRunning
        
            if [ $? -eq $TRUE ]; then
                kill -HUP `cat $PIDSPATH/$PIDFILE`
                log_end_msg $SCRIPT_OK
                rc=0
            else
                log_end_msg $SCRIPT_ERROR
                rc=7
            fi
        
            return
        }
        
        quietupgrade() {
            log_daemon_msg "Peforming Quiet Upgrade $DESCRIPTION"
        
            isRunning
            isAlive=$?
        
            if [ "${isAlive}" -eq $TRUE ]; then
                kill -USR2 `cat $PIDSPATH/$PIDFILE`
                kill -WINCH `cat $PIDSPATH/$PIDFILE.oldbin`
        
                isRunning
                isAlive=$?
        
                if [ "${isAlive}" -eq $TRUE ]; then
                    kill -QUIT `cat $PIDSPATH/$PIDFILE.oldbin`
                    wait_for_pid 'removed' $PIDSPATH/$PIDFILE.oldbin
                    removePIDFile $PIDSPATH/$PIDFILE.oldbin
        
                    log_end_msg $SCRIPT_OK
                    rc=0
                else
                    log_end_msg $SCRIPT_ERROR
        
                    log_daemon_msg "ERROR! Reverting back to original $DESCRIPTION"
        
                    kill -HUP `cat $PIDSPATH/$PIDFILE`
                    kill -TERM `cat $PIDSPATH/$PIDFILE.oldbin`
                    kill -QUIT `cat $PIDSPATH/$PIDFILE.oldbin`
        
                    wait_for_pid 'removed' $PIDSPATH/$PIDFILE.oldbin
                    removePIDFile $PIDSPATH/$PIDFILE.oldbin
        
                    log_end_msg $SCRIPT_OK
                    rc=0
                fi
            else
                log_end_msg $SCRIPT_ERROR
                rc=7
            fi
        
            return
        }
        
        terminate() {
            log_daemon_msg "Force terminating (via KILL) $DESCRIPTION"
        
            PIDS=`pidof $PS` || true
        
            [ -e $PIDSPATH/$PIDFILE ] && PIDS2=`cat $PIDSPATH/$PIDFILE`
        
            for i in $PIDS; do
                if [ "$i" = "$PIDS2" ]; then
                    kill $i
                    wait_for_pid 'removed' $PIDSPATH/$PIDFILE
                    removePIDFile
                fi
            done
        
            log_end_msg $SCRIPT_OK
            rc=0
        }
        
        destroy() {
            log_daemon_msg "Force terminating and may include self (via KILLALL) $DESCRIPTION"
            killall $PS -q >> /dev/null 2>&1
            log_end_msg $SCRIPT_OK
            rc=0
        }
        
        pidof_daemon() {
            PIDS=`pidof $PS` || true
        
            [ -e $PIDSPATH/$PIDFILE ] && PIDS2=`cat $PIDSPATH/$PIDFILE`
        
            for i in $PIDS; do
                if [ "$i" = "$PIDS2" ]; then
                    return 1
                fi
            done
        
            return 0
        }
        
        action="$1"
        case "$1" in
            start)
                start
                ;;
            stop)
                stop
                ;;
            restart|force-reload)
                stop
                # if [ $rc -ne 0 ]; then
                #     script_exit
                # fi
                sleep 1
                start
                ;;
            reload)
                $1
                ;;
            status)
                status
                ;;
            configtest)
                $1
                ;;
            quietupgrade)
                $1
                ;;
            terminate)
                $1
                ;;
            destroy)
                $1
                ;;
            *)
                FULLPATH=/etc/init.d/$PS
                echo "Usage: $FULLPATH {start|stop|restart|force-reload|reload|status|configtest|quietupgrade|terminate|destroy}"
                echo "       The 'destroy' command should only be used as a last resort."
                exit 3
                ;;
        esac
        
        exit $rc
        ```
+   根据自己环境，配置文件路径，下面修改为Openresty下的Nginx启动项(Nginx 安装在/usr/local/openresty/目录下)
  
    ```bash
    sudo vim /etc/init.d/nginx
    NGINXPATH=${NGINXPATH:-/usr/local/openresty/nginx}
    ```
+   开启服务

    ```bash
    sudo service nginx restart
    [sudo] password for www: 
     * Stopping Nginx Server...      [ OK ] 
     * Starting Nginx Server...      [ OK ]
    ```    
##  <a name="Ubuntu16"/>   Ubuntu 16.04.2 LTS  启动脚本
### PHP-FPM 服务
+   `php-fpm.sh`脚本代码 同上
+   注意，需要重新加载服务：

    ```
    sudo systemctl daemon-reload
    ```
+   开启服务

    ```bash
    sudo systemctl start php-fpm.service
    ```   
+   停止服务

    ```javascript
    sudo systemctl stop php-fpm.service
    ```
+   重启服务

    ```javascript
    sudo systemctl restart php-fpm.service
    ```        
+   服务状态

    ```bash
    sudo systemctl status php-fpm.service
    ● php-fpm.service - LSB: starts php-fpm
       Loaded: loaded (/etc/init.d/php-fpm; bad; vendor preset: enabled)
       Active: active (running) since Sun 2017-10-22 11:16:06 CST; 1 day 5h ago
         Docs: man:systemd-sysv-generator(8)
       CGroup: /system.slice/php-fpm.service
               ├─ 7670 php-fpm: pool www                                                                                                                              
               ├─ 7711 php-fpm: pool www                                                                                                                              
               ├─ 7752 php-fpm: pool www                                                                                                                              
               └─18244 php-fpm: master process (/usr/local/php-7.1.8/etc/php-fpm.conf)                                                                                
    
    Oct 22 11:16:06 TinywanAliYun php-fpm[18232]: Stopping PHP-FPM Server ... .                          [OK]
    Oct 22 11:16:06 TinywanAliYun systemd[1]: Stopped LSB: starts php-fpm.
    Oct 22 11:16:06 TinywanAliYun systemd[1]: Starting LSB: starts php-fpm...
    Oct 22 11:16:06 TinywanAliYun php-fpm[18239]: Starting PHP-FPM Server ... [OK]
    Oct 22 11:16:06 TinywanAliYun systemd[1]: Started LSB: starts php-fpm.
    ```        
###  <a name="Nginx-16"/> Nginx 服务
+   `nginx.sh`代码：

    ```javascript
    #!/bin/sh
     
    ### BEGIN INIT INFO
    # Provides:          nginx
    # Required-Start:    $all
    # Required-Stop:     $all
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: starts the nginx web server
    # Description:       starts nginx using start-stop-daemon
    ### END INIT INFO
     
    PATH=/opt/bin:/opt/sbin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    DAEMON=/usr/local/openresty/nginx/sbin/nginx
    NAME=nginx
    DESC=nginx
     
    test -x $DAEMON || exit 0
     
    # Include nginx defaults if available
    if [ -f /etc/default/nginx ] ; then
            . /etc/default/nginx
    fi
     
    set -e
     
    case "$1" in
      start)
            echo -n "Starting $DESC: "
            start-stop-daemon --start --quiet --pidfile /var/run/nginx.pid \
                    --exec $DAEMON -- $DAEMON_OPTS
            echo "$NAME."
            ;;
      stop)
            echo -n "Stopping $DESC: "
            start-stop-daemon --stop --quiet --pidfile /var/run/nginx.pid \
                    --exec $DAEMON
            echo "$NAME."
            ;;
      restart|force-reload)
            echo -n "Restarting $DESC: "
            start-stop-daemon --stop --quiet --pidfile \
                    /var/run/nginx.pid --exec $DAEMON
            sleep 1
            start-stop-daemon --start --quiet --pidfile \
                    /var/run/nginx.pid --exec $DAEMON -- $DAEMON_OPTS
            echo "$NAME."
            ;;
      reload)
          echo -n "Reloading $DESC configuration: "
          start-stop-daemon --stop --signal HUP --quiet --pidfile /var/run/nginx.pid \
              --exec $DAEMON
          echo "$NAME."
          ;;
      *)
            N=/etc/init.d/$NAME
            echo "Usage: $N {start|stop|restart|force-reload}" >&2
            exit 1
            ;;
    esac
     
    exit 0
    ```  
+   CP到默认开启的服务脚本：

    ```
    sudo cp nginx.sh  /etc/init.d/nginx
    ``` 
+   给予权限：

    ```
    sudo chmod +x /etc/init.d/nginx
    ```    
+   设置为开机启动项：

    ```
    sudo update-rc.d nginx defaults
    ```       
+   重新加载服务：

    ```
    sudo systemctl daemon-reload
    ```    
+   开启服务

    ```javascript
    sudo systemctl start nginx.service
    ```
+   停止服务

    ```javascript
    sudo systemctl stop nginx.service
    ```
+   重启服务

    ```javascript
    sudo systemctl restart nginx.service
    ```        
+   服务状态

    ```bash
    sudo systemctl status nginx.service 
    ● nginx.service
       Loaded: loaded (/etc/init.d/nginx; bad; vendor preset: enabled)
       Active: active (running) since Mon 2017-10-23 16:48:24 CST; 1min 28s ago
         Docs: man:systemd-sysv-generator(8)
      Process: 19089 ExecStop=/etc/init.d/nginx stop (code=exited, status=0/SUCCESS)
      Process: 19138 ExecStart=/etc/init.d/nginx start (code=exited, status=0/SUCCESS)
       CGroup: /system.slice/nginx.service
               ├─19142 nginx: master process /usr/local/openresty/nginx/sbin/nginx -c /usr/local/openresty/nginx/conf/nginx.con
               ├─19143 nginx: worker process                                                              
               └─19144 nginx: cache manager process                                                       
    
    Oct 23 16:48:24 TinywanAliYun systemd[1]: Starting nginx.service...
    Oct 23 16:48:24 TinywanAliYun nginx[19138]: Starting NGINX Web Server: ok
    Oct 23 16:48:24 TinywanAliYun systemd[1]: Started nginx.service.
    ```  
+   参考文章：   
    +   [Nginx官方参考](https://www.nginx.com/resources/wiki/start/topics/tutorials/solaris_11/#startup-script) 
    +   [linux wget 命令用法详解(附实例说明)](http://www.jb51.net/LINUXjishu/86326.html)     
    +   [理解Linux系统/etc/init.d目录和/etc/rc.local脚本](http://blog.csdn.net/acs713/article/details/7322082)     
    +   [Ubuntu启动项设置——之update-rc.d 命令使用](http://blog.csdn.net/typ2004/article/details/38712887)   
