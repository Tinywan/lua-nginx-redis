--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/6/6
-- Time: 8:57
-- To change this template use File | Settings | File Templates.
--
--在 Lua 5.1 语言中，元表 (metatable) 的表现行为类似于 C++ 语言中的操作符重载，例如我们可以重载 "__add" 元方法 (metamethod)，来计算两个 Lua 数组的并集；或者重载 "__index" 方法，来定义我们自己的 Hash 函数。Lua 提供了两个十分重要的用来处理元表的方法，如下：
--setmetatable(table, metatable)：此方法用于为一个表设置元表。
--getmetatable(table)：此方法用于获取表的元表对象

------------------------------------------------------ 通过重载 "__add" 元方法来计算集合的并集实例：
local set1 = {10,20,30}
local set2 = {40,50,60}
-- 将用于重载__add的函数，注意第一个参数是self
local union = function (self, another)
    local set = {}
    local result = {}

    -- 利用数组来确保集合的互异性
    for i, j in pairs(self) do set[j] = true end
    for i, j in pairs(another) do set[j] = true end

    -- 加入结果集合
    for i, j in pairs(set) do table.insert(result, i) end
    return result
end
setmetatable(set1, {__add = union}) -- 重载 set1 表的 __add 元方法

local set3 = set1 + set2
for _, j in pairs(set3) do
    io.write(j.." ")               -->output：30 50 20 40 10
end