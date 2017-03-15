local key=KEYS[1]   --local 显示声明为局部变量

local list=redis.call("lrange",key,0,-1) -- 局部变量

return list
