require('nvim-treesitter.configs').setup({
  disable = { 'bigfile' },
  auto_install = true,
  ensure_installed = {
    'bash',
    'c',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
  },
  highlight = { enable = true },
  incremental_selection = { enable = false },
  textobjects = { enable = false },
  indent = { enable = false },
})

-- Disable injections in 'lua' language
local ts_query = require('vim.treesitter.query')
local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
ts_query_set('lua', 'injections', '')
