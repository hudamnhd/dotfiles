-- See :help Deps-plugin-specification
return {
  -- Setup Lsp
  {
    source = 'neovim/nvim-lspconfig',
    config = function() require('config.plugin.nvim-lspconfig') end,
  },

  -- Auto completion
  -- See :help blink-cmp-installation-mini.deps
  {
    source = 'saghen/blink.cmp',
    checkout = 'v1.3.1',
    config = function() require('config.plugin.blink') end,
  },

  {
    source = 'linrongbin16/fzfx.nvim',
    checkout = 'v7.2.1',
    config = function() require('fzfx').setup() end,
  },

  -- Picker
  {
    source = 'ibhagwan/fzf-lua',
    config = function() require('config.plugin.fzf-lua') end,
  },
  {
    source = 'michel-garcia/fzf-lua-file-browser.nvim',
    config = function() require('fzf-lua-file-browser').setup() end,
  },

  -- Git wrapper
  {
    source = 'tpope/vim-fugitive',
    config = function() require('config.plugin.vim-fugitive') end,
  },

  -- Formatter
  {
    source = 'stevearc/conform.nvim',
    config = function() require('config.plugin.conform') end,
  },

  -- Colorscheme
  {
    source = 'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    config = function() require('config.plugin.rose-pine') end,
  },

  -- Tree-sitter (advanced syntax parsing, highlighting, textobjects)
  {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
    config = function() require('config.plugin.nvim-treesitter') end,
  },
  { source = 'nvim-treesitter/nvim-treesitter-textobjects' },

  -- movement
  {
    source = 'haya14busa/vim-edgemotion',
    config = function()
      vim.keymap.set('', '<c-j>', '<Plug>(edgemotion-j)', {})
      vim.keymap.set('', '<c-k>', '<Plug>(edgemotion-k)', {})
    end,
  },

  -- tools
  {
    source = 'thinca/vim-partedit',
    config = function()
      vim.keymap.set('v', '<CR>', ":Partedit -opener new -filetype vimpe -prefix '>'<CR>", {})
    end,
  },
  { source = 'kana/vim-grex' },
  { source = 'kana/vim-tabpagecd' },
  { source = 'tyru/capture.vim' },
  {
    source = 'thinca/vim-qfreplace',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'qf',
        desc = 'Quicfix replacer',
        callback = function() vim.keymap.set('n', 'r', '<Cmd>Qfreplace<CR>', { buffer = true }) end,
      })
    end,
  },
}

