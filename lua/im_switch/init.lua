local M = {}

-- 检查 xkbswitch 是否可用
local function check_xkbswitch()
  return vim.fn.executable("xkbswitch") == 1
end

-- 获取当前输入法
local function get_current_input_method()
  local handle = io.popen("xkbswitch -g 2>/dev/null")
  if not handle then return nil end
  
  local current_im = handle:read("*a"):gsub("[\n\r]", "")
  handle:close()
  
  return current_im
end

-- 切换输入法到 ABC
local function switch_to_abc()
  -- 获取配置的布局或使用默认值
  local layout = vim.g.im_switch_layout or "com.apple.keylayout.ABC"

  if layout == get_current_input_method() then return end
  
  -- 使用 xkbswitch 切换输入法
  local cmd = string.format("xkbswitch -s '%s'", layout)
  local handle = io.popen(cmd .. " 2>&1")  -- 捕获标准错误输出
  local output = handle:read("*a")
  local success, exit_code, error_msg = handle:close()
  
  -- -- 改进的错误处理
  -- if not success or exit_code ~= 0 then
  --   local msg = string.format(
  --     "输入法切换失败 (code:%d): %s",
  --     exit_code or -1,
  --     output or error_msg or "未知错误"
  --   )
  --   vim.notify(msg, vim.log.levels.WARN)
  -- end
end

-- 设置自动命令
function M.setup(opts)
  opts = opts or {}
  
  if not check_xkbswitch() then
    vim.notify("im_switch: 未找到 xkbswitch 命令", vim.log.levels.ERROR)
    return
  end
  
  -- 应用配置选项
  if opts.layout then
    vim.g.im_switch_layout = opts.layout
  end
  
  -- 创建自动命令组
  vim.api.nvim_create_augroup("ImSwitch", { clear = true })
  
  -- 退出插入模式时切换输入法
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = "ImSwitch",
    pattern = "*",
    callback = switch_to_abc
  })
  
end

return M

