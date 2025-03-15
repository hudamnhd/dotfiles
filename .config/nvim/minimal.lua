vim.g.fzf_colors = {
  ["fg"] = { "fg", "Normal" },
  ["bg"] = { "bg", "Normal" },
  ["bg+"] = { "bg", "Visual" },
  ["hl"] = { "fg", "Identifier" },
  ["hl+"] = { "fg", "Identifier" },
  ["gutter"] = { "bg", "Normal" },
  ["info"] = { "fg", "Comment" },
  ["border"] = { "fg", "LineNr" },
  ["prompt"] = { "fg", "Function" },
  ["pointer"] = { "fg", "Exception" },
  ["marker"] = { "fg", "WarningMsg" },
  ["spinner"] = { "fg", "WarningMsg" },
  ["header"] = { "fg", "Comment" },
}

-- stylua: ignore start
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/mini.nvim]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/oil.nvim]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/fzf-lua]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/quickfix-reflector.vim]])
vim.cmd([[set rtp+=~/.local/share/nvim/lazy/vim-rsi]])

-- Load configuration files
require("vscript")
require("options")
require("autocmd")
require("keymaps")
require("utils.buffers")
require("plugins.mini").config()
require("plugins.fzf-lua").config()
require("plugins.oil").config()
require("plugins.dirvish")
require("mini.statusline").setup()
require("mini.completion").setup()

-- Move inside completion list with <TAB>
vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

vim.cmd("colorscheme default")
-- stylua: ignore end
