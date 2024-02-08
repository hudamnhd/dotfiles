local ls = require('luasnip')

ls.setup()
require('luasnip.loaders.from_vscode').lazy_load({
  paths = vim.fn.stdpath('config') .. '/vscode-snippets',
})

ls.filetype_extend('lua', { 'lua' })
ls.filetype_extend('javascriptreact', { 'javascript', 'html' })
ls.filetype_extend('php', { 'html' })
ls.filetype_extend('typescript', { 'javascript' })
ls.filetype_extend(
  'typescriptreact',
  { 'javascriptreact', 'javascript', 'html' }
)
