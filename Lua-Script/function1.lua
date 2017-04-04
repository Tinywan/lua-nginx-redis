-- 函数
function add(a,b)
    return a+b
end

print('这两个数的和是:',add(12,4))

local _name = "Tinywan"
local man = {}

function man.GetName()
    return _name
end

function man.SetName(name)
    _name = name    
end

return man    