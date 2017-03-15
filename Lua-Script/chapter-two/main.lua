require("members")
require("package-function")

print(wan.name)
--print(wan_local.name) 由于时局部变量，所以打印不了

function foo( )
    x = 100
    local y = 11
    print(y)
end
foo()
print(x) -- 100
print(y) -- nil

print('RedisMethod.set ::',RedisMethod.set(1,1000000))