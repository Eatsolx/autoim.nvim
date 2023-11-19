local M = {}

local detector = require'autoim.detector'

-- 进入插入模式
function M.on_insert_enter()
  -- 判断上次退出插入模式时的输入法状态
  -- 如果之前是中文输入法则切换回中文输入法
  if detector.isChineseInputMethod() then
    -- 传入上下十行内的数据
    local current_line = vim.fn.line(".")
    local start_line = math.max(current_line - 10, 1)
    local end_line = math.min(current_line + 10, vim.fn.line("$"))
    local current_lines = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)
    local above_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, current_line - 1, false)
    local below_lines = vim.api.nvim_buf_get_lines(0, current_line, end_line, false)
    -- END

    local isMarkdown = detector.isMarkdown()

    -- 判断是否为Markdown
    if isMarkdown then
      vim.fn.system("xkbswitch -s com.apple.inputmethod.SCIM.ITABC")
    else
      if detector.hasCommentAboveBelow(current_lines, above_lines, below_lines) then
        vim.fn.system("xkbswitch -s com.apple.inputmethod.SCIM.ITABC")
      end
    end
  end
end

-- 退出插入模式
function M.on_insert_leave()
  -- 如果不是英文输入法则切换回英文输入法
  if detector.isEnglishInputMethod() then
    vim.fn.system("xkbswitch -s com.apple.keylayout.ABC")
  end
end

-- 创建自动命令，当进入和退出插入模式时触发对应的函数

function M.setup()
  -- 创建一个名为 "AutoIM" 的自动命令组，并获取组的ID
  local AutoIM_id = vim.api.nvim_create_augroup("AutoIM", { clear = true })

  -- 为 InsertEnter 事件添加自动命令
  vim.api.nvim_create_autocmd({"InsertEnter"}, {
    group = AutoIM_id,
    callback = function()
      require'autoim'.on_insert_enter()
    end
  })

  -- 为 InsertLeave 事件添加自动命令
  vim.api.nvim_create_autocmd({"InsertLeave"}, {
    group = AutoIM_id,
    callback = function()
      require'autoim'.on_insert_leave()
    end
  })

  -- 结束自动命令组
  -- vim.api.nvim_command("augroup END")
  vim.api.nvim_del_autocmd(AutoIM_id)
end


return M
