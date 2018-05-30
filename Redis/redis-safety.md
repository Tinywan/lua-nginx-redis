## Redis 配置不当致使 root 被提权漏洞  

#### 问题来源  

阿里云报警，提示`Linux系统计划任务配置文件写入行为`，随后立即登录与主机返现redis服务被干掉了  

####  原因分析  

自己个人维护的一个项目在提交代码的时候把redis配置也提交到github了  

####  漏洞描述  

Redis 服务因配置不当，可被攻击者恶意利用。黑客借助 Redis 内置命令，可将现有数据恶意清空；如果 Redis 以 root 身份运行，黑客可往服务器上写入 SSH 公钥文件，直接登录服务器。  

#### 受影响范围  

对公网开放，且未启用认证的 Redis 服务器（没有设置密码的redis）  

#### 修复方案  

注意：以下操作，均需重启 Redis 后才能生效。  

#####  绑定需要访问数据库的 IP  

将 Redis.conf 中的 bind 127.0.0.1 修改为需要访问此数据库的 IP 地址。

绑定只允许内网可以访问：`bind 172.19.230.35`  

##### 设置访问密码   

在 Redis.conf 中 requirepass 字段后，设置添加访问密码。 

Redis官方建议，由于Redis速度很快，外部用户可以尝试使用对密码箱每秒150k密码。 这意味着你应该使用非常强大的密码，否则将很容易中断。  

密码强度最好是64字符以上，可以使用base64获取其他方式生成改密码

如：`requirepass WktjD1QB9xX2W/WktjD1QB9xX/oDZSnH8m283ern8YiFtY=v81xzLNU`

#####  修改 Redis 服务运行账号  

以较低权限账号运行 Redis 服务，且禁用该账号的登录权限。  

* 当前redis运行账号为：`root`  
* 新建较低权限账号`redis`用户：`sudo useradd -s /bin/bash -d /home/redis -m redis -g www -G www`  
  > dsfds
  > fsdfds

* 修改用户组：`sudo usermod -g www redis`  
* 设置账号密码：`passwd redis`  
* 使用低权限账号` redis` 启动redis服务  
```bash
sudo -u redis ../bin/redis-server ./redis.conf  
```
* 查看redis启动用户信息  
```bash
ps -axu | grep redis
redis     2495  0.0  0.4  38472  4624 ?        Ssl  May29   0:22 /redis-server *:63009
redis     2510  0.0  0.3  36424  3528 ?        Ssl  May29   0:22 /redis-server 172.19.230.35:6379
```
> 启动两个服务，一个是通过公网可以访问，而另外一个是和内网绑定的  

* 可能会遇到权限问题  
  提示：`Failed opening the RDB file dump.rdb (in server root dir /home) for saving: Permission denied`，出现上面的问题原因适用于以前使用`root`账号启动服务，现在使用级别较低的`redis`启动服务，导致redis服务没办法加载db文件导致的 ，所以赋予该db文件为redis用户所属：`chown redis:www 63789-dump.rdb`  

* redis 参数优化配置  
  * 编辑 `vim /etc/sysctl.conf`文件，添加内容：`'vm.overcommit_memory = 1'`并且使用root执行`sysctl vm.overcommit_memory=1`是能够生效  
  * 使用root执行命令：`echo never > /sys/kernel/mm/transparent_hugepage/enabled`  

* 禁止`redis`运行账号登录 `passwd -l redis`，这就话的意思是锁定`redis`用户，这样该用户就不能登录了。  

#####  参考建议  

日志文件和数据库文件最好使用绝对路径  

* 日志文件路径：`logfile "/home/redis/log/6379.log"`   
* 数据库文件路径：`dir "/home/redis/data"`  

#### 使用xshell连接阿里云服务器登陆时密码框为灰色，无法输入密码解决办法  

* 使用阿里云`[远程连接]`   
* 编辑文件：`vi/etc/ssh/sshd_config`  
* 修改最后一项为yes：`PasswordAuthentication yes`  
* 保存退出，重启`sshd`服务`systemctl restart sshd.service`然后重新登陆，此时，一切就OK啦  

#### 参考文献  
* [redis crackit入侵事件总结](https://blog.csdn.net/u012573259/article/details/51803447)  
* [Redis 配置不当致使 root 被提权漏洞](https://help.aliyun.com/knowledge_detail/37433.html)  
* [linux 新建用户、用户组 以及为新用户分配权限](https://www.cnblogs.com/mingforyou/archive/2012/06/19/2555045.html)  







