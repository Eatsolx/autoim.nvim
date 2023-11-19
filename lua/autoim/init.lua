local M = {}

local detector = require'autoim.detector'

-- 进入插入模式
function M.on_insert_enter()
  -- 判断上次退出插入模式时的输入法状态
  -- 如果之前是中文输入法则切换回中文输入法
  if detector.isChineseInputMethod() then
    local line = vim.api.nvim_get_current_line()
    local has_comment = detector.hasComment(line)

    if has_comment then
      -- 如果当行含有注释并且上次退出前输入法为英文，则切换为中文
      vim.fn.system("xkbswitch -s com.apple.inputmethod.SCIM.ITABC")
    end
  end
end

-- 退出插入模式
function M.on_insert_leave()
  -- 获取当前输入法状态
  local currentInputMethod = vim.fn.system("xkbswitch -g | grep com.apple.keylayout.ABC")
  -- 如果为英文输入法，则为False
  local lastInputMethod = currentInputMethod == ""

  -- 如果不是英文输入法则切换回英文输入法
  if lastInputMethod then
    vim.fn.system("xkbswitch -s com.apple.keylayout.ABC")
  end

  vim.b.lastInputMethod = currentInputMethod
end

-- 创建自动命令，当进入和退出插入模式时触发对应的函数
-- function M.setup()
--   -- 创建自动命令组
--   vim.api.nvim_command("augroup AutoIM")
--   -- 清空已存在的自动命令
--   vim.api.nvim_command("autocmd!")
--   -- 添加 InsertEnter 事件的自动命令
--   vim.api.nvim_command("autocmd InsertEnter * lua require'autoim'.on_insert_enter()")
--   -- 添加 InsertLeave 事件的自动命令
--   vim.api.nvim_command("autocmd InsertLeave * lua require'autoim'.on_insert_leave()")
--   -- 结束自动命令组
--   vim.api.nvim_command("augroup END")
-- end

function M.setup()
  -- Create an autocommand group named "AutoIM"
  local group_id = vim.api.nvim_create_augroup("AutoIM", { clear = true })

  -- Add an autocmd for InsertEnter event
  vim.api.nvim_create_autocmd({"InsertEnter"}, {
    group = group_id,
    callback = function()
      require'autoim'.on_insert_enter()
    end
  })

  -- Add an autocmd for InsertLeave event
  vim.api.nvim_create_autocmd({"InsertLeave"}, {
    group = group_id,
    callback = function()
      require'autoim'.on_insert_leave()
    end
  })

  -- End the autocommand group
  vim.api.nvim_command("augroup END")
end

return M
