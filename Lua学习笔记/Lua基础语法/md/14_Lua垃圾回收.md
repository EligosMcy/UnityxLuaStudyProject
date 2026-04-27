# Lua垃圾回收（Garbage Collection）

## 目录
- [什么是垃圾回收？](#什么是垃圾回收)
- [Lua的垃圾回收机制](#lua的垃圾回收机制)
- [垃圾回收的触发时机](#垃圾回收的触发时机)
- [垃圾回收API](#垃圾回收api)
- [垃圾回收的元方法 __gc](#垃圾回收的元方法-__gc)
- [弱引用表](#弱引用表)
- [垃圾回收的调优](#垃圾回收的调优)
- [内存泄漏的原因和解决方法](#内存泄漏的原因和解决方法)
- [实际应用示例](#实际应用示例)
- [垃圾回收的性能影响](#垃圾回收的性能影响)
- [垃圾回收的调试](#垃圾回收的调试)
- [实际项目中的垃圾回收策略](#实际项目中的垃圾回收策略)
- [常见问题和解决方案](#常见问题和解决方案)

## 什么是垃圾回收？

垃圾回收（Garbage Collection，简称GC）是一种自动内存管理机制，用于回收不再被程序使用的内存空间。

在Lua中，当一个对象不再被任何变量引用时，它就成为垃圾，垃圾回收器会自动回收这些垃圾占用的内存。

## Lua的垃圾回收机制

Lua使用标记-清除（Mark and Sweep）算法进行垃圾回收：

1. **标记阶段**：从根对象（全局变量、局部变量、寄存器等）开始，标记所有可达的对象。

2. **清除阶段**：遍历所有对象，清除未被标记的对象，回收它们占用的内存。

3. **收尾阶段**：对即将被回收的对象调用__gc元方法（如果存在）。

Lua 5.1使用的是分代垃圾回收器，主要分为三个代：
- 0代：新创建的对象
- 1代：经过一次垃圾回收后仍然存在的对象
- 2代：经过多次垃圾回收后仍然存在的对象

## 垃圾回收的触发时机

### 自动触发

- 当新分配的内存超过一定阈值时
- 当内存分配失败时

### 手动触发

```lua
collectgarbage()
```

## 垃圾回收API

### collectgarbage()函数

```lua
-- 手动触发垃圾回收
print("当前内存使用:", collectgarbage("count"), "KB")

-- 创建一些对象
local t = {}
for i = 1, 10000 do
    t[i] = {}
end

-- 释放引用
t = nil

-- 手动触发垃圾回收
collectgarbage()
```

### 常用选项

```lua
-- "collect": 执行一次完整的垃圾回收
collectgarbage("collect")

-- "count": 返回当前Lua使用的内存量（KB）
local mem = collectgarbage("count")

-- "step": 执行一步垃圾回收
local result = collectgarbage("step", 1000)

-- "stop": 停止垃圾回收
collectgarbage("stop")

-- "restart": 重启垃圾回收
collectgarbage("restart")

-- "setpause": 设置垃圾回收的暂停时间
local old_pause = collectgarbage("setpause", 100)

-- "setstepmul": 设置垃圾回收的步长倍数
local old_stepmul = collectgarbage("setstepmul", 200)
```

## 垃圾回收的元方法 __gc

```lua
local obj = {}
local meta = {
    __gc = function(self)
        print("对象被垃圾回收了")
    end
}
setmetatable(obj, meta)

obj = nil
collectgarbage()
```

## 弱引用表

弱引用表是一种特殊的表，它的引用不会阻止垃圾回收。弱引用表可以有三种弱引用模式：
- `"k"`: 键是弱引用
- `"v"`: 值是弱引用
- `"kv"`: 键和值都是弱引用

```lua
local weak_table = setmetatable({}, {__mode = "v"})

local obj1 = {}
weak_table[1] = obj1
obj1 = nil
collectgarbage()
print(weak_table[1])  -- nil
```

## 垃圾回收的调优

### 调整pause值

- pause值越大，垃圾回收越不频繁
- pause值越小，垃圾回收越频繁
- 默认值是100

### 调整stepmul值

- stepmul值越大，垃圾回收速度越快
- stepmul值越小，垃圾回收速度越慢
- 默认值是200

## 内存泄漏的原因和解决方法

### 常见的内存泄漏原因

- 全局变量持有对象引用
- 闭包持有外部变量引用
- 弱引用表使用不当
- 循环引用

### 解决方法

- 及时释放不需要的引用
- 使用局部变量而不是全局变量
- 合理使用弱引用表
- 避免不必要的循环引用

## 实际应用示例

### 监控内存使用

```lua
local function monitorMemory()
    local mem = collectgarbage("count")
    print(string.format("内存使用: %.2f KB", mem))
end

monitorMemory()
```

### 使用弱引用表缓存

```lua
local cache = setmetatable({}, {__mode = "v"})

local function createObject(id)
    if cache[id] then
        return cache[id]
    end
    local obj = {id = id}
    cache[id] = obj
    return obj
end
```

### 资源管理

```lua
local ResourceManager = {
    resources = {}
}

function ResourceManager:add(id, resource)
    self.resources[id] = resource
end

function ResourceManager:remove(id)
    self.resources[id] = nil
end

function ResourceManager:cleanup()
    for id, resource in pairs(self.resources) do
        if resource.isUnused then
            self:remove(id)
        end
    end
    collectgarbage()
end
```

## 垃圾回收的性能影响

### 垃圾回收的开销

- 垃圾回收会暂停程序执行
- 频繁的垃圾回收会影响性能
- 过大的内存使用会导致垃圾回收时间过长

### 性能优化建议

- 合理调整垃圾回收参数
- 避免创建过多临时对象
- 使用对象池减少内存分配
- 在合适的时机手动触发垃圾回收

## 垃圾回收的调试

```lua
local function gcinfo()
    local mem = collectgarbage("count")
    print(string.format("内存: %.2f KB", mem))

    collectgarbage("collect")
    local mem_after = collectgarbage("count")
    print(string.format("垃圾回收后: %.2f KB", mem_after))
    print(string.format("回收内存: %.2f KB", mem - mem_after))
end
```

## 实际项目中的垃圾回收策略

### 游戏开发中的策略

- 在场景切换时手动触发垃圾回收
- 调整垃圾回收参数以适应游戏节奏
- 使用对象池减少内存分配

### 服务器开发中的策略

- 定期手动触发垃圾回收
- 监控内存使用，避免内存泄漏
- 合理设置垃圾回收参数以平衡性能和内存使用

## 常见问题和解决方案

### 内存使用持续增长

- 检查是否有内存泄漏
- 检查全局变量是否持有过多引用
- 检查闭包是否持有不必要的引用

### 垃圾回收时间过长

- 减少同时存在的对象数量
- 调整垃圾回收参数
- 分批次处理大量数据

### 弱引用表不工作

- 检查是否正确设置了__mode元方法
- 检查是否有其他引用持有对象
- 确保对象确实没有被引用
