
#### Nginx日志服务
---

*   Nginx日志主要分为两种：访问日志和错误日志。日志开关在Nginx配置文件（/etc/nginx/nginx.conf）中设置，两种日志都可以选择性关闭，默认都是打开的 

**一、访问日志**   

*   访问日志主要记录客户端访问Nginx的每一个请求，格式可以自定义。通过访问日志，你可以得到用户地域来源、跳转来源、使用终端、某个URL访问量等相关信息。Nginx中访问日志相关指令主要有两条

> 1.log_format

| 字段 | 作用  | 案例 |
| :------------ |:---------------:| -----:|
| $server_name     | 虚拟主机名称        |   虚拟主机名称 |
| $remote_addr      | 记录客户端IP地址 | 218.108.35.150 |
| $remote_user | 远程客户端用户名称 |    如登录百度的用户名scq2099yt，如果没有登录就是空白 |
| $time_local | 访问的时间与时区 |    16/Mar/2017:17:50:52 +0800 时间信息最后的"+0800"表示服务器所处时区位于UTC之后的8小时 |
| $request | 请求的URI和HTTP协议|    这是整个PV日志记录中最有用的信息，记录服务器收到一个什么样的请求 |
| $status | 记录请求返回的http状态码 |    比如成功是200 |
| $uptream_status| upstream状态 |    比如成功是200 |
| $body_bytes_sent | 发送给客户端的文件主体内容的大小 |  比如899，可以将日志每条记录中的这个值累加起来以粗略估计服务器吞吐量 |
| $http_referer | 记录从哪个页面链接访问过来的 |  ... |
| $http_user_agent | 记录客户端浏览器信息 |  ... |
| $http_x_forwarded_for | 客户端的真实ip|  通常web服务器放在反向代理的后面，这样就不能获取到客户的IP地址了，通过$remote_add拿到的IP地址是反向代理服务器的iP地址。反向代理服务器在转发请求的http头信息中，可以增加x_forwarded_for信息，用以记录原有客户端的IP地址和原来客户端的请求的服务器地址。 |
| $ssl_protocol | SSL协议版本 |  比如TLSv1|
| $ssl_cipher | 交换数据中的算法 |  比如RC4-SHA|
| $upstream_addr | upstream的地址 |  即真正提供服务的主机地址|
| $request_time | 整个请求的总时间 |  ...|
| $upstream_response_time | 请求过程中，upstream的响应时间 |  0.1s|

> 2.access_log    
>> 格式：`access_log path(存放路径) [format(自定义日志格式名称) [buffer=size | off]]`   
>> 案例：`access_log logs/access.log main;`     
>> 上下文：`http、server、location`     
>> 注意要点：`Nginx进程设置的用户和组必须对日志路径有创建文件的权限，否则，会报错`    


**二、错误日志**

*   错误日志主要记录客户端访问Nginx出错时的日志，格式不支持自定义。通过错误日志，你可以得到系统某个服务或server的性能瓶颈等。因此，将日志好好利用，你可以得到很多有价值的信息。错误日志由指令error_log来指定`  

>> 格式：`error_log path(存放路径) level(日志等级)`   
>> 日志等级：`[ debug | info | notice | warn | error | crit ]`，从左至右，日志详细程度逐级递减，即debug最详细，crit最少        
>> 案例：`error_log logs/error.log info;` 
>> 上下文：`http、server、location`     
>> 注意要点：`error_log off并不能关闭错误日志，而是会将错误日志记录到一个文件名为off的文件中`        
>> 正确的关闭错误日志记录功能：`error_log /dev/null;`，上面表示将存储日志的路径设置为“垃圾桶” 
          
