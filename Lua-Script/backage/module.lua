--
-- Created by IntelliJ IDEA.
-- User: Tinywan
-- Date: 2017/5/22
-- Time: 12:16
-- To change this template use File | Settings | File Templates.
--
-- 文件名为 module.lua
-- 定义一个名为 module 的模块
module = {}

-- 定义一个常量
module.constant = "这是一个常量"

-- 定义一个函数
function module.func1()
    io.write("这是一个公有函数！\n")
end

-- 定义一个私有函数，只允许内部调用 ，如果外部 module.func2() 会提示错误：at 0x004044a0
local function func2()
    print("这是一个私有函数！")
end

-- 通过定义一个普通方法使用外界调用，该方法是可以调用自己的私有函数的
function module.func3()
    func2()
end

return module

