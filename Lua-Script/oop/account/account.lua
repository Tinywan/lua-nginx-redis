--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/6/6
-- Time: 17:14
-- To change this template use File | Settings | File Templates.
--
local _M = {}

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

function _M.new (self, balance)
    balance = balance or 0
    return setmetatable({balance = balance}, mt)
end

