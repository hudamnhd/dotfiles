return {
  -- Lazy
  -- {
  --   "RRethy/base16-nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("base16-colorscheme").setup({
  --       base00 = "#000000",
  --       base01 = "#413f3f",
  --       base02 = "#5b5858",
  --       base03 = "#a7a4a4",
  --       base04 = "#a7a4a4",
  --       base05 = "#ffffff",
  --       base06 = "#c2c983",
  --       base07 = "#c2c983",
  --       base08 = "#ffffff",
  --       base09 = "#fb923c",
  --       base0A = "#e5c07b",
  --       base0B = "#c2c983",
  --       base0C = "#38bdf8",
  --       base0D = "#38bdf8",
  --       base0E = "#fb923c",
  --       base0F = "#fb923c",
  --     })
  --   end,
  -- },
  {
    "2kabhishek/tdo.nvim",
    cmd = { "Tdo", "TdoEntry", "TdoNote", "TdoTodos", "TdoToggle", "TdoFind", "TdoFiles" },
    keys = { "[t", "]t" },
  },

  {
    "mong8se/buffish.nvim",
    event = "VeryLazy",
    config = function() end,
  },
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
