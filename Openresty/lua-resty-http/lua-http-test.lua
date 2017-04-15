local http = require("resty.http")
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
ngx.status = resp.status
for k, v in pairs(resp.headers) do
    if k ~= "Transfer-Encoding" and k ~= "Connection" then
        ngx.header[k] = v
    end
end
ngx.say(resp.body)
httpc:close()