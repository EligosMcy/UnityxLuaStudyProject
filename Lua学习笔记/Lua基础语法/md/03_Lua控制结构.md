# Lua控制结构

## 目录
- [if 条件语句](#if-条件语句)
- [while 循环](#while-循环)
- [repeat...until 循环](#repeatuntil-循环)
- [for 循环](#for-循环)
- [泛型for循环](#泛型for循环)
- [break 语句](#break-语句)
- [return 语句](#return-语句)
- [goto语句](#goto语句)
- [逻辑运算符](#逻辑运算符)
- [关系运算符](#关系运算符)

## if 条件语句

```lua
local age = 18

if age >= 18 then
    print("已成年")
end

-- if-else
local score = 85
if score >= 90 then
    print("优秀")
elseif score >= 60 then
    print("及格")
else
    print("不及格")
end
```

## while 循环

```lua
local i = 1
while i <= 5 do
    print("while循环第" .. i .. "次")
    i = i + 1
end
```

## repeat...until 循环

repeat循环至少执行一次，直到条件为真时退出：
```lua
local j = 1
repeat
    print("repeat循环第" .. j .. "次")
    j = j + 1
until j > 5
```

## for 循环

### 数值for循环
```lua
for i = 1, 5 do
    print("数值for循环第" .. i .. "次")
end
```

### 带步长的for循环
```lua
for i = 10, 1, -2 do
    print("倒计时：" .. i)
end
```

## 泛型for循环

### 遍历数组
```lua
local fruits = {"苹果", "香蕉", "橙子"}
for index, value in ipairs(fruits) do
    print(index, value)
end
```

### 遍历键值对
```lua
local person = {name = "张三", age = 25, city = "北京"}
for key, value in pairs(person) do
    print(key, value)
end
```

## break 语句

用于退出循环：
```lua
local k = 1
while true do
    if k > 5 then
        break  -- 退出循环
    end
    print("break示例：" .. k)
    k = k + 1
end
```

## return 语句

用于从函数中返回值：
```lua
local function add(a, b)
    return a + b
end

local result = add(3, 5)
print("add(3,5) = " .. result)
```

## goto语句

Lua 5.2+支持goto语句：
```lua
local i = 1
::loop::
print(i)
i = i + 1
if i <= 5 then
    goto loop
end
```

## 逻辑运算符

```lua
local a, b = true, false
print(a and b)  -- false
print(a or b)   -- true
print(not a)    -- false
```

## 关系运算符

```
==  ~=  <   >   <=  >=
```
