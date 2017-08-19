## <a name="index"/>目录
+   Nginx 教程 
    +   [Nginx安装](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-install.md)
    +   [nginx.conf详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-base-config.md)
    +   [Nginx基础知识](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-basic.md)
    +   [Nginx高性能WEB服务器详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-high-basic.md) 
    +   [Nginx高并发系统内核优化和PHP7配置文件优化](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-parameter-config.md)
    +   [Nginx和PHP-FPM启动脚本](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-start-script.md)
+   Lua 教程    
    +  [Lua 基础语法](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/lua-basic.md)
    +  [Lua 模块与包](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/openresty-resty-module.md) 
    +  [luajit 执行文件默认安装路径](#Nginx_base_knowledge) 
    +  [lua中self.__index = self 详解](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/oop/self__index.md)      
+   Redis 教程    
    +   [Redis基础知识](#Redis_base_knowledge) 
    +   [Redis 简易安装教程](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-install.md) 
    +   [Redis 开发与运维](#Redis-DevOps)
    +   [Redis执行Lua脚本基本用法](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Redis/redis-lua.md)    
+   Openresty 教程
    +   [安装默认配置信息](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-basic.md) 
    +   [扩展模块学习](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-resty-module.md) 
    +   [ngx_lua APi 方法和常量](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-resty-module.md) 
    +   [lua-resty-upstream-healthcheck使用](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/lua-resty-upstream-healthcheck.md) 
    +   [Openresty与Nginx_RTMP](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Openresty/openresty-rtmp.md) 
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
## 开发过程记录
## <a name="githubpush"/> Visual Studio Code 向github提交代码不用输入帐号密码    
+   在命令行输入以下命令
    ```
    git config --global credential.helper store
    ```
    > 这一步会在用户目录下的.gitconfig文件最后添加:
    ```
    [credential]
    helper = store
    ```
+   push 代码
    > push你的代码 (git push), 这时会让你输入用户名和密码, 这一步输入的用户名密码会被记住, 下次再push代码时就不用输入用户名密码!这一步会在用户目录下生成文件.git-credential记录用户名密码的信息。
+   Markdown 的超级链接技术
    > 【1】需要链接的地址：
    ```
    [解决向github提交代码不用输入帐号密码](#githubpush)  
    ```
    > 【2】要链接到的地方：
    ``` 
    <a name="githubpush"/> 解决向github提交代码不用输入帐号密码
    ```
    > 通过【1】和【2】可以很完美的实现一个连接哦！
# 掘金爬虫

![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/github_good1.png)

# Lua-Ngx
![Markdown](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Images/Nginx-Phase.png)
# Live demo

Changes are automatically rendered as you type.

* Follows the [CommonMark](http://commonmark.org/) spec
* Renders actual, "native" React DOM elements
* Allows you to escape or skip HTML (try toggling the checkboxes above)
* If you escape or skip the HTML, no `dangerouslySetInnerHTML` is used! Yay!

## HTML block below

<blockquote>
    This blockquote will change based on the HTML settings above.
</blockquote>

## How about some code?
```js
var React = require('react');
var Markdown = require('react-markdown');

React.render(
    <Markdown source="# Your markdown here" />,
    document.getElementById('content')
);
```

Pretty neat, eh?

## More info?

Read usage information and more on [GitHub](//github.com/rexxars/react-markdown)

---------------

A component by [VaffelNinja](http://vaffel.ninja) / Espen Hovlandsdal

##  <a name="Linux_base_knowledge"/> Copyright and License

This module is licensed under the BSD license  

Copyright (C) 2017, by Wanshaobo "Tinywan".  