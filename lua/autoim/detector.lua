-- detector.lua

-- 创建一个局部变量用于包裹模块中的函数和变量
local M = {}

-- 函数：检测文本是否包含注释
function M.hasComment(text)
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
  if string.match(text, single_line_comment_pattern) then
    return true
  end

  -- 检查是否包含多行注释标记
  for lang, start_pattern in pairs(multi_line_comment_start) do
    local end_pattern = multi_line_comment_end[lang]
    local multi_line_pattern = start_pattern .. ".-" .. end_pattern
    if string.match(text, multi_line_pattern) then
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
