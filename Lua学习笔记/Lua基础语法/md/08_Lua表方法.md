# Lua表（Table）方法

## 目录
- [表的创建](#表的创建)
- [table库方法](#table库方法)
- [表的遍历](#表的遍历)
- [表的操作](#表的操作)
- [表的应用](#表的应用)
- [表的元方法](#表的元方法)
- [表的性能](#表的性能)
- [表的注意事项](#表的注意事项)
- [实用的表工具函数](#实用的表工具函数)
- [表的高级应用](#表的高级应用)

## 表的创建

```lua
local t1 = {}
local t2 = {1, 2, 3}
local t3 = {name = "张三", age = 25}
local t4 = {1, 2, name = "李四", 3, 4}
```

## table库方法

### table.insert()

在指定位置插入元素：
```lua
local t = {1, 2, 3, 4, 5}
table.insert(t, 6)         -- 在末尾插入
table.insert(t, 2, 10)     -- 在位置2插入10
```

### table.remove()

删除指定位置的元素：
```lua
local removed = table.remove(t)      -- 删除末尾元素
local removed = table.remove(t, 2)   -- 删除位置2的元素
```

### table.concat()

连接表中的元素为字符串：
```lua
local t = {"a", "b", "c", "d"}
print(table.concat(t))
print(table.concat(t, ", "))
print(table.concat(t, "|", 2, 3))
```

### table.sort()

对表进行排序：
```lua
local t = {3, 1, 4, 1, 5, 9, 2, 6}
table.sort(t)  -- 默认排序（升序）
table.sort(t, function(a, b) return a > b end)  -- 降序排序
```

### table.maxn()

获取表中最大的整数索引（Lua 5.1）：
```lua
local t = {[1] = "a", [5] = "b", [10] = "c"}
print(table.maxn(t))
```

### table.pack()

将参数打包成表（Lua 5.2+）：
```lua
local packed = table.pack(1, "hello", true)
print(packed[1], packed[2], packed[3])
print(packed.n)
```

### table.unpack()

将表解包为参数：
```lua
local t = {1, 2, 3, 4, 5}
local a, b, c = table.unpack(t, 1, 3)
print(a, b, c)
```

## 表的遍历

### ipairs() 遍历
```lua
local t = {"a", "b", "c", "d"}
for i, v in ipairs(t) do
    print("索引:", i, "值:", v)
end
```

### pairs() 遍历
```lua
local t = {name = "张三", age = 25, city = "北京"}
for k, v in pairs(t) do
    print("键:", k, "值:", v)
end
```

## 表的操作

### 获取表的长度

```lua
local t = {1, 2, 3, 4, 5}
print("表长度:", #t)
```

注意：#操作符只计算连续的整数索引。

### 表的复制

浅拷贝：
```lua
function shallowCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end
```

深拷贝：
```lua
function deepCopy(t)
    if type(t) ~= "table" then
        return t
    end
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = deepCopy(v)
    end
    return copy
end
```

### 表的合并
```lua
function merge(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        result[k] = v
    end
    return result
end
```

### 检查表是否为空
```lua
function isEmpty(t)
    return next(t) == nil
end
```

## 表的应用

### 作为数组
```lua
local numbers = {10, 20, 30, 40, 50}
```

### 作为字典
```lua
local person = {
    name = "李四",
    age = 30,
    job = "工程师"
}
```

### 作为集合
```lua
local set = {}
function addToSet(set, value)
    set[value] = true
end

function isInSet(set, value)
    return set[value] ~= nil
end
```

### 作为对象
```lua
local person = {
    name = "王五",
    age = 28,
    greet = function(self)
        print("你好，我是" .. self.name)
    end
}
person:greet()
```

## 表的元方法

### __index 元方法
```lua
local default = {value = 0}
local t = {}
setmetatable(t, {__index = default})
print(t.value)  -- 会查找元表
```

### __newindex 元方法
```lua
local t = {}
local proxy = {}
setmetatable(proxy, {
    __index = t,
    __newindex = function(table, key, value)
        t[key] = value
    end
})
proxy.name = "测试"
```

## 表的注意事项

### 表的索引从1开始
```lua
local t = {"a", "b", "c"}
print(t[0])  -- nil
print(t[1])  -- 第一个元素
```

### 表是引用类型
```lua
t1 = {a = 1}
t2 = t1
t2.a = 2
print(t1.a)  -- 2，因为t2和t1引用同一个表
```

### #操作符的陷阱
```lua
local t = {1, 2, 3, nil, 5}
print(#t)  -- 可能是3，因为遇到nil就停止计数
```

## 实用的表工具函数

### 计算表的大小
```lua
function tableSize(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end
```

### 反转表
```lua
function reverseTable(t)
    local reversed = {}
    local size = #t
    for i = 1, size do
        reversed[i] = t[size - i + 1]
    end
    return reversed
end
```

### 查找表中是否存在某个值
```lua
function contains(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end
```

### 获取表中所有键
```lua
function getKeys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end
```

### 获取表中所有值
```lua
function getValues(t)
    local values = {}
    for _, v in pairs(t) do
        table.insert(values, v)
    end
    return values
end
```

## 表的高级应用

### 二维表
```lua
local matrix = {}
for i = 1, 3 do
    matrix[i] = {}
    for j = 1, 3 do
        matrix[i][j] = i * j
    end
end
```

### 稀疏表
```lua
local sparse = {}
sparse[1000] = "值1"
sparse[10000] = "值2"
```

### 表的序列化
```lua
function serialize(t, indent)
    indent = indent or ""
    local result = "{\n"
    local nextIndent = indent .. "  "

    for k, v in pairs(t) do
        local key = type(k) == "string" and k or "[" .. k .. "]"
        if type(v) == "table" then
            result = result .. nextIndent .. key .. " = " .. serialize(v, nextIndent)
        elseif type(v) == "string" then
            result = result .. nextIndent .. key .. " = \"" .. v .. "\",\n"
        else
            result = result .. nextIndent .. key .. " = " .. tostring(v) .. ",\n"
        end
    end

    result = result .. indent .. "}"
    return result
end
```
