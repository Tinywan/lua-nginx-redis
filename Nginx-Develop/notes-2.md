## nginx变量使用方法详解(2)
+   `echo_exec` 指令属于 `ngx_echo` 模块，发起到 `location` 的`内部跳转`
    +   `内部跳转` 就是在处理请求的过程中，于服务器内部，从一个 location 跳转到另一个 location 的过程
    +   `外部跳转` set 指令 还有创建 Nginx 变量的副作用，即当作为赋值对象的变量尚不存在时，它会自动创建该变量

        > 利用 HTTP 状态码 301 和 302 所进行的“外部跳转”，因为由 HTTP 客户端配合进行跳转的，而且在客户端，用户可以通过浏览器地址栏这样的界面，看到请求的 URL 地址发生了变化
+   标准 ` ngx_rewrite` 模块的 `rewrite` 配置指令其实也可以发起“内部跳转” 
    ```
    server {
 
        listen 8080;
 
        location /foo {
            set $a hello;
            rewrite ^ /bar;
        }
 
        location /bar {
            echo "a = [$a]";
        }
    }
    ```
+   `rewrite` 发起 301 和 302 这样的“外部跳转”
+   Nginx 模块提供的“预定义变量”，或者说“内建变量”（builtin variables）
    +   变量 `$uri` 属于 `ngx_http_core ` 模块，可以用来获取当前请求的 URI（经过解码，并且不含请求参数）
    +   变量 `$request_uri` 用来获取请求最原始的 URI （未经解码，并且包含请求参数）
    +   案例
        ```
        location /test {
                echo "uri = $uri";
                echo "request_uri = $request_uri";
        }
        ``` 
    +   测试结果
        ```
        $ curl 'http://localhost:8080/test'
        uri = /test
        request_uri = /test
        
        $ curl 'http://localhost:8080/test?a=3&b=4'
        uri = /test
        request_uri = /test?a=3&b=4
        
        $ curl 'http://localhost:8080/test/hello%20world?a=3&b=4'
        uri = /test/hello world
        request_uri = /test/hello%20world?a=3&b=4
        ```    
+   内建变量其实并不是单独一个变量，而是有无限多变种的一群变量，即名字以 arg_ 开头的所有变量，我们估且称之为 $arg_XXX 变量群
+   Nginx 会在匹配参数名之前，自动把原始请求中的参数名调整为全部小写的形式
+   `set_unescape_uri` 配置指令属于 `ngx_set_misc `模块,对 URI 参数值中的 %XX 这样的编码序列进行解码
+   取 cookie 值的 $cookie_XXX 变量群
+   用来取请求头的 $http_XXX 变量群
+   用来取响应头的 $sent_http_XXX 变量群
+   [nginx变量使用方法详解(2)](http://www.ttlsa.com/nginx/nginx-var-2/)