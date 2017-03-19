
## Nginx服务器的代理服务
---
*  配置实例一：对所有请求实现一般轮询规则的负载均衡  
    ```
    upstream live_node {
        server 127.0.0.1:8089;
        server 127.0.0.1:8088;
    }
    server {
        listen 80;
        server_name  localhost;
        location / {
　　　　　　　　proxy_pass http://live_node;
        }
    }
    server {
        listen 8088;
        server_name  localhost;
        location / {
            root   /usr/local/nginx/html2;
            index  index.html index.htm;
        }
    }
    server {
        listen 8089;
        server_name  localhost;
        location / {
            root   /usr/local/nginx/html3;
            index  index.html index.htm;
        }
    } 
    ```
*  简单的使用“ index ”指令一次就够了。只需要把它放到 http {} 区块里面，下面的就会继承这个配置 
    
    ```
        http {
            index index.php index.htm index.html;
            server {
                server_name www.example.com;
                location / {
                    # [...]
                }
            }
            server {
                server_name example.com;
                location / {
                    # [...]
                }
                location /foo {
                    # [...]
                }
            }
        }
    ```
*  不要使用 if 判断 Server Name  
    > 不推荐

     ```
      server {
            server_name example.com *.example.com;
                if ($host ~* ^www\.(.+)) {
                    set $raw_domain $1;
                    rewrite ^/(.*)$ $raw_domain/$1 permanent;
                }
                # [...]
            }
        }
     ```
     > 推荐配置

     ```
      server {
            server_name www.example.com;
            return 301 $scheme://example.com$request_uri;
      }
      server {
            server_name example.com;
            # [...]
      }
     ```
*   使用主机名来解析地址

    > 不推荐配置

    ```
    upstream {
        server http://someserver;
    }

    server {
        listen myhostname:80;
        # [...]
    }
    ```

    > 推荐配置

    ```
    upstream {
        server http://10.48.41.12;
    }

    server {
        listen 127.0.0.16:80;
        # [...]
    }
    ```
*   [更多信息](https://moonbingbing.gitbooks.io/openresty-best-practices/content/ngx/pitfalls_and_common_mistakes.html)    
    
