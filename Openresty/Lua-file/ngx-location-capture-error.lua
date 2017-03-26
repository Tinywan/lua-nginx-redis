location  / foo {
      content_by_lua_block {
          res = ngx.location.capture（“/ bar”）
     }
 }
 location  / bar {
      echo_location / blah;
 }
 location / blah {
      echo  “Success！” ;
 }

 -- curl -i http://example.com/foo  将不按预期工作。


 location /test {
     content_by_lua '
         local regex = [[\\d+]]   -- 正则表达式模式可以通过将其包含在“ [[...]]长方括号” 中作为长括号的Lua字符串表示，在这种情况下，只能对Nginx配置文件解析器转义一次反斜杠
         local m = ngx.re.match("hello, 1234", regex)
         if m then ngx.say(m[0]) else ngx.say("not matched!") end
     ';
 }