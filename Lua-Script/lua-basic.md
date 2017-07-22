#### Lua 基础语法
+   删除一个全局变量，只要将变量值赋值为nil：`a = nil`,当且仅当一个变量不为nil 时，这个变量存在
+   `Boolean`类型：在控制条件中除了`false`和`nil` 为假，其他值都为真，所以lua认为0和空字符串也是真 
+   `String`类型：
    +   字符串替换：`string.gsub()`
        ```lua
        a = 'one HELLO'
        b = string.gsub(a,'one','two')
        print(a)    -- one HELLO
        print(b)    -- two HELLO
        ```  
    +   字符串和数字
        ```lua 
        print("10" + 1)       -- 11
        print("10" + "1")     -- 11
        print("10 + 1")       -- 10 + 1
        print("hello " .. " world")  -- hello  world
        --print("hello" + 1)  -- 错误写法
        ```
    +   字符串和数字转换
        ```lua 
        a = 10
        print(tostring(a))  -- 10
        b = "20"
        print(tonumber(b))  -- "20"
        
        print(tostring(10) == "10")  -- true
        print(10 .. "" == "10")      -- true
        ```
+   表达式
    +   如果两个值类型不相等，Lua认为两者不同       
    +   nil 只和自己相等
    +   逻辑运算符
        ```lua 
        -- a and b          -- 如果a为false，则返回a ,否则返回b
        -- a or b          --  如果a为true，则返回a ,否则返回b
        print(4 and 5)      -- 5
        print(nil and 12 )  -- nill
        print(false and 12) -- false
        print(4 or 5)       -- 4
        print(false or 5)   -- 5
        ```      
    +   注意：`and`的优先级比`or`高    
    +   Lua 三元运算符：`( a and b) or c`  
+   变量    
    +   赋值语句
        ```lua 
        x = 20
        y = 30
        x,y = y,x
        print(x,y) -- 30 20
        
        a,b,c = 10,20
        print(a,b,c) --10 20 nil
        
        x,y,z = 10
        print(x,y,z) -- 10 nil nil
        ```
    +   局部变量与代码块
        +   代码块：指一个控制结构内，一个函数体，或者一个chunk（变量被声明的哪个文件或者文本串）
        +   ```lua
            a = 12
            if a>10 then
               local i = 19
                print(i)  -- 19
            end
            print(i)      -- nil
            ```
+   控制语句
    ```lua 
    members = { Tom = 10, Jake = 11, Dodo = 12, Jhon = 16 }
    
    for k, v in pairs(members) do
        if v == 10 then
            print(k, 'is 10 years old')     -- Tom	is 10 years old
        elseif v == 11 then
            print(k, 'is 11 years old')     -- Jake	is 11 years old
        elseif v == 12 then
            print(k, 'is 12 years old')     -- Dodo	is 12 years old
        else
            print(k, "is not 10,11,12 years old")   -- Jhon	is not 10,11,12 years old
        end
    end
    ```  
+   函数
    +   单个返回值
        ```lua 
        function max(a,b)
            if a > b then
                return a
            else
                return b
            end
        end
        print(max(10,20)) -- 20
        ```
    +   多个返回值
        ```lua 
        function more()
            return 10 , 20 ,30
        end
        a , b , c = more()
        print(a,b,c) -- 10 20 30
        ```   
    +   可变数目的参数
        ```lua
        function more()
            return 10 , 20 ,30
        end
        -- 当函数位于最后一位的时候，返回全部值，否则值返回一个数值
        a , b , c ,d = 100, more()
        print(a,b,c,d) -- 100 10 20 30
        ``` 
    +   闭合函数
        ```lua
        function count()
            -- i属于一个非局部变量，因为它既不是全局变量，也不是单纯的局部变量（因为另外一个函数可以访问到它）
            local i = 0
            return function()
                i =i +1
                return i
            end
        end
        -- 以上 count()函数里的那个函数，加上一个非全局变量i,就构成一个闭合函数
        -- 所以每次调用闭合函数，非局部变量的值都不会被重置
        local func = count()
        print(func())   -- 1
        print(func())   -- 2
        ```
    +   非全局函数，在定义函数的使用要注意定义函数的顺序
        ```lua
        local eat
        local drink
        eat = function()
            print("eat")
            return drink() -- 这里的drink()属于尾调用
        end
        drink = function()
            print("drink")
        end
        eat()
        ```
+   table 使用
    +   Lua table 第一个索引为1
    +   简单
        ```lua 
        a = {}
        a.x = 100
        a.y = 200
        a["z"] = 300 -- a.z = 300
        print(a.x) -- 100
        print(a.y) -- 200
        print(a.z) -- 300
        ``` 
+   泛型迭代器
    +  标准库迭代器包括：
        +   迭代文件每行：`io.lines`
        +   迭代table元素：`pairs`
            - [x] 可以遍历表中的所有key
            - [x] 并且除了迭代器本身以及遍历表本身，还可以返回nil
        +   迭代数组元素：`ipairs`
            - [x] ipairs不能返回nil，只能返回数字0，如果遇到nil则退出
            - [x] 只能遍历表中出现的第一个不是整数的key
    +   泛型迭代器
        ```lua
        config = {host = '127.0.0.1',port = '3306', dbname = 'LuaDB' }
        config.redis_host = "192.168.1.1"
        config.redis_port = "6379"
        config.redis_db = "12"
        print(config['redis_host'])     -- 192.168.1.1
        print(config.redis_port)        -- 6379
        print(config.dbname)            -- LuaDB
        
        for k, v in pairs(config) do
            print(k,v)
        end
        
        --[[
        host    127.0.0.1
        dbname	LuaDB
        redis_host	192.168.1.1
        redis_db	12
        redis_port	6379
        port	3306
        -- ]]
        ```       
    +   迭代table元素
        ```lua
        arr = {}
        for var = 1,100 do      -- for 循环
            table.insert(arr,1,var)
        end
        
        for k, v in pairs(arr) do   -- 遍历表
            print(k,v)
        end
        --[[ 打印结果
        1	100
        2	99
        ... ...
        99	2
        100	1
        
        -- ]]
        print(table.maxn(arr))  -- table长度 100
        print(#arr)     -- table长度（快捷方式） 100
        ```
    +   迭代数组元素：`ipairs`
        ```lua
        arr = {host = '127.0.0.1',port = '3306','Tinywan'}
        -- 如果没有找到下标为整数的则直接退出，是整数的则直接输出，如上面的'Tinywan'
        for k, v in ipairs(arr) do  -- 只能遍历key 为整数的下标
            print(k,v)   -- 1   Tinywan
        end
        ```
    +   循环迭代table元素（如：lua-resty-mysql 扩展查询的数据）
        +   查询 ：`res, err, errcode, sqlstate = db:query("select * from tb_ngx_test order by id asc", 10)`
        +   转换成JSON结果集输出2条记录：
            ```lua
                ngx.say("result: ", cjson.encode(res))
                result: [{"age":"24123","name":"tinywan123","address":"China","id":"1"},{"age":"24","name":"tinywan","address":"China","id":"2"}]
            ```
        +   遍历该结果集：
            ```lua
            res, err, errcode, sqlstate = db:query("select * from tb_ngx_test order by id asc", 10)
            if not res then
                ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
                return
            end
            
            for k, v in pairs(res) do
                if type(v) == "table" then
                    for new_table_index, new_table_value in pairs(v) do
                        ngx.say(new_table_index.." = "..new_table_value)
                    end
                else
                    ngx.say(k,v)
                end
            end

            --[[ 打印结果
                age = 24123
                name = tinywan123
                address = China
                id = 1
                age = 24
                name = tinywan
                address = China
                id = 2 
            ]]
            ```
    +   json 和 lua table 转换
        +   [1] 将 json 转换成 lua table  
            ```lua
            local json_str = '{"is_male":"nan","name":"zhangsan","id":1}'
            local t = json.decode(json_str)
            ngx.say(format_table(t))
            ```      
        +   [2] 将 lua table 转换成 json 字符串
            ```lua
            local t = [[{key="table key",value="table value"}]]
            local json_str = json.encode(t)
            ngx.say(json_str) -- "{key=\"table key\",value=\"table value\"}"
            ```   
        +   [3] 将lua table转换成 json 数组 (lua 两个大括号表示一个数组)  
             ```lua
            local t = {keys={"list1","list2","list3"},num=1}
            local str = json.encode(t)
            ngx.say(str)  -- {"keys":["list1","list2","list3"],"num":1}
             ```   
+   编译执行与错误
    +   error 错误     
        ```lua
        local name = "Lua1"
        if name ~= "Lua"
        then
            error("this is not Lua  ");
        end
        ```
    +   assert 错误：`assert(name~="Lua"," this is not Lua")`       
    +   pcall 捕获错误代码
        ```lua
        function test()
            print(a[1])
        end
        -- pcall 除了会返回true或者false外，还能返回函数的错误信息。
        -- 如果没有错误信息，err 会返回一个nil
        local status,err = pcall(test)
        if status then
            print('success')
        else
            print('函数执行出错了')
            print('错误信息：',err)
        end
        ```  
+   Lua面向对象（重点）
    +   [博客详细地址描述](http://www.cnblogs.com/tinywan/p/6940784.html)   
    +   :white_check_mark:  `__add` 元方法 #demo1 
         ```lua
         local mt = {}
         mt.__add = function(t1, t2)
             print("两个Table 相加的时候会调用我")
         end
         local t1 = {}
         local t2 = {}
         -- 给两个table 设置新的元表,一个元表就是一个table的值
         setmetatable(t1, mt) -- meta:元素
         setmetatable(t2, mt)
         -- 进行相加操作
         local t = t1 + t2
         print(t)
         
         --[[输出结果
         两个Table 相加的时候会调用我
         nil
         --]]
         ```  
    +   :white_check_mark:  `__add` 元方法 #demo2   
         ```lua
         -- 创建一个元表 （是创建一个类吗？）
         local mt = {}
         mt.__add = function(s1, s2)
             local result = ""
             if s1.sex == "boy" and s2.sex == "girl" then
                 result = "一个男孩和一个女孩的家庭"
             elseif s1.sex == "girl" and s2.sex == "girl" then
                 result = "两个女孩的家庭"
             else
                 result = "未知孩子的家庭"
             end
             return result
         end
         -- 创建两个table，可以想象成是两个类的对象（实例化两个类）
         local s1 = { name = "Per1", sex = "boy" }
         local s2 = { name = "Per2", sex = "girl" }
         -- 给两个table 设置新的元表,一个元表就是一个table的值
         setmetatable(s1, mt)
         setmetatable(s2, mt)
         -- 进行加法操作
         local result = s1 + s2
         print(result) 
         
         -- 输出结果 一个男孩和一个女孩的家庭
         ```  
    +   :white_check_mark:  `__index` 元方法 #demo1 
        ```lua
        local t = {
            name = "Tinywan"
        }
        local mt = {
            __index = function(table, key)
                print("虽然你调用了我不存在的字段和方法，不过没关系，我能检测出来" .. key)
            end
        }
        setmetatable(t, mt)
        print(t.name)
        print(t.age)

        --[[输出结果
        -- Tinywan
        -- 虽然你调用了我不存在的字段和方法，不过没关系，我能检测出来age
        -- nil
        ---- ]]
        ```    
    +   :white_check_mark:  `__index` 元方法 #demo2 
        ```lua
        local t = {
            name = "Tinywan"
        }
        local mt = {
            money = 808080
        }
        
        mt.__index = mt
        setmetatable(t, mt)
        print(t.money)
        -- 输出结果 808080
        ```                
    +   :white_check_mark:  `__index` 元方法 #demo3
        ```lua
        local t = {
            name = "Tinywan"
        }
        local mt = {
            __index = {
                money = 909090
            }
        }
        setmetatable(t, mt)
        print(t.money)
        -- 输出结果 909090
        ```   
    +   :white_check_mark:  `__index` 元方法 #demo4
        ```lua
        local smartMan = {
            name = "Tinywan",
            age = 26,
            money = 800000,
            say_fun = function()
                print("Tinywan say 大家好")
            end
        }
        
        local t1 = {}
        local t2 = {}
        local mt = { __index = smartMan } -- __index 可以是一个表，也可以是一个函数
        setmetatable(t1, mt)
        setmetatable(t2, mt)
        print(t1.money)
        t2.say_fun()
        --- 输出结果
        -- 800000
        -- Tinywan say 大家好
        ```                        
    +   Lua面向对象1          
    +   Lua面向对象1          
    +   Lua面向对象3 更新中...  
+   Lua 排序算法
    +   [Lua 排序算法 - 选择排序](https://www.openresty.com.cn/ms2008-select-sort.html#section-1)
    +   选择排序
        ```lua
        local function selectionSort(arr)
            for i = 1,#arr-1 do
                local idx = i
                -- 迭代剩下的元素，寻找最小的元素
                for j = i+1,#arr do
                    if arr[j] < arr[idx] then
                        idx = j
                    end
                end
                -- 
                arr[i],arr[idx]= arr[idx],arr[i]
            end
        end
        
        local list = {
            -81, -93, -36.85, -53, -31, 79, 45.94, 36, 94, -95.03, 11, 56, 23, -39,
            14, 1, -20.1, -21, 91, 31, 91, -23, 36.5, 44, 82, -30, 51, 96, 64, -41
        }
        
        selectionSort(list)
        print(table.concat( list, ", "))
        ```        
####    控制结构
+ [if-elseif-end 语句](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/chapter-one/if-else-example.lua)
+ [for 语句](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/chapter-one/for-example.lua)
+ [Lua 只有一个容器，那就是table](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/chapter-one/container-table.lua)
####    [Lua 实现简单封装](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Lua-Script/function1.lua)
####    <a name="Lua_table"/> Table 操作常用的方法
+   table.concat (table [, sep [, start [, end]]])
    +   concat是concatenate(连锁, 连接)的缩写. table.concat()函数列出参数中指定table的数组部分从start位置到end位置的所有元素, 元素间以指定的分隔符(sep)隔开
    +   demo
        ```lua
        fruits = {"banana","orange","apple"}
        -- 返回 table 连接后的字符串 value = banana orange apple
        print("连接后的字符串 ",table.concat(fruits))
        -- 指定连接字符   value = banana, orange, apple
        print("指定连接字符连接后的字符串 ",table.concat(fruits,", "))
        ```
+   table.insert (table, [pos,] value):
    +   在table的数组部分指定位置(pos)插入值为value的一个元素. pos参数可选, 默认为数组部分末尾
    +   demo
        ```lua
        fruits = {"banana","orange","apple"}
        
        -- 在末尾插入
        table.insert(fruits,"Tinywan4")
        print("索引为 4 的元素为 ",fruits[4]) -- 索引为 4 的元素为 	Tinywan
        
        -- 在索引为 2 的键处插入
        table.insert(fruits,2,'Tinywan2')
        print("索引为 2 的元素为 ",fruits[2])  -- 索引为 2 的元素为 	Tinywan
        
        print("最后一个元素为 ",fruits[5])     -- 最后一个元素为 	Tinywan4
        table.remove(fruits)
        print("移除后最后一个元素为 ",fruits[5])  -- 移除后最后一个元素为 	nil
        ```
+   table.sort (table [, comp])
    +   对给定的table进行升序排序
####    Lua 模块与包
+   定义：Lua 的模块是由变量、函数等已知元素组成的 table，因此创建一个模块很简单，就是创建一个 table，然后把需要导出的常量、函数放入其中，最后返回这个 table 就行.  
+   Table 操作常用的方法
    - [x] table.concat()
    - [x] table.insert()
    - [x] table.maxn()
    - [x] table.concat()