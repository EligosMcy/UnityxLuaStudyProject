-- Lua字符串（String）方法教程
--[[
本文档详细介绍Lua中字符串的常用操作方法。
]]

print("=================== Lua字符串方法 ===================")

-- 1. 字符串的创建
print("\n--- 1. 字符串的创建 ---")
local str1 = "双引号字符串"
local str2 = '单引号字符串'
local str3 = [[多行字符串
可以包含换行
和特殊字符]]

print("双引号字符串:", str1)
print("单引号字符串:", str2)
print("多行字符串:", str3)

-- 2. 字符串长度
print("\n--- 2. 字符串长度 ---")
local s = "Hello Lua"
print("字符串:", s)
print("长度:", #s)  -- 使用#操作符

-- 3. 字符串连接
print("\n--- 3. 字符串连接 ---")
local first = "Hello"
local last = "World"
local result = first .. " " .. last  -- 使用..操作符
print("连接结果:", result)

-- 4. string库方法
print("\n--- 4. string库方法 ---")

-- 4.1 string.len() - 获取字符串长度
print("\n4.1 string.len():")
print("长度:", string.len("Lua Programming"))

-- 4.2 string.upper() - 转换为大写
print("\n4.2 string.upper():")
print("大写:", string.upper("hello lua"))

-- 4.3 string.lower() - 转换为小写
print("\n4.3 string.lower():")
print("小写:", string.lower("HELLO LUA"))

-- 4.4 string.sub() - 截取子字符串
-- string.sub(s, i, j) 从i到j（包含）
print("\n4.4 string.sub():")
local text = "Lua is awesome"
print("原始字符串:", text)
print("从第5个字符开始:", string.sub(text, 5))
print("从第1到第3个字符:", string.sub(text, 1, 3))
print("从第-5个字符开始（倒数）:", string.sub(text, -5))

-- 4.5 string.find() - 查找子字符串
-- 返回开始和结束位置，没有找到返回nil
print("\n4.5 string.find():")
local s = "Hello Lua World"
local start, stop = string.find(s, "Lua")
print("查找 'Lua':")
print("开始位置:", start, "结束位置:", stop)

-- 4.6 string.gsub() - 替换子字符串
-- string.gsub(s, pattern, replacement, n)
print("\n4.6 string.gsub():")
local s = "Lua Lua Lua"
local result, count = string.gsub(s, "Lua", "Python")
print("替换结果:", result)
print("替换次数:", count)

-- 限制替换次数
local result2, count2 = string.gsub(s, "Lua", "Python", 2)
print("限制替换2次:", result2)
print("替换次数:", count2)

-- 4.7 string.gmatch() - 匹配模式并返回迭代器
print("\n4.7 string.gmatch():")
local s = "name:John,age:25,city:Beijing"
print("原始字符串:", s)
print("提取键值对:")
for key, value in string.gmatch(s, "(%w+):(%w+)") do
    print("  ", key, "=", value)
end

-- 4.8 string.match() - 匹配模式并返回结果
print("\n4.8 string.match():")
local s = "My phone number is 123-456-7890"
local number = string.match(s, "(%d+-%d+-%d+)")
print("匹配电话号码:", number)

-- 4.9 string.reverse() - 反转字符串
print("\n4.9 string.reverse():")
print("反转 'Lua':", string.reverse("Lua"))

-- 4.10 string.format() - 格式化字符串
print("\n4.10 string.format():")
local name = "张三"
local age = 25
local message = string.format("我的名字是%s，年龄是%d岁", name, age)
print("格式化结果:", message)

-- 常用格式说明符:
-- %s - 字符串
-- %d - 整数
-- %f - 浮点数
-- %c - 字符
-- %x - 十六进制

-- 4.11 string.rep() - 重复字符串
print("\n4.11 string.rep():")
print("重复 'Lua' 3次:", string.rep("Lua", 3))
print("重复 'Lua ' 3次:", string.rep("Lua ", 3))

-- 4.12 string.byte() - 获取字符的ASCII码
print("\n4.12 string.byte():")
local s = "Lua"
print("'L'的ASCII码:", string.byte(s, 1))
print("'u'的ASCII码:", string.byte(s, 2))
print("'a'的ASCII码:", string.byte(s, 3))

-- 4.13 string.char() - 根据ASCII码创建字符
print("\n4.13 string.char():")
print("ASCII 76,117,97:", string.char(76, 117, 97))  -- Lua

-- 5. 字符串模式匹配
print("\n--- 5. 字符串模式匹配 ---")

-- 5.1 模式字符
-- . 任意字符
-- %a 字母
-- %d 数字
-- %w 字母+数字
-- %s 空白字符
-- %c 控制字符
-- %p 标点符号
-- %l 小写字母
-- %u 大写字母

-- 5.2 模式修饰符
-- * 匹配0次或多次
-- + 匹配1次或多次
-- - 匹配0次或多次（非贪婪）
-- ? 匹配0次或1次

-- 5.3 捕获
-- () 用于捕获匹配的内容

print("\n5.3 模式匹配示例:")
local text = "Contact: john@example.com, Phone: 123-456-7890"

-- 提取邮箱
local email = string.match(text, "(%w+@%w+%.%w+)")
print("提取邮箱:", email)

-- 提取所有数字
print("提取所有数字:")
for num in string.gmatch(text, "(%d+)") do
    print("  ", num)
end

-- 6. 字符串操作的性能
print("\n--- 6. 字符串操作的性能 ---")

-- 6.1 字符串连接的性能
print("\n6.1 字符串连接性能:")

-- 方法1: 使用..操作符
local start = os.clock()
local s = ""
for i = 1, 1000 do
    s = s .. "a"
end
print("使用..连接1000次:", os.clock() - start, "秒")

-- 方法2: 使用table.concat
start = os.clock()
local t = {}
for i = 1, 1000 do
    t[i] = "a"
end
local s2 = table.concat(t)
print("使用table.concat:", os.clock() - start, "秒")

-- 7. 字符串的特殊字符
print("\n--- 7. 字符串的特殊字符 ---")

-- 转义字符
local s = "Line1\nLine2\tTabbed"
print("转义字符示例:", s)

-- 常用转义字符:
-- \n 换行
-- \t 制表符
-- \\ 反斜杠
-- \" 双引号
-- \' 单引号

-- 8. 字符串的比较
print("\n--- 8. 字符串的比较 ---")
local a = "apple"
local b = "banana"

print("a < b:", a < b)  -- 字典序比较
print("a == b:", a == b)
print("a > b:", a > b)

-- 9. 实际应用场景
print("\n--- 9. 实际应用场景 ---")

-- 9.1 分割字符串
function split(str, sep)
    local result = {}
    for word in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(result, word)
    end
    return result
end

local csv = "John,25,Engineer,New York"
local parts = split(csv, ",")
print("分割CSV:")
for i, part in ipairs(parts) do
    print("  ", i, part)
end

-- 9.2 去除首尾空白
function trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

local s = "   Hello Lua   "
print("原始字符串:", s)
print("去除空白后:", trim(s))

-- 9.3 检查字符串是否以某个前缀开头
function startsWith(str, prefix)
    return string.sub(str, 1, #prefix) == prefix
end

print("\n检查前缀:")
print("'Hello' 以 'He' 开头:", startsWith("Hello", "He"))
print("'World' 以 'He' 开头:", startsWith("World", "He"))

-- 9.4 检查字符串是否以某个后缀结尾
function endsWith(str, suffix)
    return string.sub(str, -#suffix) == suffix
end

print("\n检查后缀:")
print("'test.lua' 以 '.lua' 结尾:", endsWith("test.lua", ".lua"))
print("'test.txt' 以 '.lua' 结尾:", endsWith("test.txt", ".lua"))

-- 10. 字符串的内存管理
print("\n--- 10. 字符串的内存管理 ---")

-- Lua中的字符串是不可变的
-- 每次字符串操作都会创建新的字符串
local s1 = "Hello"
local s2 = s1 .. " World"  -- 创建新字符串
print("s1和s2是否相同:", s1 == s2)

-- 字符串池：相同内容的字符串会共享内存
local s3 = "Lua"
local s4 = "Lua"
print("s3和s4是否引用同一对象:", rawequal(s3, s4))

print("\n=================== 字符串方法教程完成 ===================")
