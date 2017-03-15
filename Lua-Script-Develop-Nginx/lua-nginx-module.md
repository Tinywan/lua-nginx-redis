## Lua-Nginx-Module模块学习
### 原理介绍

*   原理介绍

    原理：ngx_lua将Lua嵌入Nginx，可以让Nginx执行Lua脚本，并且高并发、非阻塞的处理各种请求。Lua内建协程，这样就可以很好的将异步回调转换成顺序调用的形式。ngx_lua在Lua中进行的IO操作都会委托给Nginx的事件模型，从而实现非阻塞调用。开发者可以采用串行的方式编写程序，ngx_lua会自动的在进行阻塞的IO操作时中断，保存上下文；然后将IO操作委托给Nginx事件处理机制，在IO操作完成后，ngx_lua会恢复上下文，程序继续执行，这些操作都是对用户程序透明的。 每个NginxWorker进程持有一个Lua解释器或者LuaJIT实例，被这个Worker处理的所有请求共享这个实例。每个请求的Context会被Lua轻量级的协程分割，从而保证各个请求是独立的。 ngx_lua采用“one-coroutine-per-request”的处理模型，对于每个用户请求，ngx_lua会唤醒一个协程用于执行用户代码处理请求，当请求处理完成这个协程会被销毁。每个协程都有一个独立的全局环境（变量空间），继承于全局共享的、只读的“comman data”。所以，被用户代码注入全局空间的任何变量都不会影响其他请求的处理，并且这些变量在请求处理完成后会被释放，这样就保证所有的用户代码都运行在一个“sandbox”（沙箱），这个沙箱与请求具有相同的生命周期。 得益于Lua协程的支持，ngx_lua在处理10000个并发请求时只需要很少的内存。根据测试，ngx_lua处理每个请求只需要2KB的内存，如果使用LuaJIT则会更少。所以ngx_lua非常适合用于实现可扩展的、高并发的服务。

### Nginx Lua 指令 
---
* **set_by_lua**

    > 语法： set_by_lua res <lua−script−str>[res<lua−script−str> [ arg1 $ arg2 ...]

    ```
            location =/set_by_lua {
                    set $diff '';
                    set_by_lua $sum '
                    local a = 32
                    local b = 56
                    ngx.var.diff = a - b;
                    return a + b;
                    ';
                    echo "sum=${sum},diff=${diff}";
            }
    ```

    > 测试结果：

    ```
    curl 'http://localhost/set_by_lua'
    sum=88,diff=-24
    ```
* **set_by_lua_file**

    > 语法： set_by_lua_file res<path−to−lua−script−file>[res<path−to−lua−script−file>[arg1 $arg2 ...]

    ```
          location =/lua_set_args {
                default_type 'text/html';
                set_by_lua_file $num /usr/local/nginx/conf/lua_set_1.lua;
                echo $num;
        }
    ```
    
    > lua_set_1.lua 添加一下内容

    ```
        local uri_args = ngx.req.get_uri_args()
        local i = uri_args["i"] or 0
        local j = uri_args["j"] or 0
        return i + j
    ```

    > 测试结果：

    ```
    curl 'http://localhost/lua_set_args?i=2&j=10'
    12
    ```



    
