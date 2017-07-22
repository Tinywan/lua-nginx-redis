## <a name="Linux_base_knowledge"/> Linux 基础知识
+   检查网卡是否正确工作
    1.  检查系统路由表信息是否正确
    1.  [Linux route命令详解和使用示例](http://www.jb51.net/LINUXjishu/152385.html)
    1.  案例介绍：
        ```  
        www@ubuntu1:/var/log$ route
        Kernel IP routing table
        Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
        default         122.11.11.161 0.0.0.0         UG    0      0        0 em1
        10.10.101.0     *               255.255.255.0   U     0      0        0 em2
        122.11.11.160 *               255.255.255.224 U     0      0        0 em1
        ```
        +   默认路由为：`122.11.11.161`,绑定在`em1` 网卡上
        +   而`10.10.101.0` 段的IP仅供局域网主机之间共享数据，没对外连接访问权限,因而外界是没办法通过`10`段网络连接到服务器的
        +   如果需要`10.10.101.0` 段可以让外网放完的,则需要删除`122.11.11.161` 的默认路由，需要在`em2`网卡上添加`10`段的默认路由即可
        +   具体步骤：
            ``` 
            www@ubuntu1:/var/log$   route delete defaul
            www@ubuntu1:/var/log$   route add defaul gw 10.10.101.1
            ```
        +   此时外界就可以通过`ssh www@10.10.101.2`连接到服务器了    
+ find 命令
    + 查找超出7天前的flv的文件进行删除：
        + 命令：
        ```Bash
        find ./ -mindepth 1 -maxdepth 3 -type f -name "*.flv" -mmin +10080 | xargs rm -rf 
        ```
        + `-type f` 按类型查找
        + `-mmin +10080` 7天之前的文件
        + xargs与-exec功能类似,` find ~ -type f | xargs ls -l `
        + -r 就是向下递归，不管有多少级目录，一并删除
        + -f 就是直接强行删除，不作任何提示的意思
    + 查找当前目录下.p文件中，最近30分钟内修改过的文件：
        + `find . -name '*.p' -type f -mmin -30`   
    + 查找当前目录下.phtml文件中，最近30分钟内修改过的文件，的详细de情况加上ls：
        + `find . -name '*.phtml' -type f -mmin -30 -ls`  
    + 查找当前目录下，最近1天内修改过的常规文件：`find . -type f -mtime -1`  
    + 查找当前目录下，最近1天前（2天内）修改过的常规文件：`find . -type f -mtime +1`    