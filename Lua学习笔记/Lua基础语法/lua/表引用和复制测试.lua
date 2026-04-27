-- Lua表引用和复制测试
--[[
Lua中表是引用类型：
- 变量存储的是表的引用，不是表的副本
- 直接赋值只是复制引用，多个变量指向同一个表
- 修改一个变量会影响所有引用该表的变量
]]

print("=================== 表的引用和复制 ===================")

-- 1. 引用类型演示
print("\n--- 1. 引用类型演示 ---")
local t1 = {name = "原始表", value = 100}
local t2 = t1  -- t2只是t1的引用，不是副本

print("t1.name =", t1.name)
print("t2.name =", t2.name)

t2.name = "修改后的表"  -- 通过t2修改
print("\n修改t2.name后:")
print("t1.name =", t1.name)  -- 也变了！
print("t2.name =", t2.name)  -- 同样的变化

print("\nt1 == t2:", t1 == t2)  -- true，指向同一个表

-- 2. 函数参数传递（引用传递）
print("\n--- 2. 函数参数传递 ---")
local function modifyTable(t)
    t.value = 999
    t.newField = "新字段"
end

local testTable = {value = 10}
print("调用函数前 testTable.value =", testTable.value)

modifyTable(testTable)  -- 传递引用
print("调用函数后 testTable.value =", testTable.value)  -- 999
print("testTable.newField =", testTable.newField)  -- 新字段

-- 3. 浅拷贝实现
print("\n--- 3. 浅拷贝 ---")
function shallowCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        copy[k] = v  -- 直接复制值（对于表来说仍然是引用）
    end
    return copy
end

local original = {name = "原始", nested = {a = 1, b = 2}}
local copied = shallowCopy(original)

print("original.name =", original.name)
print("copied.name =", copied.name)

copied.name = "副本"
print("\n修改副本name后:")
print("original.name =", original.name)  -- 不变
print("copied.name =", copied.name)  -- 变了

-- 但嵌套表仍然是引用
print("\n--- 浅拷贝的嵌套表问题 ---")
copied.nested.a = 100
print("修改copied.nested.a后:")
print("original.nested.a =", original.nested.a)  -- 也变了！（问题所在）
print("copied.nested.a =", copied.nested.a)

-- 4. 深拷贝实现
print("\n--- 4. 深拷贝（递归拷贝） ---")
function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)  -- 递归拷贝嵌套表
        else
            copy[k] = v
        end
    end
    return copy
end

local original2 = {
    name = "原始",
    nested = {a = 1, b = 2},
    data = {inner = {value = 50}}
}
local deepCopied = deepCopy(original2)

print("修改deepCopied.nested.a前:")
print("original2.nested.a =", original2.nested.a)
print("deepCopied.nested.a =", deepCopied.nested.a)

deepCopied.nested.a = 999
print("\n修改deepCopied.nested.a = 999后:")
print("original2.nested.a =", original2.nested.a)  -- 不变！
print("deepCopied.nested.a =", deepCopied.nested.a)  -- 变了

-- 5. 循环引用的深拷贝（需要 visited 表防止无限递归）
print("\n--- 5. 循环引用的处理 ---")
local circular1 = {value = 1}
local circular2 = {value = 2}
circular1.next = circular2
circular2.next = circular1  -- 形成循环引用

-- 简单深拷贝会死循环，需要特殊处理
function safeDeepCopy(original, visited)
    visited = visited or {}
    if type(original) ~= "table" then
        return original
    end

    if visited[original] then
        return visited[original]  -- 返回已拷贝的引用
    end

    local copy = {}
    visited[original] = copy  -- 记录已访问

    for k, v in pairs(original) do
        copy[k] = safeDeepCopy(v, visited)
    end
    return copy
end

local circularCopy = safeDeepCopy(circular1)
print("circularCopy.value =", circularCopy.value)
print("circularCopy.next.value =", circularCopy.next.value)
print("circularCopy.next.next == circularCopy:", circularCopy.next.next == circularCopy)

-- 6. 表作为函数返回值
print("\n--- 6. 表作为函数返回值 ---")
function createCounter()
    local count = 0
    return {
        increment = function()
            count = count + 1
            return count
        end,
        getCount = function()
            return count
        end
    }
end

local counter1 = createCounter()
local counter2 = createCounter()

print("counter1 第1次:", counter1.increment())  -- 1
print("counter1 第2次:", counter1.increment())  -- 2
print("counter1 第3次:", counter1.increment())  -- 3
print("counter2 第1次:", counter2.increment())  -- 1（独立的count）
print("counter2 第2次:", counter2.increment())  -- 2

-- 7. 全局表和局部表
print("\n--- 7. 全局表和局部表 ---")
GlobalTable = {value = "全局"}
local LocalTable = {value = "局部"}

function accessTable()
    print("直接访问 GlobalTable.value =", GlobalTable.value)  -- 全局
    print("直接访问 LocalTable.value =", LocalTable.value)  -- 局部

    -- 在函数内部访问全局变量
    _G.GlobalTable = {value = "通过_G访问"}
    print("通过_G访问:", _G.GlobalTable.value)
end

accessTable()

-- 8. 表的比较
print("\n--- 8. 表的比较 ---")
local a = {1, 2, 3}
local b = {1, 2, 3}
local c = a

print("a == b:", a == b)  -- false（不同引用）
print("a == c:", a == c)  -- true（同一引用）

-- 9. 表的清空
print("\n--- 9. 表的清空 ---")
local toClear = {a = 1, b = 2, c = 3, d = 4}
print("清空前:", table.concat({"a", "b", "c", "d"}, ", "))

-- 方法1：逐个置nil
-- for k in pairs(toClear) do
--     toClear[k] = nil
-- end

-- 方法2：创建新表替换
toClear = {}  -- 原来的表失去引用，等待GC回收
print("创建新表后 toClear.a =", toClear.a)  -- nil

-- 10. 多层引用
print("\n--- 10. 多层引用 ---")
local level1 = {name = "第一层"}
local level2 = {parent = level1}
local level3 = {parent = level2}

-- level3 -> level2 -> level1 -> 同一个表
print("level3.parent.parent.name =", level3.parent.parent.name)  -- 第一层

-- 修改level1会影响level3
level1.name = "修改后的第一层"
print("修改后 level3.parent.parent.name =", level3.parent.parent.name)

print("\n=================== 引用和复制测试完成 ===================")
