local ensure_installed = {
  'bash',
  'blade',
  'c',
  'cpp',
  'css',
  'diff',
  'go',
  'html',
  'javascript',
  'json',
  'php',
  'php_only',
  'python',
  'markdown',
  'regex',
  'toml',
  'tsx',
  'yaml',
}
local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
if #to_install > 0 then require('nvim-treesitter').install(to_install) end

-- Ensure enabled
local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()
local ts_start = function(ev) vim.treesitter.start(ev.buf) end
vim.api.nvim_create_autocmd('FileType', { pattern = filetypes, callback = ts_start })

-- Disable injections in 'lua' language
local ts_query = require('vim.treesitter.query')
local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
ts_query_set('lua', 'injections', '')
