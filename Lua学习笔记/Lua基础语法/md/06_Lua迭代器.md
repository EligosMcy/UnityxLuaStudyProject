# Lua迭代器（Iterator）

迭代器是Lua中用于遍历集合（如表）元素的重要概念。

## 目录
- [什么是迭代器？](#什么是迭代器)
- [内置迭代器](#内置迭代器)
- [泛型for循环的工作原理](#泛型for循环的工作原理)
- [无状态迭代器](#无状态迭代器)
- [有状态迭代器](#有状态迭代器)
- [自定义迭代器的应用](#自定义迭代器的应用)
- [迭代器的性能考虑](#迭代器的性能考虑)
- [高级迭代器技巧](#高级迭代器技巧)
- [迭代器与协程](#迭代器与协程)
- [实际应用场景](#实际应用场景)
- [迭代器的注意事项](#迭代器的注意事项)

## 什么是迭代器？

迭代器是一种可以遍历集合中所有元素的机制。在Lua中，迭代器通常表现为一个函数，每次调用返回集合中的下一个元素。当没有元素时，返回nil。

## 内置迭代器

### ipairs()

用于遍历数组（从1开始的连续索引）：
```lua
local array = {"苹果", "香蕉", "橙子", "葡萄"}
for i, v in ipairs(array) do
    print("索引:", i, "值:", v)
end
```

### pairs()

用于遍历表的所有键值对（无序）：
```lua
local person = {name = "张三", age = 25, city = "北京"}
for k, v in pairs(person) do
    print("键:", k, "值:", v)
end
```

## 泛型for循环的工作原理

泛型for循环的语法：
```lua
for var1, var2, ..., varN in iterator do
    body
end
```

泛型for循环实际上调用了三个值：
1. 迭代函数
2. 状态（通常是被遍历的表）
3. 控制变量（通常是初始索引）

## 无状态迭代器

无状态迭代器不保留任何状态，每次调用只依赖于传入的参数。

示例：数字范围迭代器
```lua
function range(from, to, step)
    step = step or 1
    return function(state, current)
        current = current + step
        if current <= state then
            return current
        end
    end, to, from - step
end

for i in range(1, 10, 2) do
    print("数字:", i)
end
```

## 有状态迭代器

有状态迭代器保留状态，通常使用闭包来实现。

示例：计数器迭代器
```lua
function counter(max)
    local count = 0
    return function()
        count = count + 1
        if count <= max then
            return count
        end
    end
end

for i in counter(5) do
    print("计数:", i)
end
```

## 自定义迭代器的应用

### 遍历表的键
```lua
function keys(t)
    local key, value
    return function()
        key, value = next(t, key)
        return key
    end
end
```

### 遍历表的值
```lua
function values(t)
    local key, value
    return function()
        key, value = next(t, key)
        return value
    end
end
```

### 过滤迭代器
```lua
function filter(t, predicate)
    local key, value
    return function()
        repeat
            key, value = next(t, key)
            if key == nil then
                return nil
            end
        until predicate(value)
        return key, value
    end
end
```

## 迭代器的性能考虑

### ipairs vs pairs vs 数值for

```lua
local bigArray = {}
for i = 1, 10000 do
    bigArray[i] = i
end

-- 测试ipairs
for i, v in ipairs(bigArray) do
    -- 空操作
end

-- 测试数值for
for i = 1, #bigArray do
    local v = bigArray[i]
end
```

## 高级迭代器技巧

### 链式迭代器
```lua
function chain(...)
    local iterators = {...}
    local current = 1
    local it, state, var

    return function()
        while current <= #iterators do
            if not it then
                it, state, var = iterators[current]()
            end
            local result = {it(state, var)}
            var = result[1]
            if var then
                return table.unpack(result)
            else
                current = current + 1
                it, state, var = nil, nil, nil
            end
        end
    end
end
```

### 带索引的迭代器
```lua
function enumerate(t)
    local i = 0
    return function()
        i = i + 1
        if t[i] then
            return i, t[i]
        end
    end
end
```

## 迭代器与协程

```lua
function coroutineIterator(t)
    return coroutine.wrap(function()
        for i, v in pairs(t) do
            coroutine.yield(i, v)
        end
    end)
end
```

## 实际应用场景

### 遍历文件行
```lua
function lines(filename)
    local file = {"第一行", "第二行", "第三行"}
    local i = 0
    return function()
        i = i + 1
        return file[i]
    end
end
```

### 遍历目录
```lua
function dir(path)
    local files = {"file1.lua", "file2.lua", "dir1"}
    local i = 0
    return function()
        i = i + 1
        return files[i]
    end
end
```

## 迭代器的注意事项

### 遍历时修改表

错误做法：在迭代中添加元素
```lua
local items = {1, 2, 3, 4, 5}
for i, v in ipairs(items) do
    if v == 3 then
        table.insert(items, 100)  -- 可能导致无限循环
    end
end
```

正确做法：先收集要添加的元素
```lua
local toAdd = {}
for i, v in ipairs(items) do
    if v == 3 then
        table.insert(toAdd, 100)
    end
end
for _, v in ipairs(toAdd) do
    table.insert(items, v)
end
```

### 迭代器的内存管理

避免在迭代器中创建大量临时对象。对于大集合，考虑使用无状态迭代器以减少内存使用。
