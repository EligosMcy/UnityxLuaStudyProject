-- Lua元表（Metatable）教程
--[[
本文档详细介绍Lua中元表的概念、使用方法和实际应用。
元表是Lua面向对象编程的核心机制。
]]

print("=================== Lua元表 ===================")

-- 1. 什么是元表？
print("\n--- 1. 什么是元表？ ---")
--[[
元表（Metatable）是一种特殊的表，用于改变另一个表的行为。
当对某个表进行操作（如加法、索引访问）时，
如果该表没有定义这个操作，Lua会查找该表的元表来执行相应功能。

每个表都可以有对应的元表，元表本身也是一个表。
]]

-- 2. 基本操作
print("\n--- 2. 基本操作 ---")

-- 2.1 设置元表 - setmetatable(table, metatable)
print("\n2.1 设置元表:")
local myTable = {1, 2, 3}
local myMetatable = {}

setmetatable(myTable, myMetatable)
print("myTable的元表:", getmetatable(myTable))

-- 2.2 获取元表 - getmetatable(table)
print("\n2.2 获取元表:")
local mt = getmetatable(myTable)
print("元表类型:", type(mt))

-- 3. 元方法（Metamethods）
print("\n--- 3. 元方法 ---")
--[[
元方法是定义在元表中的特殊函数，
用于自定义表的行为。

常见元方法：
- __index: 访问表中的键
- __newindex: 设置表中的键
- __add: 加法运算
- __sub: 减法运算
- __mul: 乘法运算
- __div: 除法运算
- __mod: 取模运算
- __pow: 幂运算
- __unm: 相反数
- __concat: 连接运算
- __eq: 相等比较
- __lt: 小于比较
- __le: 小于等于比较
- __len: 获取长度
- __call: 函数调用
- __tostring: 转换为字符串
- __gc: 垃圾回收
]]

-- 4. __index 元方法 - 访问控制
print("\n--- 4. __index 元方法 ---")
-- 当访问表中不存在的键时，会调用__index

-- 示例1：使用表作为__index
print("\n示例1：使用表作为__index")
local defaultValues = {
    health = 100,
    mana = 50,
    speed = 10
}

local player = {}
setmetatable(player, {__index = defaultValues})

print("player.health:", player.health)  -- 100
print("player.mana:", player.mana)     -- 50
print("player.speed:", player.speed)   -- 10
print("player.level:", player.level)   -- nil

-- 示例2：使用函数作为__index
print("\n示例2：使用函数作为__index")
local props = {
    x = 10,
    y = 20
}

setmetatable(props, {
    __index = function(table, key)
        if key == "distance" then
            local origin = props
            return math.sqrt(origin.x^2 + origin.y^2)
        elseif key == "info" then
            return "坐标点(" .. props.x .. ", " .. props.y .. ")"
        end
        return nil
    end
})

print("x:", props.x)
print("y:", props.y)
print("distance:", props.distance)
print("info:", props.info)

-- 5. __newindex 元方法 - 写入控制
print("\n--- 5. __newindex 元方法 ---")
-- 当对表中不存在的键赋值时，会调用__newindex

print("\n示例：只读表")
local readOnly = {}
local data = {name = "张三", age = 25}

setmetatable(readOnly, {
    __index = data,
    __newindex = function(table, key, value)
        print("错误：不能修改只读表！")
        print("尝试设置:", key, "=", value)
    end
})

print("读取 name:", readOnly.name)
print("读取 age:", readOnly.age)
readOnly.name = "李四"  -- 会触发__newindex

-- 5.1 使用 rawset 修改表
print("\n5.1 使用 rawset 修改表:")
-- 在 __newindex 中如果需要修改表本身的键值对，
-- 直接赋值会再次触发 __newindex 导致无限递归，
-- 需要使用 rawset 函数来绕过元方法

local t = {}
local meta = {}
setmetatable(t, meta)

meta.__newindex = function(table, key, value)
    print("__newindex 被调用:", key, "=", value)
    
    -- 错误做法：直接赋值会导致无限递归
    -- table[key] = value
    
    -- 正确做法：使用 rawset 绕过元方法
    rawset(table, key, value)
    
    -- 可以在这里添加额外的逻辑，如日志记录、数据验证等
    print("使用 rawset 设置成功")
end

print("设置 t.x = 10")
t.x = 10
print("t.x 的值:", t.x)

print("设置 t.y = 20")
t.y = 20
print("t.y 的值:", t.y)

-- 5.2 实际应用：数据验证
print("\n5.2 实际应用：数据验证")
local Person = {}
local personData = {}

setmetatable(Person, {
    __index = personData,
    __newindex = function(table, key, value)
        if key == "age" then
            if type(value) ~= "number" or value < 0 or value > 150 then
                print("错误：年龄必须是0-150之间的数字")
                return
            end
        elseif key == "name" then
            if type(value) ~= "string" or #value == 0 then
                print("错误：姓名不能为空")
                return
            end
        end
        
        -- 验证通过后使用 rawset 设置值
        rawset(personData, key, value)
        print("设置", key, "=", value, "成功")
    end
})

Person.name = "张三"
Person.age = 25
Person.age = 200  -- 会触发验证错误
print("Person.name:", Person.name)
print("Person.age:", Person.age)

-- 6. 算术运算符元方法
print("\n--- 6. 算术运算符元方法 ---")

-- 6.1 __add - 加法
print("\n6.1 __add 加法:")
local Point = {}
Point.__index = Point

function Point.new(x, y)
    local self = setmetatable({}, Point)
    self.x = x
    self.y = y
    return self
end

function Point.__add(p1, p2)
    return Point.new(p1.x + p2.x, p1.y + p2.y)
end

function Point:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end

local p1 = Point.new(1, 2)
local p2 = Point.new(3, 4)
local p3 = p1 + p2
print("p1:", p1)
print("p2:", p2)
print("p1 + p2:", p3)

-- 6.2 __sub - 减法
print("\n6.2 __sub 减法:")
function Point.__sub(p1, p2)
    return Point.new(p1.x - p2.x, p1.y - p2.y)
end

local p4 = p3 - p1
print("p3 - p1:", p4)

-- 6.3 __mul - 乘法
print("\n6.3 __mul 乘法:")
function Point.__mul(p, scalar)
    return Point.new(p.x * scalar, p.y * scalar)
end

local p5 = p1 * 2
print("p1 * 2:", p5)

-- 6.4 __div - 除法
print("\n6.4 __div 除法:")
function Point.__div(p, scalar)
    return Point.new(p.x / scalar, p.y / scalar)
end

local p6 = p5 / 2
print("p5 / 2:", p6)

-- 6.5 __unm - 相反数
print("\n6.5 __unm 相反数:")
function Point.__unm(p)
    return Point.new(-p.x, -p.y)
end

local p7 = -p1
print("-p1:", p7)

-- 6.6 __concat - 连接
print("\n6.6 __concat 连接:")
function Point.__concat(p, str)
    if type(p) == "table" and getmetatable(p) == Point then
        return tostring(p) .. str
    end
    return p .. str
end

local result = p1 .. " 是坐标点"
print(result)

-- 7. 关系运算符元方法
print("\n--- 7. 关系运算符元方法 ---")

-- 7.1 __eq - 相等
print("\n7.1 __eq 相等:")
local p8 = Point.new(1, 2)
local p9 = Point.new(1, 2)
local p10 = Point.new(3, 4)

print("p1 == p8:", p1 == p8)  -- Point.new使用的是同一个元表
print("p1 == p10:", p1 == p10)

-- 7.2 __lt - 小于
print("\n7.2 __lt 小于:")
function Point.__lt(p1, p2)
    if p1.x ~= p2.x then
        return p1.x < p2.x
    end
    return p1.y < p2.y
end

local pa = Point.new(1, 5)
local pb = Point.new(2, 1)
print("pa < pb:", pa < pb)

-- 7.3 __le - 小于等于
print("\n7.3 __le 小于等于:")
function Point.__le(p1, p2)
    if p1.x ~= p2.x then
        return p1.x <= p2.x
    end
    return p1.y <= p2.y
end

print("pa <= pb:", pa <= pb)

-- 8. __len 元方法 - 长度
print("\n--- 8. __len 元方法 ---")
print("\n示例：自定义长度")
local IntList = {}
IntList.__index = IntList

function IntList.new(values)
    local self = setmetatable({}, IntList)
    self.values = values or {}
    return self
end

function IntList:__len()
    return #self.values
end

function IntList:__tostring()
    return "{" .. table.concat(self.values, ", ") .. "}"
end

local list = IntList.new({1, 2, 3, 4, 5})
print("list:", list)
print("#list:", #list)

-- 9. __call 元方法 - 函数调用
print("\n--- 9. __call 元方法 ---")
-- 使表可以像函数一样被调用

print("\n示例：创建一个可调用的表")
local Callable = {}
Callable.__index = Callable

function Callable.new(initial)
    local self = setmetatable({}, Callable)
    self.value = initial
    return self
end

function Callable:__call(...)
    local args = {...}
    if #args == 0 then
        return self.value
    elseif #args == 1 then
        self.value = self.value + args[1]
        return self
    end
end

function Callable:__tostring()
    return "Callable: " .. self.value
end

local myCallable = Callable.new(10)
print("初始值:", myCallable())
myCallable(5)
print("加5后:", myCallable())
myCallable(3)
print("再加3后:", myCallable())

-- 10. __tostring 元方法 - 字符串转换
print("\n--- 10. __tostring 元方法 ---")
-- 当把表传给print或使用tostring时调用

print("\n示例：自定义字符串表示")
local Person = {}
Person.__index = Person

function Person.new(name, age)
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

function Person:__tostring()
    return string.format("Person{name='%s', age=%d}", self.name, self.age)
end

local person = Person.new("张三", 25)
print(person)

-- 11. 面向对象实现
print("\n--- 11. 面向对象实现 ---")

print("\n示例：完整的类系统")
-- 类定义
local Animal = {}
Animal.__index = Animal

function Animal.new(name, sound)
    local self = setmetatable({}, Animal)
    self.name = name
    self.sound = sound
    return self
end

function Animal:speak()
    print(self.name .. " 说: " .. self.sound)
end

function Animal:describe()
    return self.name .. "是一只" .. self.species
end

-- 子类定义
local Dog = {}
Dog.__index = Dog
setmetatable(Dog, Animal)

function Dog.new(name)
    local self = Animal.new(name, "汪汪汪")
    self.species = "狗"
    return setmetatable(self, Dog)
end

function Dog:speak()
    print(self.name .. " 汪汪叫")
end

function Dog:fetch()
    print(self.name .. " 正在捡球")
end

local cat = Animal.new("小猫", "喵喵喵")
cat.species = "猫"
print(cat:describe())
cat:speak()

local dog = Dog.new("旺财")
print(dog:describe())
dog:speak()
dog:fetch()

-- 12. 继承
print("\n--- 12. 继承 ---")

print("\n示例：多层继承")
local GoldenRetriever = {}
GoldenRetriever.__index = GoldenRetriever
setmetatable(GoldenRetriever, Dog)

function GoldenRetriever.new(name)
    local self = Dog.new(name)
    return setmetatable(self, GoldenRetriever)
end

function GoldenRetriever:swim()
    print(self.name .. " 正在游泳")
end

local golden = GoldenRetriever.new("金毛")
golden:speak()
golden:fetch()
golden:swim()

-- 13. 实际应用示例
print("\n--- 13. 实际应用示例 ---")

-- 13.1 默认值表
print("\n13.1 默认值表:")
function withDefaultValues(defaults)
    return function(t)
        return setmetatable(t, {
            __index = function(table, key)
                return defaults[key]
            end
        })
    end
end

local withDefaults = withDefaultValues({speed = 10, health = 100})
local entity = withDefaults({name = "Player"})
print("entity.name:", entity.name)
print("entity.speed:", entity.speed)
print("entity.health:", entity.health)

-- 13.2 跟踪表访问
print("\n13.2 跟踪表访问:")
function tracked(t)
    return setmetatable({}, {
        __index = function(table, key)
            print("读取键:", key)
            return t[key]
        end,
        __newindex = function(table, key, value)
            print("设置键:", key, "=", value)
            t[key] = value
        end,
        __pairs = function()
            return function(table, key)
                local nextKey, nextValue = next(t, key)
                if nextKey then
                    print("访问键:", nextKey)
                end
                return nextKey, nextValue
            end
        end
    })
end

local trackedEntity = tracked({x = 0, y = 0})
trackedEntity.x = 10
print("x的值:", trackedEntity.x)
for k, v in pairs(trackedEntity) do
    print(k, v)
end

-- 13.3 自动求值表
print("\n13.3 自动求值表:")
local Lazy = {}
Lazy.__index = Lazy

function Lazy.new(data, evaluator)
    return setmetatable({
        _data = data,
        _evaluator = evaluator,
        _computed = false,
        _value = nil
    }, Lazy)
end

function Lazy:__index(key)
    if key == "value" then
        if not self._computed then
            self._value = self._evaluator(self._data)
            self._computed = true
        end
        return self._value
    end
    return nil
end

local lazyValue = Lazy.new(100, function(data)
    print("执行耗时计算...")
    return data * 2
end)

print("准备获取值...")
print("lazyValue.value:", lazyValue.value)
print("lazyValue.value (再次访问，无计算):", lazyValue.value)

-- 13.4 代理表
print("\n13.4 代理表:")
function Proxy(target)
    return setmetatable({}, {
        __index = function(table, key)
            return target[key]
        end,
        __newindex = function(table, key, value)
            target[key] = value
        end,
        __pairs = function()
            return pairs(target)
        end,
        __len = function()
            return #target
        end
    })
end

local original = {a = 1, b = 2}
local proxy = Proxy(original)
print("proxy.a:", proxy.a)
proxy.c = 3
print("original.c:", original.c)

print("\n=================== 元表教程完成 ===================")
