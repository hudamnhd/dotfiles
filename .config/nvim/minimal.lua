-- stylua: ignore start
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/mini.nvim]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/oil.nvim]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/fzf-lua]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/rose-pine]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/quickfix-reflector.vim]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/vim-rsi]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/blink.cmp]])

-- Load configuration files
require("vscript")
require("options")
require("autocmd")
require("keymaps")
require("utils.buffers")
require("plugins.mini").config()
require("plugins.fzf-lua").config()
require("plugins.oil").config()
require('blink.cmp').setup()

vim.cmd("colorscheme rose-pine-moon")
-- stylua: ignore end
