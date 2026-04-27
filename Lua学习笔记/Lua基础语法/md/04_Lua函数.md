# Lua函数

## 目录
- [函数定义](#函数定义)
- [多返回值](#多返回值)
- [可变参数](#可变参数)
- [命名参数](#命名参数)
- [闭包](#闭包)
- [递归](#递归)
- [尾调用](#尾调用)
- [高阶函数](#高阶函数)
- [匿名函数](#匿名函数)

## 函数定义

```lua
function greet(name)
    print("你好，" .. name)
end

greet("张三")
```

## 多返回值

```lua
function getMinMax(arr)
    local min = arr[1]
    local max = arr[1]
    for i = 1, #arr do
        if arr[i] < min then min = arr[i] end
        if arr[i] > max then max = arr[i] end
    end
    return min, max
end

local minVal, maxVal = getMinMax({3, 1, 4, 1, 5, 9, 2, 6})
print("最小值：" .. minVal .. "，最大值：" .. maxVal)
```

## 可变参数

```lua
function sum(...)
    local total = 0
    local args = {...}
    for i = 1, #args do
        total = total + args[i]
    end
    return total
end

print("sum(1,2,3,4,5) = " .. sum(1, 2, 3, 4, 5))
```

## 命名参数

通过table实现：
```lua
function createPlayer(args)
    return {
        name = args.name or "未知",
        level = args.level or 1,
        health = args.health or 100
    }
end

local player = createPlayer({name = "李四", level = 10})
print("玩家：" .. player.name .. "，等级：" .. player.level)
```

## 闭包

```lua
function counter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

local count1 = counter()
print(count1())  -- 1
print(count1())  -- 2
print(count1())  -- 3
```

## 递归

```lua
function factorial(n)
    if n <= 1 then
        return 1
    end
    return n * factorial(n - 1)
end

print("5! = " .. factorial(5))
```

## 尾调用

```lua
function foo(n)
    if n > 0 then
        return foo(n - 1)
    end
    return "完成"
end
```

## 高阶函数

```lua
function apply(func, value)
    return func(value)
end

local function double(x)
    return x * 2
end

print("apply(double, 5) = " .. apply(double, 5))
```

## 函数作为参数和返回值

```lua
function outer(x)
    return function(y)
        return x + y
    end
end

local addFive = outer(5)
print("addFive(3) = " .. addFive(3))
print("addFive(10) = " .. addFive(10))
```

## 匿名函数

```lua
local anonymous = function(x)
    return x * x
end
print("匿名函数：" .. anonymous(4))
```
