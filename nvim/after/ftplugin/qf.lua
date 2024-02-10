-- If is quickfix list, always open it at the bottom of screen
if vim.fn.win_gettype() == 'quickfix' then
  vim.cmd.wincmd('J')
  vim.cmd('highlight link qfLineNr WarningMsg')
  vim.cmd('highlight! link QuickFixLine CursorLine')
end

vim.bo.buflisted = false
vim.opt_local.list = false
vim.opt_local.spell = false
vim.opt_local.rnu = false
vim.opt_local.signcolumn = 'no'
vim.opt_local.statuscolumn = ''

-- stylua: ignore start
vim.keymap.set('n', 'q',     '<cmd>Bq<cr>',      { buffer = true })
vim.keymap.set('n', '=',     '<CR>zz<C-w>p', { buffer = true })
vim.keymap.set('n', '<C-j>', 'j<CR>zz<C-w>p', { buffer = true })
vim.keymap.set('n', '<C-k>', 'k<CR>zz<C-w>p', { buffer = true })
-- stylua: ignore end

-- Provides `:Cfilter` and `:Lfilter` commands
vim.cmd.packadd({
  args = { 'cfilter' },
  mods = { emsg_silent = true },
})
