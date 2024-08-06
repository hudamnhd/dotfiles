-- stylua: ignore start
return {
  { "stefandtw/quickfix-reflector.vim", ft = "qf" },
  { "cohama/agit.vim", cmd = { "Agit", "AgitFile" } },
  { "kshenoy/vim-signature",      event = "VeryLazy"},
  { "haya14busa/vim-asterisk",    event = "VeryLazy" },
  { "LeafCage/yankround.vim",     event = "VeryLazy" },
  { "Shougo/unite.vim",           event = "VeryLazy" },
  { "wellle/targets.vim",         event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim",   event = "VeryLazy" },
  { "tpope/vim-eunuch",           event = "VeryLazy" },
  { "tpope/vim-rsi",              event = "VeryLazy" },
  { "tpope/vim-git",              event = "VeryLazy" },
  { "tpope/vim-repeat",           event = "VeryLazy" },
  { "mbbill/undotree",            event = "BufReadPost" },
  { 'romainl/vim-cool',           event = "BufReadPost" },
  { "haya14busa/vim-edgemotion",  event = "BufReadPost" },
  -- { "nvim-lua/plenary.nvim" },
  -- stylua: ignore end
}
