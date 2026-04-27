-- Lua表遍历测试
--[[
Lua提供两种遍历方式：
1. ipairs() - 遍历数组/序列（从1开始，连续索引）
2. pairs() - 遍历所有键值对（无序）
]]

print("=================== 表的遍历 ===================")

-- 1. ipairs遍历（用于数组/序列）
print("\n--- 1. ipairs遍历 ---")
local fruits = {"苹果", "香蕉", "橙子", "葡萄"}
for i, v in ipairs(fruits) do
    print(i, v)
end

-- 2. pairs遍历（用于字典/键值对）
print("\n--- 2. pairs遍历 ---")
local person = {name = "张三", age = 25, city = "北京"}
for k, v in pairs(person) do
    print(k, v)
end

-- 3. 泛型for循环遍历
print("\n--- 3. 泛型for循环遍历 ---")
-- 遍历数组
local nums = {10, 20, 30, 40, 50}
for i = 1, #nums do
    print("nums[" .. i .. "] =", nums[i])
end

-- 4. 遍历混合表
print("\n--- 4. 遍历混合表 ---")
local mixed = {1, 2, 3, name = "李四", age = 30}
print("使用ipairs遍历混合表：")
for i, v in ipairs(mixed) do
    print("  ", i, v)
end
print("使用pairs遍历混合表：")
for k, v in pairs(mixed) do
    print("  ", k, v)
end

-- 5. 遍历二维表
print("\n--- 5. 遍历二维表 ---")
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}
print("按行遍历：")
for i, row in ipairs(matrix) do
    local line = ""
    for j, val in ipairs(row) do
        line = line .. val .. " "
    end
    print("  行" .. i .. ": " .. line)
end

print("直接遍历所有元素：")
for i = 1, #matrix do
    for j = 1, #matrix[i] do
        print("  [" .. i .. "][" .. j .. "] =", matrix[i][j])
    end
end

-- 6. pairs遍历顺序
print("\n--- 6. pairs遍历顺序说明 ---")
print("pairs遍历顺序是随机的，不是按照插入顺序")
local test = {}
for i = 1, 10 do
    test["key" .. i] = i
end
print("pairs遍历结果（注意顺序是随机的）：")
for k, v in pairs(test) do
    print("  ", k, v)
end

-- 7. 嵌套表遍历
print("\n--- 7. 嵌套表遍历 ---")
local students = {
    {name = "学生A", scores = {90, 85, 88}},
    {name = "学生B", scores = {75, 92, 80}},
    {name = "学生C", scores = {88, 76, 95}}
}
for i, student in ipairs(students) do
    print("学生: " .. student.name)
    for j, score in ipairs(student.scores) do
        print("  科目" .. j .. ": " .. score)
    end
end

-- 8. 遍历时修改表（危险操作）
print("\n--- 8. 遍历时修改表 ---")
local t = {1, 2, 3, 4, 5}
print("原始表:", table.concat(t, ", "))

-- 在遍历时添加元素（可能导致无限循环）
-- for i, v in ipairs(t) do
--     if v == 3 then
--         table.insert(t, 100)  -- 不要在遍历时修改表
--     end
-- end

-- 正确的修改方式：遍历副本
local t_copy = {1, 2, 3, 4, 5}
for i, v in ipairs(t_copy) do
    if v == 3 then
        table.insert(t_copy, 100)
    end
end
print("修改后（遍历副本）:", table.concat(t_copy, ", "))

-- 9. 遍历时删除元素
print("\n--- 9. 遍历时删除元素 ---")
local items = {a = 1, b = 2, c = 3, d = 4}
print("原始表:")
for k, v in pairs(items) do
    print("  ", k, v)
end

-- 删除值为偶数的项
local to_delete = {}
for k, v in pairs(items) do
    if v % 2 == 0 then
        table.insert(to_delete, k)
    end
end
for i, k in ipairs(to_delete) do
    items[k] = nil
end
print("删除偶数值后:")
for k, v in pairs(items) do
    print("  ", k, v)
end

-- 10. #操作符与ipairs的区别
print("\n--- 10. #操作符与ipairs的区别 ---")
local arr = {1, 2, 3}
print("#arr =", #arr)
print("ipairs遍历:")
for i, v in ipairs(arr) do
    print("  i=" .. i .. ", v=" .. v)
end

local arr_with_nil = {1, 2, nil, 4, 5}
print("\n含有nil的表 arr_with_nil = {1, 2, nil, 4, 5}")
print("#arr_with_nil =", #arr_with_nil)  -- 结果是2（遇到nil停止）
print("ipairs遍历（只遍历连续部分）:")
for i, v in ipairs(arr_with_nil) do
    print("  i=" .. i .. ", v=" .. v)
end

print("\n=================== 遍历测试完成 ===================")
