# Lua表（Table）

表是Lua唯一的数据结构，可以用作数组、字典、对象等。表的索引从1开始（不是0）。

## 目录
- [表的创建](#表的创建)
- [数组操作](#数组操作)
- [字典操作](#字典操作)
- [表的嵌套](#表的嵌套)
- [表的常用函数](#表的常用函数)
- [表的排序](#表的排序)
- [表的复制](#表的复制)
- [二维表](#二维表)
- [序列](#序列)
- [表的内存](#表的内存)

## 表的创建

```lua
local emptyTable = {}
local array = {1, 2, 3, 4, 5}
local dict = {name = "张三", age = 25}
local mixed = {1, 2, name = "李四", 3, 4}
```

## 数组操作

```lua
local arr = {10, 20, 30, 40, 50}
print("数组长度：" .. #arr)
print("第一个元素：" .. arr[1])
print("最后一个元素：" .. arr[#arr])

-- 遍历数组
for i = 1, #arr do
    print("arr[" .. i .. "] = " .. arr[i])
end
```

## 字典操作

```lua
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
```

## 表的嵌套

```lua
local students = {
    {name = "学生A", score = 90},
    {name = "学生B", score = 85},
    {name = "学生C", score = 92}
}

print("第一个学生：" .. students[1].name .. "，分数：" .. students[1].score)
```

## 表的常用函数

```lua
local t = {3, 1, 4, 1, 5, 9, 2, 6}

-- table.insert 在指定位置插入元素
table.insert(t, 1, 0)  -- 在位置1插入0

-- table.remove 移除指定位置元素
table.remove(t, 1)     -- 移除位置1的元素

-- table.concat 连接表中所有字符串
local s = table.concat(t, ", ")
print("连接结果：" .. s)
```

## 表的排序

```lua
local unsorted = {5, 2, 8, 1, 9}
table.sort(unsorted)
print("排序后：" .. table.concat(unsorted, ", "))

-- 降序排序
table.sort(unsorted, function(a, b) return a > b end)
print("降序：" .. table.concat(unsorted, ", "))
```

## 表的复制

```lua
local original = {name = "测试", data = {1, 2, 3}}
local shallowCopy = original  -- 浅复制（引用同一个表）
```

## 二维表

```lua
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
```

## 序列

序列是没有空洞的数组：
```lua
local seq = {"a", "b", "c", "d", "e"}
print("序列长度：" .. #seq)
for i, v in ipairs(seq) do
    print(i, v)
end
```

## 表的内存

```lua
local t1 = {}
local t2 = {}
t1.next = t2
t2.next = t1
-- collectgarbage() 强制垃圾回收
```
