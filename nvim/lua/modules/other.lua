return {
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = {
      { 'junegunn/fzf', build = ':call fzf#install()' },
    },
  },

  {
    'kevinhwang91/nvim-fundo',
    dependencies = 'kevinhwang91/promise-async',
    build = function()
      require('fundo').install()
    end,
    event = { 'BufReadPre' },
    config = function()
      vim.o.undofile = true
      require('fundo').setup()
    end,
  },

  {
    'kevinhwang91/nvim-hlslens',
    branch = 'main',
    keys = { '*', '#', 'n', 'N' },
    config = function()
      require('configs.hlslens')
    end,
  },

  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre' },
    config = function()
      require('configs.lint')
    end,
  },

  {
    'stevearc/conform.nvim',
    config = function()
      require('configs.conform')
    end,
  },

  {
    'TheBlob42/houdini.nvim',
    event = 'VeryLazy',
    config = function()
      require('configs.houdini')
    end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    event = 'VeryLazy',
    config = function()
      require('configs.harpoon')
    end,
  },

  {
    'AndrewRadev/simple_bookmarks.vim',
    event = { 'VimEnter' },
    config = function()
      vim.keymap.set('n', '<leader>ba', ':BookmarkAdd<space>')
      vim.keymap.set('n', '<leader>bg', ':BookmarkGo<space>')
      vim.keymap.set('n', '<leader>bx', ':BookmarkDel<space>')
      vim.keymap.set('n', '<leader>bl', ':BookmarkQf<CR>')
    end,
  },

  {
    'ojroques/nvim-bufdel',
    event = { 'BufReadPost' },
    config = function()
      require('bufdel').setup({ next = 'alternate', quit = false })
      vim.keymap.set('n', '<leader>bd', '<CMD>BufDelOthers<CR>')
      vim.keymap.set('n', '<leader>bq', '<CMD>BufDelAll<CR>')
    end,
  },
}
