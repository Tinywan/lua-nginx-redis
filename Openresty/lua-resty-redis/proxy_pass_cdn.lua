local function close_redis(redis_instance)  
    if not redis_instance then  
        return  
    end  
    -- local ok, err = redis_instance:close()  
    -- if not ok then  
    --     ngx.say("close redis error : ", err)  
    -- end 

    --释放连接(连接池实现)  
    local pool_max_idle_time = 10000 --毫秒  
    local pool_size = 100 --连接池大小  
    local ok, err = redis_instance:set_keepalive(pool_max_idle_time, pool_size)  
    if not ok then  
        ngx.say("set keepalive error : ", err)  
    end   
end 

-- 接受Nginx传递进来的参数$1 也就是SteamName
local stream_a = ngx.var.a

local redis = require("resty.redis");
-- 创建一个redis对象实例。在失败，返回nil和描述错误的字符串的情况下
local redis_instance = redis:new();
--设置后续操作的超时（以毫秒为单位）保护，包括connect方法
redis_instance:set_timeout(1000)
--建立连接
local ip = '127.0.0.1'
local port = 6379
--尝试连接到redis服务器正在侦听的远程主机和端口
local ok,err = redis_instance:connect(ip,port)
if not ok then
        ngx.say("connect redis error : ",err)
        return err
end

-- 权限验证
local res,err = redis_instance:auth('pass_tinywan')
if not res then
    ngx.say("failed to authenticate: ", err)
    return
end

--数据库选择 
redis_instance:select(2)

--调用API获取数据  
local resp, err = redis_instance:hget("CDNnode:"..stream_a,'livenode')
if not resp then
    ngx.say("get msg error : ", err)
    return err
end

--得到的数据为空处理  
if resp == ngx.null then
    ngx.say("this is not redis_data")  --比如默认值  
    return nil
end
ngx.var.stream_id = resp
close_redis(redis_instance)
-- ngx.say("reds get result : ", resp)
-- help doc http://jinnianshilongnian.iteye.com/blog/2187328