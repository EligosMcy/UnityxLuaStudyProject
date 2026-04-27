-- Lua面向对象编程示例
--[[
本文件通过简单明了的示例展示Lua中面向对象编程的核心概念。
Lua通过表和元表机制实现面向对象编程。

首先lua对象是通过元表进行实现的。
1.通过 : 实现自调用，即在方法中调用自身。
例如：self:sayHello(),不使用:使用. 就需要在方法中传入参数self来引用对象。
2.通过 __index 元方法实现属性的动态访问 (特性是当表中不存在该属性时，会调用__index方法设置的表中的属性)。
例如：self.name = "Alice"
例如：self.name = "Alice"
3.通过 __call 元方法实现函数的动态调用。
例如：self:sayHello()
4.设置相关值，其实是再自己的表中进行键值对的添加，
例如：self.age = 25 => obj{age = 25},如此才实现属性修改,此时读取的是自己的表而非元表中的数据。
5.obj，是对象的实例，是元表的实例。最好设置为local类型，避免全局污染。


//
1.继承核心就是，让另外一个表的元表指向当前表，从而实现继承。
2.多态核心就是，通过键值对的使用，实现不同的方法调用。
3.封装（私有成员）核心就是，将对象的属性和方法封装起来，只暴露必要的接口,将数据存储到创建的新对象中，在构造函数中进行初始化。
]]

print("=================== Lua面向对象编程示例 ===================")

-- 核心概念说明
print("\n--- 核心概念 ---")
print("1. Lua对象通过表(table)实现")
print("2. 元表(metatable)用于实现继承和方法查找")
print("3. : 语法用于自动传递self参数")
print("4. __index元方法用于属性和方法的动态查找")

-- 1. 基本类定义
print("\n--- 1. 基本类定义 ---")

-- 定义Person类
local Person = {}

-- 构造函数：创建并返回新对象
function Person:new(name, age)
    local obj = {name = name, age = age}  -- 创建对象实例
    setmetatable(obj, self)  -- 设置元表为Person
    self.__index = self  -- 当对象中找不到属性时，从Person中查找
    return obj
end

-- 方法定义
function Person:sayHello()
    print("Hello, my name is " .. self.name)
end

function Person:getAge()
    return self.age
end

-- 使用示例
local person = Person:new("Alice", 25)
print("创建Person对象:")
person:sayHello()  -- 调用方法
print("Age:", person:getAge())  -- 访问属性

-- 2. 继承
print("\n--- 2. 继承 ---")

-- Student类继承自Person
local Student = Person:new()  -- 创建Person的子类

-- 子类构造函数
function Student:new(name, age, grade)
    local obj = Person:new(name, age)  -- 调用父类构造函数
    obj.grade = grade  -- 添加子类特有属性
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- 重写父类方法
function Student:sayHello()
    print("Hello, my name is " .. self.name .. " and I'm in grade " .. self.grade)
end

-- 添加子类特有方法
function Student:study()
    print(self.name .. " is studying")
end

-- 使用示例
local student = Student:new("Bob", 15, 10)
print("创建Student对象:")
student:sayHello()  -- 调用重写的方法
print("Age:", student:getAge())  -- 继承父类方法
student:study()  -- 调用子类特有方法

-- 3. 多态
print("\n--- 3. 多态 ---")

-- 基类Shape
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

-- 多态函数：接受任何Shape类型的对象
function drawShape(shape)
    shape:draw()  -- 根据对象类型调用不同的draw方法
end

-- 使用示例
print("多态示例:")
drawShape(Circle:new(5))      -- 调用Circle的draw
print(" ")
drawShape(Rectangle:new(10, 20))  -- 调用Rectangle的draw
print(" ")
drawShape(Shape:new())       -- 调用Shape的draw

-- 4. 封装（私有成员）
print("\n--- 4. 封装 ---")

local Account = {}
function Account:new(owner, balance)
    local obj = {owner = owner}  -- 公共属性
    local _balance = balance  -- 私有成员（通过闭包实现）
    
    setmetatable(obj, self)
    self.__index = self
    
    -- 访问私有成员的方法
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
print("创建Account对象:")
print("Owner:", account.owner)  -- 可以访问公共属性
print("Balance:", account:getBalance())  -- 通过方法访问私有成员
account:deposit(500)
-- print(account._balance)  -- 无法直接访问私有成员

-- 5. 静态方法和属性
print("\n--- 5. 静态方法和属性 ---")

local MathUtils = {}

-- 静态属性：直接定义在类表上
MathUtils.PI = 3.14159

-- 静态方法：不需要self参数
function MathUtils.add(a, b)
    return a + b
end

-- 使用示例
print("静态成员示例:")
print("PI:", MathUtils.PI)
print("5 + 3 =", MathUtils.add(5, 3))

-- 6. 设计模式：单例模式
print("\n--- 6. 设计模式：单例模式 ---")

local Logger = {}

-- 获取单例实例
function Logger:getInstance()
    if not self.instance then  -- 只有第一次调用时创建实例
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
print("单例模式示例:")
local logger1 = Logger:getInstance()
local logger2 = Logger:getInstance()
print("logger1和logger2是同一个对象:", logger1 == logger2)

logger1:log("Application started")
logger2:log("User logged in")  -- 使用同一个实例

-- 7. 核心机制总结
print("\n--- 7. 核心机制总结 ---")
print("1. 表(table)：Lua中所有数据结构的基础")
print("2. 元表(metatable)：用于修改表的行为")
print("3. __index：当表中找不到属性时的查找规则")
print("4. 闭包：用于实现私有成员")
print("5. : 语法：自动传递self参数的语法糖")

-- 8. 实际应用建议
print("\n--- 8. 实际应用建议 ---")
print("- 使用局部变量存储对象，避免全局污染")
print("- 合理设计类的层次结构，避免过深继承")
print("- 使用有意义的命名，提高代码可读性")
print("- 为复杂类提供清晰的文档和注释")

print("\n=================== 面向对象编程示例完成 ===================")
