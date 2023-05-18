-- custom auto comman disini

vim.cmd([[
augroup NeovimStartup
  autocmd!
  autocmd BufWinEnter * set colorcolumn=0
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END
]])
