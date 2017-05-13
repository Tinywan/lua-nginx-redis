--
-- Created by IntelliJ IDEA.
-- User: tinywan
-- Date: 2017/5/13
-- Time: 23:02
-- To change this template use File | Settings | File Templates.
--
local a = { 1, 3, 5, "hello" }
print(table.concat(a)) -- output: 135hello
print(table.concat(a, "|")) -- output: 1|3|5|hello
print(table.concat(a, " ", 4, 2)) -- output:
print(table.concat(a, " ", 2, 4)) -- output: 3 5 hello

table.concat(table[, sep[, start [, end]]])

