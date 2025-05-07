vim.wo.scrolloff      = 0
vim.wo.wrap           = false
vim.wo.number         = true
vim.wo.relativenumber = false
vim.wo.linebreak      = true
vim.wo.list           = false
vim.wo.cursorline     = true
vim.wo.spell          = false
vim.bo.buflisted      = false

vim.keymap.set('n', 'q', vim.cmd.bd, { buffer = true })
