-- lua-01.lua 
local _M = {}   
local data = {dog = 3,cat = 4,pig = 5,}   
function _M.get_age(name)      
    return data[name]  
end   
return _M

--[[
    location /lua_file {
                default_type 'text/html';  -- 设置该行，则在浏览器就可以访问了
                lua_code_cache off;     --  关闭缓存
                content_by_lua_block {
                        local mydata = require "../Lua/lua-01"
                         ngx.say(mydata.get_age("dog"))
                }
         }
--]]