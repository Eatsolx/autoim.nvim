## 介绍
- 这是一个macOS下的Neovim自动切换输入法插件，使用`xkbswitch`
- 本插件仅在本人的开发环境中进行过测试，如果无法使用，欢迎阅读代码后进行完善

## 安装与初始化
1.  安装xkbswitch-macosx  
    建议使用[这里](https://github.com/xiehuc/xkbswitch-macosx)提供的 fork，自行编译，
    然后根据系统架构将`xkbswitch-arm`或者`xkbswitch-x86`放到`/usr/local/bin`目录,
    并重命名为`xkbswitch`。
2.  安装插件（这里以lazy.nvim进行示例）
    ```LUA
    -- 自动切换输入法
    {
      "eatsolx/autoim.nvim",
      event = "InsertEnter",
    }
    ```
## License
The MIT License (MIT)

Copyright (c) 2023 Eatsolx

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
