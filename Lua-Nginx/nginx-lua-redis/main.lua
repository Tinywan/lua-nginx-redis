--[[
  Author: Tinywan
  Mail: Overcome.wan@Gmail.com
  Date: 2017/3/12
  Github: https://github.com/Tinywan 
  Description: 这是一入口文件 
--]]
local redis = require("resty.redis")
require("redis")
print('redis.add() : ',M.redis_add(120,130))
