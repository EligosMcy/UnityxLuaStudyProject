# Lua Metatable元表测试

## 目录
- [元表基础](#元表基础)
- [__index元方法](#__index元方法)
- [__newindex元方法](#__newindex元方法)
- [__add元方法](#__add元方法)
- [其他运算符元方法](#其他运算符元方法)
- [__tostring元方法](#__tostring元方法)
- [__call元方法](#__call元方法)
- [__len元方法](#__len元方法)
- [继承的实现](#继承的实现)
- [rawget和rawset](#rawget和rawset)

## 元表基础

```lua
local t1 = {1, 2, 3}
local t2 = {4, 5, 6}

setmetatable(t1, t2)
local mt = getmetatable(t1)
print(mt == t2)
```

## __index元方法

当访问表中不存在的键时触发：

```lua
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

setmetatable(son, {__index = father})

print(son.name)           -- 儿子（自己的）
print(son.fatherName)     -- nil（son本身没有，会查father）
```

使用函数作为__index：
```lua
local customIndex = function(table, key)
    print("访问了键: " .. key)
    if key == "greet" then
        return "你好！"
    end
    return "默认值"
end

local t3 = setmetatable({}, {__index = customIndex})
print(t3.greet)    -- 你好！
print(t3.unknown)  -- 默认值
```

## __newindex元方法

当设置表中不存在的键时触发：

```lua
local proxy = {}
local target = {}

setmetatable(proxy, {
    __newindex = function(table, key, value)
        print("设置新键: " .. key .. " = " .. tostring(value))
        target[key] = value
    end
})

proxy.name = "张三"
proxy.age = 25
print(target.name)  -- 张三
print(target.age)   -- 25
```

## __add元方法

```lua
local Vec2 = {}
Vec2.__index = Vec2

function Vec2:new(x, y)
    local self = setmetatable({}, Vec2)
    self.x = x
    self.y = y
    return self
end

setmetatable(Vec2, {
    __add = function(v1, v2)
        return Vec2:new(v1.x + v2.x, v1.y + v2.y)
    end
})

local v1 = Vec2:new(1, 2)
local v2 = Vec2:new(3, 4)
local v3 = v1 + v2
print("v3 = (" .. v3.x .. ", " .. v3.y .. ")")  -- (4, 6)
```

## 其他运算符元方法

```lua
local Number = {}
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
```

## __tostring元方法

```lua
local Person = {}
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
```

## __call元方法

使表可调用：

```lua
local MathUtils = {}
setmetatable(MathUtils, {
    __call = function(self, x, y)
        return x + y
    end
})

print(MathUtils(3, 4))  -- 7
```

## __len元方法

```lua
local arr = setmetatable({10, 20, 30}, {__len = function(t) return #t end})
print(#arr)  -- 3
```

## 继承的实现

```lua
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
setmetatable(Cat, {__index = Animal})

function Cat:new(name)
    local self = Animal:new(name, "喵~")
    setmetatable(self, {__index = Cat})
    return self
end

function Cat:purr()
    print(self.name .. " 在打呼噜")
end

local cat = Cat:new("小猫")
cat:speak()  -- 继承自Animal的方法
cat:purr()   -- Cat自己的方法
```

## rawget和rawset

绕过元表进行读写：

```lua
local rawDemo = setmetatable({}, {
    __index = function(t, k)
        return "默认值"
    end
})

print(rawDemo.key)                    -- 默认值
print(rawget(rawDemo, "key"))        -- nil（绕过__index）

rawDemo.key = "直接值"
print(rawDemo.key)                   -- 直接值

rawset(rawDemo, "key2", "value2")   -- 绕过__newindex
print(rawDemo.key2)                   -- value2
```
