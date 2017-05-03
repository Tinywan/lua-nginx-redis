## Openresty_rtmp_obs_push.md

#### nginx.conf
```lua
    # rtmp auth_key
    location /rtmp_redirect_lua {
            lua_code_cache off;
            access_by_lua_file /opt/openresty/nginx/conf/lua/rtmp_auth_key.lua;
    }
```

#### rtmp_auth_key.lua 文件
```lua
local cjson = require "cjson"
local redis = require("resty.redis_iresty")
local var = ngx.var
local client_ip = var.remote_addr
local client_port = var.remote_port

ngx.req.read_body()
local post_var = ngx.req.get_post_args()
local stream_name = post_var.name
local app = post_var.app
local action = post_var.call

local red = redis:new()
-- 权限验证
local res,err = red:auth('=123123')
if not res then
     ngx.say("failed to authenticate: ", err)
     return
end
red:select(1)

local res, err = red:sismember('StreamNameValidityCheck',stream_name)
if not res then
     ngx.log(ngx.WARN, "warn: failed to sismember: ", res)
     return
end
-- auth flag
if tonumber(res) ~= 1 then
    local ok, err = red:multi()
    if not ok then
        ngx.log(ngx.ERR, "error: failed to run multi: ", err)
        return
    end

    local ok, err = red:zrem('NonInterfaceStreamName',stream_name)
    if not ok then
        ngx.log(ngx.ERR, "error: zrem failed : ", err)
        return
    end

    --local ok, err = red:zadd('NonInterfaceStreamName',ngx.time(),client_ip..':'..client_port..'=:'..stream_name)
    local ok, err = red:zadd('NonInterfaceStreamName',ngx.time(),stream_name)
    if not ok then
        ngx.log(ngx.ERR, "error: failed to run multi: ", err)
        return
    end

    local ans, err = red:exec()
    if not ans then
        ngx.log(ngx.WARN, "warn: failed to sismember: ", res)
        return
    end
    --ngx.log(ngx.ERR, "warn: RTMP to sismember: ",ngx.HTTP_BAD_REQUEST)
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end
ngx.exit(ngx.HTTP_OK)
```
#### post 请求方式
```lua
curl -d "name=CY0000768621&app=live123&call=publish_done_12" http://localhost:8081/rtmp_redirect_lua
```

#### 状态码查看
```javascript
www@ubuntu4:/opt/openresty/nginx/conf/lua$ curl -I http://localhost:8081/rtmp_redirect_lua
HTTP/1.1 400 Bad Request
Server: openresty/1.11.2.1
Date: Tue, 02 May 2017 09:59:42 GMT
Content-Type: text/html
Content-Length: 179
Connection: close
```
