      location /other {
             content_by_lua_block {
                 ngx.say("dog = ", ngx.var.dog)
                 ngx.say("cat = ", ngx.var.cat)
                 ngx.say("name = ",ngx.var.name)
            }
        }

        location /lua123 {
                set $dog '';
                set $cat '';
                set $name ''; #-- 下面要传递的参数必须的在这里提前声明设置了，否则会报错 500 
                content_by_lua_block {
                        res = ngx.location.capture("/other",
                        { vars = { dog = "hello", cat = 32,name = 'tinywan' }});
                        ngx.print(res.body)
                }
        }

--[[
    下面是错误的做法！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    location /other {
             content_by_lua_block {
                 ngx.say("dog = ", ngx.var.dog)
                 ngx.say("cat = ", ngx.var.cat)
                 ngx.say("name = ",ngx.var.name)
            }
        }

        location /lua123 {
                set $dog '';
                set $cat '';
                content_by_lua_block {
                        res = ngx.location.capture("/other",
                        { vars = { dog = "hello", cat = 32,name = 'tinywan' }});
                        ngx.print(res.body)
                }
        }
--]]        