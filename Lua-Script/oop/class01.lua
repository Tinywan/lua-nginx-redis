--
local Sharp = { _val = 1 }       --①  父类

function Sharp:new()
    local new_sharp = {}
    self.__index = self          --②，self == Sharp Sharp.__index = Sharp 等价于 Sharp.__index = function(key) return Sharp[key] end
    setmetatable(new_sharp, self)
    return new_sharp
end

-- define fun1
function Sharp:sharp_func()
    print("Sharp call sharp_func")
end

-- define fun2
function Sharp:name()
    print("Sharp call name")
end

-- define fun3
function Sharp:val()
    print(string.format("Sharp call val %d", self._val))
end

local sharp = Sharp:new()
sharp:sharp_func()
sharp:name()
sharp:val()