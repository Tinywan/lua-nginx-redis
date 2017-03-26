 server {
    listen       8008;
    server_name  localhost;   
    location = /sum {
        # 只允许内部调用
        internal;
        # 这里做了一个求和运算只是一个例子，可以在这里完成一些数据库、
        # 缓存服务器的操作，达到基础模块和业务逻辑分离目的
        content_by_lua_block {
            local args = ngx.req.get_uri_args()
            ngx.say(tonumber(args.a) + tonumber(args.b))
        }
    }

    location = /app/test {
        content_by_lua_block {
            local res = ngx.location.capture(
                            "/sum", {args={a=3, b=8}}
                            )
            ngx.say("status:", res.status, " response:", res.body)
        }
    }
 }

 --[[
    输出结果：
    root@tinywan:/opt/openresty/nginx/conf/Lua# curl http://127.0.0.1:8008/app/test
    status:200 response:11
    
    （1）问题一，为何一下直接访问是错误的？ curl http://127.0.0.1:8008/sum  直接：500 错误!
        ngx.say(args.a.."---hello----"..args.b)
        ngx.say(tonumber(args.a) + tonumber(args.b))
 --]]

location = /sum {
    internal;
    content_by_lua_block {
        ngx.sleep(0.1)
        local args = ngx.req.get_uri_args()
        ngx.print(tonumber(args.a) + tonumber(args.b))
    }
}

location = /subduction {
    internal;
    content_by_lua_block {
        ngx.sleep(0.1)
        local args = ngx.req.get_uri_args()
        ngx.print(tonumber(args.a) - tonumber(args.b))
    }
}

 location = /app/test_parallels {
    content_by_lua_block {
        local start_time = ngx.now()
        local res1, res2 = ngx.location.capture_multi( {    -- 可以批量去执行 
                        {"/sum", {args={a=3, b=8}}},        -- ngx.location.capture_multi 函数
                        {"/subduction", {args={a=3, b=8}}}
                    })
        ngx.say("status:", res1.status, " response:", res1.body)
        ngx.say("status:", res2.status, " response:", res2.body)
        ngx.say("time used:", ngx.now() - start_time)
    }
}

location = /app/test_queue {
    content_by_lua_block {
        local start_time = ngx.now()                    -- ngx.now() = 1490443876.303
        local res1 = ngx.location.capture_multi( {      -- 单个去执行
                        {"/sum", {args={a=3, b=8}}}
                    })
        local res2 = ngx.location.capture_multi( {      -- 单个去执行
                        {"/subduction", {args={a=3, b=8}}}
                    })
        ngx.say("status:", res1.status, " response:", res1.body)
        ngx.say("status:", res2.status, " response:", res2.body)
        ngx.say("time used:", ngx.now() - start_time)
    }
}

--[[
    执行结果：

    root@tinywan:/opt/openresty/nginx/conf/Lua# curl http://127.0.0.1:8008/app/test_parallels
    status:200 response:11
    status:200 response:-5
    time used:0.10099983215332

    root@tinywan:/opt/openresty/nginx/conf/Lua# curl http://127.0.0.1:8008/app/test_queue
    status:200 response:11
    status:200 response:-5
    time used:0.20099997520447

    利用 ngx.location.capture_multi 函数，直接完成了两个子请求并行执行。当两个请求没有相互依赖，这种方法可以极大提高查询效率。
    两个无依赖请求，各自是 100ms，顺序执行需要 200ms，但通过并行执行可以在 100ms 完成两个请求。实际生产中查询时间可能没这么规整，
    但思想大同小异，这个特性是很有用的。

--]]