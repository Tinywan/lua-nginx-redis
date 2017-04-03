## 第三方士大夫
+ 配置文件详解
    ```
    |Project_dir
    |
    |         |----nginx.conf      			配置文件（PHP版本，适合WordPress、Typecho等）
    |--Nginx--|----nginx_pelican.conf      			配置文件（静态HTML版本，适合Pelican、HEXO等）
    |         |----nginx      			服务控制脚本
    |
    |         |----php.ini      			配置文件
    |         |----php-fpm      			服务控制脚本
    |---PHP---|
    |         |----php-fpm.conf      			配置文件
    |		  |----www.conf      			配置文件
    |
    |         |----my.cnf      			配置文件
    |--MySql--|
    |         |----mysqld      			服务控制脚本
    |
    |--nginx_log_backup.sh      			每天切割Nginx服务产生的日志文件
    |
    |--README.md
    ```