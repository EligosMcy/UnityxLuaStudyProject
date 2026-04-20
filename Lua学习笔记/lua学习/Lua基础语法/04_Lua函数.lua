-- Lua函数
--[[
函数是Lua的基本组成单元，可以完成特定任务或计算并返回值。
]]

-- 1. 函数定义
function greet(name)
    print("你好，" .. name)
end

greet("张三")

-- 2. 多返回值
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

-- 3. 可变参数
function sum(...)
    local total = 0
    local args = {...}
    for i = 1, #args do
        total = total + args[i]
    end
    return total
end

print("sum(1,2,3,4,5) = " .. sum(1, 2, 3, 4, 5))

-- 4. 命名参数（通过table实现）
function createPlayer(args)
    return {
        name = args.name or "未知",
        level = args.level or 1,
        health = args.health or 100
    }
end

local player = createPlayer({name = "李四", level = 10})
print("玩家：" .. player.name .. "，等级：" .. player.level)

-- 5. 闭包
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

-- 6. 递归
function factorial(n)
    if n <= 1 then
        return 1
    end
    return n * factorial(n - 1)
end

print("5! = " .. factorial(5))

-- 7. 尾调用
function foo(n)
    if n > 0 then
        return foo(n - 1)
    end
    return "完成"
end

-- 8. 高阶函数
function apply(func, value)
    return func(value)
end

local function double(x)
    return x * 2
end

print("apply(double, 5) = " .. apply(double, 5))

-- 9. 函数作为参数和返回值
function outer(x)
    return function(y)
        return x + y
    end
end

local addFive = outer(5)
print("addFive(3) = " .. addFive(3))
print("addFive(10) = " .. addFive(10))

-- 10. 匿名函数
local anonymous = function(x)
    return x * x
end
print("匿名函数：" .. anonymous(4))
