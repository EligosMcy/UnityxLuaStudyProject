-- Lua表（Table）
--[[
表是Lua唯一的数据结构，可以用作数组、字典、对象等。
表的索引从1开始（不是0）。
]]

-- 1. 表的创建
local emptyTable = {}
local array = {1, 2, 3, 4, 5}
local dict = {name = "张三", age = 25}
local mixed = {1, 2, name = "李四", 3, 4}

-- 2. 数组操作
local arr = {10, 20, 30, 40, 50}
print("数组长度：" .. #arr)
print("第一个元素：" .. arr[1])
print("最后一个元素：" .. arr[#arr])

-- 遍历数组
for i = 1, #arr do
    print("arr[" .. i .. "] = " .. arr[i])
end

-- 3. 字典操作
local person = {name = "王五", age = 30, city = "上海"}
print("姓名：" .. person.name)
print("年龄：" .. person["age"])

-- 添加/修改键值对
person.job = "工程师"
person["hobby"] = "游泳"

-- 删除键值对
person.age = nil

-- 遍历字典
for key, value in pairs(person) do
    print(key .. " = " .. tostring(value))
end

-- 4. 表的嵌套
local students = {
    {name = "学生A", score = 90},
    {name = "学生B", score = 85},
    {name = "学生C", score = 92}
}

print("第一个学生：" .. students[1].name .. "，分数：" .. students[1].score)

-- 5. 表的常用函数
local t = {3, 1, 4, 1, 5, 9, 2, 6}

-- table.insert 在指定位置插入元素
table.insert(t, 1, 0)  -- 在位置1插入0
-- table.remove 移除指定位置元素
table.remove(t, 1)     -- 移除位置1的元素
-- table.concat 连接表中所有字符串
local s = table.concat(t, ", ")
print("连接结果：" .. s)

-- 6. 表的排序
local unsorted = {5, 2, 8, 1, 9}
table.sort(unsorted)
print("排序后：" .. table.concat(unsorted, ", "))

-- 降序排序
table.sort(unsorted, function(a, b) return a > b end)
print("降序：" .. table.concat(unsorted, ", "))

-- 7. 表的复制
local original = {name = "测试", data = {1, 2, 3}}
local shallowCopy = original  -- 浅复制（引用同一个表）

-- 8. 二维表（矩阵）
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

for i = 1, 3 do
    for j = 1, 3 do
        io.write(matrix[i][j] .. " ")
    end
    print()
end

-- 9. 序列（没有空洞的数组）
local seq = {"a", "b", "c", "d", "e"}
print("序列长度：" .. #seq)
for i, v in ipairs(seq) do
    print(i, v)
end

-- 10. 表的内存
local t1 = {}
local t2 = {}
t1.next = t2
t2.next = t1
-- collectgarbage() 强制垃圾回收
