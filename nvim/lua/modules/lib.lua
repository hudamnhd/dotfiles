return {
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },

  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    enabled = vim.g.modern_ui or false,
    config = function()
      require('configs.nvim-web-devicons')
    end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- If it complains 'fzf doesn't exists, run 'make' inside
    -- the root folder of this plugin
    build = 'make',
    lazy = true,
    dependencies = 'nvim-lua/plenary.nvim',
  },
}