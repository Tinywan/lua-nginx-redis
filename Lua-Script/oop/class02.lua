-- 类的继承
local Sharp = { _val = 1 } --①  父类

function Sharp:new()
    local new_sharp = {}
    self.__index = self --②，self == Sharp Sharp.__index = Sharp 等价于 Sharp.__index = function(key) return Sharp[key] end
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

Circle = Sharp:new() --① 子类
function Circle:new()
    local new_circle = {}
    self.__index = self --②，self == Circle
    setmetatable(new_circle, self) --③

    return new_circle
end

--新函数
function Circle:circle_func()
    print("Circle call circle_func")
end

--覆盖函数name
function Circle:name()
    print("Circle call name")
end

--覆盖函数val
function Circle:val()
    print(string.format("Circle call val %d", self._val))
end

local circle = Circle:new()
circle._val = 2         --覆盖赋值
circle:sharp_func()     --调用父类函数
circle:circle_func()    --调用新函数
circle:name()           --调用覆盖函数
circle:val()            --调用覆盖函数

--输出结果
--Sharp call sharp_func
--Circle call circle_func
--Circle call name
--Circle call val 2