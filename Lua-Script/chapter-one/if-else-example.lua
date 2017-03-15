-- 条件判断
members = {Tom = 10,Jake = 11,Dodo = 12,Jhon = 16}

for k,v in pairs(members) do
    if v==10 then
        print(k,'is 10 years old')
    elseif v==11 then    
        print(k,'is 11 years old')
    elseif v==12 then
        print(k,'is 12 years old')    
    else
        print(k,"is not 10,11,12 years old")
    end
end

--[[
打印结果：
        Dodo	is 12 years old
        Jake	is 11 years old
        Jhon	is not 10,11,12 years old
        Tom	is 10 years old
--]]