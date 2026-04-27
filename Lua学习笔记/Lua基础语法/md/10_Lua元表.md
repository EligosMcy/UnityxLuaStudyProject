# Lua元表（Metatable）

## 目录
- [什么是元表？](#什么是元表)
- [基本操作](#基本操作)
- [元方法（Metamethods）](#元方法metamethods)
- [__index 元方法](#__index-元方法)
- [__newindex 元方法](#__newindex-元方法)
- [算术运算符元方法](#算术运算符元方法)
- [关系运算符元方法](#关系运算符元方法)
- [__len 元方法](#__len-元方法)
- [__call 元方法](#__call-元方法)
- [__tostring 元方法](#__tostring-元方法)
- [面向对象实现](#面向对象实现)
- [继承](#继承)
- [实际应用示例](#实际应用示例)

## 什么是元表？

元表（Metatable）是一种特殊的表，用于改变另一个表的行为。当对某个表进行操作（如加法、索引访问）时，如果该表没有定义这个操作，Lua会查找该表的元表来执行相应功能。

每个表都可以有对应的元表，元表本身也是一个表。

## 基本操作

### 设置元表

```lua
local myTable = {1, 2, 3}
local myMetatable = {}
setmetatable(myTable, myMetatable)
```

### 获取元表

```lua
local mt = getmetatable(myTable)
```

## 元方法（Metamethods）

元方法是定义在元表中的特殊函数，用于自定义表的行为。

常见元方法：
- `__index`: 访问表中的键
- `__newindex`: 设置表中的键
- `__add`: 加法运算
- `__sub`: 减法运算
- `__mul`: 乘法运算
- `__div`: 除法运算
- `__mod`: 取模运算
- `__pow`: 幂运算
- `__unm`: 相反数
- `__concat`: 连接运算
- `__eq`: 相等比较
- `__lt`: 小于比较
- `__le`: 小于等于比较
- `__len`: 获取长度
- `__call`: 函数调用
- `__tostring`: 转换为字符串
- `__gc`: 垃圾回收

## __index 元方法

当访问表中不存在的键时，会调用__index。

### 使用表作为__index

```lua
local defaultValues = {
    health = 100,
    mana = 50,
    speed = 10
}

local player = {}
setmetatable(player, {__index = defaultValues})

print(player.health)  -- 100
print(player.mana)     -- 50
print(player.level)    -- nil
```

### 使用函数作为__index

```lua
local props = {
    x = 10,
    y = 20
}

setmetatable(props, {
    __index = function(table, key)
        if key == "distance" then
            return math.sqrt(props.x^2 + props.y^2)
        elseif key == "info" then
            return "坐标点(" .. props.x .. ", " .. props.y .. ")"
        end
        return nil
    end
})

print(props.x)         -- 10
print(props.distance)  -- 调用函数计算
print(props.info)      -- 调用函数返回
```

## __newindex 元方法

当对表中不存在的键赋值时，会调用__newindex。

### 只读表

```lua
local readOnly = {}
local data = {name = "张三", age = 25}

setmetatable(readOnly, {
    __index = data,
    __newindex = function(table, key, value)
        print("错误：不能修改只读表！")
    end
})

print(readOnly.name)   -- 读取正常
readOnly.name = "李四" -- 触发__newindex
```

### 使用 rawset 修改表

在 __newindex 中需要使用 rawset 函数来绕过元方法：
```lua
local t = {}
local meta = {}
setmetatable(t, meta)

meta.__newindex = function(table, key, value)
    rawset(table, key, value)
end

t.x = 10  -- 使用rawset设置
```

### 数据验证

```lua
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
        rawset(personData, key, value)
    end
})
```

## 算术运算符元方法

### __add 加法

```lua
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

local p1 = Point.new(1, 2)
local p2 = Point.new(3, 4)
local p3 = p1 + p2  -- 自动调用__add
```

### 其他算术运算符

```lua
__sub  -- 减法
__mul  -- 乘法
__div  -- 除法
__unm  -- 相反数
__mod  -- 取模
__pow  -- 幂运算
__concat -- 连接
```

## 关系运算符元方法

### __eq 相等

```lua
function Point.__eq(p1, p2)
    return p1.x == p2.x and p1.y == p2.y
end
```

### __lt 小于

```lua
function Point.__lt(p1, p2)
    if p1.x ~= p2.x then
        return p1.x < p2.x
    end
    return p1.y < p2.y
end
```

### __le 小于等于

```lua
function Point.__le(p1, p2)
    if p1.x ~= p2.x then
        return p1.x <= p2.x
    end
    return p1.y <= p2.y
end
```

## __len 元方法

```lua
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

local list = IntList.new({1, 2, 3, 4, 5})
print(#list)  -- 5
```

## __call 元方法

使表可以像函数一样被调用：

```lua
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

local myCallable = Callable.new(10)
print(myCallable())  -- 10
myCallable(5)
print(myCallable())  -- 15
```

## __tostring 元方法

```lua
function Person:__tostring()
    return string.format("Person{name='%s', age=%d}", self.name, self.age)
end

local person = Person.new("张三", 25)
print(person)  -- Person{name='张三', age=25}
```

## 面向对象实现

### 完整的类系统

```lua
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

local dog = Dog.new("旺财")
dog:speak()
```

## 继承

```lua
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
golden:speak()  -- 继承自Dog
golden:swim()   -- GoldenRetriever自己的方法
```

## 实际应用示例

### 默认值表

```lua
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
print(entity.speed)  -- 10（默认值）
```

### 跟踪表访问

```lua
function tracked(t)
    return setmetatable({}, {
        __index = function(table, key)
            print("读取键:", key)
            return t[key]
        end,
        __newindex = function(table, key, value)
            print("设置键:", key, "=", value)
            t[key] = value
        end
    })
end
```
