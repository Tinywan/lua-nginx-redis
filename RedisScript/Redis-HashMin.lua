-- 找到hash中age小于指定值的所有数据
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
