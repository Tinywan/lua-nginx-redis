--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/24
-- Time: 9:18
-- To change this template use File | Settings | File Templates.
--
local account = require "account"

local a = account:new()
a:deposit(100)

local b = account:new()
b:deposit(50)

print(a.balance)  --> output: 100
print(b.balance)  --> output: 50

