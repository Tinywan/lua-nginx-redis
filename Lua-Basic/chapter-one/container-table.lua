-- Lua 只有一个容器，那就是table
a = {"Tome","Jake"}
-- 取出数组中的值
print(a[1],a[2]) -- 打印 Tome,Jake

--[[
    如何表示键值对,Tome=>20,Jake=>32
--]]
arr = {Tome=20,Jake=32}
print(arr.Tome,arr.Jake) -- 打印：20，32