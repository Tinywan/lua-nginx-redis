--
-- Created by IntelliJ IDEA.
-- User: tinywan
-- Date: 2017/7/22
-- Time: 12:02
-- To change this template use File | Settings | File Templates.
-- [1]
local function factoricall(n)
    if tonumber(n) == 0 then
        return 1
    else
        return n* factoricall(n-1)
    end
end

print(factoricall(5))
fun1 = factoricall
print(fun1(5))

-- function 可以以匿名函数（anonymous function）的方式通过参数传递: anonymous
local function anonymous(tab,fun)
    for k , v in pairs(tab) do
        print(fun(k,v))
    end
end

tab_demo = {name = "Tinywan",age=24 }
anonymous(tab_demo,function(key,value)
    return key .. ' = '..value
end)
