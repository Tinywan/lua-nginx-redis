--
-- Created by IntelliJ IDEA.
-- User: tinywan
-- Date: 2017/5/27
-- Time: 22:33
-- To change this template use File | Settings | File Templates.
--
--a = 'one HELLO'
--b = string.gsub(a,'one','two')
--print(a)    -- one HELLO
--print(b)    -- two HELLO

--print("10" + 1)       -- 11
--print("10" + "1")     -- 11
--print("10 + 1")       -- 10 + 1
--print("hello " .. " world")  -- hello  world
--- -print("hello" + 1)  -- 错误写法

--a = 10
--print(tostring(a))  -- 10
--b = "20"
--print(tonumber(b))  -- "20"
--
--print(tostring(10) == "10")  -- true
--print(10 .. "" == "10")      -- true

-- a and b          -- 如果a为false，则返回a ,否则返回b
-- a or b          --  如果a为true，则返回a ,否则返回b
--print(4 and 5)      -- 5
--print(nil and 12 )  -- nill
--print(false and 12) -- false
--print(4 or 5)       -- 4
--print(false or 5)   -- 5
--x = 20
--y = 30
--x,y = y,x
--print(x,y) -- 30 20

--a,b,c = 10,20
--print(a,b,c) --10 20 nil
--
--x,y,z = 10
--print(x,y,z) -- 10 nil nil
--a = 12
--if a>10 then
--   local i = 19
--    print(i)  -- 19
--end
--print(i)      -- nil

--members = { Tom = 10, Jake = 11, Dodo = 12, Jhon = 16 }
--
--for k, v in pairs(members) do
--    if v == 10 then
--        print(k, 'is 10 years old')
--    elseif v == 11 then
--        print(k, 'is 11 years old')
--    elseif v == 12 then
--        print(k, 'is 12 years old')
--    else
--        print(k, "is not 10,11,12 years old")
--    end
--end

--function more()
--    return 10 , 20 ,30
--end
---- 当函数位于最后一位的时候，返回全部值，否则值返回一个数值
--a , b , c ,d = 100, more()
--print(a,b,c,d) -- 100 10 20 30
a = {}
a.x = 100
a.y = 200
a["z"] = 300 -- a.z = 300
print(a.x) -- 100
print(a.y) -- 200
print(a.z) -- 300






