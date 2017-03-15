-- 定义一个表
members = {Tom=12,Jake=14,Lucy=13,Lili=12,Lihua=18}

-- 遍历这个容器表
for key,value in pairs(members) do
    print("key : ",key,"value : ",value)
end
--[[
打印结果：
        key : 	Tom 	value : 	12
        key : 	Jake	value : 	14
        key : 	Lili	value : 	12
        key : 	Lihua	value : 	18
        key : 	Lucy	value : 	13
--]]

-- 遍历一个数组
arrs = {"Tinywan","Tinyaiai","Tinyboys"}
for k,v in pairs(arrs) do
    print(k,v)
end
--[[
打印结果：
        1	Tinywan
        2	Tinyaiai
        3	Tinyboys
--]]
print('-------------------------------------------')
-- 中途退出for循环
arrsw = {Tome=20,Jhom=30,Jhonn=40,Jkok=32}
for k,v in pairs(arrs) do
    print('for 循环次数统计:',k)
    if v == 30 then
        print("Break",v)
        break  -- 跳出整个遍历的过程
    end 
    --print(k,v)
end