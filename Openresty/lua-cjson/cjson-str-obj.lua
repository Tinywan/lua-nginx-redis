local cjson = require("cjson")

--lua对象到字符串  
local obj = {
    id = 1,
    name = "zhangsan",
    age = nil,
    is_male = false,
    hobby = {"film", "music", "read"}
}

local str = cjson.encode(obj)
ngx.say(str, "<br/>")       -- 打印输出：{"hobby":["film","music","read"],"is_male":false,"name":"zhangsan","id":1}<br/>

--字符串到lua对象  
str = '{
    "hobby":["film","music","read"],"is_male":false,"name":"zhangsan","id":1,"age":null}'
local obj = cjson.decode(str)           -- 字符串转换成一个对象

ngx.say(obj.age, "<br/>")               -- 对象访问形式：obs.age
ngx.say(obj.age == nil, "<br/>")        -- 数组访问形式：hobby[1]
ngx.say(obj.age == cjson.null, "<br/>")
ngx.say(obj.hobby[1], "<br/>")

--obj.obj
str_obj = '{"hobby":{"name":"tinywan","age":24,"reader":"AMAI"},"is_male":false}'
local obj_obj = cjson.decode(str_obj)

ngx.say(obj_obj.is_male, "<br/>")
ngx.say(obj_obj.hobby.name, "<br/>")
ngx.say(obj_obj.hobby.age, "<br/>")
ngx.say(obj_obj.hobby.reader, "<br/>")


--循环引用  
obj = {
   id = 1
}
obj.obj = obj
-- Cannot serialise, excessive nesting  
--ngx.say(cjson.encode(obj), "<br/>")  
local cjson_safe = require("cjson.safe")
--nil  
ngx.say(cjson_safe.encode(obj), "<br/>")


--[[
打印结果：
        root@tinywan:/opt/openresty/nginx/conf/Lua# curl http://127.0.0.1/dcjson
        {"hobby":["film","music","read"],"is_male":false,"name":"zhangsan","id":1}<br/>
        nil
        null<br/>
        false<br/>
        true<br/>
        film<br/>
        false<br/>
        tinywan<br/>
        24<br/>
        AMAI<br/>
        nil<br/>

经验分享：
[1]   lua对象到字符串 ，通过cjson.encode(obj)把所有的对象转换成了json格式,对象中的对象，被转换成了数组（数组作为 JSON 对象）    
[2] JSON 对象中的数组
        {
        "name":"网站",
        "num":3,
        "sites":[ "Google", "Runoob", "Taobao" ]
        }
[3] 嵌套 JSON 对象
    myObj = {
    "name":"runoob",
    "alexa":10000,
    "sites": {
        "site1":"www.runoob.com",
        "site2":"m.runoob.com",
        "site3":"c.runoob.com"
     }
    }       
     
--]]