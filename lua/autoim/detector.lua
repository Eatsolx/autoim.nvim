-- detector.lua

-- 创建一个局部变量用于包裹模块中的函数和变量
local M = {}

-- 函数：检测文本是否包含注释
function module.hasComment(line)
    local comment_pattern = "%s*[%#%-%/%*]"
    return string.match(line, comment_pattern) ~= nil
end

-- 函数：判断上次输入法是否为中文
function module.isChineseInputMethod()
    local lastInputMethod = vim.b.lastInputMethod
    return lastInputMethod == ""
end

-- 导出模块
return M
