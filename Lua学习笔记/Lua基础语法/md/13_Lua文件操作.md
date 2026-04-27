# Lua文件操作

## 目录
- [文件操作的基本模式](#文件操作的基本模式)
- [打开和关闭文件](#打开和关闭文件)
- [文件读取操作](#文件读取操作)
- [文件位置操作](#文件位置操作)
- [错误处理](#错误处理)
- [路径处理](#路径处理)
- [临时文件](#临时文件)
- [标准输入输出](#标准输入输出)
- [文件操作的最佳实践](#文件操作的最佳实践)
- [实际应用示例](#实际应用示例)
- [文件操作的注意事项](#文件操作的注意事项)

## 什么是文件操作？

文件操作是指对文件进行读写、创建、删除等操作的过程。Lua通过io库提供了丰富的文件操作功能。

## 文件操作的基本模式

文件操作有以下几种模式：
- `"r"`: 只读模式（默认）
- `"w"`: 只写模式，会覆盖已存在的文件
- `"a"`: 追加模式，在文件末尾添加内容
- `"r+"`: 读写模式
- `"w+"`: 读写模式，会覆盖已存在的文件
- `"a+"`: 读写模式，在文件末尾添加内容

## 打开和关闭文件

### 打开文件

```lua
local file, err = io.open("test.txt", "w")  -- 以只写模式打开文件
if file then
    print("文件打开成功")
    file:close()
    print("文件关闭成功")
else
    print("文件打开失败:", err)
end
```

## 文件读取操作

### 写入测试文件

```lua
local file = io.open("test.txt", "w")
if file then
    file:write("Hello, Lua!\n")
    file:write("这是文件操作测试\n")
    file:write("第三行内容\n")
    file:close()
end
```

### 读取整个文件

```lua
local file = io.open("test.txt", "r")
if file then
    local content = file:read("*a")  -- *a 表示读取整个文件
    print("文件内容:")
    print(content)
    file:close()
end
```

### 按行读取

```lua
local file = io.open("test.txt", "r")
if file then
    print("按行读取:")
    for line in file:lines() do
        print("  ", line)
    end
    file:close()
end
```

### 按指定格式读取

```lua
-- 读取数据
local file = io.open("data.txt", "r")
if file then
    local num1, num2, num3 = file:read("*n", "*n", "*n")  -- *n 表示读取数字
    print("读取的数字:", num1, num2, num3)
    local line = file:read("*l")  -- *l 表示读取一行
    print("读取的行:", line)
    file:close()
end
```

## 文件位置操作

```lua
local file = io.open("test.txt", "r")
if file then
    print("当前文件位置:", file:seek())

    -- 读取前5个字符
    local content = file:read(5)
    print("读取的内容:", content)
    print("当前文件位置:", file:seek())

    -- 移动到文件开头
    file:seek("set", 0)

    -- 移动到文件末尾
    local pos = file:seek("end")
    print("文件大小:", pos, "字节")

    file:close()
end
```

## 错误处理

```lua
local file, err = io.open("non_existent_file.txt", "r")
if file then
    file:close()
else
    print("打开不存在的文件错误:", err)
end
```

## 路径处理

在Windows系统中，路径可以使用双反斜杠或正斜杠：

```lua
local windows_path = "data\\test.txt"
local unix_path = "data/test.txt"
```

## 临时文件

```lua
local temp_file = io.tmpfile()
temp_file:write("临时文件内容\n")
temp_file:seek("set", 0)
print("临时文件内容:", temp_file:read("*a"))
temp_file:close()
```

## 标准输入输出

### 标准输出

```lua
print("使用print输出")
io.write("使用io.write输出\n")
```

## 文件操作的最佳实践

### 使用局部变量

```lua
local function readFile(filename)
    local file, err = io.open(filename, "r")
    if not file then
        return nil, err
    end

    local content, read_err = file:read("*a")
    file:close()

    if not content then
        return nil, read_err
    end

    return content
end
```

### 异常处理

```lua
local function safeReadFile(filename)
    local status, result = pcall(function()
        local file = io.open(filename, "r")
        local content = file:read("*a")
        file:close()
        return content
    end)

    if status then
        return result
    else
        return nil, result
    end
end
```

## 实际应用示例

### 读取配置文件

```lua
-- 读取配置文件
local config = dofile("config.lua")
print("配置信息:")
print("  用户名:", config.username)
print("  端口:", config.port)
print("  调试模式:", config.debug)
```

### 日志文件

```lua
local function log(message, level)
    level = level or "INFO"
    local file = io.open("app.log", "a")
    if file then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        file:write(string.format("[%s] [%s] %s\n", timestamp, level, message))
        file:close()
    end
end

log("应用启动")
log("发生错误", "ERROR")
log("调试信息", "DEBUG")
```

## 文件操作的注意事项

### 权限问题

- 确保有足够的权限读写文件
- 注意文件路径的访问权限

### 路径问题

- 在Windows中使用双反斜杠或正斜杠
- 相对路径和绝对路径的区别

### 资源管理

- 总是确保文件被关闭
- 使用try-finally模式确保资源释放

### 性能考虑

- 对于大文件，使用逐行读取而不是一次性读取
- 避免频繁的文件打开和关闭操作
