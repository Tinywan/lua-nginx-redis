--[[
  Author: Tinywan
  Mail: Overcome.wan@Gmail.com
  Date: 2017/3/12
  Github: https://github.com/Tinywan  
--]]

ngx.header.content_type = 'text/html'
local config = require("config")
local functions = require("functions")

local short_string = ngx.re.sub(ngx.var.uri, "^/u/(.*)", "$1", "o")
local long_url, err = functions.get_long_url(short_string)
if err then
    functions.show_err(err)
end
ngx.redirect(long_url)    
