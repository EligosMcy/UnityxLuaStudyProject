-- Lua文件操作教程
--[[
本文档详细介绍Lua中文件操作的基本方法，特别是文件读取操作。
文件操作是Lua中处理外部数据的重要功能。
]]

print("=================== Lua文件操作 ===================")

-- 1. 什么是文件操作？
print("\n--- 1. 什么是文件操作？ ---")
--[[
文件操作是指对文件进行读写、创建、删除等操作的过程。
Lua通过io库提供了丰富的文件操作功能。
]]

-- 2. 文件操作的基本模式
print("\n--- 2. 文件操作的基本模式 ---")
--[[
文件操作有以下几种模式：
- "r": 只读模式（默认）
- "w": 只写模式，会覆盖已存在的文件
- "a": 追加模式，在文件末尾添加内容
- "r+": 读写模式
- "w+": 读写模式，会覆盖已存在的文件
- "a+": 读写模式，在文件末尾添加内容
]]

-- 3. 打开和关闭文件
print("\n--- 3. 打开和关闭文件 ---")

-- 3.1 打开文件 - io.open()
print("\n3.1 打开文件:")
local file, err = io.open("test.txt", "w")  -- 以只写模式打开文件
if file then
    print("文件打开成功")
    -- 3.2 关闭文件 - file:close()
    file:close()
    print("文件关闭成功")
else
    print("文件打开失败:", err)
end

-- 4. 文件读取操作
print("\n--- 4. 文件读取操作 ---")

-- 4.1 写入测试文件
print("\n4.1 写入测试文件:")
local file = io.open("test.txt", "w")
if file then
    file:write("Hello, Lua!\n")
    file:write("这是文件操作测试\n")
    file:write("第三行内容\n")
    file:close()
    print("测试文件写入完成")
end

-- 4.2 读取整个文件
print("\n4.2 读取整个文件:")
local file = io.open("test.txt", "r")
if file then
    local content = file:read("*a")  -- *a 表示读取整个文件
    print("文件内容:")
    print(content)
    file:close()
end

-- 4.3 按行读取
print("\n4.3 按行读取:")
local file = io.open("test.txt", "r")
if file then
    print("按行读取:")
    for line in file:lines() do
        print("  ", line)
    end
    file:close()
end

-- 4.4 按指定格式读取
print("\n4.4 按指定格式读取:")
-- 重新写入测试数据
local file = io.open("data.txt", "w")
if file then
    file:write("123 456 789\n")
    file:write("hello world\n")
    file:close()
end

-- 读取数据
local file = io.open("data.txt", "r")
if file then
    local num1, num2, num3 = file:read("*n", "*n", "*n")  -- *n 表示读取数字
    print("读取的数字:", num1, num2, num3)
    local line = file:read("*l")  -- *l 表示读取一行
    print("读取的行:", line)
    file:close()
end

-- 5. 文件位置操作
print("\n--- 5. 文件位置操作 ---")

local file = io.open("test.txt", "r")
if file then
    print("当前文件位置:", file:seek())
    
    -- 读取前5个字符
    local content = file:read(5)
    print("读取的内容:", content)
    print("当前文件位置:", file:seek())
    
    -- 移动到文件开头
    file:seek("set", 0)
    print("移动到开头后位置:", file:seek())
    
    -- 移动到文件末尾
    local pos = file:seek("end")
    print("文件大小:", pos, "字节")
    
    file:close()
end

-- 6. 错误处理
print("\n--- 6. 错误处理 ---")

local file, err = io.open("non_existent_file.txt", "r")
if file then
    file:close()
else
    print("打开不存在的文件错误:", err)
end

-- 7. 路径处理
print("\n--- 7. 路径处理 ---")

-- 在Windows系统中，路径可以使用双反斜杠或正斜杠
local windows_path = "data\\test.txt"
local unix_path = "data/test.txt"

print("Windows路径:", windows_path)
print("Unix路径:", unix_path)

-- 8. 临时文件
print("\n--- 8. 临时文件 ---")

local temp_file = io.tmpfile()
temp_file:write("临时文件内容\n")
temp_file:seek("set", 0)  -- 移动到文件开头
print("临时文件内容:", temp_file:read("*a"))
temp_file:close()  -- 临时文件会被自动删除

-- 9. 标准输入输出
print("\n--- 9. 标准输入输出 ---")

-- 标准输出
print("使用print输出")
io.write("使用io.write输出\n")

-- 标准输入（注意：在某些环境中可能无法正常工作）
print("\n输入测试:")
print("请输入一些文本（按Enter结束）:")
-- local input = io.read()
-- if input then
--     print("你输入的是:", input)
-- end

-- 10. 文件操作的最佳实践
print("\n--- 10. 文件操作的最佳实践 ---")

-- 10.1 使用局部变量
print("\n10.1 使用局部变量:")
local function readFile(filename)
    local file, err = io.open(filename, "r")
    if not file then
        return nil, err
    end
    
    local content, read_err = file:read("*a")
    file:close()  -- 确保文件被关闭
    
    if not content then
        return nil, read_err
    end
    
    return content
end

local content, err = readFile("test.txt")
if content then
    print("文件读取成功")
else
    print("文件读取失败:", err)
end

-- 10.2 异常处理
print("\n10.2 异常处理:")
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

local content, err = safeReadFile("test.txt")
if content then
    print("安全读取成功")
else
    print("安全读取失败:", err)
end

-- 11. 实际应用示例
print("\n--- 11. 实际应用示例 ---")

-- 11.1 读取配置文件
print("\n11.1 读取配置文件:")
-- 创建配置文件
local config_file = io.open("config.lua", "w")
if config_file then
    config_file:write([[
-- 配置文件
return {
    username = "admin",
    password = "123456",
    port = 8080,
    debug = true
}
]])
    config_file:close()
end

-- 读取配置文件
local config = dofile("config.lua")
print("配置信息:")
print("  用户名:", config.username)
print("  端口:", config.port)
print("  调试模式:", config.debug)

-- 11.2 日志文件
print("\n11.2 日志文件:")
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

print("日志文件内容:")
local log_file = io.open("app.log", "r")
if log_file then
    for line in log_file:lines() do
        print("  ", line)
    end
    log_file:close()
end

-- 12. 文件操作的注意事项
print("\n--- 12. 文件操作的注意事项 ---")

-- 12.1 权限问题
print("\n12.1 权限问题:")
print("- 确保有足够的权限读写文件")
print("- 注意文件路径的访问权限")

-- 12.2 路径问题
print("\n12.2 路径问题:")
print("- 在Windows中使用双反斜杠或正斜杠")
print("- 相对路径和绝对路径的区别")

-- 12.3 资源管理
print("\n12.3 资源管理:")
print("- 总是确保文件被关闭")
print("- 使用try-finally模式确保资源释放")

-- 12.4 性能考虑
print("\n12.4 性能考虑:")
print("- 对于大文件，使用逐行读取而不是一次性读取")
print("- 避免频繁的文件打开和关闭操作")

print("\n=================== 文件操作教程完成 ===================")

-- 清理测试文件
local function cleanTestFiles()
    local files = {"test.txt", "data.txt", "config.lua", "app.log"}
    for _, file in ipairs(files) do
        os.remove(file)
    end
end

-- 取消注释以下行以清理测试文件
-- cleanTestFiles()
-- print("测试文件已清理")
