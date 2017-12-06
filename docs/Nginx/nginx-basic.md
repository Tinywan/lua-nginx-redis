
# Nginx 基础知识
---
+   [NGINX 所有 Modules](https://www.nginx.com/resources/wiki/modules/)

##  agentzh的Nginx教程（版本2016.07.21）

####  [agentzh的Nginx教程地址](https://openresty.org/download/agentzh-nginx-tutorials-zhcn.html)

####  Nginx 变量漫谈（一）
* Nginx 变量的值只有一种类型，那就是字符串
* Nginx “变量插值”

    ```bash
    location /test {
        set $first "hello ";
        echo "${first}world";
    }
    ```
* `set` 指令（以及前面提到的 geo 指令）不仅有赋值的功能，它还有创建 Nginx 变量的副作用，即当作为赋值对象的变量尚不存在时   
 
* Nginx 变量一旦创建，其变量名的可见范围就是整个 Nginx 配置，甚至可以跨越不同虚拟主机的 server 配置块

* Nginx 变量的生命期是不可能跨越请求边界的

#####  Nginx 变量漫谈（二）
+   跳转
    +   内部跳转：就是在处理请求的过程中，于服务器内部，从一个 location 跳转到另一个 location 的过程。         
    +   外部跳转： HTTP 状态码 301 和 302 所进行的“外部跳转”
+   标准 ngx_rewrite 模块的 rewrite 配置指令其实也可以发起“内部跳转”
+   Nginx 核心和各个 Nginx 模块提供的“预定义变量”         
+   Nginx 会在匹配参数名之前，自动把原始请求中的参数名调整为全部小写的形式         
+   如果你尝试改写另外一些只读的内建变量，比如 $arg_XXX 变量，在某些 Nginx 的版本中甚至可能导致进程崩溃。

####  Nginx 变量漫谈（三）
+    map 指令：用于定义两个 Nginx 变量之间的映射关系，或者说是函数关系            
+    map 指令只能在 http 块中使用           
+    map 配置指令的工作原理是为用户变量注册 “取处理程序”，并且实际的映射计算是在“取处理程序”中完成的，而“取处理程序”只有在该用户变量被实际读取时才会执行（当然，因为缓存的存在，只在请求生命期中的第一次读取中才被执行），所以对于那些根本没有用到相关变量的请求来说，就根本不会执行任何的无用计算。           

####  [Nginx的11个Phases](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-phases.md)

####  [Nginx 陷阱和常见错误](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-1-config.md)

####  [Nginx 高并发系统内核优化](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx/nginx-parameter-config.md)

####  [nginx 并发数问题思考：worker_connections,worker_processes与 max clients](http://liuqunying.blog.51cto.com/3984207/1420556?utm_source=tuicool)
+   从用户的角度，http 1.1协议下，由于浏览器默认使用两个并发连接,因此计算方法：
    1. nginx作为http服务器的时候：  
    `max_clients = worker_processes * worker_connections/2`
    1. nginx作为反向代理服务器的时候：  
    `max_clients = worker_processes * worker_connections/4`
+   从一般建立连接的角度,客户并发连接为1：
    1. nginx作为http服务器的时候：  
    `max_clients = worker_processes * worker_connections`
    1. nginx作为反向代理服务器的时候：  
    `max_clients = worker_processes * worker_connections/2`    
+   nginx做反向代理时，和客户端之间保持一个连接，和后端服务器保持一个连接
+   clients与用户数  
    同一时间的clients(客户端数)和用户数还是有区别的，当一个用户请求发送一个连接时这两个是相等的，但是当一个用户默认发送多个连接请求的时候，clients数就是用户数*默认发送的连接并发数了。    
