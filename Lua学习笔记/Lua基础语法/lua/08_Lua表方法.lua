-- Lua表（Table）方法教程
--[[
本文档详细介绍Lua中table的常用操作方法。
]]

print("=================== Lua表方法 ===================")

-- 1. 表的创建
print("\n--- 1. 表的创建 ---")
local t1 = {}
local t2 = {1, 2, 3}
local t3 = {name = "张三", age = 25}
local t4 = {1, 2, name = "李四", 3, 4}

print("空表:", t1)
print("数组表:", t2[1], t2[2], t2[3])
print("字典表:", t3.name, t3["age"])
print("混合表:", t4[1], t4.name, t4[3])

-- 2. table库方法
print("\n--- 2. table库方法 ---")

-- 2.1 table.insert() - 在指定位置插入元素
print("\n2.1 table.insert():")
local t = {1, 2, 3, 4, 5}
print("原始表:", table.concat(t, ", "))

-- 在末尾插入
 table.insert(t, 6)
print("在末尾插入6:", table.concat(t, ", "))

-- 在指定位置插入
 table.insert(t, 2, 10)
print("在位置2插入10:", table.concat(t, ", "))

-- 2.2 table.remove() - 删除指定位置的元素
print("\n2.2 table.remove():")
t = {1, 2, 3, 4, 5}
print("原始表:", table.concat(t, ", "))

-- 删除末尾元素
local removed = table.remove(t)
print("删除末尾元素:", table.concat(t, ", "), "被删除的元素:", removed)

-- 删除指定位置元素
removed = table.remove(t, 2)
print("删除位置2的元素:", table.concat(t, ", "), "被删除的元素:", removed)

-- 2.3 table.concat() - 连接表中的元素为字符串
print("\n2.3 table.concat():")
t = {"a", "b", "c", "d"}
print("原始表:", t[1], t[2], t[3], t[4])
print("默认连接:", table.concat(t))
print("指定分隔符:", table.concat(t, ", "))
print("指定范围:", table.concat(t, "|", 2, 3))

-- 2.4 table.sort() - 对表进行排序
print("\n2.4 table.sort():")
t = {3, 1, 4, 1, 5, 9, 2, 6}
print("原始表:", table.concat(t, ", "))

-- 默认排序（升序）
 table.sort(t)
print("升序排序:", table.concat(t, ", "))

-- 自定义排序（降序）
 table.sort(t, function(a, b) return a > b end)
print("降序排序:", table.concat(t, ", "))

-- 对字符串表排序
local fruits = {"banana", "apple", "orange", "grape"}
print("\n字符串表:", table.concat(fruits, ", "))
 table.sort(fruits)
print("按字母顺序排序:", table.concat(fruits, ", "))

-- 2.5 table.maxn() - 获取表中最大的整数索引（Lua 5.1）
print("\n2.5 table.maxn():")
t = {[1] = "a", [5] = "b", [10] = "c"}
print("最大索引:", table.maxn(t))

-- 2.6 table.pack() - 将参数打包成表（Lua 5.2+）
print("\n2.6 table.pack():")
local packed = table.pack(1, "hello", true)
print("打包结果:", packed[1], packed[2], packed[3])
print("参数数量:", packed.n)

-- 2.7 table.unpack() - 将表解包为参数
print("\n2.7 table.unpack():")
local t = {1, 2, 3, 4, 5}
local a, b, c = table.unpack(t, 1, 3)
print("解包结果:", a, b, c)

-- 3. 表的遍历
print("\n--- 3. 表的遍历 ---")

-- 3.1 ipairs() - 遍历数组部分
print("\n3.1 ipairs() 遍历:")
t = {"a", "b", "c", "d"}
for i, v in ipairs(t) do
    print("  索引:", i, "值:", v)
end

-- 3.2 pairs() - 遍历所有键值对
print("\n3.2 pairs() 遍历:")
t = {name = "张三", age = 25, city = "北京"}
for k, v in pairs(t) do
    print("  键:", k, "值:", v)
end

-- 4. 表的操作
print("\n--- 4. 表的操作 ---")

-- 4.1 获取表的长度
print("\n4.1 获取表的长度:")
t = {1, 2, 3, 4, 5}
print("表长度:", #t)

-- 注意：#操作符只计算连续的整数索引
local t2 = {1, 2, nil, 4, 5}  -- 中间有nil
print("有nil的表长度:", #t2)  -- 结果可能是2

-- 4.2 表的复制
print("\n4.2 表的复制:")

-- 浅拷贝
function shallowCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

-- 深拷贝
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

local original = {a = 1, b = {c = 2}}
local shallow = shallowCopy(original)
local deep = deepCopy(original)

print("修改原始表中的嵌套表:")
original.b.c = 99
print("原始表:", original.b.c)
print("浅拷贝:", shallow.b.c)  -- 受影响
print("深拷贝:", deep.b.c)     -- 不受影响

-- 4.3 表的合并
print("\n4.3 表的合并:")
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

local t1 = {a = 1, b = 2}
local t2 = {b = 3, c = 4}
local merged = merge(t1, t2)
print("合并结果:")
for k, v in pairs(merged) do
    print("  ", k, "=", v)
end

-- 4.4 检查表是否为空
print("\n4.4 检查表是否为空:")
function isEmpty(t)
    return next(t) == nil
end

print("空表:", isEmpty({}))
print("非空表:", isEmpty({a = 1}))

-- 5. 表的应用
print("\n--- 5. 表的应用 ---")

-- 5.1 作为数组
print("\n5.1 作为数组:")
local numbers = {10, 20, 30, 40, 50}
print("数组元素:")
for i = 1, #numbers do
    print("  ", i, numbers[i])
end

-- 5.2 作为字典
print("\n5.2 作为字典:")
local person = {
    name = "李四",
    age = 30,
    job = "工程师",
    address = {
        city = "上海",
        district = "浦东新区"
    }
}
print("姓名:", person.name)
print("年龄:", person.age)
print("城市:", person.address.city)

-- 5.3 作为集合
print("\n5.3 作为集合:")
local set = {}
function addToSet(set, value)
    set[value] = true
end

function removeFromSet(set, value)
    set[value] = nil
end

function isInSet(set, value)
    return set[value] ~= nil
end

addToSet(set, "apple")
addToSet(set, "banana")
print("'apple' 在集合中:", isInSet(set, "apple"))
print("'orange' 在集合中:", isInSet(set, "orange"))

-- 5.4 作为对象
print("\n5.4 作为对象:")
local person = {
    name = "王五",
    age = 28,
    greet = function(self)
        print("你好，我是" .. self.name)
    end,
    getOlder = function(self)
        self.age = self.age + 1
        return self.age
    end
}

person:greet()
print("年龄增长后:", person:getOlder())

-- 6. 表的元方法
print("\n--- 6. 表的元方法 ---")

-- 6.1 __index 元方法
print("\n6.1 __index 元方法:")
local default = {value = 0}
local t = {}
setmetatable(t, {__index = default})

print("t.value:", t.value)  -- 会查找元表
print("t.notExist:", t.notExist)  -- nil

-- 6.2 __newindex 元方法
print("\n6.2 __newindex 元方法:")
local t = {}
local proxy = {}
setmetatable(proxy, {
    __index = t,
    __newindex = function(table, key, value)
        print("设置", key, "=", value)
        t[key] = value
    end
})

proxy.name = "测试"
print("proxy.name:", proxy.name)
print("t.name:", t.name)

-- 6.3 __metable 元方法
print("\n6.3 __metable 元方法:")
-- __metable 用于保护元表，防止被修改
local protectedTable = {}
local protectedMetatable = {__metable = "protected"}

setmetatable(protectedTable, protectedMetatable)

print("尝试获取元表:", getmetatable(protectedTable))  -- 会返回 __metable 的值

-- 尝试修改元表会失败
-- setmetatable(protectedTable, {})  -- 会报错
print("注意：当元表中存在 __metable 键值对时，setmetatable 会失败")
print("当元表中存在 __metable 键值对时，getmetatable 会返回 __metable 的值")

-- 7. 表的性能
print("\n--- 7. 表的性能 ---")

-- 7.1 表的访问性能
print("\n7.1 表的访问性能:")

local t = {}
for i = 1, 10000 do
    t[i] = i
end

local start = os.clock()
for i = 1, 10000 do
    local v = t[i]
end
print("访问10000个元素:", os.clock() - start, "秒")

-- 7.2 表的插入性能
print("\n7.2 表的插入性能:")
t = {}
start = os.clock()
for i = 1, 10000 do
    table.insert(t, i)
end
print("插入10000个元素:", os.clock() - start, "秒")

-- 8. 表的注意事项
print("\n--- 8. 表的注意事项 ---")

-- 8.1 表的索引从1开始
print("\n8.1 表的索引从1开始:")
t = {"a", "b", "c"}
print("t[0]:", t[0])  -- nil
print("t[1]:", t[1])  -- 第一个元素

-- 8.2 表是引用类型
print("\n8.2 表是引用类型:")
t1 = {a = 1}
t2 = t1
t2.a = 2
print("t1.a:", t1.a)  -- 2，因为t2和t1引用同一个表

-- 8.3 #操作符的陷阱
print("\n8.3 #操作符的陷阱:")
t = {1, 2, 3, nil, 5}  -- 中间有nil
print("#t:", #t)  -- 可能是3，因为遇到nil就停止计数

-- 8.4 避免创建巨大的表
print("\n8.4 内存使用:")
-- 创建大型表时要注意内存使用
-- 考虑使用弱表（weak table）来自动垃圾回收

-- 9. 实用的表工具函数
print("\n--- 9. 实用的表工具函数 ---")

-- 9.1 计算表的大小
function tableSize(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

local t = {a = 1, b = 2, c = 3}
print("表大小:", tableSize(t))

-- 9.2 反转表
function reverseTable(t)
    local reversed = {}
    local size = #t
    for i = 1, size do
        reversed[i] = t[size - i + 1]
    end
    return reversed
end

local t = {1, 2, 3, 4, 5}
local reversed = reverseTable(t)
print("反转表:", table.concat(reversed, ", "))

-- 9.3 查找表中是否存在某个值
function contains(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

local t = {"a", "b", "c"}
print("包含 'b':", contains(t, "b"))
print("包含 'd':", contains(t, "d"))

-- 9.4 获取表中所有键
function getKeys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

local t = {name = "张三", age = 25, city = "北京"}
local keys = getKeys(t)
print("表的键:", table.concat(keys, ", "))

-- 9.5 获取表中所有值
function getValues(t)
    local values = {}
    for _, v in pairs(t) do
        table.insert(values, v)
    end
    return values
end

local values = getValues(t)
print("表的值:", table.concat(values, ", "))

-- 10. 表的高级应用
print("\n--- 10. 表的高级应用 ---")

-- 10.1 二维表
print("\n10.1 二维表:")
local matrix = {}
for i = 1, 3 do
    matrix[i] = {}
    for j = 1, 3 do
        matrix[i][j] = i * j
    end
end

print("3x3矩阵:")
for i = 1, 3 do
    local row = {}
    for j = 1, 3 do
        table.insert(row, matrix[i][j])
    end
    print("  ", table.concat(row, " \t"))
end

-- 10.2 稀疏表
print("\n10.2 稀疏表:")
local sparse = {}
sparse[1000] = "值1"
sparse[10000] = "值2"
sparse[100000] = "值3"
print("稀疏表大小:", tableSize(sparse))
print("sparse[1000]:", sparse[1000])

-- 10.3 表的序列化
print("\n10.3 表的序列化:")
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

local person = {name = "张三", age = 25, address = {city = "北京", district = "朝阳区"}}
print("表的序列化:")
print(serialize(person))

print("\n=================== 表方法教程完成 ===================")
