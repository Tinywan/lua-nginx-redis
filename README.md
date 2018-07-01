#  [在线文档（Online documentation）](http://github.tinywan.com/lua-nginx-redis/)
![Author](https://img.shields.io/badge/Author-Tinywan-green.svg)
[![Conda](https://img.shields.io/conda/pn/conda-forge/python.svg)]()
[![GitHub license](https://img.shields.io/github/license/Tinywan/tinywan-react-app.svg)](https://github.com/Tinywan/tinywan-react-app/blob/master/LICENSE)
## <a name="index"/>目录
#### Nginx 教程 （Nginx tutorial）  
* [Nginx编译安装](/Nginx/nginx-install.md)  
* [Nginx.conf详解](/Nginx/nginx-base-config.md)  
* [Location 详解](/docs/Nginx/location-detail.md)  
* [Nginx基础知识](/Nginx/nginx-basic.md)  
* [Nginx高性能WEB服务器详解](/Nginx/nginx-high-basic.md)   
* [Nginx高并发系统内核优化和PHP7配置文件优化](/Nginx/nginx-parameter-config.md)   
* [Nginx和PHP-FPM启动脚本](/Nginx/nginx-start-script.md)  
* [Nginx的11个Phases](/Nginx/nginx-phases.md)  
* [agentzh 的 Nginx 教程](https://openresty.org/download/agentzh-nginx-tutorials-zhcn.html)  
* [Nginx 陷阱和常见错误](h/Nginx/nginx-1-config.md)  
* [TCP和UDP负载平衡官方参考文档](https://www.cnblogs.com/tinywan/p/6586053.html)  
* [Nginx 高并发系统内核优化](/Nginx/nginx-parameter-config.md)  
* [nginx 并发数问题思考：worker_connections,worker_processes与 max clients](http://liuqunying.blog.51cto.com/3984207/1420556?utm_source=tuicool)
* [如何在工作中提高Ngixn服务器性能?达到高效](https://juejin.im/post/5adb45e96fb9a07ab773c767?utm_source=gold_browser_extension)   
* 项目案例 （Project notes）  
  * [Nginx 同一个IP上配置多个HTTPS主机](/Nginx/more-domain-config.md)  
  * [Nginx 如何配置一个安全的HTTPS网站服务器](http://www.cnblogs.com/tinywan/p/7542629.html)  
  * [Nginx 配置启用 HTTP/2](http://www.cnblogs.com/tinywan/p/7860774.html)  
  * [申请Let's Encrypt通配符HTTPS证书](https://www.cnblogs.com/tinywan/p/8573169.html)   
* 扩展模块 （Third-party module）  
  * [nginx-vod-module](http://www.cnblogs.com/tinywan/p/7879559.html)    
  * [nginx-module-vts](http://www.cnblogs.com/tinywan/p/7872366.html)    
  * [ngx_cache_purge](/Nginx/Nginx-Web/Nginx-8-proxy_cache.md)    
  * [lua-nginx-module](http://www.cnblogs.com/tinywan/p/6538006.html)    
  * [nginx-rtmp-module](http://www.cnblogs.com/tinywan/p/6639360.html)    
* PHP 相关  
	* [PHP7中php.ini/php-fpm/www.conf的配置,Nginx和PHP-FPM的开机自动启动脚本](/PHP/PHP-FPM/config.md)  
	* 

#### Lua 教程    
* [Lua 基础语法](/Lua-Script/lua-basic.md)  
* [luajit 执行文件默认安装路径](#Nginx_base_knowledge)   
* [lua中self_indes详解](/Lua-Script/oop/self__index.md)   

#### Redis 教程  
* [Redis 安装](/Redis/redis-install.md)   
* [Redis 配置详解](/Redis/redis-config.md)   
* [Redis 基础知识](#Redis_base_knowledge)   
* [Redis 开发与运维](#Redis-DevOps)  
* [Redis 执行Lua脚本基本用法](/Redis/redis-lua.md)    
* [Redis 漏洞如何防止被黑客攻击](/Redis/redis-safety.md)   
* 与 PHP 相关   
	* [PHP脚本运行Redis](#PHP_Run_Redis)   
	* [PHP 脚本执行一个Redis 订阅功能，用于监听键过期事件，返回一个回调，API接受改事件](/Redis-PHP/Php-Run-Redis-psubscribe/nohupRedisNotify.php)   
* [阿里云Redis开发规范](https://yq.aliyun.com/articles/531067)   
* [高可用Redis服务架构分析与搭建](https://mp.weixin.qq.com/s/DA4uhPULaXI-KDKwvLzb8Q)  
* [如何轻松搭建电商秒杀系统](https://yq.aliyun.com/articles/277885)  

####  Openresty 教程  
* [安装默认配置信息](/Openresty/openresty-basic.md)   
* [如何编译一个高性能 OpenResty](https://yq.aliyun.com/articles/228399) 
* [ngx_lua APi 方法和常量](/Openresty/openresty-api.md)   
* [ngx_lua 扩展模块学习](/Openresty/openresty-resty-module.md)   
* [lua-resty-upstream-healthcheck使用](/Openresty/lua-resty-upstream-healthcheck.md)   
* [Openresty与Nginx_RTMP](/Openresty/openresty-rtmp.md)   
* [自己写的一个简单项目lua_project_v0.01](https://github.com/Tinywan/lua_project_v0.01)   

#### Linux 教程  
* [Linux 基础知识](/Linux/linux-basic.md)    
* Systemd 入门教程    
  * [命令篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)   
  * [实战篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)   
  * [定时器教程](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)   
#### Shell 教程    
* [编写快速安全Bash脚本的建议](https://www.oschina.net/translate/bash-scripting-quirks-safety-tips)  
* [写好shell脚本的13个技巧](https://mp.weixin.qq.com/s/f3xDHZ7dCQr7sHJ9KDvuyQ)  
* [shell脚本实现分日志级别记录日志](/Nginx-Rtmp/Shell_Log.sh)   
* [Nginx日志定时备份和删除](/Nginx-Rtmp/Shell_Nginx_Log_cut.sh)   
* [SHELL脚本小技巧](/Nginx-Rtmp/Shell_script.md)   
* [Mysql 自动备份脚本安全加锁机制](/Nginx-Rtmp/backup_mysql.sh)   
* PHP 相关  
	* [PHP和Shell 脚本如何很好的搭配](/PHP/php-shell_run.md)  

#### 流媒体教程  
* [Nginx配置Rtmp支持Hls的直播和点播功能](/Nginx-Rtmp/HLS-live-vod.md)
* [HLS视频直播和点播的Nginx的Location的配置信息(成功)](/Nginx-Rtmp/HLS-live-vod-locatiuon-config.md)     

## Lua-Ngx
![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Nginx-Phase.png)

