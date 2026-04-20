# Unity中Lua开发环境配置

## 问题背景

在Unity中使用Lua开发时，通常需要将Lua文件后缀名改为`.lua.txt`，以便Unity能识别为文本文件进行处理。本文档介绍如何使用Visual Studio Code和Visual Studio进行高效的Lua开发。

---

## 一、使用 Visual Studio Code 开发Lua

### 1. 必备插件

| 插件名称 | 作者 | 功能 |
|---------|------|------|
| **Lua** | sumneko | 强大的Lua语言服务器，提供智能提示、语法检查、格式化等 |
| **EmmyLua** | tangzx | 另一个优秀的Lua插件，支持类型推断 |
| **Lua Debug** | actboy168 | Lua调试器 |
| **File Utils** | sleistner | 文件操作工具，方便重命名 |

### 2. 配置文件关联（处理.lua.txt）

VS Code默认不识别`.lua.txt`为Lua文件，需要进行配置：

#### 方法一：通过设置界面配置
1. 打开设置（`Ctrl + ,` 或 `File` → `Preferences` → `Settings`）
2. 搜索 `files.associations`
3. 添加项：
   - Item: `*.lua.txt`
   - Value: `lua`

#### 方法二：通过settings.json配置
1. 打开命令面板（`Ctrl + Shift + P`）
2. 输入 `Preferences: Open User Settings (JSON)`
3. 添加以下配置：
```json
{
    "files.associations": {
        "*.lua.txt": "lua"
    }
}
```

#### 方法三：工作区配置（推荐）
在项目根目录创建 `.vscode/settings.json`：
```json
{
    "files.associations": {
        "*.lua.txt": "lua"
    },
    "Lua.workspace.library": [
        "${workspaceFolder}/**"
    ],
    "Lua.diagnostics.globals": [
        "XLua",
        "CS",
        "UnityEngine",
        "UnityEditor"
    ]
}
```

### 3. 快速重命名脚本

#### 方法一：使用File Utils插件
1. 安装 `File Utils` 插件
2. 右键文件 → `File Utils: Rename`
3. 输入新名称

#### 方法二：使用任务配置
在 `.vscode/tasks.json` 中添加：
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Convert to lua.txt",
            "type": "shell",
            "command": "powershell",
            "args": [
                "-Command",
                "Rename-Item '${file}' ('${file}' -replace '\\.lua$', '.lua.txt')"
            ],
            "problemMatcher": []
        },
        {
            "label": "Convert to lua",
            "type": "shell",
            "command": "powershell",
            "args": [
                "-Command",
                "Rename-Item '${file}' ('${file}' -replace '\\.lua\\.txt$', '.lua')"
            ],
            "problemMatcher": []
        }
    ]
}
```
使用 `Ctrl + Shift + P` → `Tasks: Run Task` 选择任务执行。

### 4. 代码片段配置

创建 `.vscode/lua.json` 代码片段：
```json
{
    "Lua Class": {
        "prefix": "luaclass",
        "body": [
            "local ${1:ClassName} = {}",
            "${1:ClassName}.__index = ${1:ClassName}",
            "",
            "function ${1:ClassName}.new()",
            "    local self = setmetatable({}, ${1:ClassName})",
            "    $0",
            "    return self",
            "end",
            "",
            "return ${1:ClassName}"
        ],
        "description": "Create a Lua class"
    }
}
```

---

## 二、使用 Visual Studio 开发Lua

### 1. 必备扩展

| 扩展名称 | 功能 |
|---------|------|
| **Lua for Visual Studio** | Lua语言支持 |
| **BabeLua** | 强大的Lua开发工具，支持语法高亮、智能提示 |

### 2. 配置文件关联

#### 方法一：通过选项配置
1. `工具` → `选项` → `文本编辑器` → `文件扩展名`
2. 添加：
   - 扩展名: `lua.txt`
   - 编辑器: `Microsoft Visual C++` 或选择Lua编辑器

#### 方法二：使用BabeLua
安装BabeLua扩展后，它会自动处理Lua文件。

### 3. 项目配置

创建 `.vcxproj` 或使用文件夹视图：
```xml
<ItemGroup>
    <Content Include="**/*.lua" />
    <Content Include="**/*.lua.txt" />
</ItemGroup>
```

---

## 三、Unity XLua 开发推荐配置

### 1. VS Code 完整配置示例

`.vscode/settings.json`：
```json
{
    "files.associations": {
        "*.lua.txt": "lua"
    },
    "Lua.runtime.version": "Lua 5.1",
    "Lua.workspace.library": [
        "${workspaceFolder}/Assets/Lua/**"
    ],
    "Lua.diagnostics.globals": [
        "XLua",
        "CS",
        "UnityEngine",
        "UnityEditor",
        "Vector3",
        "Vector2",
        "Quaternion",
        "Color",
        "Time",
        "Input",
        "GameObject",
        "Transform",
        "Debug"
    ],
    "Lua.format.enable": true,
    "Lua.completion.callSnippet": "Both",
    "Lua.completion.keywordSnippet": "Both"
}
```

### 2. Unity中的Lua文件管理

推荐目录结构：
```
Assets/
├── Lua/
│   ├── Common/          # 通用工具
│   ├── Modules/         # 业务模块
│   ├── Config/          # 配置文件
│   └── Main.lua.txt     # 入口文件
└── XLua/                # XLua插件
```

---

## 四、快速切换后缀名的PowerShell脚本

在项目根目录创建 `ToggleLuaExtension.ps1`：
```powershell
# 切换Lua文件后缀名
param(
    [string]$Path = "."
)

Get-ChildItem -Path $Path -Filter "*.lua" -File | ForEach-Object {
    Rename-Item $_.FullName ($_.FullName -replace '\.lua$', '.lua.txt')
    Write-Host "Converted: $($_.Name) -> $($_.Name -replace '\.lua$', '.lua.txt')"
}

Write-Host "Done!"
```

创建 `ToggleTxtExtension.ps1`：
```powershell
param(
    [string]$Path = "."
)

Get-ChildItem -Path $Path -Filter "*.lua.txt" -File | ForEach-Object {
    Rename-Item $_.FullName ($_.FullName -replace '\.lua\.txt$', '.lua')
    Write-Host "Converted: $($_.Name) -> $($_.Name -replace '\.lua\.txt$', '.lua')"
}

Write-Host "Done!"
```

---

## 五、总结推荐

| 编辑器 | 优势 | 推荐度 |
|--------|------|--------|
| **VS Code** | 轻量、插件丰富、配置灵活 | ⭐⭐⭐⭐⭐ |
| **Visual Studio** | 强大的调试能力、与Unity集成好 | ⭐⭐⭐⭐ |

**推荐使用VS Code**，配置简单，插件生态丰富，非常适合Lua开发。
