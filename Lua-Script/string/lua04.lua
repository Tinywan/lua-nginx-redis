--
-- Created by IntelliJ IDEA.
-- User: tinywan
-- Date: 2017/5/31
-- Time: 20:42
-- To change this template use File | Settings | File Templates.
--
--config = {host = '127.0.0.1',port = '3306', dbname = 'LuaDB' }
--config.redis_host = "192.168.1.1"
--config.redis_port = "6379"
--config.redis_db = "12"
--print(config['redis_host'])     -- 192.168.1.1
--print(config.redis_port)        -- 6379
--print(config.dbname)            -- LuaDB
--
--for k, v in pairs(config) do
--    print(k,v)
--end
--
----[[
--host    127.0.0.1
--dbname	LuaDB
--redis_host	192.168.1.1
--redis_db	12
--redis_port	6379
--port	3306
---- ]]
--arr = {}
--for var = 1,100 do      -- for 循环
--    table.insert(arr,1,var)
--end
--
--for k, v in pairs(arr) do   -- 遍历表
--    print(k,v)
--end
----[[
--1	100
--2	99
--... ...
--99	2
--100	1
--
---- ]]
--print(table.maxn(arr))  -- table长度 100
--print(#arr)     -- table长度（快捷方式） 100

arr = {host = '127.0.0.1',port = '3306','Tinywan'}
-- 如果没有找到下标为整数的则直接退出，是整数的则直接输出，如上面的'Tinywan'
for k, v in ipairs(arr) do  -- 只能遍历key 为整数的下标
    print(k,v)   -- 1   Tinywan
end



