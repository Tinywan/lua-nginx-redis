-- simple chat with redis
local server = require "resty.websocket.server"
local redis = require "resty.redis"
 
local channel_name = "chat"
local msg_id = 0
 
--create connection
local wb, err = server:new{
  timeout = 10000,
  max_payload_len = 65535
}
 
--create success
if not wb then
  ngx.log(ngx.ERR, "failed to new websocket: ", err)
  return ngx.exit(444)
end
 
 
local push = function()
    -- --create redis
    local red = redis:new()
    red:set_timeout(5000) -- 1 sec
    local ok, err = red:connect("127.0.0.1", 6379)
    if not ok then
        ngx.log(ngx.ERR, "failed to connect redis: ", err)
        wb:send_close()
        return
    end
 
    --sub
    local res, err = red:subscribe(channel_name)
    if not res then
        ngx.log(ngx.ERR, "failed to sub redis: ", err)
        wb:send_close()
        return
    end
 
    -- loop : read from redis
    while true do
        local res, err = red:read_reply()
        if res then
            local item = res[3]
            local bytes, err = wb:send_text(tostring(msg_id).." "..item)
            if not bytes then
                -- better error handling
                ngx.log(ngx.ERR, "failed to send text: ", err)
                return ngx.exit(444)
            end
            msg_id = msg_id + 1
        end
    end
end
 
 
local co = ngx.thread.spawn(push)
 
--main loop
while true do
    -- 获取数据
    local data, typ, err = wb:recv_frame()
 
    -- 如果连接损坏 退出
    if wb.fatal then
        ngx.log(ngx.ERR, "failed to receive frame: ", err)
        return ngx.exit(444)
    end
 
    if not data then
        local bytes, err = wb:send_ping()
        if not bytes then
          ngx.log(ngx.ERR, "failed to send ping: ", err)
          return ngx.exit(444)
        end
        ngx.log(ngx.ERR, "send ping: ", data)
    elseif typ == "close" then
        break
    elseif typ == "ping" then
        local bytes, err = wb:send_pong()
        if not bytes then
            ngx.log(ngx.ERR, "failed to send pong: ", err)
            return ngx.exit(444)
        end
    elseif typ == "pong" then
        ngx.log(ngx.ERR, "client ponged")
    elseif typ == "text" then
        --send to redis
        local red2 = redis:new()
        red2:set_timeout(1000) -- 1 sec
        local ok, err = red2:connect("127.0.0.1", 6379)
        if not ok then
            ngx.log(ngx.ERR, "failed to connect redis: ", err)
            break
        end
        local res, err = red2:publish(channel_name, data)
        if not res then
            ngx.log(ngx.ERR, "failed to publish redis: ", err)
        end
    end
end
 
wb:send_close()
ngx.thread.wait(co)