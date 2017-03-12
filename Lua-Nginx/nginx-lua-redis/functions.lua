--[[
  Author: Tinywan
  Mail: Overcome.wan@Gmail.com
  Date: 2017/3/12
  Github: https://github.com/Tinywan 
  Description: 这是一个公共函数类包 
--]]
local config = require 'config'
local redis = require "redis"
local M = {}

function M.redis_connect()
    local red = redis:new()
    red:set_timeout(1000)
    local ok, err = red:connect(config['redis']['host'], config['redis']['port'])
    if not ok then
        return nil, 51
    end
    local res, err = red:auth(config['redis']['password'])
    if not res then
        return nil, 51
    end
    return red
end

function M.get_long_url(short_string)
    if ngx.re.find(short_string, '[^0-9a-zA-Z]') then
        return false, 42
    end
    local red, err = M.redis_connect()
    if err then
        return false, err
    end
    local result, err = red:hget(config['redis']['prefix'] .. config['redis']['info'] .. short_string, "link")
    if err then
        return nil, 52
    end
    if result ~= ngx.null then
        local date = os.date("%Y%m%d")
        red:incr(config['redis']['prefix'] .. config['redis']['count'] .. short_string .. ":" .. date)
        red:set_keepalive(10000, 100)
        return result
    else
        return config['default']['url']
    end
end

function M.show_error(err_code)
    local result = {}
    result['status'] = 0
    result['error'] = err_code
    result['msg'] = config['err_msg'][err_code]
    ngx.say(cjson.encode(result))
    ngx.exit(ngx.HTTP_OK)
end

return M