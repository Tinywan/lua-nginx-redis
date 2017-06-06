--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/6/6
-- Time: 9:47
-- To change this template use File | Settings | File Templates.
-- 自己尝试着写一个类哦

--
local ok, new_tab = pcall(require, "table.new")
if not ok or type(new_tab) ~= "function" then
    new_tab = function (narr, nrec) return {} end
end

local _M = new_tab(0, 54)       --①  父类

_M._VERSION = '0.01'

function _M:new()
    local new_obj = {}
    self.__index = self          --②，self == _M
    setmetatable(new_obj, self)
    return new_obj
end

-- 定义个简单的方法
function _M:func()
    print("Function func ")
end

return _M

