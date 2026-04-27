# Lua基础语法

## 目录
- [注释](#注释)
- [变量](#变量)
- [数据类型](#数据类型)
- [字符串](#字符串)
- [布尔值](#布尔值)
- [nil](#nil)
- [print输出](#print输出)

## 注释

### 单行注释
```lua
-- 单行注释
```

### 多行注释
```lua
--[[
    多行注释
]]
```

## 变量

Lua中变量默认是全局的，除非使用local声明。
```lua
local age = 25
name = "张三"  -- 全局变量
```

### 标识符规则

Lua的标识符（变量名、函数名等）必须遵循以下规则：
1. 只能由字母、数字、下划线组成
2. 不能以数字开头
3. 区分大小写
4. 不能使用Lua关键字作为标识符

### 合法的标识符
```lua
local userName = "李四"
local user_age = 30
local _privateVar = "私有变量"
```

### Lua关键字（共21个）
```
and       break     do        else      elseif
end       false     for       function  if
in        local     nil       not       or
repeat    return    then      true      until
while
```

## 数据类型

```lua
print(type("Hello"))      -- string
print(type(123))         -- number
print(type(true))        -- boolean
print(type(nil))         -- nil
print(type(print))       -- function
print(type({}))           -- table
```

## 字符串

```lua
local str1 = "双引号字符串"
local str2 = '单引号字符串'
local str3 = [[多行字符串]]
```

## 字符串拼接

```lua
local fullName = "Hello" .. " World"
print(fullName)
```

## 布尔值

```lua
local isStudent = true
local isWorking = false
```

## nil

nil表示空值：
```lua
local emptyValue = nil
```

## print输出

```lua
print("这是print输出")
print(age, name)
```
