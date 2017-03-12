local redis = require("resty.redis");
local redis_instance = redis:new();
redis_instance:set_timeout(1000)
local ip = '127.0.0.1'
local port = 6379

local ok,err = redis_instance:connect(ip,port)
if not ok then
        ngx.say("connect redis error : ",err)
        return err
end
-- 接受Nginx传递进来的参数$1 也就是SteamName
local stream_id = ngx.var.a
local resp, err = redis_instance:get("msg")
if not resp then
    ngx.say("get msg error : ", err)
    return err
end

if resp == ngx.null then
    ngx.say("this is not redis_data") 
    return nil
end

ngx.say("reds get result : ", resp)
