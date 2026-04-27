# Lua在Unity中的热更新实现

热更新（Hot Update）是指在不重新编译和发布应用的情况下，更新游戏逻辑和资源的技术手段。

---

## 为什么要热更新

1. 修复线上bug，无需重新发布应用
2. 快速更新游戏内容（活动、节日内容等）
3. 减少用户更新App的频率
4. A/B测试和灰度发布

---

## Unity热更新方案

### 方案1: Lua脚本热更新

**原理：** Lua是纯文本文件，可以在运行时从服务器下载新的.lua文件，然后用Lua解释器执行。Unity项目中的C#代码需要编译后才能运行，但Lua脚本可以在运行时动态加载。

### 方案2: C# IL2CPP + 反射（高级方案）

通过反射动态加载程序集，需要Mono运行时支持。在iOS上由于AOT编译限制，无法使用反射加载。

### 方案3: AssetBundle资源热更新

资源（模型、贴图、音频等）通过AssetBundle打包，运行时从服务器下载新的AssetBundle实现资源更新。

---

## Lua热更新实现步骤

### 1. 选择Lua运行环境库

常用库：
- **LuaBridge**: 轻量级，创始人已经不再维护
- **LuaFramework**: 基于LuaBridge，国产框架
- **sluaunreal**: 用于Unreal，商业级
- **ULua**: 性能好，支持JIT
- **ToLua**: 国产，基于ULua，文档完善

### 2. 项目结构

```
Assets/
├── Lua/
│   ├── Core/          -- Lua核心库
│   ├── System/        -- 系统模块
│   └── Logic/         -- 游戏逻辑（可热更新）
├── Scripts/           -- C#桥接代码（不可热更新）
└── Resources/         -- 资源文件
```

### 3. C#端加载Lua脚本

```csharp
public class LuaManager : MonoBehaviour
{
    private LuaState luaState;

    void Start()
    {
        luaState = new LuaState();
        luaState.Start();

        // 加载Lua脚本
        luaState.DoFile("Logic/test.lua");

        // 调用Lua函数
        LuaFunction func = luaState.GetFunction("OnInit");
        func.Call();
    }

    void Update()
    {
        // 执行Lua中的Update逻辑
        LuaFunction updateFunc = luaState.GetFunction("OnUpdate");
        if (updateFunc != null)
            updateFunc.Call(Time.deltaTime);
    }

    // 热更新关键：重新加载指定模块
    public void HotfixModule(string moduleName)
    {
        // 1. 从服务器下载新的.lua文件
        // 2. 保存到本地
        // 3. 重新加载执行
        string path = Application.persistentDataPath + "/" + moduleName + ".lua";
        if (File.Exists(path))
        {
            string script = File.ReadAllText(path);
            luaState.DoString(script);
        }
    }
}
```

### 4. Lua端的热更新机制

```lua
-- Logic/HotfixSample.lua

HotfixSample = HotfixSample or {}

-- 热更新后会重新执行这个文件
function HotfixSample.OnInit()
    print("HotfixSample 初始化")
end

function HotfixSample.OnUpdate(dt)
    -- 可以在这里写更新逻辑
end

-- 模拟需要热更新的配置
HotfixSample.Config = {
    health = 100,
    damage = 50,
    speed = 10
}

-- 提供更新配置的方法
function HotfixSample.UpdateConfig(newConfig)
    for k, v in pairs(newConfig) do
        HotfixSample.Config[k] = v
    end
end

return HotfixSample
```

### 5. 热更新流程

```
1. 游戏启动，检测服务器版本号
2. 如果服务器版本 > 本地版本
3. 下载需要更新的Lua文件列表
4. 下载到 Application.persistentDataPath 目录
5. 调用 HotfixModule() 重新加载对应模块
6. 游戏逻辑使用新的Lua代码
```

### 6. 服务器端版本控制

服务器返回的版本信息示例（JSON）：

```json
{
    "version": "1.0.1",
    "modules": [
        {
            "name": "HotfixSample",
            "version": "1.0.1",
            "url": "http://server/lua/HotfixSample.lua",
            "md5": "abc123..."
        }
    ]
}
```

### 7. 下载管理

```lua
-- Lua端下载模块
DownloadManager = {}

function DownloadManager:DownloadModule(moduleInfo, callback)
    -- 使用C#的UnityWebRequest下载
    -- 这里需要C#提供下载接口
end

function DownloadManager:CheckVersion()
    -- 1. 向服务器请求版本信息
    -- 2. 对比本地版本
    -- 3. 返回需要更新的模块列表
end
```

### 8. 完整热更新示例流程

```csharp
// C# 热更新管理器
public class HotfixManager : MonoBehaviour
{
    private static HotfixManager instance;
    public static HotfixManager Instance => instance;

    private Dictionary<string, string> localVersions = new Dictionary<string, string>();
    private string luaDir => Application.persistentDataPath + "/Lua/";

    void Awake()
    {
        instance = this;
        LoadLocalVersions();
    }

    void LoadLocalVersions()
    {
        string path = luaDir + "versions.json";
        if (File.Exists(path))
        {
            string json = File.ReadAllText(path);
            // 解析版本信息
        }
    }

    public void CheckAndUpdate()
    {
        StartCoroutine(CheckServerVersion());
    }

    IEnumerator CheckServerVersion()
    {
        // 1. 请求服务器版本
        // UnityWebRequest request = UnityWebRequest.Get(serverUrl);
        // yield return request.SendWebRequest();

        // 2. 解析版本信息
        // 3. 对比本地版本
        // 4. 下载需要更新的文件
        // 5. 保存新版本信息
        // 6. 通知Lua层重新加载
    }

    public void ReloadModule(string moduleName)
    {
        LuaManager.Instance.HotfixModule(moduleName);
    }
}
```

---

## 注意事项

### 1. 只更新Lua文件，不更新C#

C#代码需要编译到Assembly中，无法热更新。所以核心架构和性能关键代码要用C#写。

### 2. 需要热更新的逻辑必须用Lua实现

提前规划好哪些模块需要热更新，这些模块的代码必须放在Lua中。

### 3. 版本管理和回滚机制

- 记录每个模块的版本号
- 支持回滚到旧版本
- 热更新前备份原有文件

### 4. 网络安全和完整性校验

- 使用HTTPS下载
- 校验文件MD5
- 签名验证防止篡改

### 5. iOS平台特殊考虑

- iOS有DRM限制，某些文件系统是只读的
- 需要使用Application.persistentDataPath
- AssetBundle在iOS上需要特殊处理

---

## 常用Lua框架

| 框架 | 说明 |
|------|------|
| LuaFramework | ToLua作者框架 |
| SLua | 商业级Lua集成 |
| ULua / ToLua | 国产，文档完善 |
| **XLua** | 腾讯开源，支持C#调用Lua和Lua调用C#，维护活跃 |
| Moon | 轻量级框架 |

> **推荐：** XLua - 腾讯开源，维护活跃，文档完善
