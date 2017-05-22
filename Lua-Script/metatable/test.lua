--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/22
-- Time: 12:53
-- To change this template use File | Settings | File Templates.
--- 普通表
mytable = {}

-- 元表
mymetatable = {}

-- 把 mymetatable 设为 mytable 的元表 以上代码也可以直接写成一行 mytable = setmetatable({},{})
setmetatable(mytable,mymetatable)

-- 这回返回mymetatable
getmetatable(mytable)