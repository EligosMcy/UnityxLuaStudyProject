# Lua数据类型

## 目录
- [nil（空类型）](#nil空类型)
- [boolean（布尔类型）](#boolean布尔类型)
- [number（数字类型）](#number数字类型)
- [string（字符串）](#string字符串)
- [function（函数）](#function函数)
- [table（表）](#table表)
- [userdata（用户数据）](#userdata用户数据)
- [thread（线程）](#thread线程)

## nil（空类型）

```lua
local var
print(var)  -- nil
var = 100
print(var)  -- 100
```

## boolean（布尔类型）

```lua
local isTrue = true
local isFalse = false
-- 布尔值中，只有false和nil为假，其他都为真
if isTrue then
    print("isTrue为真")
end
```

## number（数字类型）

```lua
local intNum = 42
local floatNum = 3.14
local negativeNum = -10
local scientificNum = 1.5e-2  -- 科学计数法
```

## string（字符串）

```lua
local str1 = "这是字符串"
local str2 = '这也是字符串'
local str3 = [[这是
多行字符串
可以包含换行]]

-- 字符串长度
print(#str1)  -- 5

-- 字符串转换
local num = 123
local strFromNum = tostring(num)

-- 数值转换
local str = "456"
local numFromStr = tonumber(str)
```

## function（函数）

```lua
local function sayHello()
    print("Hello!")
end

local funcVar = function()
    print("这是一个函数变量")
end
```

## table（表）

```lua
local tbl = {}
local tbl2 = {1, 2, 3}
local tbl3 = {name = "张三", age = 25}
```

## userdata（用户数据）

用于将C数据传递给Lua。

## thread（线程）

用于协程。

## type函数

返回数据类型：
```lua
print(type("Hello"))   -- string
print(type(123))       -- number
print(type(true))      -- boolean
print(type(nil))       -- nil
print(type(print))     -- function
print(type({}))        -- table
```
