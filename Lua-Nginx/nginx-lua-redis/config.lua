--[[
  Author: Tinywan
  Mail: Overcome.wan@Gmail.com
  Date: 2017/3/12
  Github: https://github.com/Tinywan  
  Description: 这是一个配置文件信息包
--]]

local M = {}
local redis = {}
redis['host'] = '127.0.0.1'
redis['port'] = 6379
redis['pwd'] = 'tinywanredis' 
redis['prefix'] = 'url_server:'
redis['info'] = 'info_ad:'
redis['count'] = 'count_ad:'

local err_msg = {}
err_msg[42] = 'URL is invalid'
err_msg[51] = 'Redis is out of service'
err_msg[52] = 'Getting data error'

local default = {}
default['url'] = 'http://127.0.0.1/url'

M['redis'] = redis
M['err_msg'] = err_msg
M['default'] = default

return M