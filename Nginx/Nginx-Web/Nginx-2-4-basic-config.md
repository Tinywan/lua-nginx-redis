
#### Nginx服务器基础配置命令
---
+ 基于域名的虚拟主机配置
    + 语法格式：
    ```
    server_name name name2 name3 ...            # 可以有一个或者多个名称并列，之间用空格隔开
    ```
    + 普通案例：
    ```
    server_name www.tinywan.com      www.redis.com    # 第一个名称作为虚拟主机的主要名称
    ```
     + 通配符案例：
    ```
    server_name *.tinywan.com      www.redis.*        # 通配符只能用在域名字符串名称的手段或尾端
    ```
     + 正则匹配案例：
    ```
    server_name ~^www\d+\.tinywan.com$    
    ```
    > 波浪号 ` ~ ` 作为正则表达式字符串的开始标记   
    > 正则表达式含义：   
    >>` ^www ` 以 www 开头    
    >>` \d+ ` ,`\d` 代表 0 ~ 9 的某一个数字，`+` 表示以前的字符出现一次或者多次   
    >>`\.` ,由于`.`在正则表达式有特殊含义，因此需要转义字符`\`进行转义   
    >> ` m$` 表示一个m结束  

    + 访问服务器域名
    > 可以访问   
    ```
    www1.tinywan.com    
    ```   

    > 不可以访问   
    ```
    www.tinywan.com 
    ```
+ 基于IP的虚拟主机配置 
    + 本机IP地址为: `192.168.127.129`
    + 添加 IP 别名 (`192.168.127.131` 和 `192.168.127.141`)
    ```
    sudo ifconfig ens33:0 192.168.127.131 netmask 255.255.255.0 up

    sudo ifconfig ens33:1 192.168.127.141 netmask 255.255.255.0 up
    ```
    + 将以上两条命令添加到Linux 系统的启动脚本rc.local 中，系统重启后，ens33 的别名就自动设置好了(注意：sudo 权限)
    ```
    echo "ifconfig ens33:1 192.168.127.131 netmask 255.255.255.0 up" >> /etc/rc.local

    echo "ifconfig ens33:1 192.168.127.131 netmask 255.255.255.0 up" >> /etc/rc.local
    ```
    + /etc/rc.local 解释
    >在Linux启动的最后阶段，系统会执行存于rc.local中的命令   

    + 配置虚拟主机
    ```
    server {
        listen 80;
        server_name  192.168.127.131;
        location / {
            root   /usr/local/nginx/html2;
        }
    }

    server {
        listen 80;
        server_name 192.168.127.141;
        location / {
            root   /usr/local/nginx/html3;
        }
    }
    ```


          
