-- Lua基础语法
--[[
Lua是一种轻量级的脚本语言，设计目的是为了嵌入应用程序中。
以下为Lua的基础语法示例：
]]

-- 1. 注释
-- 单行注释
--[[
    多行注释
]]

-- 2. 变量
-- Lua中变量默认是全局的，除非使用local声明
local age = 25
name = "张三"  -- 全局变量

-- 2.1 标识符规则
-- Lua的标识符（变量名、函数名等）必须遵循以下规则：
-- 1. 只能由字母、数字、下划线组成
-- 2. 不能以数字开头
-- 3. 区分大小写
-- 4. 不能使用Lua关键字作为标识符

-- 合法的标识符
local userName = "李四"
local user_age = 30
local _privateVar = "私有变量"

-- 不合法的标识符（会导致语法错误）
-- local 123abc = 100  -- 不能以数字开头
-- local user-name = "测试"  -- 不能包含连字符
-- local function = 10  -- 不能使用关键字

-- 2.2 Lua关键字（共21个）
-- and       break     do        else      elseif
-- end       false     for       function  if
-- in        local     nil       not       or
-- repeat    return    then      true      until
-- while

-- 3. 数据类型
print(type("Hello"))      -- string
print(type(123))         -- number
print(type(true))        -- boolean
print(type(nil))         -- nil
print(type(print))       -- function
print(type({}))           -- table

-- 4. 字符串
local str1 = "双引号字符串"
local str2 = '单引号字符串'
local str3 = [[多行字符串]]

-- 5. 字符串拼接
local fullName = "Hello" .. " World"
print(fullName)

-- 6. 布尔值
local isStudent = true
local isWorking = false

-- 7. nil表示空值
local emptyValue = nil

-- 8. print输出
print("这是print输出")
print(age, name)
