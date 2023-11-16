local M = {}

-- 进入插入模式
local function on_insert_enter()
  -- 判断上次退出插入模式时的输入法状态
  -- 如果是中文输入法则切换回中文输入法
  local lastInputMethod = vim.b.lastInputMethod
  if lastInputMethod and lastInputMethod ~= "com.apple.keylayout.ABC" then
    vim.fn.system("xkbswitch -s com.apple.inputmethod.SCIM.ITABC")
  end
end

-- 退出插入模式
local function on_insert_leave()
  -- 获取当前输入法状态
  -- 如果为英文输入法，则为False
  local currentInputMethod = vim.fn.system("xkbswitch -g | grep com.apple.keylayout.ABC")
  local lastInputMethod = currentInputMethod ~= ""

  -- 如果不是英文输入法则切换回英文输入法
  if lastInputMethod then
    vim.fn.system("xkbswitch -s com.apple.keylayout.ABC")
  end

  vim.b.lastInputMethod = currentInputMethod
end

-- 创建自动命令，当进入和退出插入模式时触发对应的函数
vim.api.nvim_create_autocmd("InsertModeEvents", {
  { "InsertEnter", "*", "lua on_insert_enter()" },
  { "InsertLeave", "*", "lua on_insert_leave()" },
})

return M
