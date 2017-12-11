#  [在线文档（Online documentation）](http://github.tinywan.com/lua-nginx-redis/)
![Author](https://img.shields.io/badge/Author-Tinywan-green.svg)
[![Conda](https://img.shields.io/conda/pn/conda-forge/python.svg)]()
[![GitHub license](https://img.shields.io/github/license/Tinywan/tinywan-react-app.svg)](https://github.com/Tinywan/tinywan-react-app/blob/master/LICENSE)
## <a name="index"/>目录
+   Nginx 教程 （Nginx tutorial） 
    +   [Nginx编译安装](/Nginx/nginx-install.md)
    +   [Nginx.conf详解和配置](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-base-config.md)
    +   [Location 详解和配置](https://github.com/Tinywan/lua-nginx-redis/blob/master/docs/Nginx/location-detail.md)
    +   [Nginx基础知识](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-basic.md)
    +   [Nginx高性能WEB服务器详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-high-basic.md) 
    +   [Nginx高并发系统内核优化和PHP7配置文件优化](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-parameter-config.md)
    +   [Nginx和PHP-FPM启动脚本](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-start-script.md)
    +   项目案例 （Project notes）
        +   [Nginx 同一个IP上配置多个HTTPS主机](https://github.com/Tinywan/lua-nginx-redis/blob/master/Nginx/more-domain-config.md)
        +   [Nginx 如何配置一个安全的HTTPS网站服务器](http://www.cnblogs.com/tinywan/p/7542629.html)
        +   [Nginx 配置启用 HTTP/2](http://www.cnblogs.com/tinywan/p/7860774.html)
    +   扩展模块 （Third-party module）
        +   [nginx-vod-module](http://www.cnblogs.com/tinywan/p/7879559.html)    
        +   [nginx-module-vts](http://www.cnblogs.com/tinywan/p/7872366.html)    
        +   [ngx_cache_purge](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/Nginx-Web/Nginx-8-proxy_cache.md)    
        +   [lua-nginx-module](http://www.cnblogs.com/tinywan/p/6538006.html)    
        +   [nginx-rtmp-module](http://www.cnblogs.com/tinywan/p/6639360.html)    
+   Lua 教程    
    +  [Lua 基础语法](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/lua-basic.md)
    +  [luajit 执行文件默认安装路径](#Nginx_base_knowledge) 
    +  [lua中self.__index = self 详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/oop/self__index.md)      
+   Redis 教程    
    +   [Redis 安装](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-install.md) 
    +   [Redis 配置详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-config.md) 
    +   [Redis 基础知识](#Redis_base_knowledge) 
    +   [Redis 开发与运维](#Redis-DevOps)
    +   [Redis执行Lua脚本基本用法](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-lua.md)    
+   Openresty 教程
    +   [安装默认配置信息](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-basic.md) 
    +   [ngx_lua APi 方法和常量](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-api.md) 
    +   [ngx_lua 扩展模块学习](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-resty-module.md) 
    +   [lua-resty-upstream-healthcheck使用](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-upstream-healthcheck.md) 
    +   [Openresty与Nginx_RTMP](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-rtmp.md) 
    +   [自己写的一个简单项目lua_project_v0.01](https://github.com/Tinywan/lua_project_v0.01) 
+   PHP 教程
    +   [PHP脚本](#PHP_base_knowledge) 
         +   [PHP脚本运行Redis](#PHP_Run_Redis)
         +   [PHP7中php.ini/php-fpm/www.conf的配置,Nginx和PHP-FPM的开机自动启动脚本](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/PHP/PHP-FPM/config.md)  
         +   [PHP 脚本执行一个Redis 订阅功能，用于监听键过期事件，返回一个回调，API接受改事件](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis-PHP/Php-Run-Redis-psubscribe/nohupRedisNotify.php)
+   Linux 教程
    +   [Linux 基础知识](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Linux/linux-basic.md)    
+   Shell 教程    
    +   Shell脚本 
        +   [编写快速安全Bash脚本的建议](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Shell/write-shell-suggestions.md) 
        +   [shell脚本实现分日志级别记录日志](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Shell_Log.sh)   
        +   [Nginx日志定时备份和删除](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Shell_Nginx_Log_cut.sh)   
        +   [SHELL脚本小技巧](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/Shell_script.md)   
        +   [Mysql 自动备份脚本安全加锁机制](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/backup_mysql.sh)   
+   流媒体教程         
    + [Nginx配置Rtmp支持Hls的直播和点播功能](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/HLS-live-vod.md)
    + [HLS视频直播和点播的Nginx的Location的配置信息(成功)](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/HLS-live-vod-locatiuon-config.md)     

## Lua-Ngx
![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Nginx-Phase.png)

## 随意打赏  

|支付宝打赏|微信打赏|
|:----:|:----:|
|![image](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/alipay.png)|![image](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/wechat.png)|
