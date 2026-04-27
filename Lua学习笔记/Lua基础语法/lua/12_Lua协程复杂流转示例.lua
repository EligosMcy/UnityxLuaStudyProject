-- Lua协程复杂流转示例
--[[
这个示例详细展示了协程的复杂流转过程，包括：
1. 协程中调用其他函数，该函数中也使用了coroutine.yield
2. 多次resume和yield的交互
3. 参数传递和返回值的处理
]]

--[[
1.第一个yield的参数作为第一个resume的参数
2.第一个resume的参数作为协程的参数，第二个resume的参数作为第一个yield的返回值
3.仔细理解这两句话，会发现协程的执行流程。
4.所以也能解释，为什么先输出协程内的语句，再输出协程外的resume语句。
--]]

print("=================== 协程复杂流转示例 ===================")

-- 定义一个在协程中调用的函数
function foo(a)
    print("foo 函数输出", a)
    return coroutine.yield(2 * a)  -- 返回 2*a 的值
end

-- 创建协程
co = coroutine.create(function(a, b)
    print("第一次协同程序执行输出", a, b)  -- co-body 1 10
    local r = foo(a + 1)
    
    print("第二次协同程序执行输出", r)
    local r, s = coroutine.yield(a + b, a - b)   -- a，b的值为第一次调用协同程序时传入
    
    print("第三次协同程序执行输出", r, s)
    return b, "结束协同程序"            -- b的值为第二次调用协同程序时传入
end)

-- 协程运行后的完整输出结果
--[[
运行上述代码后，实际输出如下：

第一次协同程序执行输出    1    10
foo 函数输出    2
main    true    4
--分割线----
第二次协同程序执行输出    r
main    true    11    -9
---分割线---
第三次协同程序执行输出    x    y
main    true    10    结束协同程序
---分割线---
main    false    cannot resume dead coroutine
---分割线---

说明：
1. 首先执行协程内部的print语句，然后执行协程外部的print(resume结果)语句
2. 每次resume都会先执行协程直到遇到yield或return
3. yield的参数会作为resume的返回值
4. 下一次resume的参数会作为yield的返回值
5. 当协程执行完毕后，再次resume会返回错误
]]

print("\n=== 第一次调用 coroutine.resume(co, 1, 10) ===")
print("输入参数: a=1, b=10")
print("执行流程:")
print("  1. 协程启动，接收参数 a=1, b=10")
print("  2. 执行 print('第一次协同程序执行输出', 1, 10)")
print("  3. 调用 foo(2) [因为 a+1 = 2]")
print("  4. foo函数执行 print('foo 函数输出', 2)")
print("  5. foo函数执行 coroutine.yield(4) [因为 2*2 = 4]")
print("  6. 协程挂起，返回值 4")
print("输出结果:", coroutine.resume(co, 1, 10))
print("说明: 返回 true 表示成功，4 是 yield 的返回值")

print("\n=== 第二次调用 coroutine.resume(co, 'r') ===")
print("输入参数: 'r'")
print("执行流程:")
print("  1. 协程恢复，接收参数 'r'（这个值会赋给上次 yield 的返回值）")
print("  2. foo 函数返回 'r'，赋给变量 r")
print("  3. 执行 print('第二次协同程序执行输出', 'r')")
print("  4. 执行 coroutine.yield(a+b, a-b)")
print("  5. 计算值: a+b=11, a-b=-9 [a=1, b=10 是第一次传入的参数]")
print("  6. 协程再次挂起，返回值 11, -9")
print("输出结果:", coroutine.resume(co, "r"))
print("说明: 返回 true 表示成功，11 和 -9 是 yield 的返回值")

print("\n=== 第三次调用 coroutine.resume(co, 'x', 'y') ===")
print("输入参数: 'x', 'y'")
print("执行流程:")
print("  1. 协程恢复，接收参数 'x', 'y'（这些值会赋给上次 yield 的返回值 r, s）")
print("  2. 执行 print('第三次协同程序执行输出', 'x', 'y')")
print("  3. 执行 return b, '结束协同程序'")
print("  4. 返回值: b=10 [b=10 是第一次传入的参数], '结束协同程序'")
print("  5. 协程结束，状态变为 dead")
print("输出结果:", coroutine.resume(co, "x", "y"))
print("说明: 返回 true 表示成功，10 和 '结束协同程序' 是 return 的返回值")

print("\n=== 第四次调用 coroutine.resume(co, 'x', 'y') ===")
print("输入参数: 'x', 'y'")
print("执行流程:")
print("  1. 尝试恢复已死亡的协程")
print("  2. 操作失败")
print("输出结果:", coroutine.resume(co, "x", "y"))
print("说明: 无法恢复已死亡的协程")

print("\n=== 参数传递总结 ===")
print("1. 第一次 resume(co, 1, 10):")
print("   - 传入参数: 1, 10")
print("   - 协程函数接收: a=1, b=10")
print("   - yield 返回: 4")
print("")
print("2. 第二次 resume(co, 'r'):")
print("   - 传入参数: 'r'")
print("   - yield 的返回值: 'r' (赋给 r 变量)")
print("   - yield 返回: 11, -9")
print("")
print("3. 第三次 resume(co, 'x', 'y'):")
print("   - 传入参数: 'x', 'y'")
print("   - yield 的返回值: 'x', 'y' (赋给 r, s 变量)")
print("   - return 返回: 10, '结束协同程序'")
print("")
print("4. 第四次 resume(co, 'x', 'y'):")
print("   - 协程已死亡，无法恢复")

print("\n=== 关键点说明 ===")
print("1. 协程参数传递:")
print("   - 第一次 resume 的参数会传给协程函数")
print("   - 后续 resume 的参数会传给 yield 的返回值")
print("")
print("2. yield 的返回值:")
print("   - yield 的返回值会成为 resume 的返回值")
print("   - resume 的参数会成为 yield 的返回值")
print("")
print("3. 函数中的 yield:")
print("   - 在协程调用的函数中也可以使用 yield")
print("   - yield 会挂起整个协程，而不仅仅是当前函数")
print("")
print("4. 协程状态:")
print("   - suspended: 挂起状态，可以恢复")
print("   - running: 运行状态，正在执行")
print("   - dead: 死亡状态，无法恢复")
print("")
print("5. 闭包特性:")
print("   - 协程函数可以访问外部变量")
print("   - 协程会记住这些变量的值")

print("\n=== 协程状态变化 ===")
print("创建协程 -> suspended")
print("第一次 resume -> running -> suspended (yield)")
print("第二次 resume -> running -> suspended (yield)")
print("第三次 resume -> running -> dead (return)")
print("第四次 resume -> 错误 (dead)")

print("\n=== 实际运行输出 ===")
print("运行以下代码查看实际输出:")
print([[
function foo(a)
    print("foo 函数输出", a)
    return coroutine.yield(2 * a)
end

co = coroutine.create(function(a, b)
    print("第一次协同程序执行输出", a, b)
    local r = foo(a + 1)
    
    print("第二次协同程序执行输出", r)
    local r, s = coroutine.yield(a + b, a - b)
    
    print("第三次协同程序执行输出", r, s)
    return b, "结束协同程序"
end)

print(coroutine.resume(co, 1, 10))
print(coroutine.resume(co, "r"))
print(coroutine.resume(co, "x", "y"))
print(coroutine.resume(co, "x", "y"))
]])
print("\n=================== 协程复杂流转示例完成 ===================")
