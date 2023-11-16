local M = {}

-- 进入插入模式
function M.on_insert_enter()
  -- 判断上次退出插入模式时的输入法状态
  -- 如果之前是中文输入法则切换回中文输入法
  local lastInputMethod = vim.b.lastInputMethod
  if lastInputMethod == "" then
    vim.fn.system("xkbswitch -s com.apple.inputmethod.SCIM.ITABC")
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
function M.setup()
  vim.api.nvim_exec([[
    augroup AutoIM
    autocmd!
    autocmd InsertEnter * lua require'autoim'.on_insert_enter()
    autocmd InsertLeave * lua require'autoim'.on_insert_leave()
    augroup END
  ]], false)
end

return M
