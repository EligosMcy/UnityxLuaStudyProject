-- Lua表（Table）基础测试
--[[
Table是Lua唯一的数据结构，可以用作：
- 数组（从1开始的索引）
- 字典/映射（键值对）
- 对象（模拟面向对象）
]]

print("=================== 表的基础操作 ===================")

-- 1. 表的创建
print("\n--- 1. 表的创建 ---")
local emptyTable = {}  -- 空表
local array = {1, 2, 3, 4, 5}  -- 数组
local dict = {name = "张三", age = 25}  -- 字典
local mixed = {1, 2, name = "李四", 3, 4}  -- 混合表

print("空表:", emptyTable)
print("数组:", array)
print("字典:", dict)
print("混合表:", mixed)

-- 2. 表的索引访问
print("\n--- 2. 表的索引访问 ---")
print("array[1] =", array[1])  -- 1
print("array[3] =", array[3])  -- 3
print("dict.name =", dict.name)  -- 张三
print("dict['age'] =", dict["age"])  -- 25

-- 数组越界访问会返回nil，不会报错
print("array[10] =", array[10])  -- nil

-- 3. 表的修改
print("\n--- 3. 表的修改 ---")
array[1] = 100
print("修改后 array[1] =", array[1])  -- 100

dict.name = "王五"
dict["city"] = "上海"  -- 添加新键值对
print("修改后 dict.name =", dict.name)  -- 王五
print("添加后 dict.city =", dict.city)  -- 上海

-- 4. 表的长度
print("\n--- 4. 表的长度 (#操作符) ---")
local arr = {10, 20, 30, 40, 50}
print("#arr =", #arr)  -- 5

local arr2 = {1, 2, nil, 4, 5}  -- 含有nil的元素
print("#arr2 =", #arr2)  -- 2（遇到nil就停止计数）

-- 5. 表的删除
print("\n--- 5. 表的删除 ---")
local t = {a = 1, b = 2, c = 3}
print("删除前: a =", t.a)
t.a = nil  -- 删除键'a'
print("删除后: a =", t.a)  -- nil

-- 6. 表的嵌套
print("\n--- 6. 表的嵌套 ---")
local students = {
    {name = "学生A", score = 90},
    {name = "学生B", score = 85},
    {name = "学生C", score = 92}
}
print("第一个学生:", students[1].name, students[1].score)
print("第二个学生:", students[2]["name"], students[2]["score"])

-- 7. 二维表（矩阵）
print("\n--- 7. 二维表（矩阵） ---")
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}
for i = 1, 3 do
    local row = ""
    for j = 1, 3 do
        row = row .. matrix[i][j] .. " "
    end
    print(row)
end

-- 8. 表的常用操作函数
print("\n--- 8. table库常用函数 ---")
local t2 = {3, 1, 4, 1, 5, 9, 2, 6}

-- table.insert
table.insert(t2, 1, 0)  -- 在位置1插入0
print("插入后:", table.concat(t2, ", "))

-- table.remove
table.remove(t2, 1)  -- 移除位置1的元素
print("移除后:", table.concat(t2, ", "))

-- table.sort
local unsorted = {5, 2, 8, 1, 9}
table.sort(unsorted)
print("排序后:", table.concat(unsorted, ", "))

-- 降序排序
table.sort(unsorted, function(a, b) return a > b end)
print("降序:", table.concat(unsorted, ", "))

-- table.concat
local words = {"Hello", "World", "Lua"}
print("连接:", table.concat(words, " "))

print("\n=================== 测试完成 ===================")
