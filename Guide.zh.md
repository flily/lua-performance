Lua脚本性能优化指南
=================

Lua脚本是C语言实现的脚本，广泛应用于客户端扩展脚本，例如魔兽世界等网游。但是Lua的性能一般，并且有许多不好的实现，误用会大大降低系统的性能。
网络上有一些关于Lua脚本性能优化的资料，但是都是针对Lua撰写的，写作年代较早，一些优化技巧不完全正确，而且没有针对LuaJIT优化过后的代码进行考虑。
本章对于Lua的一些语法，在Lua和LuaJIT中进行比较测试，并给出相关优化数据和结论。

由于LuaJIT的性能较Lua有很大的提高，在测试时使用的循环次数不同，以避免时间太短导致测量不准确。
在结果中，`In LuaJIT (100x)`表示LuaJIT中执行性能但愿测试次数是Lua中的100倍。

相关参考资料：

1. Roberto Ierusalimschy. Lua Performance Tips. http://www.lua.org/gems/sample.pdf
2. Lua Performance: http://springrts.com/wiki/Lua_Performance

变量局部化
---------

Lua变量区分为全局变量和局部变量。Lua为每一个函数分配了一套多达250个的寄存器，并用这些寄存器存储局部变量，这使得Lua中局部变量的访问速度很快。
相反的是，对于全局变量，Lua需要将全局变量读出存入当前函数的寄存器中，然后完成计算之后再存回全局变量表中。
这样，一个类似`a = a + b`这样的简单计算，若`a`和`b`为局部变量，则编译之后只生成一条Lua指令，而若为全局变量，则生成4条Lua指令。*Lua Performance Tips*中提到，将全局变量变为局部变量，然后在使用进行访问，速度可以提升约30%，编写如下代码进行实验：

**代码和结果**
```lua
function nonlocal()
    local x = 0
    for i = 1, 100 do
        x = x + math.sin(i)
    end
    return x
end

local sin = math.sin
function localized()
    local x = 0
    for i = 1, 100 do
        x = x + sin(i)
    end
    return x
end

--[[------------------------
In Lua (1x)
Case ID	Case name	t1	t2	t3	t4	t5	avg.	%
1	Non-local	1.66	1.65	1.65	1.66	1.66	1.656	100%
2	Localized	1.25	1.25	1.25	1.25	1.25	1.25	75.48%
In LuaJIT (2x)
Case ID	Case name	t1	t2	t3	t4	t5	avg.	%
1	Non-local	1.3	1.31	1.3	1.3	1.3	1.302	100%
2	Localized	1.3	1.3	1.3	1.29	1.3	1.298	99.69%
--]]------------------------
```

**结论**
在普通Lua的解释下，行为和//Lua Performance Tips//中所述大致一致，调用全局变量中的函数大约会慢30%。
而在LuaJIT的解释下，两者差异不明显。
不是一定需要将全局变量中的变量转变为局部变量。

数组（table）追加
---------------

Lua的标准库函数中，并不是所有函数都实现得很好，尤其是table数据结构的实现性能较差，`table.insert`函数就是一个性能较低的函数。


**代码和结果**
```lua
function table_insert()
    local t = {}
    for i = 1, 1000, 2 do
        table.insert(t, i)
    end
    return t
end

function table_insertL()
    local t, insert = {}, table.insert
    for i = 1, 1000, 2 do
        insert(t, i)
    end
    return t
end

function use_counter()
    local t, c = {}, 1
    for i = 1, 1000, 2 do
        t[c], c = i, c + 1
    end
    return t
end

function use_length()
    local t = {}
    for i = 1, 1000, 2 do
        t[#t + 1] = i
    end
end

--[[------------------------
In Lua (1x)
Case ID	Case name	t1	t2	t3	t4	t5	avg.	%
1	table.insert G	2.72	2.73	2.72	2.73	2.72	2.724	100%
2	table.insert L	2.24	2.24	2.24	2.24	2.24	2.24	82.23%
3	use counter   	1.13	1.13	1.14	1.12	1.13	1.13	41.48%
4	use length    	1.43	1.44	1.43	1.43	1.43	1.432	52.57%
In LuaJIT (5x)
Case ID	Case name	t1	t2	t3	t4	t5	avg.	%
1	table.insert G	3.69	3.69	3.68	3.68	3.69	3.686	100%
2	table.insert L	3.75	3.75	3.75	3.75	3.74	3.748	101.68%
3	use counter   	0.86	0.85	0.85	0.86	0.85	0.854	23.17%
4	use length    	3.71	3.71	3.71	3.71	3.71	3.71	100.65%
--]]------------------------
```

**结论**
当需要生成一个数组，并往数组的尾部添加数据时，应当尽可能的使用计数器，如果没办法使用计数器，也应当使用`#`运算符先求出数组的长度，然后使用计数器插入数组。

多重条件判断
----------
在Lua中，唯一的数据结构table是哈希表，创建、销毁和迭代都需要创建很多资源。
本例对比当判断较多条件时，使用连续逻辑表达式和使用table的性能。

**代码和结果**
```lua
function use_or()
    local x = 0
    for _, v in pairs(states) do
        if "alabama" == v or
            "california" == v or
            "missouri" == v or
            "virginia" == v or
            "wisconsin" == v then
            x = x + 1
        end
    end
    return x
end

function use_table()
    local x, vals = 0, {"alabama", "california", "missouri", "virginia", "wisconsin"}
    for _, v in pairs(states) do
        for _, s in pairs(vals) do
            if s == v then x = x + 1 end
        end
    end
    return x
end

--[[------------------------
In Lua (1x)
Case ID	Case name	t1	t2	t3	t4	t5	avg.	%
1	Use OR   	0.39	0.38	0.39	0.39	0.38	0.386	100%
2	Use table	1.85	1.84	1.84	1.85	1.84	1.844	477.72%
In LuaJIT (10x)
Case ID	Case name	t1	t2	t3	t4	t5	avg.	%
1	Use OR   	0.6	0.6	0.59	0.59	0.6	0.596	100%
2	Use table	2.82	2.85	2.86	2.86	2.85	2.848	477.85%
--]]------------------------
```

**结论**
当判断较多逻辑条件时，应当使用简单的逻辑运算，而table创建、销毁和迭代的开销较大，应避免使用。
尽管使用循环的方法，程序可能具有较好的可读性，但是性能会严重下降。
使用逻辑表达式判断，采取较好的写法也可以获得可读性。