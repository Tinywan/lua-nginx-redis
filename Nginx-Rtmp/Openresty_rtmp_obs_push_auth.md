## Openresty_rtmp_obs_push.md

#### nginx.conf
```lua
# Hls StreamAddressSwitch
location /stream_address_switch {
    default_type 'text/html';
    lua_code_cache on;
    content_by_lua_file /opt/openresty/nginx/conf/lua/stream_address_switch.lua;
}
```

#### stream_address_switch.lua 文件
```lua
local cjson = require "cjson"
local redis = require("resty.redis_iresty")

local uri = ngx.var.uri
ngx.req.read_body()
local var = ngx.req.get_uri_args()

local switch_type = var.switch_type
local switch_status = var.switch_status
local auth_key = var.auth_key

-- expire_time vlidation
local expire_time = string.sub(auth_key,0,10)
local res_time = ngx.time()
if tonumber(expire_time) < tonumber(res_time) then
     ngx.say("The request url has expired ")
     ngx.exit(ngx.HTTP_OK)
end

local red = redis:new()
-- auth vlidation
local res,err = red:auth('1+1=')
if not res then
     ngx.say("failed to authenticate: ", err)
     return
end
red:select(1)

-- get private_key
local private_key, err = red:get('private_key')
if not private_key then
     ngx.log(ngx.ERR, "error: failed to get private_key ", err)
     return
end

-- create res_hash_value
local rand = "0"
local uid = "0"
local seq_hash_value = string.sub(auth_key,-32)
local sstring = uri.."-"..expire_time.."-"..rand.."-"..uid.."-"..private_key
local res_hash_value = ngx.md5(sstring)

--seq_hash_value vlidation
if tostring(seq_hash_value) ~= tostring(res_hash_value) then
	ngx.say("req_hash_value is error")
	ngx.exit(ngx.HTTP_OK)
end

-- set address switch status
local ok, err = red:getset(switch_type,switch_status)
if not ok then
     ngx.log(ngx.ERR, "error: failed to set StreamAddressSwitch ", err)
     ngx.say("failed to set info:",cjson.encode(err))
     ngx.exit(ngx.HTTP_OK)
end
ngx.say("set result: ", cjson.encode(ok))
ngx.exit(ngx.HTTP_OK)
```
#### get 浏览器请求方式
```lua
http://127.0.0.1/stream_address_switch?switch_type=StreamAddressSwitch&switch_status=2&auth_key=1493863980-0-0-64f1a882229888aeae8db32b48271c84
set result: "1"
```
