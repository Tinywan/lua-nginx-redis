--[[
  Author: Tinywan
  Mail: Overcome.wan@Gmail.com
  Date: 2017/3/12
  Github: https://github.com/Tinywan 
  Description: 这是一个公共函数类包 
  Help :https://github.com/openresty/lua-redis-parser
--]]

M = {}
local config = {ip='127.0.0.1',port=6379,auth='',db=0}
-- connect
function M.redis_connect()
    local redis = require("resty.redis")
    local redis_instance = redis:new()
          redis_instance:set_timeout(1000)
    --尝试连接到redis服务器正在侦听的远程主机和端口
    local ok,err = redis_instance:connect(config.ip,config.port)
    if not ok then
            ngx.say("connect redis error : ",err)
            return close_redis(redis_instance);
    end
    return redis_instance
end

-- close 
function M.close_redis(redis_instance)
        if not redis_instance then
                return
        end
        local ok,err = redis_instance:close();
        if not ok then
                ngx.say("close redis error : ",err);
        end
end

-- set parm [key ,value]
function M.redis_set(key,value)
    local redis_instance = M.redis_connect()
    local ok,err = redis_instance:set(key,value)
    if not ok then
        ngx.say("failed to set",key,err)
        return
    end 
    -- 返回设置结果信息
    ngx.say(key,"set result is: ", ok)
    M.close_redis(redis_instance)
end  

-- get 
-- parm key
-- return fail: false ,success:true
function M.redis_get(key)
    local redis_instance = M.redis_connect()
    local res,err = redis_instance:get(key)

    -- if not res then 
    --    ngx.say("failed to get dog: ", err)
    --    return false
    -- end  

    -- if res == ngx.null then
    --     ngx.say('data not found')
    --     return
    -- end   
    -- 返回获取的结果
    -- return res
     --M.close_redis(redis_instance)
     return res
     --ngx.say(key,' value is : ',res)
end

function M.redis_add(a,b)
    return a + b
end
local result = M.redis_get('url')
return result
-- print("test Redis",M.redis_get('msg'))
