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