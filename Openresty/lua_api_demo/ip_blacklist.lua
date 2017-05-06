--[[-----------------------------------------------------------------------      
* |  Copyright (C) Shaobo Wan (Tinywan)
* |  Github: https://github.com/Tinywan
* |  Date: 2017/4/20 16:25
* |  Mail: Overcome.wan@Gmail.com
* |------------------------------------------------------------------------
* |  version: 1.0
* |  function: IP地址黑名单过滤
* |------------------------------------------------------------------------
--]]
local redis_host = "your.redis.server.here"
local redis_port = 6379

-- connection timeout for redis in ms. don't set this too high!
local redis_connection_timeout = 100

-- check a set with this key for blacklist entries
local redis_key = "ip_blacklist"

-- cache lookups for this many seconds
local cache_ttl = 60

-- end configuration

local ip = ngx.var.remote_addr
local ip_blacklist = ngx.shared.ip_blacklist
local last_update_time = ip_blacklist:get("last_update_time");

-- only update ip_blacklist from Redis once every cache_ttl seconds:
if last_update_time == nil or last_update_time < (ngx.now() - cache_ttl) then

    local redis = require "resty.redis";
    local red = redis:new();

    red:set_timeout(redis_connect_timeout);

    local ok, err = red:connect(redis_host, redis_port);
    if not ok then
        ngx.log(ngx.DEBUG, "Redis connection error while retrieving ip_blacklist: " .. err);
    else
        local new_ip_blacklist, err = red:smembers(redis_key);
        if err then
            ngx.log(ngx.DEBUG, "Redis read error while retrieving ip_blacklist: " .. err);
        else
            -- replace the locally stored ip_blacklist with the updated values:
            ip_blacklist:flush_all();
            for index, banned_ip in ipairs(new_ip_blacklist) do
                ip_blacklist:set(banned_ip, true);
            end

            -- update time
            ip_blacklist:set("last_update_time", ngx.now());
        end
    end
end

if ip_blacklist:get(ip) then
    ngx.log(ngx.DEBUG, "Banned IP detected and refused access: " .. ip);
    return ngx.exit(ngx.HTTP_FORBIDDEN);
end