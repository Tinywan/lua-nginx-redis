--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/25
-- Time: 17:02
-- To change this template use File | Settings | File Templates.
--
----------------------------------------------------------- Lua面向对象1
-- local mt = {}
-- mt.__add = function(t1, t2)
-- print("两个Table 相加的时候会调用我")
-- end
-- local t1 = {}
-- local t2 = {}
--- - 给两个table 设置新的元表,一个元表就是一个table的值
-- setmetatable(t1, mt) -- meta:元素
-- setmetatable(t2, mt)
---- 进行相加操作
-- local t = t1 + t2
-- print(t)

--[[输出结果
两个Table 相加的时候会调用我
nil
--]]

----------------------------------------------------------- Lua面向对象2
-- 创建一个元表 （是创建一个类吗？）
local mt = {}
mt.__add = function(s1, s2)
    local result = ""
    if s1.sex == "boy" and s2.sex == "girl" then
        result = "一个男孩和一个女孩的家庭"
    elseif s1.sex == "girl" and s2.sex == "girl" then
        result = "两个女孩的家庭"
    else
        result = "未知孩子的家庭"
    end
    return result
end
-- 创建两个table，可以想象成是两个类的对象（实例化两个类）
local s1 = { name = "Per1", sex = "boy" }
local s2 = { name = "Per2", sex = "girl" }
-- 给两个table 设置新的元表,一个元表就是一个table的值
setmetatable(s1, mt)
setmetatable(s2, mt)
-- 进行加法操作
local result = s1 + s2
print(result) -- 一个男孩和一个女孩的家庭

----------------------------------------------------------- Lua面向对象2
local t = {
    name = "Tinywan"
}
local mt = {
    __index = function(table, key)
        print("虽然你调用了我不存在的字段和方法，不过没关系，我能检测出来" .. key)
    end
}
setmetatable(t, mt)
print(t.name)
print(t.age)
--[[输出结果
-- Tinywan
-- 虽然你调用了我不存在的字段和方法，不过没关系，我能检测出来age
-- nil
---- ]]

----------------------------------------------------------- Lua面向对象2
local t = {
    name = "Tinywan"
}
local mt = {
    money = 808080
}

mt.__index = mt
setmetatable(t, mt)
print(t.money)
-- 输出结果 808080

------------------------------------------------------------- Lua面向对象2
local t = {
    name = "Tinywan"
}
local mt = {
    __index = {
        money = 909090
    }
}
setmetatable(t, mt)
print(t.money)
-- 输出结果 909090

----------------------------------------------------------- Lua面向对象2
local smartMan = {
    name = "Tinywan",
    age = 26,
    money = 800000,
    say_fun = function()
        print("Tinywan say 大家好")
    end
}

local t1 = {}
local t2 = {}
local mt = { __index = smartMan } -- __index 可以是一个函数，也可以是一个函数
setmetatable(t1, mt)
setmetatable(t2, mt)
print(t1.money)
t2.say_fun()
--- 输出结果
-- 800000
-- Tinywan say 大家好













