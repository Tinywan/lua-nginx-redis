local red = redis:new()

-- set Cache cache_ngx
function set_to_cache(key,value,exptime)
    if not exptime then
        exptime = 0
    end
    local cache_ngx = ngx.shared.cache_ngx
    local succ, err, forcible = cache_ngx:set(key,value,exptime)
    return succ
end

--get Cache cache_ngx
function get_from_cache(key)
    local cache_ngx = ngx.shared.cache_ngx
    local value = cache_ngx:get(key)
    if not value then
        value = nil
        set_to_cache(key, value)
    end
    return value
end    

function get_from_redis(key)
    local res, err = red:get("dog")
    if res then
        return 'yes'
    else
        return 'No'
    end        
end
local res = get_from_cache('dog')
ngx.say(res)   


local delay = 5
local handler
handler = function (premature,param)
    -- do some routine job in Lua just like a cron job
    if premature then
        return
    end

    ngx.log(ngx.ERR, "param is : ", param)
end

local ok, err = ngx.timer.at(delay, handler,"Hello Tinywan")
   