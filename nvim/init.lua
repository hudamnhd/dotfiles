vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.cmd.colorscheme("custom")

require("misc")
require("mru")
require("lazyplug")
