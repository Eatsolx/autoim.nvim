-- detector.lua

-- 创建一个局部变量用于包裹模块中的函数和变量
local M = {}

-- 函数：检测文本是否包含注释
function M.hasCommentAboveBelow(current_lines, above_lines, below_lines)
  -- 匹配单行注释
  local single_line_comment_pattern = "%s*[%#%-%/]"

  -- 匹配多行注释的开始和结束标记
  local multi_line_comment_start = {
    C = "%s*/%*",
    Java = "%s*/%*",
    JavaScript = "%s*/%*",
    Python = '%s*"""',
    HTML = "<!%-%-",
    CSS = "/%*",
    Bash = "%s*:'",
    Swift = "%s*/%*",
    Go = "%s*/%*"
    -- 添加其他语言的多行注释开始标记
  }

  local multi_line_comment_end = {
    C = "%*/%s*",
    Java = "%*/%s*",
    JavaScript = "%*/%s*",
    Python = '%s*"""',
    HTML = "%-%->",
    CSS = "%*/",
    Bash = "'%s*",
    Swift = "%*/%s*",
    Go = "%*/%s*"
    -- 添加其他语言的多行注释结束标记
  }

  -- 检查是否包含单行注释
  for _, line in ipairs(current_lines) do
    if string.match(line, single_line_comment_pattern) then
      return true
    end
  end

  -- 检查是否包含多行注释标记
  for lang, start_pattern in pairs(multi_line_comment_start) do
    local end_pattern = multi_line_comment_end[lang]
    local multi_line_pattern = start_pattern .. ".-" .. end_pattern

    -- 检查上文是否包含起始关键字
    local match_start_above = false
    for _, line in ipairs(above_lines) do
      if string.match(line, start_pattern) then
        match_start_above = true
        break
      end
    end

    -- 检查下文是否包含结束关键字
    local match_end_below = false
    for _, line in ipairs(below_lines) do
      if string.match(line, end_pattern) then
        match_end_below = true
        break
      end
    end

    -- 如果有且仅有一对符合的开始和结束关键字，则返回 true
    if match_start_above and match_end_below then
      return true
    end
  end

  return false
end

-- 函数：判断上次输入法是否为中文
function M.isChineseInputMethod()
  local lastInputMethod = vim.b.lastInputMethod
  return lastInputMethod == ""
end

-- 函数：判断当前输入法是否为英文
function M.isEnglishInputMethod()
  local currentInputMethod = vim.fn.system("xkbswitch -g | grep com.apple.keylayout.ABC")
  vim.b.lastInputMethod = currentInputMethod
  return currentInputMethod == ""
end

-- 函数：判断文件类型是否为markdown
function M.isMarkdown()
  local filetype = vim.bo.filetype
  return filetype == "markdown"
end

-- 导出模块
return M
