##  lua中self.__index = self是什么意思？
+   设置原表语法：`setmetatable(table,metatable): 对指定table设置元表(metatable)`
+   [http://www.cnblogs.com/mentalidade/p/6561418.html](http://www.cnblogs.com/mentalidade/p/6561418.html)
+   当一个表存在元表的时候可能会发生改变。lua当发现一个不存在的key时，如果这个table存在元表，则会尝试在元表中寻找是否有匹配key对应的value
    ```lua
    local a = {}        -- 普通表
    local b = {k = 11}  -- 元表 
    setmetatable(a,b)   -- 把 b 设为 a 的元表
    b.__index = b       --设置元方法
    b.v = 22                 --给b表增加一个属性
    a.aa = 33                --给a表增加一个属性
    print(a.k)               --11,因为a有元表b，且存在元方法，可以索引到b表中对应的值
    print(a.v)               --22，设定关系后，b增加的属性，a也可以索引到
    print(b.aa)              --nil，相反，b并不可以索引到a的值
    
    ```