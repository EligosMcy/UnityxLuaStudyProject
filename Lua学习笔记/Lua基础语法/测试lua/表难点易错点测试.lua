-- Lua表难点和易错点测试
--[[
本文档总结Lua表学习过程中的难点和易错点
]]

print("=================== 表的难点和易错点 ===================")

-- 难点1: 数组索引从1开始
print("\n【难点1】数组索引从1开始（不是0）")
local arr = {10, 20, 30, 40, 50}
print("arr[1] =", arr[1])  -- 10（第一个元素）
print("arr[0] =", arr[0])  -- nil（C语言习惯用0开始，容易出错）
print("arr[2] =", arr[2])  -- 20（第二个元素）

-- 难点2: #操作符的行为
print("\n【难点2】#操作符遇到nil就停止")
local t1 = {1, 2, 3, 4, 5}
print("#t1 =", #t1)  -- 5

local t2 = {1, 2, nil, 4, 5}
print("#t2 =", #t2)  -- 2（遇到nil就停止）

-- 正确获取表元素个数的方法
local function getSize(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end
print("getSize(t2) =", getSize(t2))  -- 5（正确计算所有元素）

-- 难点3: 表的默认nil值
print("\n【难点3】未赋值的键默认为nil")
local dict = {name = "张三", age = 25}
print("dict.city =", dict.city)  -- nil
print("dict.job =", dict.job)  -- nil

-- 判断键是否存在
print("\n判断键是否存在:")
if dict.name ~= nil then
    print("dict.name 存在")
end

if dict.name ~= nil then
    print("dict.name 存在")
else
    print("dict.name 不存在")
end

-- 键存在但值为nil的情况（难以区分）
print("\n【易错点】键存在但值为nil难以区分")
local tricky = {}
tricky["key"] = nil  -- 明确设置为nil
print("tricky.key =", tricky.key)  -- nil

if tricky.key == nil then
    print("无法区分是未设置还是设置为nil")
end

-- 正确做法：使用next()判断
print("使用 next(tricky) 判断:")
if next(tricky) ~= nil then
    print("表中有键值对")
else
    print("表中没有键值对（空表）")
end

-- 难点4: ipairs vs pairs
print("\n【难点4】ipairs vs pairs 的区别")
local mixed = {1, 2, 3, name = "李四", age = 30}
print("使用ipairs遍历（只遍历连续数组部分）:")
for i, v in ipairs(mixed) do
    print("  ", i, v)  -- 只输出1,2,3
end

print("使用pairs遍历（遍历所有）:")
for k, v in pairs(mixed) do
    print("  ", k, v)  -- 输出所有键值对
end

-- 难点5: 表的赋值是引用传递
print("\n【易错点】赋值是引用传递，不是拷贝")
local original = {value = 100}
local copy = original
copy.value = 200
print("original.value =", original.value)  -- 200（被意外修改）
print("copy.value =", copy.value)  -- 200

-- 正确拷贝
local correctCopy = {value = original.value}  -- 值拷贝
correctCopy.value = 300
print("original.value =", original.value)  -- 200（不变）
print("correctCopy.value =", correctCopy.value)  -- 300

-- 难点6: for循环中修改表
print("\n【易错点】遍历时修改或添加元素")
local items = {1, 2, 3, 4, 5}

-- 错误做法：在遍历中添加元素可能死循环
-- for i, v in ipairs(items) do
--     if v == 2 then
--         table.insert(items, 6)  -- 危险！
--     end
-- end

-- 正确做法：先收集要添加的内容
local toAdd = {}
for i, v in ipairs(items) do
    if v == 2 then
        table.insert(toAdd, 6)
    end
end
for _, v in ipairs(toAdd) do
    table.insert(items, v)
end
print("正确添加后:", table.concat(items, ", "))

-- 难点7: metatable的查找链
print("\n【难点7】元表查找链")
local parent = {parentValue = "来自父类"}
local child = setmetatable({}, {__index = parent})

print("child.parentValue =", child.parentValue)  -- 来自父类
print("child不存在childValue")

-- __index可以是一个函数
local obj = setmetatable({}, {
    __index = function(t, k)
        return "默认值:" .. k
    end
})
print("obj.anyKey =", obj.anyKey)  -- 默认值:anyKey

-- 难点8: 表的相等比较
print("\n【易错点】表相等比较是引用比较")
local a = {1, 2, 3}
local b = {1, 2, 3}
local c = a

print("a == b:", a == b)  -- false（内容相同但不是同一引用）
print("a == c:", a == c)  -- true（同一引用）
print("#a == #b:", #a == #b)  -- true（长度相同）

-- 难点9: 全局表和_G
print("\n【难点9】全局表和_G")
globalVar = "全局变量"
local localVar = "局部变量"

print("globalVar =", globalVar)
-- print("localVar =", localVar)  -- 局部变量在函数外不可访问

print("_G.globalVar =", _G.globalVar)
print("_G['globalVar'] =", _G["globalVar"])

-- 难点10: 表构造函数的坑
print("\n【易错点】表构造函数的歧义")
-- 当键是数字时
local withNumericKeys = {[1] = "a", [2] = "b", [3] = "c"}
print("withNumericKeys[1] =", withNumericKeys[1])

-- 当键是字符串时
local withStringKeys = {a = "1", b = "2", c = "3"}
print("withStringKeys.a =", withStringKeys.a)

-- 混合使用时注意语法
local mixedKeys = {[1] = "数字键1", two = "字符串键two"}
print("mixedKeys[1] =", mixedKeys[1])
print("mixedKeys.two =", mixedKeys.two)

-- 难点11: table库函数的副作用
print("\n【易错点】table库函数可能改变表")
local t = {3, 1, 4, 1, 5, 9, 2, 6}
print("排序前:", table.concat(t, ", "))

table.sort(t)  -- 直接修改原表
print("排序后:", table.concat(t, ", "))  -- 原表被改变

-- 解决：先拷贝再排序
local t2 = {3, 1, 4, 1, 5, 9, 2, 6}
local sorted = {}
for i, v in ipairs(t2) do
    sorted[i] = v
end
table.sort(sorted)
print("t2未改变:", table.concat(t2, ", "))
print("sorted:", table.concat(sorted, ", "))

-- 难点12: 多返回值与表
print("\n【难点12】多返回值打包成表")
function getValues()
    return 1, 2, 3
end

-- 将多返回值存入表
local packed = {getValues()}
print("packed表内容:", table.concat(packed, ", "))  -- 1, 2, 3

-- 使用table.pack（Lua 5.2+）
-- local packed2 = table.pack(getValues())
-- print("packed2.n =", packed2.n)  -- 3

-- 难点13: 表作为键
print("\n【难点13】使用表作为键（需要元表支持）")
local invalid = {}
-- local key = {1, 2, 3}
-- invalid[key] = "值"  -- 错误：表不能作为键

-- 使用字符串化或者特殊处理
local keyStr = tostring({1, 2, 3})
print("键的字符串化:", keyStr)

-- 另一种方案：使用元表模拟
local TableAsKey = {}
setmetatable(TableAsKey, {
    __index = function(t, k)
        if type(k) == "table" then
            local key = tostring(k)
            return rawget(t, key)
        end
    end,
    __newindex = function(t, k, v)
        if type(k) == "table" then
            local key = tostring(k)
            rawset(t, key, v)
        end
    end
})

local key = {1, 2, 3}
TableAsKey[key] = "使用表作为键"
print("使用表作为键的值:", TableAsKey[key])

-- 难点14: nil和空表的区别
print("\n【易错点】nil和空表的区别")
local nilVar = nil
local emptyTable = {}

print("nilVar == nil:", nilVar == nil)
print("#emptyTable:", #emptyTable)  -- 0
print("next(emptyTable):", next(emptyTable))  -- nil（空表）

print("判断方法:")
if nilVar == nil then
    print("nilVar是nil")
end

if next(emptyTable) == nil then
    print("emptyTable是空表")
end

print("\n=================== 难点和易错点测试完成 ===================")
