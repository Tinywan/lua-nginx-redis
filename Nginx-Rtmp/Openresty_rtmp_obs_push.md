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
local redis = require("resty.redis_iresty")
ngx.req.read_body()
local post_var = ngx.req.get_post_args()
local stream_name = post_var.name
local app = post_var.app
local action = post_var.call

local red = redis:new()
-- 权限验证
local res,err = red:auth('1111')
if not res then
     ngx.say("failed to authenticate: ", err)
     return
end
red:select(1)

local res,err = red:sismember('ValidityCheck',stream_name)
--ngx.say(res)
--if not res then
--      ngx.say('failed to sismember ', err)
--      return
--end
if tonumber(res) ~= 1 then
        ngx.exit(ngx.HTTP_BAD_REQUEST)
end

-- red:hmset(myhash, { field1 = value1, field2 = value2, ... })
local ok, err = red:hmset("myhash9999:::"..stream_name, "name", app, "field2", action)
--local ok, err = red:hmset("Redis"..stream_name, { stream_name = "123213123" })
ngx.exit(ngx.HTTP_OK)
```