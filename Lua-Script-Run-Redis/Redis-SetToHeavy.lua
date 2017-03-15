-- 根据外面传过来的IDList 做“集合去重”
local key=KEYS[1];
local args=ARGV
local i=0;
local result={};

  for m,n in ipairs(args) do

    local ishit=redis.call("sismember",key,n);

    if(ishit) then
       table.insert(result,1,n);
    end

  end

return  result;
