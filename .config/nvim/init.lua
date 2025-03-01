-- enable loader
vim.loader.enable()

-- disable treesitter
-- vim.treesitter.stop()

require("lazyplug")

-- Load configuration files
require("options")
require("autocmd")
require("keymaps")
require("vscript")

-- Load default colorscheme
-- vim.cmd.colorscheme("tokyonight")
