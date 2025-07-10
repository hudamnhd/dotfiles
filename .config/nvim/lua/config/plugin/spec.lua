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

  -- Picker
  {
    source = 'ibhagwan/fzf-lua',
    config = function() require('config.plugin.fzf-lua') end,
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
  {
    source = 'folke/tokyonight.nvim',
    lazy = false,
    enable = false,
    config = function()
      require('tokyonight').setup({
        -- use the night style
        style = 'night',
        transparent = true,
        -- disable italic for functions
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
        },
        on_highlights = function(highlights, c)
          for _, defn in pairs(highlights) do
            if defn.undercurl then
              defn.undercurl = false
              defn.underline = true
            end
          end
          highlights.Comment = { fg = c.dark5 }
          highlights.TabLine = { fg = c.dark5 }
        end,
      })

      vim.cmd('colorscheme tokyonight')
    end,
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
  { source = 'kana/vim-grex' },
  { source = 'kana/vim-tabpagecd' },
  {
    source = 'thinca/vim-partedit',
    config = function() vim.keymap.set('v', '<CR>', ":Partedit -opener new -filetype vimpe -prefix '>'<CR>", {}) end,
  },
  {
    source = 'thinca/vim-qfreplace',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'qf',
        desc = 'Quicfix replacer',
        callback = function(ctx) vim.keymap.set('n', 'R', '<Cmd>Qfreplace<CR>', { buffer = ctx.buf }) end,
      })
    end,
  },
}
