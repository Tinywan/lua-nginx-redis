-- 根据keys 获取string的值
local key=KEYS[1]
local string=redis.call("get",'foo')
return string
