# Lua字符串（String）方法

## 目录
- [字符串的创建](#字符串的创建)
- [字符串长度](#字符串长度)
- [字符串连接](#字符串连接)
- [string库方法](#string库方法)
- [字符串模式匹配](#字符串模式匹配)
- [字符串操作的性能](#字符串操作的性能)
- [字符串的特殊字符](#字符串的特殊字符)
- [字符串的比较](#字符串的比较)
- [实际应用场景](#实际应用场景)
- [字符串的内存管理](#字符串的内存管理)

## 字符串的创建

```lua
local str1 = "双引号字符串"
local str2 = '单引号字符串'
local str3 = [[多行字符串
可以包含换行
和特殊字符]]
```

## 字符串长度

```lua
local s = "Hello Lua"
print("字符串:", s)
print("长度:", #s)  -- 使用#操作符
```

## 字符串连接

```lua
local first = "Hello"
local last = "World"
local result = first .. " " .. last  -- 使用..操作符
print("连接结果:", result)
```

## string库方法

### string.len()

获取字符串长度：
```lua
print("长度:", string.len("Lua Programming"))
```

### string.upper()

转换为大写：
```lua
print("大写:", string.upper("hello lua"))
```

### string.lower()

转换为小写：
```lua
print("小写:", string.lower("HELLO LUA"))
```

### string.sub()

截取子字符串：
```lua
local text = "Lua is awesome"
print("从第5个字符开始:", string.sub(text, 5))
print("从第1到第3个字符:", string.sub(text, 1, 3))
print("从第-5个字符开始（倒数）:", string.sub(text, -5))
```

### string.find()

查找子字符串，返回开始和结束位置：
```lua
local s = "Hello Lua World"
local start, stop = string.find(s, "Lua")
print("开始位置:", start, "结束位置:", stop)
```

### string.gsub()

替换子字符串：
```lua
local s = "Lua Lua Lua"
local result, count = string.gsub(s, "Lua", "Python")
print("替换结果:", result)
print("替换次数:", count)

-- 限制替换次数
local result2, count2 = string.gsub(s, "Lua", "Python", 2)
```

### string.gmatch()

匹配模式并返回迭代器：
```lua
local s = "name:John,age:25,city:Beijing"
for key, value in string.gmatch(s, "(%w+):(%w+)") do
    print(key, "=", value)
end
```

### string.match()

匹配模式并返回结果：
```lua
local s = "My phone number is 123-456-7890"
local number = string.match(s, "(%d+-%d+-%d+)")
print("匹配电话号码:", number)
```

### string.reverse()

反转字符串：
```lua
print("反转 'Lua':", string.reverse("Lua"))
```

### string.format()

格式化字符串：
```lua
local name = "张三"
local age = 25
local message = string.format("我的名字是%s，年龄是%d岁", name, age)
print("格式化结果:", message)
```

常用格式说明符:
- %s - 字符串
- %d - 整数
- %f - 浮点数
- %c - 字符
- %x - 十六进制

### string.rep()

重复字符串：
```lua
print("重复 'Lua' 3次:", string.rep("Lua", 3))
```

### string.byte()

获取字符的ASCII码：
```lua
local s = "Lua"
print("'L'的ASCII码:", string.byte(s, 1))
print("'u'的ASCII码:", string.byte(s, 2))
```

### string.char()

根据ASCII码创建字符：
```lua
print("ASCII 76,117,97:", string.char(76, 117, 97))  -- Lua
```

## 字符串模式匹配

### 模式字符

- `.` - 任意字符
- `%a` - 字母
- `%d` - 数字
- `%w` - 字母+数字
- `%s` - 空白字符
- `%c` - 控制字符
- `%p` - 标点符号
- `%l` - 小写字母
- `%u` - 大写字母

### 模式修饰符

- `*` - 匹配0次或多次
- `+` - 匹配1次或多次
- `-` - 匹配0次或多次（非贪婪）
- `?` - 匹配0次或1次

### 捕获

`()` 用于捕获匹配的内容

```lua
local text = "Contact: john@example.com, Phone: 123-456-7890"

-- 提取邮箱
local email = string.match(text, "(%w+@%w+%.%w+)")
print("提取邮箱:", email)

-- 提取所有数字
for num in string.gmatch(text, "(%d+)") do
    print(num)
end
```

## 字符串操作的性能

### 字符串连接的性能

方法1: 使用..操作符
```lua
local s = ""
for i = 1, 1000 do
    s = s .. "a"
end
```

方法2: 使用table.concat
```lua
local t = {}
for i = 1, 1000 do
    t[i] = "a"
end
local s2 = table.concat(t)
```

## 字符串的特殊字符

转义字符：
```lua
local s = "Line1\nLine2\tTabbed"
```

常用转义字符:
- `\n` - 换行
- `\t` - 制表符
- `\\` - 反斜杠
- `\"` - 双引号
- `\'` - 单引号

## 字符串的比较

```lua
local a = "apple"
local b = "banana"

print("a < b:", a < b)  -- 字典序比较
print("a == b:", a == b)
print("a > b:", a > b)
```

## 实际应用场景

### 分割字符串
```lua
function split(str, sep)
    local result = {}
    for word in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(result, word)
    end
    return result
end
```

### 去除首尾空白
```lua
function trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end
```

### 检查字符串是否以某个前缀开头
```lua
function startsWith(str, prefix)
    return string.sub(str, 1, #prefix) == prefix
end
```

### 检查字符串是否以某个后缀结尾
```lua
function endsWith(str, suffix)
    return string.sub(str, -#suffix) == suffix
end
```

## 字符串的内存管理

Lua中的字符串是不可变的，每次字符串操作都会创建新的字符串。

```lua
local s1 = "Hello"
local s2 = s1 .. " World"  -- 创建新字符串
print("s1和s2是否相同:", s1 == s2)
```

字符串池：相同内容的字符串会共享内存：
```lua
local s3 = "Lua"
local s4 = "Lua"
print("s3和s4是否引用同一对象:", rawequal(s3, s4))
```
