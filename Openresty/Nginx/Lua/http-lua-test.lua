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