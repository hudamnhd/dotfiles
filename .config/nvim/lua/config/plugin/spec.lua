local function is_enable(plug) return config.plugin[plug] or false end

-- See :help Deps-plugin-specification
return {
  -- Setup Lsp
  {
    source = 'neovim/nvim-lspconfig',
    enable = is_enable('lsp'),
    config = function() require('config.plugin.nvim-lspconfig') end,
  },

  -- Auto completion
  -- See :help blink-cmp-installation-mini.deps
  {
    source = 'saghen/blink.cmp',
    enable = is_enable('completion'),
    checkout = 'v1.3.1',
    config = function() require('config.plugin.blink') end,
  },

  -- Picker
  {
    source = 'ibhagwan/fzf-lua',
    enable = is_enable('picker'),
    config = function() require('config.plugin.fzf-lua') end,
  },

  -- Formatter
  {
    source = 'stevearc/conform.nvim',
    enable = is_enable('formatter'),
    config = function() require('config.plugin.conform') end,
  },

  -- Colorscheme
  {
    source = 'rose-pine/neovim',
    name = 'rose-pine',
    enable = is_enable('colorscheme'),
    lazy = false,
    config = function() require('config.plugin.rose-pine') end,
  },

  -- Tree-sitter (advanced syntax parsing, highlighting, textobjects)
  {
    source = 'nvim-treesitter/nvim-treesitter',
    enable = is_enable('treesitter'),
    checkout = 'main',
    lazy = false,
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
    config = function() require('config.plugin.nvim-treesitter') end,
  },
  {
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    enable = is_enable('treesitter'),
    lazy = false,
    checkout = 'main',
  },

  -- Motion
  {
    source = 'haya14busa/vim-edgemotion',
    config = function()
      vim.keymap.set('', '<c-j>', '<Plug>(edgemotion-j)', {})
      vim.keymap.set('', '<c-k>', '<Plug>(edgemotion-k)', {})
    end,
  },

  {
    source = 'thinca/vim-partedit',
    config = function() vim.keymap.set('v', '<CR>', ":Partedit -opener new  -prefix '>'<CR>", {}) end,
  },
}
