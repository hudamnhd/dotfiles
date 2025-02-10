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
  { "skim-rs/skim", event = "VeryLazy", dir = "~/skim", build = "./install" },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "stefandtw/quickfix-reflector.vim", ft = "qf" },
  { "LeafCage/yankround.vim", event = "VeryLazy" },
  { "Shougo/unite.vim", event = "VeryLazy" },
  { "wellle/targets.vim", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim", event = "VeryLazy" },
  { "tpope/vim-eunuch", event = "VeryLazy" },
  { "leafgarland/typescript-vim", event = "VeryLazy" },
  { "tpope/vim-rsi", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "mbbill/undotree", event = "BufReadPost" },
  { "haya14busa/vim-edgemotion", event = "BufReadPost" },
}
