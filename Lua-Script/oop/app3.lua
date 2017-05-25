--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/5/25
-- Time: 17:02
-- To change this template use File | Settings | File Templates.
--
local db = 1
if not db then
    print("failed to instantiate mysql: ", err)
    --return
end
print('OK')

--[[
[1] db = nill
    failed to instantiate mysql: 	nil
    OK
[2] db ~= nil
    OK
--]]

