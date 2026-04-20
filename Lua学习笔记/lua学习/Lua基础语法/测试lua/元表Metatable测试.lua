-- Lua Metatable元表测试
--[[
Metatable（元表）是Lua的核心概念，用于：
1. 重定义表的操作行为（运算符重载）
2. 实现面向对象（self和方法调用）
3. 模拟继承
]]

print("=================== Metatable元表测试 ===================")

-- 1. 元表基础
print("\n--- 1. 元表基础 ---")
local t1 = {1, 2, 3}
local t2 = {4, 5, 6}

-- 设置元表
setmetatable(t1, t2)

-- 获取元表
local mt = getmetatable(t1)
print("t1的元表:", mt)
print("t1的元表是否是t2:", mt == t2)

-- 2. __index元方法（访问表字段时触发）
print("\n--- 2. __index元方法 ---")
local father = {
    name = "父亲",
    age = 50,
    say = function(self)
        print(self.name .. "在说话")
    end
}

local son = {
    name = "儿子",
    age = 20
}

-- 设置__index指向father，实现继承
setmetatable(son, {__index = father})

print("son.name =", son.name)  -- 儿子（自己的）
print("son.age =", son.age)  -- 20（自己的）
print("son:fatherName =", son.fatherName)  -- nil（son本身没有，会查father）
-- son:fatherName实际会访问father.fatherName，返回nil

-- 另一种__index写法：使用函数
local customIndex = function(table, key)
    print("访问了键: " .. key)
    if key == "greet" then
        return "你好！"
    end
    return "默认值"
end

local t3 = setmetatable({}, {__index = customIndex})
print("t3.greet =", t3.greet)  -- 你好！
print("t3.unknown =", t3.unknown)  -- 默认值

-- 3. __newindex元方法（设置表字段时触发）
print("\n--- 3. __newindex元方法 ---")
local proxy = {}
local target = {}

setmetatable(proxy, {
    __newindex = function(table, key, value)
        print("设置新键: " .. key .. " = " .. tostring(value))
        target[key] = value
    end
})

proxy.name = "张三"  -- 触发__newindex
proxy.age = 25  -- 触发__newindex
print("target.name =", target.name)  -- 张三
print("target.age =", target.age)  -- 25

-- 4. __add元方法（加法运算）
print("\n--- 4. __add元方法 ---")
local Vec2 = {}
Vec2.__index = Vec2

function Vec2:new(x, y)
    local self = setmetatable({}, Vec2)
    self.x = x
    self.y = y
    return self
end

function Vec2:add(other)
    return Vec2:new(self.x + other.x, self.y + other.y)
end

-- 定义__add元方法
setmetatable(Vec2, {
    __add = function(v1, v2)
        return Vec2:new(v1.x + v2.x, v1.y + v2.y)
    end
})

local v1 = Vec2:new(1, 2)
local v2 = Vec2:new(3, 4)
local v3 = v1 + v2  -- 使用+运算符，自动调用__add
print("v3 = (" .. v3.x .. ", " .. v3.y .. ")")  -- (4, 6)

-- 5. 其他运算符元方法
print("\n--- 5. 其他运算符元方法 ---")
local Number = {}
Number.__index = Number

function Number:new(val)
    return setmetatable({value = val}, Number)
end

setmetatable(Number, {
    __add = function(a, b) return Number:new(a.value + b.value) end,
    __sub = function(a, b) return Number:new(a.value - b.value) end,
    __mul = function(a, b) return Number:new(a.value * b.value) end,
    __div = function(a, b) return Number:new(a.value / b.value) end,
    __mod = function(a, b) return Number:new(a.value % b.value) end,
    __pow = function(a, b) return Number:new(a.value ^ b.value) end,
    __unm = function(a) return Number:new(-a.value) end,
    __concat = function(a, b) return tostring(a.value) .. tostring(b.value) end,
    __eq = function(a, b) return a.value == b.value end,
    __lt = function(a, b) return a.value < b.value end,
    __le = function(a, b) return a.value <= b.value end
})

local n1 = Number:new(10)
local n2 = Number:new(3)
print("n1 + n2 =", (n1 + n2).value)
print("n1 - n2 =", (n1 - n2).value)
print("n1 * n2 =", (n1 * n2).value)
print("n1 / n2 =", (n1 / n2).value)
print("n1 % n2 =", (n1 % n2).value)
print("n1 ^ 2 =", (n1 ^ 2).value)
print("-n1 =", (-n1).value)
print("n1 == n2:", n1 == n2)
print("n1 < n2:", n1 < n2)
print("n1 <= n2:", n1 <= n2)

-- 6. __tostring元方法
print("\n--- 6. __tostring元方法 ---")
local Person = {}
Person.__index = Person

function Person:new(name, age)
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

setmetatable(Person, {
    __tostring = function(self)
        return "Person: " .. self.name .. ", " .. self.age .. "岁"
    end
})

local p = Person:new("张三", 25)
print(tostring(p))  -- Person: 张三, 25岁
print(p)  -- Person: 张三, 25岁

-- 7. __call元方法（使表可调用）
print("\n--- 7. __call元方法 ---")
local MathUtils = {}
setmetatable(MathUtils, {
    __call = function(self, x, y)
        return x + y
    end
})

print("MathUtils(3, 4) =", MathUtils(3, 4))  -- 7

-- 8. __len元方法（用于#操作符）
print("\n--- 8. __len元方法 ---")
local SizedArray = {}
setmetatable(SizedArray, {
    __index = SizedArray,
    __len = function(self)
        local count = 0
        for _ in pairs(self) do count = count + 1 end
        return count
    end
})

local arr = setmetatable({10, 20, 30}, {__len = function(t) return #t end})
print("#arr =", #arr)  -- 3

-- 9. 继承的实现
print("\n--- 9. 继承的实现 ---")
-- 基础类
local Animal = {}
Animal.__index = Animal

function Animal:new(name, sound)
    local self = setmetatable({}, Animal)
    self.name = name
    self.sound = sound
    return self
end

function Animal:speak()
    print(self.name .. " 说: " .. self.sound)
end

-- 派生类
local Cat = {}
Cat.__index = Cat
setmetatable(Cat, {__index = Animal})  -- Cat继承Animal

function Cat:new(name)
    local self = Animal:new(name, "喵~")  -- 调用父类构造函数
    setmetatable(self, {__index = Cat})  -- 但自己的元表是Cat
    return self
end

function Cat:purr()
    print(self.name .. " 在打呼噜")
end

local cat = Cat:new("小猫")
cat:speak()  -- 继承自Animal的方法
cat:purr()  -- Cat自己的方法

-- 10. rawget和rawset（绕过元表）
print("\n--- 10. rawget和rawset ---")
local rawDemo = setmetatable({}, {
    __index = function(t, k)
        return "默认值"
    end
})

print("rawDemo.key =", rawDemo.key)  -- 默认值（通过__index）
print("rawget(rawDemo, 'key') =", rawget(rawDemo, "key"))  -- nil（绕过__index）

rawDemo.key = "直接值"
print("设置后 rawDemo.key =", rawDemo.key)  -- 直接值

rawset(rawDemo, "key2", "value2")  -- 直接设置，绕过__newindex
print("rawDemo.key2 =", rawDemo.key2)  -- value2

print("\n=================== 元表测试完成 ===================")
