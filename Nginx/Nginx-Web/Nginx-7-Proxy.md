
#### Nginx服务器的代理服务
---
* **配置实例一：对所有请求实现一般轮询规则的负载均衡**  
    ```
       http {

            upstream live_node {                        # 配置后端服务器组
                server 127.0.0.1:8089;
                server 127.0.0.1:8088;
            }

            server {
                listen 80;
                server_name  localhost;
                location / {
                    proxy_pass http://live_node;
                    proxy_set_header Host $host;         # 保留客户端的真实信息
                }
            }

            server {                    # 配置虚拟服务器8088
                listen 8088;
                server_name  localhost;
                location / {
                    root   /usr/local/nginx/html2;      
                    index  index.html index.htm;
                }
            }

            server {                    # 配置虚拟服务器8089
                listen 8089;
                server_name  localhost;
                location / {
                    root   /usr/local/nginx/html3;
                    index  index.html index.htm;
                }
            }
        }
    ```
*  **配置实例二：对所有请求实现加权轮询规则负载均衡**  
    ```
       http {

            upstream live_node {                        # 配置后端服务器组
                server 127.0.0.1:8089 weight=5;         # 这个处理客户端请求会多些 
                server 127.0.0.1:8088 weight=1;         # 默认 weight = 1
            }

            server {
                listen 80;
                server_name  localhost;
                location / {
                    proxy_pass http://live_node;
                    proxy_set_header Host $host;         # 保留客户端的真实信息
                }
            }

            server {                    # 配置虚拟服务器8088
                listen 8088;
                server_name  localhost;
                location / {
                    root   /usr/local/nginx/html2;      
                    index  index.html index.htm;
                }
            }

            server {                    # 配置虚拟服务器8089
                listen 8089;
                server_name  localhost;
                location / {
                    root   /usr/local/nginx/html3;
                    index  index.html index.htm;
                }
            }
        }
    ``` 
*  **配置实例三：对特定资源实现负载均衡** 
    ```
       http {

            upstream videobackend {                     # 配置后端服务器组视频代理
                server 127.0.0.1:8088;         
                server 127.0.0.1:8089;        
            }

            upstream filebackend {                      # 配置后端服务器组文件代理
                server 127.0.0.1:8888;        
                server 127.0.0.1:8889;        
            }

            server {
                listen 80;
                server_name  localhost;
                location /video/ {
                    proxy_pass http://videobackend;      # 视频代理
                    proxy_set_header Host $host;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;         
                }

                location /file/ {
                    proxy_pass http://filebackend;       # 文件代理
                    proxy_set_header Host $host;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;         
                }
            }

            server {                    # 配置虚拟服务器8088
                listen 8088;
                server_name  localhost;
                location /video {
                     alias   /usr/local/nginx/html2;
                }
            }

            server {                    # 配置虚拟服务器8089
                listen 8089;
                server_name  localhost;
                location /video {
                     alias   /usr/local/nginx/html3;
                }
            }

            server {                    # 文件虚拟服务器1
                listen 8888;
                server_name  localhost;
                location /file {
                    alias   /usr/local/nginx/html4;
                }
            }

            server {                    # 文件虚拟服务器2
                listen 8889;
                server_name  localhost;
                location /file {
                    alias   /usr/local/nginx/html5;
                }
            }
        }
    ```    
   > 访问方式：`http://127.0.0.1/video/demo.txt`
   >>输出：`this is video HTML2 demo2 8088`   
   >>输出：`this is video HTML3 demo3 8089`

   > 访问方式：`http://127.0.0.1/file/demo.txt`   
   >>输出：`this is file HTML4 demo4 8888`   
   >>输出：`this is file HTML4 demo5 8889`

   >测数文件：`demo.txt` 
   >>`echo "this is video HTML2 demo2 8088" > ./html2/demo.txt`
    
*  **配置实例四：不同的域名实现负载均衡**  
    ```
       http {

            upstream frontend {                     # 配置后端服务器组视频代理
                server 127.0.0.1:8088;         
                server 127.0.0.1:8089;        
            }

            upstream backend {                      # 配置后端服务器组文件代理
                server 127.0.0.1:8888;        
                server 127.0.0.1:8889;        
            }

            server {
                listen 80;
                server_name  www.frontend.com;
                location /video/ {
                    proxy_pass http://frontend;      # 前台域名代理
                    proxy_set_header Host $host;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;         
                }
            }

            server {
                listen 8088;
                server_name  www.backend.com;
                location /video/ {
                    proxy_pass http://backend;      # 后台域名代理
                    proxy_set_header Host $host;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;         
                }
            }

        }
    ``` 
*  **配置实例五：实现带有URL重写的负载均衡**  
    ```
       http {

            upstream backend {                      # 配置后端服务器组
                server 127.0.0.1:8888;        
                server 127.0.0.1:8889;        
            }

            server {
                listen 80;
                server_name  www.backend.com;
                index  index.html index.htm;
                location /file/ {
                    rewrite ^(/file/.*)/media/(.*)\.*$ $1/mp3/$2.mp3 last;        
                }

                location / {
                    proxy_pass http://frontend;      # 前台域名代理
                    proxy_set_header Host $host;      
                }
            }

        }
    ``` 
    
   >客户端请求URL为：`http://www.backend.com/file/download/media/1.mp3`   
   >[1]：虚拟主机` location /file/ `块将该URL进行重写为:`http://www.backend.com/file/download/media/mp3/1.mp3`      
   >[2]：新的URL再有  ` location / `块转发转发到后端的backend服务器组中实现负载均衡    
   >[3]: 这样就可以实现URL重写的负载均衡            
