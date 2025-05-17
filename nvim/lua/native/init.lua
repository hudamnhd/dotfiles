local M = {}
local U = require('native.utils')

--stylua: ignore start
local default_config = {
  core = {
    options  = true,
    keymaps  = true,
    autocmds = true,
    usercmds = true,
  },
  extras = {
    hlsearch   = true,
    netrw      = false,
    quickfix   = true,
    rsi        = true,
    substitute = true,
    toggleopts = true,
    zenmode    = true,
    rules      = true,
  },
  rules = {
    unmap_keys     = { 'q', 's', '<space>' },
    delimiter_keys = { ',', ';', '.' },
    no_yank_keys   = { 'c', 'x', '<s-s>', '<s-d>', '<s-c>' },
  },
}
--stylua: ignore end

M.setup = function(config)
  config = config and U.deep_merge(default_config, config) or default_config
  M.map = U.map
  M.augroup = U.augroup

  U.load_modules(config)

  -- Export module
  _G.NvimConfig = M
end

return M
