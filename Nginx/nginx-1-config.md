
## Nginx 陷阱和常见错误（以下为正确或者推荐配置）
---
*  把 root 放在 location 区块外  
    ```
        server {
            server_name www.example.com;
            root /var/www/Nginx -default/;
            location / {
                # [...]
            }
            location /foo {
                # [...]
            }
            location /bar {
                # [...]
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
    
