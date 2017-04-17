-- Get Nginx ConfigInformation
local get_args = ngx.req.get_uri_args()
local ws_secret = tostring(get_args["wsSecret"])    -- tel 
local ws_time = tostring(get_args["wsTime"])      -- string

-- Sign md5


-- Redis Info
local redis = require("resty.redis_iresty")
local red = redis:new()

local ok, err = red:set("AMI1999", "Redis is an animal 1999")
if not ok then
    ngx.say("failed to set dog: ", err)
    return
end
