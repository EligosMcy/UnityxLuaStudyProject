# Lua协程（Coroutine）

## 目录
- [什么是协程？](#什么是协程)
- [协程的状态](#协程的状态)
- [协程的基本操作](#协程的基本操作)
- [协程的高级用法](#协程的高级用法)
- [协程的错误处理](#协程的错误处理)
- [协程与闭包](#协程与闭包)
- [协程的实际应用](#协程的实际应用)
- [协程的性能](#协程的性能)
- [协程的注意事项](#协程的注意事项)
- [高级协程技巧](#高级协程技巧)
- [协程的替代方案](#协程的替代方案)
- [实际项目中的应用](#实际项目中的应用)

## 什么是协程？

协程（Coroutine）是一种可以在执行过程中暂停并在将来恢复执行的程序组件。与线程不同，协程的执行是协作式的，而不是抢占式的。这意味着协程必须显式地让出控制权，其他协程才能执行。

Lua中的协程是完全由Lua本身实现的，不依赖于操作系统。

## 协程的状态

协程有四种状态：
- `suspended`: 挂起状态，协程创建后或执行yield后处于此状态
- `running`: 运行状态，协程正在执行
- `dead`: 死亡状态，协程执行完毕或发生错误
- `normal`: 正常状态，协程正在运行但不是当前协程

## 协程的基本操作

### 创建协程

```lua
local co = coroutine.create(function()
    print("协程开始执行")
    print("协程执行中")
    print("协程执行完毕")
end)

print(coroutine.status(co))  -- suspended
```

### 启动协程

```lua
coroutine.resume(co)
print(coroutine.status(co))  -- dead
```

### 挂起协程

```lua
local co2 = coroutine.create(function()
    print("协程开始")
    local value = coroutine.yield("挂起中")
    print("协程恢复，收到值:", value)
    local value2 = coroutine.yield("再次挂起")
    print("协程再次恢复，收到值:", value2)
    print("协程结束")
    return "协程返回值"
end)

-- 第一次resume
coroutine.resume(co2)  -- 启动并挂起

-- 第二次resume，传递参数
coroutine.resume(co2, "Hello")  -- 恢复并再次挂起

-- 第三次resume
coroutine.resume(co2, "World")  -- 恢复并结束
```

### 获取当前协程

```lua
local co3 = coroutine.create(function()
    print("当前协程:", coroutine.running())
end)

coroutine.resume(co3)
print("主协程:", coroutine.running())
```

## 协程的高级用法

### 协程作为迭代器

```lua
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

for perm in permutations("abc") do
    print(perm)
end
```

### 生产者-消费者模式

```lua
local producer = coroutine.create(function()
    for i = 1, 5 do
        print("生产者生产:", i)
        coroutine.yield(i)
    end
end)

local consumer = coroutine.create(function(producer)
    while coroutine.status(producer) ~= "dead" do
        local status, value = coroutine.resume(producer)
        if status and value then
            print("消费者消费:", value)
        end
    end
end)

coroutine.resume(consumer, producer)
```

### 协作式多任务

```lua
local task1 = coroutine.create(function()
    for i = 1, 3 do
        print("任务1执行:", i)
        coroutine.yield()
    end
end)

local task2 = coroutine.create(function()
    for i = 1, 3 do
        print("任务2执行:", i)
        coroutine.yield()
    end
end)

while coroutine.status(task1) ~= "dead" or coroutine.status(task2) ~= "dead" do
    if coroutine.status(task1) ~= "dead" then
        coroutine.resume(task1)
    end
    if coroutine.status(task2) ~= "dead" then
        coroutine.resume(task2)
    end
end
```

## 协程的错误处理

```lua
local co_with_error = coroutine.create(function()
    error("协程内部错误")
end)

local status, error_msg = coroutine.resume(co_with_error)
print("执行状态:", status)
print("错误信息:", error_msg)
```

## 协程与闭包

```lua
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
print(c())  -- 1
print(c())  -- 2
print(c())  -- 3
```

## 协程的实际应用

### 异步操作模拟

```lua
function asyncOperation(name, delay)
    return coroutine.create(function()
        for i = 1, delay do
            coroutine.yield()
        end
        return name .. " 完成"
    end)
end
```

### 迭代大集合

```lua
function iterateLargeCollection(size)
    return coroutine.wrap(function()
        for i = 1, size do
            coroutine.yield(i)
        end
    end)
end

local iterator = iterateLargeCollection(1000000)
for i = 1, 5 do
    print(iterator())
end
```

### 状态机实现

```lua
function createStateMachine()
    local state = "idle"

    return coroutine.wrap(function()
        while true do
            local event = coroutine.yield(state)
            if state == "idle" and event == "start" then
                state = "running"
            elseif state == "running" and event == "stop" then
                state = "idle"
            end
        end
    end)
end
```

## 协程的性能

协程创建和切换开销比线程小很多。

```lua
local start = os.clock()
for i = 1, 10000 do
    local co = coroutine.create(function()
        coroutine.yield()
    end)
    coroutine.resume(co)
end
print("创建并切换10000个协程耗时:", os.clock() - start, "秒")
```

## 协程的注意事项

### 协程不是线程

- 协程是协作式的，不是抢占式的
- 同一时间只有一个协程在执行
- 协程切换开销比线程小很多

### 避免死锁

- 确保协程之间的依赖关系没有循环
- 合理设计协程的暂停和恢复逻辑

### 内存管理

- 死协程会被自动垃圾回收
- 长时间运行的协程可能会占用内存

## 高级协程技巧

### 协程池

```lua
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
            func(...)
            table.insert(self.pool, coroutine.running())
            func, ... = coroutine.yield()
        end
    end)
end
```

### 协程包装器

```lua
function async(func)
    return function(...)
        local args = {...}
        local co = coroutine.create(function()
            pcall(func, table.unpack(args))
        end)
        coroutine.resume(co)
        return co
    end
end
```

### 协程与事件系统

```lua
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

function waitForEvent(event)
    local co = coroutine.running()
    EventSystem:on(event, function(...)
        coroutine.resume(co, ...)
    end)
    return coroutine.yield()
end
```

## 协程的替代方案

### 回调函数

传统的异步编程方式，可能导致回调地狱。

### 异步/等待（async/await）

现代语言中的异步编程模型，在Lua中可以通过协程模拟。

### 状态机

对于简单的状态管理，状态机可能更直接。

## 实际项目中的应用

### 游戏开发

- NPC AI行为
- 游戏事件和动画序列
- 任务系统

### 网络编程

- 异步网络请求
- 服务器端并发处理

### 数据处理

- 大文件处理
- 数据流转换
