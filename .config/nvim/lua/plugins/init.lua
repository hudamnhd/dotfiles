return {
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    config = function()
      require("early-retirement").setup({
        retirementAgeMins = 5,
        ignoredFiletypes = { "lazy" },
        notificationOnAutoClose = false,
        ignoreAltFile = true,
        minimumBufferNum = 1,
        ignoreUnsavedChangesBufs = true,
        ignoreSpecialBuftypes = true,
        ignoreVisibleBufs = true,
        ignoreUnloadedBufs = false,
        ignoreFilenamePattern = "",
        deleteBufferWhenFileDeleted = false,
      })
    end,
  },
  {
    "danymat/neogen",
    event = "BufReadPost",
    config = function()
      require("neogen").setup({})
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n", "sn", ":lua require('neogen').generate()<CR>", opts)
    end,
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "stefandtw/quickfix-reflector.vim", ft = "qf" },
  { "LeafCage/yankround.vim", event = "VeryLazy" },
  { "rktjmp/lush.nvim", event = "VeryLazy" },
  { "Shougo/unite.vim", event = "VeryLazy" },
  { "wellle/targets.vim", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim", event = "VeryLazy" },
  { "tpope/vim-vinegar", event = "VeryLazy" },
  { "tpope/vim-eunuch", event = "VeryLazy" },
  { "leafgarland/typescript-vim", event = "VeryLazy" },
  { "tpope/vim-rsi", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "mbbill/undotree", event = "BufReadPost" },
  { "haya14busa/vim-edgemotion", event = "BufReadPost" },
  -- {
  --   "grecodavide/file_browser.nvim",
  --   lazy = true,
  --   config = function()
  --     require("file_browser").setup({
  --       width_scale = 0.9,
  --       height_scale = 0.8,
  --       mappings = {
  --         {
  --           mode = "i",
  --           lhs = "<C-r>",
  --           callback = "rename",
  --         },
  --       },
  --     })
  --   end,
  --   -- I like to have <leader>fe to open file browser in the same path as current file, and <leader>fE in the CWD
  --   keys = {
  --     {
  --       "<c-p>",
  --       function()
  --         require("file_browser").open(vim.fn.expand("%:p:h"))
  --       end,
  --
  --       desc = "[F]ile [E]xplorer current file",
  --     },
  --     {
  --       "<a-p>",
  --       function()
  --         require("file_browser").open()
  --       end,
  --
  --       desc = "[F]ile [E]xplorer CWD",
  --     },
  --   },
  -- },
  {
    "Dan7h3x/LazyDo",
    branch = "main",
    keys = { -- recommended keymap for easy toggle LazyDo in normal and insert modes (arbitrary)
      {
        "<F3>",
        "<ESC><CMD>LazyDoToggle<CR>",
        mode = { "n", "i" },
      },
    },
    event = "VeryLazy",
    config = function()
      return require("lazydo").setup()
    end,
  },
}
