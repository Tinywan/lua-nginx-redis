--接受nginx变量 
local var = ngx.var
ngx.say("ngx.var.a : ", var.a, "<br/>")
ngx.say("ngx.var.b : ", var.b, "<br/>")
ngx.say("ngx.var[2] : ", var[2], "<br/>")
ngx.var.b = 2;

ngx.say("<br/>")

--请求头
local headers = ngx.req.get_headers()
ngx.say("headers begin", "<br/>")
ngx.say("Host : ", headers["Host"], "<br/>")
ngx.say("user-agent : ", headers["user-agent"], "<br/>")
ngx.say("user-agent : ", headers.user_agent, "<br/>")
ngx.say("user-agent : ", ngx.req.get_headers("user-agent"), "<br/>")
for k,v in pairs(headers) do
    if type(v) == "table" then
        ngx.say(k, " : ", table.concat(v, ","), "<br/>")
    else
        ngx.say(k, " : ", v, "<br/>")
    end
end
ngx.say("headers end", "<br/>")
ngx.say("<br/>")

--get请求uri参数
ngx.say("uri args begin", "<br/>")
local uri_args = ngx.req.get_uri_args()
for k, v in pairs(uri_args) do
    if type(v) == "table" then
        ngx.say(k, " : ", table.concat(v, ", "), "<br/>")
    else
        ngx.say(k, ": ", v, "<br/>")
    end
end
ngx.say("uri args end", "<br/>")
ngx.say("<br/>")

--post请求参数
ngx.req.read_body()
ngx.say("post args begin", "<br/>")
local post_args = ngx.req.get_post_args()
for k, v in pairs(post_args) do
    if type(v) == "table" then
        ngx.say(k, " : ", table.concat(v, ", "), "<br/>")
    else
        ngx.say(k, ": ", v, "<br/>")
    end
end
ngx.say("post args end", "<br/>")
ngx.say("<br/>")

--请求的http协议版本
ngx.say("ngx.req.http_version : ", ngx.req.http_version(), "<br/>")
--请求方法
ngx.say("ngx.req.get_method : ", ngx.req.get_method(), "<br/>")
--原始的请求头内容
ngx.say("ngx.req.raw_header : ",  ngx.req.raw_header(), "<br/>")
--请求的body内容体
ngx.say("ngx.req.get_body_data() : ", ngx.req.get_body_data(), "<br/>")
ngx.say("<br/>")

--[[
执行结果：
root@tinywan:/opt/openresty/nginx/conf# curl http://127.0.0.1/lua_request/123/890
ngx.var.a : 123<br/>
ngx.var.b : 127.0.0.1<br/>
ngx.var[2] : 890<br/>
<br/>
headers begin<br/>
Host : 127.0.0.1<br/>
user-agent : curl/7.47.0<br/>
user-agent : curl/7.47.0<br/>
host : 127.0.0.1<br/>
accept : */*<br/>
user-agent : curl/7.47.0<br/>
headers end<br/>
<br/>
uri args begin<br/>
uri args end<br/>
<br/>
post args begin<br/>
post args end<br/>
<br/>
ngx.req.http_version : 1.1<br/>
ngx.req.get_method : GET<br/>
ngx.req.raw_header : GET /lua_request/123/890 HTTP/1.1
Host: 127.0.0.1
User-Agent: curl/7.47.0
Accept: */*

<br/>
ngx.req.get_body_data() : nil<br/>
<br/>
ngx.var.b 2
--]]