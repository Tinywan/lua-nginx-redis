
#### Nginx服务器TCP代理服务
---
* **Nginx 官方自带配置**  
    ```
    stream {
        upstream rtmp {
            server 127.0.0.1:8089; # 这里配置成要访问的地址
            server 127.0.0.2:1935;
            server 127.0.0.3:1935; #需要代理的端口，在这里我代理一一个RTMP模块的接口1935
        }
        server {
            listen 1935;  # 需要监听的端口
            proxy_timeout 20s;
            proxy_pass rtmp;
        }
    }
    ```
+   [参考博客地址](http://www.cnblogs.com/tinywan/p/6560889.html)        
         
