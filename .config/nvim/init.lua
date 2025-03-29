-- enable loader

-- Load default colorscheme
vim.cmd.colorscheme("custom")

vim.loader.enable()
-- disable treesitter
-- vim.treesitter.stop()
require("lazyplug")
-- Load configuration files
require("vscript")
require("options")
require("autocmd")
require("keymaps")
require("mru")
require("utils.buffers")
