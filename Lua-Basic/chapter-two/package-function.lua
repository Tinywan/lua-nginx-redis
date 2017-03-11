-- 定义一个包名，为容器的表
RedisMethod = {};

function RedisMethod.set(key,value)
    return key + value
end

function RedisMethod.get(key)
    return key + 120
end

function RedisMethod.hset(key,value)
    return key + value
end

function RedisMethod.hget(key,value)
    return key + 110
end

--[[
    包的访问方式：
    [1] 首先要引入这个文件名：require("package-function")
    [2] 使用包名.函数名 访问该函数 如：RedisMethod.set(1,1) -- =2
--]]