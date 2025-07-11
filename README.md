## 介绍
- 这是一个 macOS 下的 Neovim 自动切换输入法插件，使用`xkbswitch`
- 本插件仅在本人的开发环境中进行过测试，如果无法使用，欢迎阅读代码后进行完善

## 安装与初始化
1.  安装 xkbswitch-macosx  
    建议使用[这里](https://github.com/xiehuc/xkbswitch-macosx)提供的 fork，自行编译，
    然后根据系统架构将 `xkbswitch-arm` 放到 `/opt/homebrew/bin/` 目录，并重命名为`xkbswitch`。
2.  安装插件（这里以 lazy.nvim 进行示例）
    ```LUA
    -- 自动切换输入法
    {
        "Eatsolx/im_switch.nvim",
        config = function()
            require("im_switch").setup({
            layout = "com.apple.keylayout.ABC",  -- 目标输入法
            })
        end,
        event = "InsertEnter",
    }
    ```
