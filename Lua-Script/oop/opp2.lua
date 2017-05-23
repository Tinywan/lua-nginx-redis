--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/23
-- Time: 17:29
-- To change this template use File | Settings | File Templates.
--
--local a = {}        -- 普通表
--local b = {k = 11}  -- 元表
--setmetatable(a,b)   -- 把 b 设为 a 的元表
--print(a.k)          -- nil
--b.__index = b       --设置元方法
--b.v = 22                 --给b表增加一个属性
--a.aa = 33                --给a表增加一个属性
--print(a.k)               --11,因为a有元表b，且存在元方法，可以索引到b表中对应的值
--print(a.v)               --22，设定关系后，b增加的属性，a也可以索引到
--print(b.aa)              --nil，相反，b并不可以索引到a的值

local a = {}        -- 普通表
local b = {k = 11}  -- 元表
setmetatable(a,{__index = b } )
print(a.k)
b.v = 1020
a.aa = 3030
print(a.v)               --22，设定关系后，b增加的属性，a也可以索引到
print(a.aa)              --nil，相反，b并不可以索引到a的值

