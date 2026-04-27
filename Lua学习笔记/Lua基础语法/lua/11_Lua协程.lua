-- Lua协程（Coroutine）教程
--[[
本文档详细介绍Lua中协程的概念、使用方法和实际应用。
协程是Lua中实现并发编程的重要机制。
]]

print("=================== Lua协程 ===================")

-- 1. 什么是协程？
print("\n--- 1. 什么是协程？ ---")
--[[
协程（Coroutine）是一种可以在执行过程中暂停并在将来恢复执行的程序组件。
与线程不同，协程的执行是协作式的，而不是抢占式的。
这意味着协程必须显式地让出控制权，其他协程才能执行。

Lua中的协程是完全由Lua本身实现的，不依赖于操作系统。
]]

-- 2. 协程的状态
print("\n--- 2. 协程的状态 ---")
--[[
协程有四种状态：
- suspended: 挂起状态，协程创建后或执行yield后处于此状态
- running: 运行状态，协程正在执行
- dead: 死亡状态，协程执行完毕或发生错误
- normal: 正常状态，协程正在运行但不是当前协程
]]

-- 3. 协程的基本操作
print("\n--- 3. 协程的基本操作 ---")

-- 3.1 创建协程 - coroutine.create()
print("\n3.1 创建协程:")
local co = coroutine.create(function()
    print("协程开始执行")
    print("协程执行中")
    print("协程执行完毕")
end)

print("协程状态:", coroutine.status(co))  -- suspended

-- 3.2 启动协程 - coroutine.resume()
print("\n3.2 启动协程:")
coroutine.resume(co)
print("协程状态:", coroutine.status(co))  -- dead

-- 3.3 挂起协程 - coroutine.yield()
print("\n3.3 挂起协程:")
local co2 = coroutine.create(function()
    print("协程开始")
    local value = coroutine.yield("挂起中")
    print("协程恢复，收到值:", value)
    local value2 = coroutine.yield("再次挂起")
    print("协程再次恢复，收到值:", value2)
    print("协程结束")
    return "协程返回值"
end)

print("第一次resume:", coroutine.resume(co2))  -- 启动并挂起
print("协程状态:", coroutine.status(co2))  -- suspended

print("第二次resume:", coroutine.resume(co2, "Hello"))  -- 恢复并再次挂起
print("协程状态:", coroutine.status(co2))  -- suspended

print("第三次resume:", coroutine.resume(co2, "World"))  -- 恢复并结束
print("协程状态:", coroutine.status(co2))  -- dead

-- 3.4 获取当前协程 - coroutine.running()
print("\n3.4 获取当前协程:")
local co3 = coroutine.create(function()
    print("当前协程:", coroutine.running())
end)

coroutine.resume(co3)
print("主协程:", coroutine.running())

-- 4. 协程的高级用法
print("\n--- 4. 协程的高级用法 ---")

-- 4.1 协程作为迭代器
print("\n4.1 协程作为迭代器:")
function permutations(str)
    local function permute(str, prefix)
        if #str == 0 then
            coroutine.yield(prefix)
        else
            for i = 1, #str do
                local char = str:sub(i, i)
                local remaining = str:sub(1, i-1) .. str:sub(i+1)
                permute(remaining, prefix .. char)
            end
        end
    end
    
    return coroutine.wrap(function()
        permute(str, "")
    end)
end

print("'abc'的所有排列:")
for perm in permutations("abc") do
    print("  ", perm)
end

-- 4.2 协程实现生产者-消费者模式
print("\n4.2 生产者-消费者模式:")
local producer = coroutine.create(function()
    for i = 1, 5 do
        print("生产者生产:", i)
        coroutine.yield(i)
    end
    print("生产者完成")
end)

local consumer = coroutine.create(function(producer)
    while coroutine.status(producer) ~= "dead" do
        local status, value = coroutine.resume(producer)
        if status and value then
            print("消费者消费:", value)
        end
    end
    print("消费者完成")
end)

coroutine.resume(consumer, producer)

-- 4.3 协程实现协作式多任务
print("\n4.3 协作式多任务:")
local task1 = coroutine.create(function()
    for i = 1, 3 do
        print("任务1执行:", i)
        coroutine.yield()
    end
    print("任务1完成")
end)

local task2 = coroutine.create(function()
    for i = 1, 3 do
        print("任务2执行:", i)
        coroutine.yield()
    end
    print("任务2完成")
end)

print("交替执行两个任务:")
while coroutine.status(task1) ~= "dead" or coroutine.status(task2) ~= "dead" do
    if coroutine.status(task1) ~= "dead" then
        coroutine.resume(task1)
    end
    if coroutine.status(task2) ~= "dead" then
        coroutine.resume(task2)
    end
end

-- 5. 协程的错误处理
print("\n--- 5. 协程的错误处理 ---")

local co_with_error = coroutine.create(function()
    print("协程开始")
    error("协程内部错误")
    print("协程结束")
end)

print("执行带错误的协程:")
local status, error_msg = coroutine.resume(co_with_error)
print("执行状态:", status)
print("错误信息:", error_msg)
print("协程状态:", coroutine.status(co_with_error))  -- dead

-- 6. 协程与闭包
print("\n--- 6. 协程与闭包 ---")

function counter()
    local count = 0
    return coroutine.wrap(function()
        while true do
            count = count + 1
            coroutine.yield(count)
        end
    end)
end

local c = counter()
print("计数器:")
print("  ", c())  -- 1
print("  ", c())  -- 2
print("  ", c())  -- 3

-- 7. 协程的实际应用
print("\n--- 7. 协程的实际应用 ---")

-- 7.1 异步操作模拟
print("\n7.1 异步操作模拟:")
function asyncOperation(name, delay)
    return coroutine.create(function()
        print(name, "开始")
        for i = 1, delay do
            print(name, "等待中...", i)
            coroutine.yield()
        end
        print(name, "完成")
        return name .. " 结果"
    end)
end

local op1 = asyncOperation("操作A", 2)
local op2 = asyncOperation("操作B", 3)

print("模拟事件循环:")
while coroutine.status(op1) ~= "dead" or coroutine.status(op2) ~= "dead" do
    if coroutine.status(op1) ~= "dead" then
        local status, result = coroutine.resume(op1)
        if status and result then
            print("获取结果:", result)
        end
    end
    if coroutine.status(op2) ~= "dead" then
        local status, result = coroutine.resume(op2)
        if status and result then
            print("获取结果:", result)
        end
    end
end

-- 7.2 迭代大集合
print("\n7.2 迭代大集合:")
function iterateLargeCollection(size)
    return coroutine.wrap(function()
        for i = 1, size do
            coroutine.yield(i)
        end
    end)
end

print("遍历大集合（只显示前5个）:")
local iterator = iterateLargeCollection(1000000)
for i = 1, 5 do
    print("  ", iterator())
end

-- 7.3 状态机实现
print("\n7.3 状态机实现:")
function createStateMachine()
    local state = "idle"
    
    return coroutine.wrap(function()
        while true do
            local event = coroutine.yield(state)
            if state == "idle" and event == "start" then
                state = "running"
                print("状态变为: running")
            elseif state == "running" and event == "pause" then
                state = "paused"
                print("状态变为: paused")
            elseif state == "paused" and event == "resume" then
                state = "running"
                print("状态变为: running")
            elseif state == "running" and event == "stop" then
                state = "idle"
                print("状态变为: idle")
            end
        end
    end)
end

local sm = createStateMachine()
print("初始状态:", sm())
sm("start")
print("当前状态:", sm())
sm("pause")
print("当前状态:", sm())
sm("resume")
print("当前状态:", sm())
sm("stop")
print("当前状态:", sm())

-- 8. 协程的性能
print("\n--- 8. 协程的性能 ---")

print("\n8.1 协程创建和切换性能:")
local start = os.clock()
local count = 10000

for i = 1, count do
    local co = coroutine.create(function()
        coroutine.yield()
    end)
    coroutine.resume(co)
    coroutine.resume(co)
end

print("创建并切换", count, "个协程耗时:", os.clock() - start, "秒")

-- 9. 协程的注意事项
print("\n--- 9. 协程的注意事项 ---")

-- 9.1 协程不是线程
print("\n9.1 协程不是线程:")
print("- 协程是协作式的，不是抢占式的")
print("- 同一时间只有一个协程在执行")
print("- 协程切换开销比线程小很多")

-- 9.2 避免死锁
print("\n9.2 避免死锁:")
print("- 确保协程之间的依赖关系没有循环")
print("- 合理设计协程的暂停和恢复逻辑")

-- 9.3 内存管理
print("\n9.3 内存管理:")
print("- 死协程会被自动垃圾回收")
print("- 长时间运行的协程可能会占用内存")

-- 10. 高级协程技巧
print("\n--- 10. 高级协程技巧 ---")

-- 10.1 协程池
print("\n10.1 协程池:")
local CoroutinePool = {
    pool = {},
    size = 0
}

function CoroutinePool:get()
    if #self.pool > 0 then
        return table.remove(self.pool)
    end
    self.size = self.size + 1
    return coroutine.create(function(func, ...)
        while true do
            func(...)  -- 执行任务
            table.insert(self.pool, coroutine.running())  -- 任务完成后回到池中
            func, ... = coroutine.yield()  -- 等待新任务
        end
    end)
end

function CoroutinePool:execute(func, ...)
    local co = self:get()
    coroutine.resume(co, func, ...)
end

print("使用协程池:")
local pool = CoroutinePool

for i = 1, 5 do
    pool:execute(function(id)
        print("执行任务:", id)
        for j = 1, 2 do
            coroutine.yield()
        end
        print("任务完成:", id)
    end, i)
end

-- 10.2 协程包装器
print("\n10.2 协程包装器:")
function async(func)
    return function(...)  
        local args = {...}
        local co = coroutine.create(function()
            local success, result = pcall(func, table.unpack(args))
            if success then
                print("异步操作成功:", result)
            else
                print("异步操作失败:", result)
            end
        end)
        coroutine.resume(co)
        return co
    end
end

local asyncTask = async(function(x, y)
    print("执行异步任务:", x, y)
    for i = 1, 3 do
        coroutine.yield()
    end
    return x + y
end)

print("创建异步任务:")
local task = asyncTask(10, 20)

-- 10.3 协程与事件系统
print("\n10.3 协程与事件系统:")
local EventSystem = {
    events = {}
}

function EventSystem:on(event, callback)
    self.events[event] = self.events[event] or {}
    table.insert(self.events[event], callback)
end

function EventSystem:emit(event, ...)
    if self.events[event] then
        for _, callback in ipairs(self.events[event]) do
            callback(...)
        end
    end
end

-- 使用协程等待事件
function waitForEvent(event)
    local co = coroutine.running()
    EventSystem:on(event, function(...)  
        coroutine.resume(co, ...)
    end)
    return coroutine.yield()
end

local co = coroutine.create(function()
    print("等待 'click' 事件...")
    local x, y = waitForEvent("click")
    print("收到点击事件:", x, y)
    
    print("等待 'key' 事件...")
    local key = waitForEvent("key")
    print("收到键盘事件:", key)
end)

coroutine.resume(co)

print("模拟用户操作:")
EventSystem:emit("click", 100, 200)
EventSystem:emit("key", "space")

-- 11. 协程的替代方案
print("\n--- 11. 协程的替代方案 ---")

-- 11.1 回调函数
print("\n11.1 回调函数:")
print("- 传统的异步编程方式")
print("- 可能导致回调地狱")

-- 11.2 异步/等待（async/await）
print("\n11.2 异步/等待:")
print("- 现代语言中的异步编程模型")
print("- 在Lua中可以通过协程模拟")

-- 11.3 状态机
print("\n11.3 状态机:")
print("- 对于简单的状态管理，状态机可能更直接")

-- 12. 实际项目中的应用
print("\n--- 12. 实际项目中的应用 ---")

-- 12.1 游戏开发
print("\n12.1 游戏开发:")
print("- NPC AI行为")
print("- 游戏事件和动画序列")
print("- 任务系统")

-- 12.2 网络编程
print("\n12.2 网络编程:")
print("- 异步网络请求")
print("- 服务器端并发处理")

-- 12.3 数据处理
print("\n12.3 数据处理:")
print("- 大文件处理")
print("- 数据流转换")

print("\n=================== 协程教程完成 ===================")
