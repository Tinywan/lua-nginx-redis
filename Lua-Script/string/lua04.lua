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

--arr = {host = '127.0.0.1',port = '3306','Tinywan'}
---- 如果没有找到下标为整数的则直接退出，是整数的则直接输出，如上面的'Tinywan'
--for k, v in ipairs(arr) do  -- 只能遍历key 为整数的下标
--    print(k,v)   -- 1   Tinywan
-- end

--function count()
--    -- i属于一个非局部变量，因为它既不是全局变量，也不是单纯的局部变量（因为另外一个函数可以访问到它）
--    local i = 0
--    return function()
--        i =i +1
--        return i
--    end
--end
---- 以上 count()函数里的那个函数，加上一个非全局变量i,就构成一个闭合函数
---- 所以每次调用闭合函数，非局部变量的值都不会被重置
--local func = count()
--print(func())   -- 1
--print(func())   -- 2

--local eat
--local drink
--eat = function()
--    print("eat")
--    return drink() -- 这里的drink()属于尾调用,游戏角色的状态切换
--end
--drink = function()
--    print("drink")
--end
--eat()
--local name = "Lua1"
--if name ~= "Lua"
--then
--    error("[error] this is not Lua");
--end
--assert(name~="Lua"," this is not Lua")

function test()
    print(a[1])
end

-- pcall 除了会返回true或者false外，还能返回函数的错误信息。如果没有错误信息，err 会返回一个nil
local status,err = pcall(test)
if status then
    print('success')
else
    print('函数执行出错了')
    print('错误信息：',err)
end








