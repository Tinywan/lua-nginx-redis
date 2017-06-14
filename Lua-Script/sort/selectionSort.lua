--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/6/14
-- Time: 10:08
-- To change this template use File | Settings | File Templates.
--首先在未排序序列中找到最小元素，存放到排序序列的起始位置 再从剩余未排序元素中继续寻找最小元素，然后放到已排序序列的末尾。 重复第二步，直到所有元素均排序完毕。
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
print(#list)
for i = 1 ,#list do
    print(i)
end


