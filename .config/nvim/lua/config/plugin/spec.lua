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
  {
    source = 'folke/tokyonight.nvim',
    lazy = false,
    enable = is_enable('colorscheme'),
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
