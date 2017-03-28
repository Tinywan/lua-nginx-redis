## Nginx指令执行命令（01）
+   `rewrite` 发生在`content`每个请求处理的相位之前，它的命令也被执行得更早
   
    + 案例
    ```
    server {
        listen       8008;
        server_name  localhost;
        location /sum {
                set $a 44;
                echo $a;
                set $a 66;
                echo $a;
        }
    }

    ```

    + 实际的执行顺序是：
    ```
    set $a 44;
    set $a 66;
    echo $a;
    echo $a;
    ```
    + 两个命令 设置在执行阶段`rewrite`，两个命令 回声在随后阶段执行`content`。不同阶段的命令无法执行。
    
+   Lua 脚本变量 ` ngx.var.remote_addr` =  Nginx的的内建变量 ` $REMOTE_ADDR`  
## Nginx指令执行命令（05）
+   多个命令的执行顺序
    + 顺序： ` rewrite phase `=> `access phase` => `content phase`
    ```
    location /test_rewrite_access_content {
                # rewrite phase
                set $age 1;
                rewrite_by_lua_block {
                        ngx.var.age = ngx.var.age + 1
                }

                # access phase
                deny 10.32.168.49;
                access_by_lua_block {
                        ngx.var.age = ngx.var.age * 3
                }

                #content phase
                echo "age = $age";
    }
    ```
    + 测试结果
    ```
    # curl http://127.0.0.2:8008/test_rewrite_access_content
    age = 6

    ```
    +  执行顺序结论
        > [1] 由ngx_rewrite模块 实现的命令 集同步执行rewrite。模块 ngx_lua的命令 rewrite_by_lua在阶段结束时执行

        > [2] 模块 ngx_access的命令被 拒绝同步执行。模块 ngx_lua的命令 access_by_lua在阶段结束时执行。

        > [3] 最后，我们最喜欢的命令 echo，由ngx_echo模块实现 ，执行阶段。

        > [4] 最后的执行顺序：rewrite access access content

    +  命令` set `集和命令 `rewrite_by_lua ` 都属于阶段 `rewrite`   
    +  命令` deny `集和命令 `access_by_lua ` 都属于阶段 `access`  
    +  命令` set `集和命令 `rewrite_by_lua ` 都属于阶段 `rewrite` 
+   下面的这样写是错误的 XXXXXXXXXX
    + 错误写法？？？？？
        ```
        ? location /test {
        ?     content_by_lua 'ngx.say("hello")';
        ?     content_by_lua 'ngx.say("world")';
        ? }
        ```  
    + 不是每个模块都支持在一个内部执行多次命令location。命令 content_by_lua为一个实例，只能使用一次
    + 正确写法
        ```
        location /test {
            content_by_lua 'ngx.say("hello") ngx.say("world")';
        }
        ```
    + 而不是使用content_by_lua两次 命令location，方法是在Lua代码中调用函数 ngx.say两次，该代码由命令content_by_lua执行
+   模块 ngx_proxy的命令 proxy_pass不能与一个中的命令echo共存， 因为它们都在同步执行  
    + 错误写法！！！！！！！！！
    ```
    ? location /test {
    ?     echo "before...";
    ?     proxy_pass http://127.0.0.1:8080/foo;
    ?     echo "after...";
    ? }
    ?
    ? location /foo {
    ?     echo "contents to be proxied";
    ? }
    ```
    + 测试结果
    ```
    $ curl 'http://localhost:8080/test'
    contents to be proxied
    ```      
    + 结论：该示例尝试在模块ngx_proxy返回其内容之前和之后 输出字符串"before..."和"after..."命令 echo。但是只有一个模块可以执行。测试表明模块 ngx_proxy获胜并且命令 echo来自模块 ngx_echo永远不会运行 content
    + 为了实现这个例子想要的，我们将使用模块ngx_echo， echo_before_body和 echo_after_body提供的另外两个命令
    ```
        location /test {
            echo_before_body "before...";
            proxy_pass http://127.0.0.1:8080/foo;
            echo_after_body "after...";
        }

        location /foo {
            echo "contents to be proxied";
        }
    ```
+   反向代理：可以看出反向代理前和反向代理后的结果
    + 案例
    ```
    location /echo_test {
            echo_before_body "before...";
            proxy_pass http://127.0.0.1:8008/tinywan;
            echo_after_body "after...";
        }
    location /tinywan {
             echo "contents to be proxied";
    }

    ```    
    + 测试结果
    ```
    root@tinywan:/opt/openresty/nginx/conf# curl http://127.0.0.2:8008/echo_test
    before...
    contents to be proxied
    after...
    ```
    + 命令echo_before_body和 echo_after_body可以与其他模块同步共存的原因 content是，它们不是Nginx的“内容处理程序”，而是“输出过滤器”
## Nginx指令执行命令（06）
+   当一个命令在 ` content ` 一个特定的阶段执行时 ` location `，通常意味着它的Nginx模块注册了一个 ` 内容处理程序 （content handler）`
+   没有模块将其命令注册为“内容处理程序”时候，将获得产生内容和产出回应是静态资源模块，它将请求URI映射到文件系统。只有当没有“内容处理程序”时，静态资源模块才会发挥作用，否则它将“责任”移交给“内容处理程序”
+   Nginx有三个静态资源模块用于该content阶段( 按照执行顺序排列 )
    +  (1) `ngx_index` 模块
    +  (2) `ngx_autoindex` 模块
    +  (3) ` ngx_static `  模块
+   ngx_index和 ngx_autoindex模块 仅适用于那些以URI为结尾的请求URI /。对于不以其他方式结束的其他请求URI /，两个模块都将忽略它们，并让以下content阶段模块处理。ngx_static然而，模块具有完全相反的策略。它忽略结束的请求URI /并处理其余的
+   模块 ngx_index主要查找特定的主页文件，如文件系统index.html或index.htm文件系统
    ```
    location / {
        root /var/www/;
        index index.htm index.html;
    }
    ```  
    + 当地址 `/ ` 请求，Nginx的查找文件 ` index.htm `，并 `index.html` 在文件系统中的路径（按照这个顺序）。路径由命令 根目录指定。如果文件 `index.htm` 存在，Nginx内部跳转到位置 `index.htm`; 如果不存在并且文件 ` index.html` 存在，Nginx将内部跳转到位置`index.html`。如果文件 `index.html` 不存在，并且处理转移到同步执行命令的其他模块 `content`  