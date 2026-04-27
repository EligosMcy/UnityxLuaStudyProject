-- Lua垃圾回收（Garbage Collection）教程
--[[
本文档详细介绍Lua中垃圾回收的概念、机制、API和实际应用。
垃圾回收是Lua自动管理内存的重要机制。
]]

print("=================== Lua垃圾回收 ===================")

-- 1. 什么是垃圾回收？
print("\n--- 1. 什么是垃圾回收？ ---")
--[[
垃圾回收（Garbage Collection，简称GC）是一种自动内存管理机制，
用于回收不再被程序使用的内存空间。

在Lua中，当一个对象不再被任何变量引用时，它就成为垃圾，
垃圾回收器会自动回收这些垃圾占用的内存。
]]

-- 2. Lua的垃圾回收机制
print("\n--- 2. Lua的垃圾回收机制 ---")
--[[
Lua使用标记-清除（Mark and Sweep）算法进行垃圾回收：

1. 标记阶段：从根对象（全局变量、局部变量、寄存器等）开始，
   标记所有可达的对象。

2. 清除阶段：遍历所有对象，清除未被标记的对象，
   回收它们占用的内存。

3. 收尾阶段：对即将被回收的对象调用__gc元方法（如果存在）。

Lua 5.1使用的是分代垃圾回收器，主要分为三个代：
- 0代：新创建的对象
- 1代：经过一次垃圾回收后仍然存在的对象
- 2代：经过多次垃圾回收后仍然存在的对象

新对象首先进入0代，当0代满时触发垃圾回收。
存活的对象会被移动到1代，1代满时会触发更大范围的垃圾回收。
]]

-- 3. 垃圾回收的触发时机
print("\n--- 3. 垃圾回收的触发时机 ---")

-- 3.1 自动触发
print("\n3.1 自动触发:")
print("- 当新分配的内存超过一定阈值时")
print("- 当内存分配失败时")

-- 3.2 手动触发
print("\n3.2 手动触发:")
print("- 使用collectgarbage()函数手动触发")

-- 4. 垃圾回收API
print("\n--- 4. 垃圾回收API ---")

-- 4.1 collectgarbage([opt [, arg]])
print("\n4.1 collectgarbage()函数:")

-- 示例：手动触发垃圾回收
print("\n4.1.1 手动触发垃圾回收:")
print("当前内存使用:", collectgarbage("count"), "KB")

-- 创建一些对象
local t = {}
for i = 1, 10000 do
    t[i] = {}
end

print("创建对象后内存使用:", collectgarbage("count"), "KB")

-- 释放引用
t = nil

-- 手动触发垃圾回收
collectgarbage()
print("垃圾回收后内存使用:", collectgarbage("count"), "KB")

-- 4.2 常用选项
print("\n4.2 常用选项:")

-- "collect": 执行一次完整的垃圾回收
print("\n4.2.1 collect:")
collectgarbage("collect")
print("执行完整垃圾回收")

-- "count": 返回当前Lua使用的内存量（KB）
print("\n4.2.2 count:")
local mem = collectgarbage("count")
print("当前内存使用:", mem, "KB")

-- "step": 执行一步垃圾回收
print("\n4.2.3 step:")
local result = collectgarbage("step", 1000)  -- 1000是步长
print("一步垃圾回收结果:", result)

-- "stop": 停止垃圾回收
print("\n4.2.4 stop:")
collectgarbage("stop")
print("垃圾回收已停止")

-- "restart": 重启垃圾回收
print("\n4.2.5 restart:")
collectgarbage("restart")
print("垃圾回收已重启")

-- "setpause": 设置垃圾回收的暂停时间
print("\n4.2.6 setpause:")
local old_pause = collectgarbage("setpause", 100)
print("旧的pause值:", old_pause)
print("新的pause值:", collectgarbage("setpause", 100))

-- "setstepmul": 设置垃圾回收的步长倍数
print("\n4.2.7 setstepmul:")
local old_stepmul = collectgarbage("setstepmul", 200)
print("旧的stepmul值:", old_stepmul)
print("新的stepmul值:", collectgarbage("setstepmul", 200))

-- 5. 垃圾回收的元方法 __gc
print("\n--- 5. 垃圾回收的元方法 __gc ---")

-- 示例：使用__gc元方法
print("\n5.1 __gc元方法示例:")
local obj = {}
local meta = {
    __gc = function(self)
        print("对象被垃圾回收了")
    end
}
setmetatable(obj, meta)

-- 释放引用
obj = nil

-- 手动触发垃圾回收
collectgarbage()

-- 6. 弱引用表
print("\n--- 6. 弱引用表 ---")
--[[
弱引用表是一种特殊的表，它的引用不会阻止垃圾回收。
弱引用表可以有三种弱引用模式：
- "k": 键是弱引用
- "v": 值是弱引用
- "kv": 键和值都是弱引用
]]

print("\n6.1 创建弱引用表:")
local weak_table = setmetatable({}, {__mode = "v"})

-- 添加对象到弱引用表
local obj1 = {}
local obj2 = {}
weak_table[1] = obj1
weak_table[2] = obj2

print("弱引用表内容:", weak_table[1], weak_table[2])

-- 释放引用
obj1 = nil
collectgarbage()

print("垃圾回收后弱引用表内容:", weak_table[1], weak_table[2])

-- 7. 垃圾回收的调优
print("\n--- 7. 垃圾回收的调优 ---")

-- 7.1 调整pause值
print("\n7.1 调整pause值:")
print("- pause值越大，垃圾回收越不频繁")
print("- pause值越小，垃圾回收越频繁")
print("- 默认值是100")

-- 7.2 调整stepmul值
print("\n7.2 调整stepmul值:")
print("- stepmul值越大，垃圾回收速度越快")
print("- stepmul值越小，垃圾回收速度越慢")
print("- 默认值是200")

-- 7.3 手动控制垃圾回收
print("\n7.3 手动控制垃圾回收:")
print("- 在关键时刻手动触发垃圾回收")
print("- 避免在性能敏感的代码中触发垃圾回收")

-- 8. 内存泄漏的原因和解决方法
print("\n--- 8. 内存泄漏的原因和解决方法 ---")

-- 8.1 常见的内存泄漏原因
print("\n8.1 常见的内存泄漏原因:")
print("- 全局变量持有对象引用")
print("- 闭包持有外部变量引用")
print("- 弱引用表使用不当")
print("- 循环引用")

-- 8.2 解决方法
print("\n8.2 解决方法:")
print("- 及时释放不需要的引用")
print("- 使用局部变量而不是全局变量")
print("- 合理使用弱引用表")
print("- 避免不必要的循环引用")

-- 9. 实际应用示例
print("\n--- 9. 实际应用示例 ---")

-- 9.1 监控内存使用
print("\n9.1 监控内存使用:")
local function monitorMemory()
    local mem = collectgarbage("count")
    print(string.format("内存使用: %.2f KB", mem))
end

monitorMemory()

-- 创建一些对象
local t = {}
for i = 1, 50000 do
    t[i] = {i = i, name = "item" .. i}
end

monitorMemory()

-- 释放引用
t = nil
collectgarbage()

monitorMemory()

-- 9.2 使用弱引用表缓存
print("\n9.2 使用弱引用表缓存:")
local cache = setmetatable({}, {__mode = "v"})

local function createObject(id)
    if cache[id] then
        print("从缓存中获取对象:", id)
        return cache[id]
    end
    
    print("创建新对象:", id)
    local obj = {id = id}
    cache[id] = obj
    return obj
end

local obj1 = createObject(1)
local obj2 = createObject(2)
local obj3 = createObject(1)  -- 应该从缓存中获取

print("obj1:", obj1)
print("obj2:", obj2)
print("obj3:", obj3)
print("obj1和obj3是否相同:", obj1 == obj3)

-- 释放引用
obj1 = nil
obj3 = nil
collectgarbage()

local obj4 = createObject(1)  -- 应该重新创建
print("obj4:", obj4)

-- 9.3 资源管理
print("\n9.3 资源管理:")
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

-- 示例使用
ResourceManager:add(1, {name = "texture1", isUnused = false})
ResourceManager:add(2, {name = "texture2", isUnused = true})
ResourceManager:add(3, {name = "texture3", isUnused = true})

print("清理前资源数量:", #ResourceManager.resources)
ResourceManager:cleanup()
print("清理后资源数量:", #ResourceManager.resources)

-- 10. 垃圾回收的性能影响
print("\n--- 10. 垃圾回收的性能影响 ---")

-- 10.1 垃圾回收的开销
print("\n10.1 垃圾回收的开销:")
print("- 垃圾回收会暂停程序执行")
print("- 频繁的垃圾回收会影响性能")
print("- 过大的内存使用会导致垃圾回收时间过长")

-- 10.2 性能优化建议
print("\n10.2 性能优化建议:")
print("- 合理调整垃圾回收参数")
print("- 避免创建过多临时对象")
print("- 使用对象池减少内存分配")
print("- 在合适的时机手动触发垃圾回收")

-- 11. 垃圾回收的调试
print("\n--- 11. 垃圾回收的调试 ---")

-- 11.1 监控垃圾回收
print("\n11.1 监控垃圾回收:")
local function gcinfo()
    local mem = collectgarbage("count")
    print(string.format("内存: %.2f KB", mem))
    
    -- 执行垃圾回收并获取统计信息
    collectgarbage("collect")
    local mem_after = collectgarbage("count")
    print(string.format("垃圾回收后: %.2f KB", mem_after))
    print(string.format("回收内存: %.2f KB", mem - mem_after))
end

-- 创建一些对象
local t = {}
for i = 1, 20000 do
    t[i] = {}
end

gcinfo()

-- 释放引用
t = nil
gcinfo()

-- 12. 实际项目中的垃圾回收策略
print("\n--- 12. 实际项目中的垃圾回收策略 ---")

-- 12.1 游戏开发中的策略
print("\n12.1 游戏开发中的策略:")
print("- 在场景切换时手动触发垃圾回收")
print("- 调整垃圾回收参数以适应游戏节奏")
print("- 使用对象池减少内存分配")

-- 12.2 服务器开发中的策略
print("\n12.2 服务器开发中的策略:")
print("- 定期手动触发垃圾回收")
print("- 监控内存使用，避免内存泄漏")
print("- 合理设置垃圾回收参数以平衡性能和内存使用")

-- 13. 常见问题和解决方案
print("\n--- 13. 常见问题和解决方案 ---")

-- 13.1 内存使用持续增长
print("\n13.1 内存使用持续增长:")
print("- 检查是否有内存泄漏")
print("- 检查全局变量是否持有过多引用")
print("- 检查闭包是否持有不必要的引用")

-- 13.2 垃圾回收时间过长
print("\n13.2 垃圾回收时间过长:")
print("- 减少同时存在的对象数量")
print("- 调整垃圾回收参数")
print("- 分批次处理大量数据")

-- 13.3 弱引用表不工作
print("\n13.3 弱引用表不工作:")
print("- 检查是否正确设置了__mode元方法")
print("- 检查是否有其他引用持有对象")
print("- 确保对象确实没有被引用")

print("\n=================== 垃圾回收教程完成 ===================")
