require('rose-pine').setup({
  dim_inactive_windows = false,
  extend_background_behind_borders = true,

  enable = {
    terminal = true,
    legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
    migrations = true, -- Handle deprecated options automatically
    transparency = false, -- Handle deprecated options automatically
  },

  styles = {
    bold = true,
    italic = false,
    transparency = false,
  },

  palette = {
    -- Override the builtin palette per variant
    moon = {
      _nc = '#16141f',
      base = '#191724',
      surface = '#1f1d2e',
      overlay = '#26233a',
      pine = '#5db5da',
      highlight_low = '#21202e',
      highlight_med = '#403d52',
      highlight_high = '#524f67',
    },
  },

  -- NOTE: Highlight groups are extended (merged) by default. Disable this
  -- per group via `inherit = false`
  highlight_groups = {
    Cursor = { bg = 'text' },
    Normal = { bg = 'none' },
    NormalNC = { bg = 'none' },
    NormalFloat = { bg = 'none' },
    FloatBorder = { bg = 'none' },
    MiniClueTitle = { bg = 'none' },
    Pmenu = { bg = 'none' },
    PmenuKind = { bg = 'none' },
    FzfLuaBorder = { bg = 'none' },
    BlinkCmpLabel = { fg = 'subtle' },
    MiniJump2dSpot = { bg = 'gold', fg = '_nc' },
    MiniJump2dSpotUnique = { bg = 'gold', fg = '_nc' },
    SignatureMarkLine = { bg = 'text', fg = '_nc' },
    -- StatusLine = { bg = '#1e1e1e', fg = 'subtle' },
    -- StatusLineTerm = { bg = '#1e1e1e', fg = 'subtle' },
    -- StatusLine = { fg = "love", bg = "love", blend = 15 },
    -- VertSplit = { fg = "muted", bg = "muted" },
    -- Visual = { fg = "base", bg = "text", inherit = false },
  },
})
vim.cmd('colo rose-pine-moon')
