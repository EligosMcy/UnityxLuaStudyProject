# Lua协程复杂流转示例

## 目录
- [协程参数传递规则](#协程参数传递规则)
- [完整示例](#完整示例)
- [执行流程详解](#执行流程详解)
- [参数传递总结](#参数传递总结)
- [关键点说明](#关键点说明)
- [协程状态变化](#协程状态变化)

## 协程参数传递规则

1. 第一个yield的参数作为第一个resume的参数
2. 第一个resume的参数作为协程的参数，第二个resume的参数作为第一个yield的返回值
3. 仔细理解这两句话，会发现协程的执行流程
4. 所以也能解释，为什么先输出协程内的语句，再输出协程外的resume语句

## 完整示例

```lua
function foo(a)
    print("foo 函数输出", a)
    return coroutine.yield(2 * a)  -- 返回 2*a 的值
end

co = coroutine.create(function(a, b)
    print("第一次协同程序执行输出", a, b)
    local r = foo(a + 1)

    print("第二次协同程序执行输出", r)
    local r, s = coroutine.yield(a + b, a - b)

    print("第三次协同程序执行输出", r, s)
    return b, "结束协同程序"
end)
```

## 执行流程详解

### 第一次调用 coroutine.resume(co, 1, 10)

- 输入参数: a=1, b=10
- 执行流程:
  1. 协程启动，接收参数 a=1, b=10
  2. 执行 `print("第一次协同程序执行输出", 1, 10)`
  3. 调用 `foo(2)` [因为 a+1 = 2]
  4. foo函数执行 `print("foo 函数输出", 2)`
  5. foo函数执行 `coroutine.yield(4)` [因为 2*2 = 4]
  6. 协程挂起，返回值 4
- 输出结果: `true, 4`
- 说明: 返回 true 表示成功，4 是 yield 的返回值

### 第二次调用 coroutine.resume(co, 'r')

- 输入参数: 'r'
- 执行流程:
  1. 协程恢复，接收参数 'r'（这个值会赋给上次 yield 的返回值）
  2. foo 函数返回 'r'，赋给变量 r
  3. 执行 `print("第二次协同程序执行输出", 'r')`
  4. 执行 `coroutine.yield(a+b, a-b)`
  5. 计算值: a+b=11, a-b=-9 [a=1, b=10 是第一次传入的参数]
  6. 协程再次挂起，返回值 11, -9
- 输出结果: `true, 11, -9`
- 说明: 返回 true 表示成功，11 和 -9 是 yield 的返回值

### 第三次调用 coroutine.resume(co, 'x', 'y')

- 输入参数: 'x', 'y'
- 执行流程:
  1. 协程恢复，接收参数 'x', 'y'（这些值会赋给上次 yield 的返回值 r, s）
  2. 执行 `print("第三次协同程序执行输出", 'x', 'y')`
  3. 执行 `return b, "结束协同程序"`
  4. 返回值: b=10 [b=10 是第一次传入的参数], '结束协同程序'
  5. 协程结束，状态变为 dead
- 输出结果: `true, 10, "结束协同程序"`
- 说明: 返回 true 表示成功，10 和 '结束协同程序' 是 return 的返回值

### 第四次调用 coroutine.resume(co, 'x', 'y')

- 输入参数: 'x', 'y'
- 执行流程:
  1. 尝试恢复已死亡的协程
  2. 操作失败
- 输出结果: `false, "cannot resume dead coroutine"`

## 参数传递总结

### 第一次 resume(co, 1, 10)

- 传入参数: 1, 10
- 协程函数接收: a=1, b=10
- yield 返回: 4

### 第二次 resume(co, 'r')

- 传入参数: 'r'
- yield 的返回值: 'r' (赋给 r 变量)
- yield 返回: 11, -9

### 第三次 resume(co, 'x', 'y')

- 传入参数: 'x', 'y'
- yield 的返回值: 'x', 'y' (赋给 r, s 变量)
- return 返回: 10, '结束协同程序'

### 第四次 resume(co, 'x', 'y')

- 协程已死亡，无法恢复

## 关键点说明

### 1. 协程参数传递

- 第一次 resume 的参数会传给协程函数
- 后续 resume 的参数会传给 yield 的返回值

### 2. yield 的返回值

- yield 的返回值会成为 resume 的返回值
- resume 的参数会成为 yield 的返回值

### 3. 函数中的 yield

- 在协程调用的函数中也可以使用 yield
- yield 会挂起整个协程，而不仅仅是当前函数

### 4. 协程状态

- `suspended`: 挂起状态，可以恢复
- `running`: 运行状态，正在执行
- `dead`: 死亡状态，无法恢复

### 5. 闭包特性

- 协程函数可以访问外部变量
- 协程会记住这些变量的值

## 协程状态变化

```
创建协程 -> suspended
第一次 resume -> running -> suspended (yield)
第二次 resume -> running -> suspended (yield)
第三次 resume -> running -> dead (return)
第四次 resume -> 错误 (dead)
```

## 实际运行输出

运行上述代码后，实际输出如下：

```
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
```

说明：
1. 首先执行协程内部的print语句，然后执行协程外部的print(resume结果)语句
2. 每次resume都会先执行协程直到遇到yield或return
3. yield的参数会作为resume的返回值
4. 下一次resume的参数会作为yield的返回值
5. 当协程执行完毕后，再次resume会返回错误
