## Openresty_rtmp_obs_push.md

#### nginx.conf
```lua
location /rtmp_redirect_lua {
        access_by_lua_file /opt/openresty/nginx/conf/lua/rtmp_auth_key.lua;
}

application live {
            live on;
            on_publish http://localhost:8081/rtmp_redirect_lua;
}
```

#### rtmp_auth_key.lua 文件
```lua
--[[-----------------------------------------------------------------------      
* |  Copyright (C) Shaobo Wan (Tinywan)
* |  Github: https://github.com/Tinywan
* |  Blog: http://www.cnblogs.com/Tinywan
* |------------------------------------------------------------------------
* |  Author: Tinywan
* |  Date: 2017/5/4
* |  Time: 16:25
* |  Mail: Overcome.wan@Gmail.com
* |------------------------------------------------------------------------
--]]
local cjson = require "cjson"
local redis = require("resty.redis_iresty")
local var = ngx.var

-- post var
ngx.req.read_body()
local post_var = ngx.req.get_post_args()
local stream_name = post_var.name
local app = post_var.app
local action = post_var.call

-- redis auth
local red = redis:new()
local res,err = red:auth('+=')
if not res then
     ngx.say("failed to authenticate: ", err)
     ngx.exit(ngx.HTTP_BAD_REQUEST)
end
-- select redis db
red:select(1)

--get push auth switch
local res, err = red:get('RTMPPushAuthSwitch')
if not res then
     ngx.log(ngx.WARN, "warn: RTMPPushAuthSwitch is not set: ", err)
     ngx.exit(ngx.HTTP_BAD_REQUEST)
end

--ngx.log(ngx.ERR, "error: TEST============: ", res)

if tonumber(res) == 0 then          -- 0 all allowed
	ngx.exit(ngx.HTTP_OK)
elseif tonumber(res) == 1 then      -- 1 web allowed
 	-- whitelist validation
    local res, err = red:sismember('StreamNameValidityCheck',stream_name)
    if not res then
        ngx.log(ngx.WARN, "warn: failed to sismember: ", res)
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    -- if set 
    if tonumber(res) ~= 1 then
        local ok, err = red:multi()
        if not ok then
            ngx.log(ngx.ERR, "error: failed to run multi: ", err)
            return
        end
        -- zrem member
        local ok, err = red:zrem('NonInterfaceStreamName',stream_name)
        if not ok then
            ngx.log(ngx.ERR, "error: zrem failed : ", err)
            return
        end

        local ok, err = red:zadd('NonInterfaceStreamName',ngx.time(),stream_name)
        if not ok then
            ngx.log(ngx.ERR, "error: failed to run multi: ", err)
            return
        end
        -- exec
        local ans, err = red:exec()
        if not ans then
            ngx.log(ngx.WARN, "warn: failed to sismember: ", res)
            return
        end
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    --if it is set
    ngx.exit(ngx.HTTP_OK) 
elseif tonumber(res) == 2 then          -- 2 all push is required to be auth_key
    --get var 
    --local uri = ngx.var.uri (uri = rtmp_redirect_lua) 这里有时间在继续研究 
    local var = ngx.req.get_post_args()
    local app = var.app
    local name = var.name
    local uri = '/'..app..'/'..name
    local auth_key = var.auth_key
	
    --ngx.log(ngx.ERR, "error: auth_key::uri====::",uri)	
    --expire_time vlidation
    local expire_time = string.sub(auth_key,0,10)
    --get current Unixtimestamp
    local res_time = ngx.time()
    if tonumber(expire_time) < tonumber(res_time) then
        ngx.log(ngx.ERR, "error : the push flow address has expired ")
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end

    --get private_key
    local private_key, err = red:get('private_key')
    if not private_key then
        ngx.log(ngx.ERR, "error: redis failed to get private_key ", err)
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end

    --create res_hash_value
    local rand = 0
    local uid = 0
    local seq_hash_value = string.sub(auth_key,-32)
    local sstring = uri.."-"..expire_time.."-"..rand.."-"..uid.."-"..private_key
    local res_hash_value = ngx.md5(sstring)

    --seq_hash_value vlidation
    if tostring(seq_hash_value) ~= tostring(res_hash_value) then
        ngx.log(ngx.ERR, "error: client hash_value is error value== ",seq_hash_value,"  server_hash_value== ",res_hash_value)
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    
    -- set name expire_time 7d = 604800
    local expire_timestamp = tonumber(expire_time)+tonumber(604800)
    local ok, err = red:hset("STREAM_GLOBAL:"..name,'expireTime',expire_timestamp)
    if not ok then
        ngx.log(ngx.ERR, "error: failed to set expire_time ", err)
    end
    ngx.exit(ngx.HTTP_OK)
else                                    -- unknown error
    ngx.log(ngx.ERR, "unknown Error 500 ")
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end
ngx.exit(ngx.HTTP_OK)

```
#### get 浏览器请求方式
```lua
http://127.0.0.1/stream_address_switch?switch_type=StreamAddressSwitch&switch_status=2&auth_key=1493863980-0-0-64f1a882229888aeae8db32b48271c84
set result: "1"
```
