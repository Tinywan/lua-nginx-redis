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

--[[
    curl http://127.0.0.1/ngx_timer_at
    
    2017/05/04 23:24:38 [error] 95933#0: *433016 [lua] get_timer_at.lua:9: param is : Hello Tinywan, context: ngx.timer, client: 127.0.0.1, server: 0.0.0.0:80
    --]]