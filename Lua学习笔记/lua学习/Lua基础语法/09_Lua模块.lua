-- Lua模块（Module）教程
--[[
本文档详细介绍Lua中模块的概念、使用方法和模块化编程。
]]

print("=================== Lua模块 ===================")

-- 1. 什么是模块？
print("\n--- 1. 什么是模块？ ---")
--[[
模块（Module）是一个包含了函数和变量的.lua文件。
通过模块可以组织代码、避免全局变量冲突、提高代码复用性。
模块本质上是定义了一个命名空间。
]]

-- 2. 模块的基本结构
print("\n--- 2. 模块的基本结构 ---")

-- 创建一个最简单的模块 math_utils.lua
--[[
local M = {}

function M.add(a, b)
    return a + b
end

function M.sub(a, b)
    return a - b
end

return M
]]

-- 模拟math_utils模块
print("\n创建math_utils模块:")
local math_utils = {}
function math_utils.add(a, b)
    return a + b
end
function math_utils.sub(a, b)
    return a - b
end
function math_utils.mul(a, b)
    return a * b
end
function math_utils.div(a, b)
    if b == 0 then
        return nil, "除数不能为0"
    end
    return a / b
end

print("3 + 5 =", math_utils.add(3, 5))
print("10 - 3 =", math_utils.sub(10, 3))
print("4 * 6 =", math_utils.mul(4, 6))

local result, err = math_utils.div(10, 0)
if err then
    print("错误:", err)
else
    print("10 / 0 =", result)
end

-- 3. 模块的加载
print("\n--- 3. 模块的加载 ---")

-- 3.1 require函数
--[[
require("模块名") 或 require "模块名"
Lua会自动在package.cpath指定的路径中查找.lua文件
]]

-- 示例：加载math_utils模块
-- local math_utils = require("math_utils")

-- 3.2 require的工作流程
-- 1. 在package.loaded表中检查模块是否已加载
-- 2. 如果已加载，直接返回缓存的结果
-- 3. 如果未加载，查找.lua文件
-- 4. 执行模块文件
-- 5. 将结果存入package.loaded
-- 6. 返回模块

-- 3.3 多次require不会重复执行
print("\n3.3 多次require不会重复执行:")
-- 第一次require后，结果会被缓存
-- 后续require直接返回缓存结果

-- 3.4 强制重新加载模块
print("\n3.4 强制重新加载模块:")
-- package.loaded["模块名"] = nil
-- require("模块名")

-- 4. 模块的返回方式
print("\n--- 4. 模块的返回方式 ---")

-- 4.1 返回表（推荐方式）
print("\n4.1 返回表方式:")
local my_module = {}
function my_module.sayHello()
    print("Hello from module!")
end
function my_module.add(a, b)
    return a + b
end
return my_module

-- 实际使用：
-- local M = require("my_module")
-- M.sayHello()

-- 4.2 设置全局变量（不推荐）
print("\n4.2 设置全局变量方式（不推荐））:")
--[[
-- 在模块中直接设置
my_global_module = {}

function my_global_module.func1()
    print("函数1")
end

-- 问题：污染全局命名空间，可能导致命名冲突
]]

-- 5. 模块的别名
print("\n--- 5. 模块的别名 ---")
local utils = require("math_utils")
local my_utils = utils  -- 给模块起别名
print("使用别名调用:", my_utils.add(10, 20))

-- 6. 模块的组织结构
print("\n--- 6. 模块的组织结构 ---")
--[[
项目结构示例：
Assets/
├── Lua/
│   ├── Main.lua
│   ├── Config/
│   │   ├── GameConfig.lua
│   │   └── UIConfig.lua
│   ├── Utils/
│   │   ├── StringUtils.lua
│   │   ├── TableUtils.lua
│   │   └── MathUtils.lua
│   └── Logic/
│       ├── Player.lua
│       └── Enemy.lua
]]

-- 模拟模块路径
print("\n6.1 模拟Config模块:")
local GameConfig = {
    gameName = "我的游戏",
    version = "1.0.0",
    maxPlayers = 100,
    serverAddress = "127.0.0.1",
    serverPort = 8888
}
print("游戏名称:", GameConfig.gameName)
print("版本:", GameConfig.version)

print("\n6.2 模拟StringUtils模块:")
local StringUtils = {}
function StringUtils.trim(s)
    return s:match("^%s*(.-)%s*$")
end
function StringUtils.split(s, sep)
    local result = {}
    for str in s:gmatch("([^" .. sep .. "]+)") do
        table.insert(result, str)
    end
    return result
end
function StringUtils.startswith(s, prefix)
    return s:sub(1, #prefix) == prefix
end

print("去除空格:", StringUtils.trim("  Hello  "))
print("分割字符串:", StringUtils.split("a,b,c", ","))
print("是否以He开头:", StringUtils.startswith("Hello", "He"))

-- 7. 模块的依赖
print("\n--- 7. 模块的依赖 ---")

-- 7.1 在模块开头声明依赖
print("\n7.1 模块依赖示例:")
--[[
-- 在my_module.lua中
local StringUtils = require("StringUtils")
local MathUtils = require("MathUtils")

local M = {}

function M.processText(text)
    if StringUtils.startswith(text, "ERROR") then
        return MathUtils.random(1000, 9999)
    end
    return text
end

return M
]]

-- 8. 模块的规范
print("\n--- 8. 模块的命名规范 ---")

-- 8.1 命名规范
print("\n8.1 命名规范:")
-- 模块名应使用PascalCase或camelCase
-- 文件名应与模块名一致
-- 公开函数以大写字母开头，私有函数以_开头

local MyModule = {}
function MyModule.PublicFunc()
    print("公开函数")
end
local function _privateFunc()
    print("私有函数")
end
MyModule.publicVar = 100

-- 8.2 模块的文档
print("\n8.2 模块文档示例:")
--[[
--- StringUtils模块
-- 字符串处理工具集
-- @author 作者名
-- @version 1.0.0

local StringUtils = {}
]]

-- 9. 高级模块特性
print("\n--- 9. 高级模块特性 ---")

-- 9.1 模块的混合导出
print("\n9.1 混合导出:")
local hybrid_module = {}

-- 方式1：直接返回表
function hybrid_module.func1()
    print("函数1")
end

-- 方式2：作为全局导出
function hybrid_module.export(global_name)
    _G[global_name] = hybrid_module
end

hybrid_module.func1()
-- hybrid_module.export("HM")  -- 导出到全局

-- 9.2 模块的延迟加载
print("\n9.2 模块的延迟加载:")
local lazy_module = {}
local _loaded = false

local function _load()
    if not _loaded then
        print("执行实际的模块加载...")
        _loaded = true
    end
end

function lazy_module.getData()
    _load()
    return "数据"
end

lazy_module.getData()  -- 第一次调用才加载
lazy_module.getData()  -- 第二次不再加载

-- 9.3 模块的缓存控制
print("\n9.3 模块缓存控制:")
--[[
-- 清除模块缓存
package.loaded["模块名"] = nil

-- 检查模块是否已加载
if package.loaded["模块名"] then
    print("模块已加载")
end

-- 预加载模块（不执行）
package.preload["模块名"] = function()
    -- 自定义加载逻辑
    return module_table
end
]]

-- 10. 模块的实际应用
print("\n--- 10. 模块的实际应用 ---")

-- 10.1 配置模块
print("\n10.1 配置模块:")
local Config = {
    database = {
        host = "localhost",
        port = 3306,
        username = "root",
        password = "123456",
        database = "game"
    },
    logging = {
        level = "INFO",
        file = "game.log",
        maxSize = 10 * 1024 * 1024  -- 10MB
    },
    game = {
        maxLevel = 100,
        startingGold = 1000,
        pvpEnabled = true
    }
}

print("数据库配置:", Config.database.host, Config.database.port)
print("日志级别:", Config.logging.level)
print("最大等级:", Config.game.maxLevel)

-- 10.2 工具模块
print("\n10.2 工具模块:")
local Logger = {}
local LogLevel = {DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4}
local currentLevel = LogLevel.INFO

function Logger.log(level, message)
    if level >= currentLevel then
        print("[" .. level .. "]", message)
    end
end

function Logger.debug(message) Logger.log("DEBUG", message) end
function Logger.info(message) Logger.log("INFO", message) end
function Logger.warn(message) Logger.log("WARN", message) end
function Logger.error(message) Logger.log("ERROR", message) end

Logger.debug("调试信息")
Logger.info("普通信息")
Logger.warn("警告信息")
Logger.error("错误信息")

-- 10.3 数据模块
print("\n10.3 数据模块:")
local PlayerData = {
    name = "玩家1",
    level = 1,
    exp = 0,
    gold = 1000,
    inventory = {
        {id = 1, name = "血瓶", count = 10},
        {id = 2, name = "蓝瓶", count = 5}
    }
}

function PlayerData:addExp(amount)
    self.exp = self.exp + amount
    while self.exp >= self:getExpForNextLevel() do
        self.exp = self.exp - self:getExpForNextLevel()
        self.level = self.level + 1
        print("升级！当前等级:", self.level)
    end
end

function PlayerData:getExpForNextLevel()
    return self.level * 100
end

PlayerData:addExp(50)
PlayerData:addExp(100)
print("当前经验:", PlayerData.exp, "下一级需要:", PlayerData:getExpForNextLevel())

-- 11. 模块的注意事项
print("\n--- 11. 模块的注意事项 ---")

-- 11.1 避免循环依赖
print("\n11.1 避免循环依赖:")
-- 模块A依赖模块B，模块B又依赖模块A
-- 可能导致其中一个模块的某些函数为nil

-- 11.2 避免模块间的紧耦合
print("\n11.2 避免紧耦合:")
-- 模块间应该通过接口交互，而不是直接访问内部实现

-- 11.3 合理划分模块
print("\n11.3 合理划分模块:")
-- 每个模块应该有明确单一职责
-- 不要创建过于庞大的模块

-- 12. package.path和package.cpath
print("\n--- 12. 模块搜索路径 ---")

print("\n12.1 Lua文件的搜索路径:")
-- package.path用于查找.lua文件
-- print(package.path)

print("\n12.2 C库的搜索路径:")
-- package.cpath用于查找C动态库
-- print(package.cpath)

print("\n12.3 添加自定义搜索路径:")
-- table.insert(package.path, "/自定义路径/?.lua")

-- 13. 使用_ENV控制模块作用域
print("\n--- 13. 使用_ENV控制作用域 ---")

local my_env = {}
setfenv(1, my_env)

-- 在这个环境中定义的函数和变量是局部的
function new_func()
    print("这是一个局部函数")
end

-- 访问全局需要特殊处理
-- _G表示全局环境

setfenv(1, _G)  -- 恢复全局环境

print("\n=================== 模块教程完成 ===================")
