# Lua模块（Module）

## 目录
- [什么是模块？](#什么是模块)
- [模块的基本结构](#模块的基本结构)
- [模块的加载](#模块的加载)
- [模块的返回方式](#模块的返回方式)
- [模块的别名](#模块的别名)
- [模块的组织结构](#模块的组织结构)
- [模块的依赖](#模块的依赖)
- [模块的规范](#模块的规范)
- [高级模块特性](#高级模块特性)
- [模块的实际应用](#模块的实际应用)
- [模块的注意事项](#模块的注意事项)
- [package.path和package.cpath](#packagepath和packagecpath)

## 什么是模块？

模块（Module）是一个包含了函数和变量的.lua文件。通过模块可以组织代码、避免全局变量冲突、提高代码复用性。模块本质上是定义了一个命名空间。

## 模块的基本结构

```lua
-- 创建一个最简单的模块 math_utils.lua
local M = {}

function M.add(a, b)
    return a + b
end

function M.sub(a, b)
    return a - b
end

return M
```

## 模块的加载

### require函数

```lua
require("模块名") 或 require "模块名"
```

require的工作流程：
1. 在package.loaded表中检查模块是否已加载
2. 如果已加载，直接返回缓存的结果
3. 如果未加载，查找.lua文件
4. 执行模块文件
5. 将结果存入package.loaded
6. 返回模块

### 多次require不会重复执行

第一次require后，结果会被缓存，后续require直接返回缓存结果。

### 强制重新加载模块

```lua
package.loaded["模块名"] = nil
require("模块名")
```

## 模块的返回方式

### 返回表（推荐方式）

```lua
local my_module = {}
function my_module.sayHello()
    print("Hello from module!")
end
function my_module.add(a, b)
    return a + b
end
return my_module
```

### 设置全局变量（不推荐）

```lua
-- 在模块中直接设置
my_global_module = {}

function my_global_module.func1()
    print("函数1")
end
-- 问题：污染全局命名空间，可能导致命名冲突
```

## 模块的别名

```lua
local utils = require("math_utils")
local my_utils = utils  -- 给模块起别名
```

## 模块的组织结构

```
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
```

### 配置模块示例

```lua
local GameConfig = {
    gameName = "我的游戏",
    version = "1.0.0",
    maxPlayers = 100,
    serverAddress = "127.0.0.1",
    serverPort = 8888
}
```

### 工具模块示例

```lua
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
```

## 模块的依赖

在模块开头声明依赖：
```lua
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
```

## 模块的规范

### 命名规范

- 模块名应使用PascalCase或camelCase
- 文件名应与模块名一致
- 公开函数以大写字母开头，私有函数以_开头

```lua
local MyModule = {}
function MyModule.PublicFunc()
    print("公开函数")
end
local function _privateFunc()
    print("私有函数")
end
MyModule.publicVar = 100
```

## 高级模块特性

### 模块的混合导出

```lua
local hybrid_module = {}

function hybrid_module.func1()
    print("函数1")
end

function hybrid_module.export(global_name)
    _G[global_name] = hybrid_module
end
```

### 模块的延迟加载

```lua
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
```

### 模块的缓存控制

```lua
-- 清除模块缓存
package.loaded["模块名"] = nil

-- 检查模块是否已加载
if package.loaded["模块名"] then
    print("模块已加载")
end
```

## 模块的实际应用

### 配置模块

```lua
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
        file = "game.log"
    },
    game = {
        maxLevel = 100,
        startingGold = 1000,
        pvpEnabled = true
    }
}
```

### 工具模块

```lua
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
```

### 数据模块

```lua
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
```

## 模块的注意事项

### 避免循环依赖

模块A依赖模块B，模块B又依赖模块A，可能导致其中一个模块的某些函数为nil。

### 避免模块间的紧耦合

模块间应该通过接口交互，而不是直接访问内部实现。

### 合理划分模块

每个模块应该有明确单一职责，不要创建过于庞大的模块。

## package.path和package.cpath

### Lua文件的搜索路径

package.path用于查找.lua文件。

### C库的搜索路径

package.cpath用于查找C动态库。

### 添加自定义搜索路径

```lua
table.insert(package.path, "/自定义路径/?.lua")
```

## 使用_ENV控制模块作用域

```lua
local my_env = {}
setfenv(1, my_env)

function new_func()
    print("这是一个局部函数")
end

setfenv(1, _G)  -- 恢复全局环境
```
