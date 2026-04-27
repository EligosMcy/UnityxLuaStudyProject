-- Lua迭代器（Iterator）教程
--[[
迭代器是Lua中用于遍历集合（如表）元素的重要概念。
本文档详细介绍Lua迭代器的原理和使用方法。
]]

print("=================== Lua迭代器 ===================")

-- 1. 什么是迭代器？
--[[
迭代器是一种可以遍历集合中所有元素的机制。
在Lua中，迭代器通常表现为一个函数，每次调用返回集合中的下一个元素。
当没有元素时，返回nil。
]]

-- 2. 内置迭代器
print("\n--- 2. 内置迭代器 ---")

-- 2.1 ipairs() - 用于遍历数组（从1开始的连续索引）
print("\n2.1 ipairs() 迭代器:")
local array = {"苹果", "香蕉", "橙子", "葡萄"}
print("使用ipairs遍历数组:")
for i, v in ipairs(array) do
    print("  索引:", i, "值:", v)
end

-- 2.2 pairs() - 用于遍历表的所有键值对（无序）
print("\n2.2 pairs() 迭代器:")
local person = {name = "张三", age = 25, city = "北京"}
print("使用pairs遍历表:")
for k, v in pairs(person) do
    print("  键:", k, "值:", v)
end

-- 3. 泛型for循环的工作原理
print("\n--- 3. 泛型for循环的工作原理 ---")
-- 泛型for循环的语法:
-- for var1, var2, ..., varN in iterator do
--     body
-- end

-- 泛型for循环实际上调用了三个值:
-- 1. 迭代函数
-- 2. 状态（通常是被遍历的表）
-- 3. 控制变量（通常是初始索引）

-- 示例：模拟ipairs的行为
print("\n模拟ipairs的工作原理:")
local function myIpairs(t)
    local i = 0
    return function()
        i = i + 1
        if i <= #t then
            return i, t[i]
        end
    end
end

print("使用自定义ipairs遍历:")
for i, v in myIpairs(array) do
    print("  索引:", i, "值:", v)
end

-- 4. 无状态迭代器
print("\n--- 4. 无状态迭代器 ---")
-- 无状态迭代器不保留任何状态，每次调用只依赖于传入的参数

-- 示例：数字范围迭代器
function range(from, to, step)
    step = step or 1
    return function(state, current)
        current = current + step
        if current <= state then
            return current
        end
    end, to, from - step
end

print("使用range迭代器:")
for i in range(1, 10, 2) do
    print("  数字:", i)
end

-- 5. 有状态迭代器
print("\n--- 5. 有状态迭代器 ---")
-- 有状态迭代器保留状态，通常使用闭包来实现

-- 示例：计数器迭代器
function counter(max)
    local count = 0
    return function()
        count = count + 1
        if count <= max then
            return count
        end
    end
end

print("使用计数器迭代器:")
for i in counter(5) do
    print("  计数:", i)
end

-- 6. 自定义迭代器的应用
print("\n--- 6. 自定义迭代器的应用 ---")

-- 6.1 遍历表的键
function keys(t)
    local key, value
    return function()
        key, value = next(t, key)
        return key
    end
end

print("遍历表的键:")
for key in keys(person) do
    print("  键:", key)
end

-- 6.2 遍历表的值
function values(t)
    local key, value
    return function()
        key, value = next(t, key)
        return value
    end
end

print("\n遍历表的值:")
for value in values(person) do
    print("  值:", value)
end

-- 6.3 过滤迭代器
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

print("\n过滤迭代器（只显示年龄大于20的）:")
local people = {
    {name = "张三", age = 25},
    {name = "李四", age = 18},
    {name = "王五", age = 30}
}

for i, person in filter(people, function(p) return p.age > 20 end) do
    print("  姓名:", person.name, "年龄:", person.age)
end

-- 7. 迭代器的性能考虑
print("\n--- 7. 迭代器的性能考虑 ---")

-- 7.1 ipairs vs pairs vs 数值for
print("\n迭代器性能比较:")
local bigArray = {}
for i = 1, 10000 do
    bigArray[i] = i
end

-- 测试ipairs
local start = os.clock()
for i, v in ipairs(bigArray) do
    -- 空操作
end
print("ipairs遍历10000个元素:", os.clock() - start, "秒")

-- 测试数值for
start = os.clock()
for i = 1, #bigArray do
    local v = bigArray[i]
end
print("数值for遍历10000个元素:", os.clock() - start, "秒")

-- 8. 高级迭代器技巧
print("\n--- 8. 高级迭代器技巧 ---")

-- 8.1 链式迭代器
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

print("\n链式迭代器:")
local t1 = {1, 2, 3}
local t2 = {4, 5, 6}

local function iterator(t) return ipairs(t) end

for i, v in chain(function() return iterator(t1) end, function() return iterator(t2) end) do
    print("  元素:", v)
end

-- 8.2 带索引的迭代器
function enumerate(t)
    local i = 0
    return function()
        i = i + 1
        if t[i] then
            return i, t[i]
        end
    end
end

print("\n带索引的迭代器:")
for index, value in enumerate({"a", "b", "c"}) do
    print("  索引:", index, "值:", value)
end

-- 9. 迭代器与协程
print("\n--- 9. 迭代器与协程 ---")

function coroutineIterator(t)
    return coroutine.wrap(function()
        for i, v in pairs(t) do
            coroutine.yield(i, v)
        end
    end)
end

print("\n使用协程的迭代器:")
for k, v in coroutineIterator({x = 1, y = 2, z = 3}) do
    print("  键:", k, "值:", v)
end

-- 10. 实际应用场景
print("\n--- 10. 实际应用场景 ---")

-- 10.1 遍历文件行
print("\n遍历文件行（模拟）:")
function lines(filename)
    local file = {"第一行", "第二行", "第三行"}  -- 模拟文件内容
    local i = 0
    return function()
        i = i + 1
        return file[i]
    end
end

for line in lines("test.txt") do
    print("  行:", line)
end

-- 10.2 遍历目录（模拟）
print("\n遍历目录（模拟）:")
function dir(path)
    local files = {"file1.lua", "file2.lua", "dir1"}
    local i = 0
    return function()
        i = i + 1
        return files[i]
    end
end

for file in dir("/path/to/dir") do
    print("  文件:", file)
end

-- 11. 迭代器的注意事项
print("\n--- 11. 迭代器的注意事项 ---")

-- 11.1 遍历时修改表
print("\n遍历时修改表的问题:")
local items = {1, 2, 3, 4, 5}
print("原始表:", table.concat(items, ", "))

-- 错误做法：在迭代中添加元素
-- for i, v in ipairs(items) do
--     if v == 3 then
--         table.insert(items, 100)  -- 可能导致无限循环
--     end
-- end

-- 正确做法：先收集要添加的元素
local toAdd = {}
for i, v in ipairs(items) do
    if v == 3 then
        table.insert(toAdd, 100)
    end
end
for _, v in ipairs(toAdd) do
    table.insert(items, v)
end
print("修改后:", table.concat(items, ", "))

-- 11.2 迭代器的内存管理
print("\n迭代器的内存管理:")
-- 避免在迭代器中创建大量临时对象
-- 对于大集合，考虑使用无状态迭代器以减少内存使用

-- 12. 内置迭代器的实现原理
print("\n--- 12. 内置迭代器的实现原理 ---")

-- ipairs的简化实现
function my_ipairs(t)
    return function(t, i)
        i = i + 1
        local v = t[i]
        if v then
            return i, v
        end
    end, t, 0
end

print("\n使用自定义ipairs:")
for i, v in my_ipairs({"a", "b", "c"}) do
    print("  ", i, v)
end

-- pairs的简化实现
function my_pairs(t)
    return next, t, nil
end

print("\n使用自定义pairs:")
for k, v in my_pairs({x = 1, y = 2}) do
    print("  ", k, v)
end

print("\n=================== 迭代器教程完成 ===================")
