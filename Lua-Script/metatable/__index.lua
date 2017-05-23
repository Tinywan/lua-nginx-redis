--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/23
-- Time: 16:51
-- To change this template use File | Settings | File Templates.
--[1]
--local other = { foo = 3 }
--t = setmetatable({}, { __index = other })
--print(t.foo) -- 3
--print(t.far) -- nil

--[2] 如果__index包含一个函数的话，Lua就会调用那个函数，table和键会作为参数传递给函数
--mytable = setmetatable({key1 = "value1"}, {
--    __index = function(mytable, key)
--        if key == "key2" then
--            return "metatablevalue"
--        else
--            return nil
--        end
--    end
--})
--
--print(mytable.key1,mytable.key2)
mytable = setmetatable({key1 = "value1"}, { __index = { key2 = "metatablevalue123" } })
print(mytable.key1,mytable.key2) -- value1	metatablevalue123


