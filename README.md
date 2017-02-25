![image](https://github.com/Tinywan/Lua/blob/master/Images/lua.jpg)
## Redis脚本用法
### Lua 基本语法
*   Hello, Lua!
    ```
    #!/usr/bin/lua
    print("Hello World!");
    ```
### 基本用法
*  基本语法   
    ```
    EVAL script numkeys key [key ...] arg [arg ...]
    ```
*  通过lua脚本获取指定的key的List中的所有数据 
    
    ```
        local key=KEYS[1]
        local list=redis.call("lrange",key,0,-1);
        return list;
    ```
*  根据外面传过来的IDList 做“集合去重”的lua脚本逻辑：     
     ```
         local result={};
         local myperson=KEYS[1];
         local nums=ARGV[1];
         
         local myresult =redis.call("hkeys",myperson);
         
         for i,v in ipairs(myresult) do
            local hval= redis.call("hget",myperson,v);
            redis.log(redis.LOG_WARNING,hval);
            if(tonumber(hval)<tonumber(nums)) then
               table.insert(result,1,v);
            end
         end
         
         return  result;
     ```
*  redis.call() 与 redis.pcall()的区别  
   > 他们唯一的区别是当redis命令执行结果返回错误时
   >> redis.call()将返回给调用者一个错误.
   >> redis.pcall()会将捕获的错误以Lua表的形式返回.
   >>redis.call() 和 redis.pcall() 两个函数的参数可以是任意的 Redis 命令
    
    ```
        > eval "return redis.call('set',KEYS[1],'bar')" 1 foo
        OK
    ```   

    
