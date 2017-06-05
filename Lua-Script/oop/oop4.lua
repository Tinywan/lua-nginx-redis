--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/25
-- Time: 17:02
-- To change this template use File | Settings | File Templates.
----------------------------------------------------------- Lua面向对象2
-- local smartMan = {
-- name = "Tinywan",
-- age = 26,
-- money = 800000,
-- sayHello = function()
-- print("Tinywan say 大家好")
-- end
-- }
-- local t1 = {}
-- local mt = {
-- __index = smartMan,
-- __newindex = function(table, key, value)
-- print(key .. "字段不存在不要试图给他赋值")
-- end
-- }
-- setmetatable(t1, mt)
-- t1.sayHello = function()
-- print("HAHA")
-- end
-- t1.sayHello()
----- 输出结果
---- sayHello字段不存在不要试图给他赋值
---- Tinywan say 大家好

----------------------------------------------------------- Lua面向对象3
-- local smartMan = {
-- name = "none"
-- }
-- local other = {
-- name = "大家好，我是无赖的table"
-- }
-- local t1 = {}
-- local mt = {
-- __index = smartMan,
-- __newindex = other
-- }
-- setmetatable(t1, mt)
-- print("other的名字，赋值前：" .. other.name)
-- t1.name = "峨眉大侠"
-- print("other的名字，赋值后：" .. other.name)
-- print("t1 的名字：" .. t1.name)
----- 输出结果
---- other的名字，赋值前：大家好，我是无赖的table
---- other的名字，赋值后：峨眉大侠
---- t1 的名字：none

----------------------------------------------------------- Lua面向对象3
a = 'fdfd'
for n in pairs(_G) do
    print(n) -- 打印全局的函数和变量
end

--输出结果
--coroutine
--assert
--tostring
--tonumber
--io
--rawget
--xpcall
--arg
--ipairs
--print
--pcall
--gcinfo
--module
--setfenv
--getfenv
--pairs
--jit
--bit
--package
--error
--debug
--loadfile
--rawequal
--loadstring
--rawset
--unpack
--table
--require
--_VERSION
--newproxy
--collectgarbage
--dofile
--next
--math
--load
--os
--_G
--select
--string
--type
--getmetatable
--a （自己定义的也出来了）
--setmetatable












