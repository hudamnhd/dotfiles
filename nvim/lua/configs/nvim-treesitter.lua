local ts_configs = require('nvim-treesitter.configs')

-- Set treesitter folds
-- vim.api.nvim_create_autocmd('FileType', {
--   group = vim.api.nvim_create_augroup('TSFolds', {}),
--   callback = function(info)
--     -- Treesitter folding is extremely slow in large markdown files,
--     -- making typing and undo lag as hell
--     if info.match == 'markdown' then
--       return
--     end
--     vim.api.nvim_buf_call(info.buf, function()
--       local o = vim.opt_local
--       local fdm = o.fdm:get() ---@diagnostic disable-line: undefined-field
--       local fde = o.fde:get() ---@diagnostic disable-line: undefined-field
--       local fdt = o.fdt:get() ---@diagnostic disable-line: undefined-field
--       o.fdm = o.fdm:get() == 'manual' and 'expr' or fdm
--       o.fde = o.fde:get() == '0' and 'nvim_treesitter#foldexpr()' or fde
--       o.fdt = o.fdt:get() == 'foldtext()' and 'v:lua.vim.treesitter.foldtext()'
--         or fdt
--     end)
--   end,
-- })

---@diagnostic disable-next-line: missing-fields
ts_configs.setup({
  -- Make sure that we install all parsers shipped with neovim so that we don't
  -- end with using nvim-treesitter's queries and neovim's shipped parsers, which
  -- are incompatible with each other,
  -- see https://github.com/nvim-treesitter/nvim-treesitter/issues/3092
  ensure_installed = {
    -- Parsers shipped with neovim
    'c',
    'lua',
    'vim',
    'bash',
    'query',
    'python',
    'html',
    'php',
    'vimdoc',
    'markdown',
    'markdown_inline',
    -- Additional parsers
    'cpp',
    'make',
    'python',
  },
  sync_install = false,
  ignore_install = {},
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = {}, -- optional, list of language that will be disabled
  },
  highlight = {
    -- enable = not vim.g.vscode,
    enable = false,
    -- disable = function(ft, buf)
    --   -- We will manually apply treesitter highlighting in markdown
    --   -- files in syntax/markdown.vim to get better inline code
    --   -- highlighting while still preserving math conceal provided
    --   -- by vimtex regex syntax rules
    --   return ft == 'markdown'
    --     or ft == 'tex'
    --     or vim.b[buf].midfile == true
    --     or vim.fn.win_gettype() == 'command'
    -- end,
    additional_vim_regex_highlighting = false,
  },
  endwise = {
    enable = true,
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      scope_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
  textobjects = {
    select = {
      enable = false,
      lookahead = false, -- Automatically jump forward to textobj
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['am'] = '@function.outer',
        ['im'] = '@function.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['ak'] = '@class.outer',
        ['ik'] = '@class.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['a/'] = '@comment.outer',
        ['a*'] = '@comment.outer',
        ['ao'] = '@block.outer',
        ['io'] = '@block.inner',
        ['a?'] = '@conditional.outer',
        ['i?'] = '@conditional.inner',
      },
    },
    move = {
      enable = false,
      set_jumps = false, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']l'] = '@loop.outer',
        [']]'] = '@function.outer',
        [']k'] = '@class.outer',
        [']a'] = '@parameter.outer',
        [']o'] = '@block.outer',
        [']?'] = '@conditional.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']L'] = '@loop.outer',
        [']['] = '@function.outer',
        [']K'] = '@class.outer',
        [']A'] = '@parameter.outer',
        [']/'] = '@comment.outer',
        [']*'] = '@comment.outer',
        [']O'] = '@block.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[l'] = '@loop.outer',
        ['[['] = '@function.outer',
        ['[k'] = '@class.outer',
        ['[a'] = '@parameter.outer',
        ['[/'] = '@comment.outer',
        ['[*'] = '@comment.outer',
        ['[o'] = '@block.outer',
        ['[?'] = '@conditional.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[L'] = '@loop.outer',
        ['[]'] = '@function.outer',
        ['[K'] = '@class.outer',
        ['[A'] = '@parameter.outer',
        ['[O'] = '@block.outer',
      },
    },
    swap = {
      enable = false,
      swap_next = {
        ['<M-C-L>'] = '@parameter.inner',
      },
      swap_previous = {
        ['<M-C-H>'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = false,
      border = 'solid',
      peek_definition_code = {
        ['<Leader>K'] = '@function.outer',
      },
    },
  },
})
