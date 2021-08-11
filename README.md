lua-performance
===============

A Lua performance guide for Lua and LuaJIT.

TODO:
  * Add more cases for performance guide.
  * Add test results for different platform, including x86 and ARM.
  * Add English edition of performance guide.


Usage
=====

Performance guide text
----------------------
  - [Original edition (in Chinese)](https://github.com/flily/lua-performance/blob/master/Guide.zh.md)
  - English edition (working)


Executable testing scripts
--------------------------

### To see results in your environment
Runs `lua main.lua run`

### Sub commands (usage)
  - `env`, display lua environment of current interpreter, support official implemented lua and LuaJIT.
  - `list`, show all test cases included in code.
  - `run`, run test cases specified in arguments, it will run all cases while no cases is specified.


How to add new cases
--------------------

### **Step 1**: write codes
Write down your test codes in different functions, with no input argument, in a single module file.

### **Step 2**: return info of test suite
At the end of the module file, returns a table including information of test, with 3 fields:
  - `name`, `[string]` name of this test suite, it MUST BE different from any other cases.
  - `desc`, `[string]` description of test suite, ONLY used in `list` command,.
  - `cases`, `[table]` an array of entries of test cases, including **2** fields:
    - `name`, `[string]` name of this test case.
    - `entry`, `[function]`, entry of test case.

### **Step 3**: add index of test suite
Add name of test suite, which is filename of module lua file of test suite, directly pass to require function,
 to index array, variable `load_list`, found at the last of file `src/init.lua`.

### **Step 4 FINAL**: run your test
Run your test with `main.lua`.

### Example
write your test suite.
```lua
function case_a()
    -- some codes
end

function case_b()
    -- some codes
end

return {
    name = "example"
    desc = "example of case."
    cases = {
        { name = "case A", entry = case_a },
        { name = "case B", entry = case_b },
    }
}
```

and add to 'src/init.lua'
```diff
--- a/src/init.lua
+++ b/src/init.lua
@@ -54,6 +54,7 @@ local load_list = {
     "set-default-value",
     "table-append",
     "tail-recursion",
+    "example",
 }
```
