![image](https://github.com/Tinywan/Lua/blob/master/Images/lua.jpg)
## Redis脚本用法
### 基本用法
*  通过lua脚本获取指定的key的List中的所有数据 
    
    ```
        local key=KEYS[1]
        local list=redis.call("lrange",key,0,-1);
        return list;
    ```
*  根据外面传过来的IDList 做“集合去重”的lua脚本逻辑：     
     ```
        local key=KEYS[1]
        local list=redis.call("lrange",key,0,-1);
        return list;
     ```
      

    
