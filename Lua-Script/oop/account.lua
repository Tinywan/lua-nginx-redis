--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/24
-- Time: 9:10
-- To change this template use File | Settings | File Templates.
-- Lua 面向对象编程 那么LUA中的类可以通过table + function模拟出来
local _M = {}
-- setmetatable(mytable,mymetatable)     -- 把 mymetatable 设为 mytable 的元表
local mt = { __index = _M }

function _M.deposit (self, v)
    self.balance = self.balance + v
end

function _M.withdraw (self, v)
    if self.balance > v then
        self.balance = self.balance - v
    else
        error("insufficient funds")
    end
end

-- 那么LUA中的类可以通过table + function模拟出来
function _M.new (self, balance)
    balance = balance or 0
    return setmetatable({balance = balance}, mt)    -- 把 mt 设为 balance 的元表,其中 mt 代表 { __index = _M }
end
--setmetatable 将 _M 作为新建表的原型，所以在自己的表内找不到 'deposit'、'withdraw' 这些方法和变量的时候，便会到 __index 所指定的 _M 类型中去寻找

return _M

