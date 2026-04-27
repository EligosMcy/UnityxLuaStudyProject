-- Lua控制结构
--[[
Lua提供以下控制结构：
if、while、repeat、for、break、return
]]

-- 1. if 条件语句
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

-- 2. while 循环
local i = 1
while i <= 5 do
    print("while循环第" .. i .. "次")
    i = i + 1
end

-- 3. repeat...until 循环
-- repeat循环至少执行一次，直到条件为真时退出
local j = 1
repeat
    print("repeat循环第" .. j .. "次")
    j = j + 1
until j > 5

-- 4. for 循环
-- 数值for循环
for i = 1, 5 do
    print("数值for循环第" .. i .. "次")
end

-- 带步长的for循环
for i = 10, 1, -2 do
    print("倒计时：" .. i)
end

-- 5. 泛型for循环（遍历表或数组）
local fruits = {"苹果", "香蕉", "橙子"}
for index, value in ipairs(fruits) do
    print(index, value)
end

-- 遍历键值对
local person = {name = "张三", age = 25, city = "北京"}
for key, value in pairs(person) do
    print(key, value)
end

-- 6. break 语句
local k = 1
while true do
    if k > 5 then
        break  -- 退出循环
    end
    print("break示例：" .. k)
    k = k + 1
end

-- 7. return 语句
-- 用于从函数中返回值
local function add(a, b)
    return a + b
end

local result = add(3, 5)
print("add(3,5) = " .. result)

-- 8. goto语句（Lua 5.2+）
--[[
local i = 1
::loop::
print(i)
i = i + 1
if i <= 5 then
    goto loop
end
]]

-- 9. 逻辑运算符
local a, b = true, false
print(a and b)  -- false
print(a or b)   -- true
print(not a)    -- false

-- 10. 关系运算符
-- ==  ~=  <   >   <=  >=
