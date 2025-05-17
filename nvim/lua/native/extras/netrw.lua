-------------------------------------------------------------------------------
-- Netrw ======================================================================
-------------------------------------------------------------------------------
local augroup = require('native.utils').augroup

local function netrw_mapping()
  local bufmap = function(lhs, rhs)
    local opts = { buffer = true, remap = true, nowait = true }
    vim.keymap.set('n', lhs, rhs, opts)
  end

  -- close window
  bufmap('q', ':bd<cr>')

  -- Go back in history
  bufmap('H', 'u')

  -- Go up a directory
  bufmap('h', '-^')

  -- Open file/directory
  bufmap('l', '<cr>')

  -- Toggle dotfiles
  bufmap('.', 'gh')
end

augroup('NetrwMap', {
  { 'FileType' },
  {
    pattern = 'netrw',
    desc = 'Keybindings for netrw',
    callback = netrw_mapping,
  },
})

vim.keymap.set('n', '-', vim.cmd.Ex, {})
