require('blink.cmp').setup({
  enabled = function() return not vim.tbl_contains({ 'bigfile' }, vim.bo.filetype) end,
  cmdline = {
    enabled = false,
  },
  keymap = { preset = 'super-tab' },

  completion = { documentation = { auto_show = false } },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lsp = { fallbacks = {} },
      snippets = {
        -- don't show when triggered manually (= length 0), useful
        -- when manually showing completions to see available fields
        min_keyword_length = 1,
        score_offset = 3,
        opts = { clipboard_register = '+' }, -- register to use for `$CLIPBOARD`
      },
      path = {
        opts = { get_cwd = vim.uv.cwd },
      },
      buffer = {
        max_items = 4,
        min_keyword_length = 3,
        score_offset = -7,
      },
    },
  },
  appearance = {
    nerd_font_variant = 'mono',
    -- make lsp icons different from the corresponding similar blink sources
    kind_icons = {
      Text = '󰉿', -- `buffer`
      Snippet = '󰞘', -- `snippets`
      File = '', -- `path`
      Module = '', -- prettier braces
    },
  },

  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
