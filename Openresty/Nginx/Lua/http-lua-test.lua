local http = require("resty.http")  
--创建http客户端实例  
local httpc = http.new()  
  
local resp, err = httpc:request_uri("http://s.taobao.com", {  
    method = "GET",  
    path = "/search?q=hello",  
    headers = {  
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36"  
    }  
})  
  
if not resp then  
    ngx.say("request error :", err)  
    return  
end  
  
--获取状态码  
ngx.status = resp.status  
  
--获取响应头  
for k, v in pairs(resp.headers) do  
    if k ~= "Transfer-Encoding" and k ~= "Connection" then  
        ngx.header[k] = v  
    end  
end  
--响应体  
ngx.say(resp.body)  
  
httpc:close() 


local var = ngx.var
local uri = var.uri

local stream_name = var.stream_name
local auth_key = var.auth_key
local expire_time = string.sub(auth_key,0,10)
local rand = "0"
local uid = "0"
local private_key = "Tinywan123"
local sstring = uri.."-"..expire_time.."-"..rand.."-"..uid.."-"..private_key
local hash_value = ngx.md5(sstring)

ngx.say("URI :: ",uri)
ngx.say("stream_name::",stream_name)
ngx.say("auth_key ::",auth_key)
ngx.say("expire_time :: ",expire_time)
ngx.say("sstring :: ",sstring)
ngx.say("hash_value :: ",hash_value)
