-- enable loader
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

-- Load default colorscheme
-- vim.cmd.colorscheme("default")
