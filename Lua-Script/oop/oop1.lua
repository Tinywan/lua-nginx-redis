--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/23
-- Time: 17:12
-- To change this template use File | Settings | File Templates.
-- 那么LUA中的类可以通过table + function模拟出来

-- Meta class
Shape = { area = 0 }

-- 基础类方法 new
function Shape:new(o, side)
    o = o or {}
    setmetatable(o, self)   -- self其实就相当于Java，C++中的this对象
    self.__index = self
    side = side or 0
    self.area = side * side;
    return o
end

-- 基础类方法 printArea
function Shape:printArea()
    print("面积为 ", self.area)
end

-- 创建对象
myshape = Shape:new(nil, 10)

-- 对象实例去访问该类的方法
myshape:printArea()

--setmetatable(table,metatable): 对指定table设置元表(metatable)