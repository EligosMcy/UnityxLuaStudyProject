# Lua面向对象编程示例

## 目录
- [核心概念说明](#核心概念说明)
- [基本类定义](#基本类定义)
- [继承](#继承)
- [多态](#多态)
- [封装](#封装)
- [静态方法和属性](#静态方法和属性)
- [设计模式：单例模式](#设计模式单例模式)
- [核心机制总结](#核心机制总结)
- [实际应用建议](#实际应用建议)

## 核心概念说明

1. Lua对象通过表(table)实现
2. 元表(metatable)用于实现继承和方法查找
3. `:` 语法用于自动传递self参数
4. `__index`元方法用于属性和方法的动态查找

**核心机制：**
1. 继承核心是，让另外一个表的元表指向当前表，从而实现继承
2. 多态核心是，通过键值对的使用，实现不同的方法调用
3. 封装（私有成员）核心是，将对象的属性和方法封装起来，只暴露必要的接口

## 基本类定义

### 定义Person类

```lua
local Person = {}

function Person:new(name, age)
    local obj = {name = name, age = age}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Person:sayHello()
    print("Hello, my name is " .. self.name)
end

function Person:getAge()
    return self.age
end

-- 使用示例
local person = Person:new("Alice", 25)
person:sayHello()
print("Age:", person:getAge())
```

## 继承

### Student类继承自Person

```lua
local Student = Person:new()

function Student:new(name, age, grade)
    local obj = Person:new(name, age)
    obj.grade = grade
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Student:sayHello()
    print("Hello, my name is " .. self.name .. " and I'm in grade " .. self.grade)
end

function Student:study()
    print(self.name .. " is studying")
end

-- 使用示例
local student = Student:new("Bob", 15, 10)
student:sayHello()
student:study()
```

## 多态

### 基类Shape

```lua
local Shape = {}
function Shape:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Shape:draw()
    print("Drawing a shape")
end

-- 子类Circle
local Circle = Shape:new()
function Circle:new(radius)
    local obj = Shape:new()
    obj.radius = radius
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Circle:draw()
    print("Drawing a circle with radius " .. self.radius)
end

-- 子类Rectangle
local Rectangle = Shape:new()
function Rectangle:new(width, height)
    local obj = Shape:new()
    obj.width = width
    obj.height = height
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Rectangle:draw()
    print("Drawing a rectangle with width " .. self.width .. " and height " .. self.height)
end

-- 多态函数
function drawShape(shape)
    shape:draw()
end

-- 使用示例
drawShape(Circle:new(5))
drawShape(Rectangle:new(10, 20))
drawShape(Shape:new())
```

## 封装

通过闭包实现私有成员：

```lua
local Account = {}
function Account:new(owner, balance)
    local obj = {owner = owner}
    local _balance = balance

    setmetatable(obj, self)
    self.__index = self

    function obj:getBalance()
        return _balance
    end

    function obj:deposit(amount)
        if amount > 0 then
            _balance = _balance + amount
            print(self.owner .. " deposited " .. amount)
            print("New balance: " .. _balance)
        end
    end

    return obj
end

-- 使用示例
local account = Account:new("Charlie", 1000)
print("Owner:", account.owner)
print("Balance:", account:getBalance())
account:deposit(500)
```

## 静态方法和属性

```lua
local MathUtils = {}

-- 静态属性
MathUtils.PI = 3.14159

-- 静态方法
function MathUtils.add(a, b)
    return a + b
end

-- 使用示例
print("PI:", MathUtils.PI)
print("5 + 3 =", MathUtils.add(5, 3))
```

## 设计模式：单例模式

```lua
local Logger = {}

function Logger:getInstance()
    if not self.instance then
        self.instance = {logs = {}}
        setmetatable(self.instance, self)
        self.__index = self
    end
    return self.instance
end

function Logger:log(message)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = "[" .. timestamp .. "] " .. message
    table.insert(self.logs, logMessage)
    print(logMessage)
end

-- 使用示例
local logger1 = Logger:getInstance()
local logger2 = Logger:getInstance()
print("logger1和logger2是同一个对象:", logger1 == logger2)

logger1:log("Application started")
logger2:log("User logged in")
```

## 核心机制总结

1. **表(table)**：Lua中所有数据结构的基础
2. **元表(metatable)**：用于修改表的行为
3. **__index**：当表中找不到属性时的查找规则
4. **闭包**：用于实现私有成员
5. **`:` 语法**：自动传递self参数的语法糖

## 实际应用建议

- 使用局部变量存储对象，避免全局污染
- 合理设计类的层次结构，避免过深继承
- 使用有意义的命名，提高代码可读性
- 为复杂类提供清晰的文档和注释
