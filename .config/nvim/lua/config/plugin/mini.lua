return {
  -- Text editing
  require('config.plugin.mini-surround'),

  { module = 'mini.align', config = true }, -- See :help MiniAlign-examples
  { module = 'mini.comment', config = true },
  {
    module = 'mini.ai',
    opts = {},
    config = function()
      vim.keymap.set({ 'x', 'o' }, 'q', 'iq', { remap = true })
      vim.keymap.set({ 'x', 'o' }, 'Q', 'aq', { remap = true })
      vim.keymap.set({ 'x', 'o' }, 'w', 'iw', { remap = true })
      vim.keymap.set({ 'x', 'o' }, 'W', 'iW', { remap = true })
    end,
  },
  { module = 'mini.operators', opts = { sort = { prefix = 'gz' } } },
  {
    module = 'mini.pairs',
    --See :help MiniPairs.config
    opts = {
      mappings = {
        ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
        ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },
      },
    },
  },
  { module = 'mini.move', opts = { options = { reindent_linewise = false } } },
  { module = 'mini.splitjoin', opts = { mappings = { toggle = '<Leader>cj' } } },

  -- General workflow
  require('config.plugin.mini-jump2d'),
  require('config.plugin.mini-files'),
  require('config.plugin.mini-clue'),
  require('config.plugin.mini-sessions'),

  { module = 'mini.bracketed', config = true },
  { module = 'mini.extra', config = true },
  { module = 'mini.visits', config = true },
  {
    module = 'mini.jump',
    opts = { mappings = { repeat_jump = ',' } },
  },
  {
    module = 'mini.bufremove',
    opts = {},
    config = function()
      vim.keymap.set('n', '<Leader>bd', '<Cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete buffer' })
      vim.keymap.set('n', '<Leader>bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', { desc = 'Wipeout buffer' })
    end,
  },
  {
    module = 'mini.diff',
    -- See :help MiniDiff.config
    opts = {
      view = {
        style = 'sign',
        signs = { add = '+', change = '~', delete = '-' },
      },
    },
  },

  -- Appearance
  require('config.plugin.mini-notify'),
  require('config.plugin.mini-starter'),
  require('config.plugin.mini-tabline'),
  require('config.plugin.mini-hipatern'),

  { module = 'mini.statusline', lazy = false, config = false },
  { module = 'mini.icons', config = true },
  { module = 'mini.indentscope', config = true },
  { module = 'mini.colors', config = true },
  {
    module = 'mini.trailspace',
    opts = {},
    config = function()
      vim.keymap.set('n', '<Leader>ct', '<Cmd>lua MiniTrailspace.trim()<CR>', { desc = 'Code Trim trailspace' })
    end,
  },
}
