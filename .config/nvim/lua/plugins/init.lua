return {
  {
    "nvimdev/indentmini.nvim",
    event = { "BufReadPost" },
    config = function()
      require("indentmini").setup() -- use default config
      vim.cmd.highlight("IndentLine guifg=#45475a")
      vim.cmd.highlight("IndentLineCurrent guifg=#9CABCA")
    end,
  },
  {
    "thinca/vim-partedit",
    keys = { { "<CR>", ":Partedit -opener vnew -filetype vimpe -prefix '>'<CR>", mode = { "x" } } },
  },
  {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = function()
      require("live-server").setup()
    end,
  },
  {
    "hudamnhd/search-replace.nvim",
    event = { "BufReadPost" },
    config = function()
      require("search-replace").setup({
        default_replace_single_buffer_options = "g",
      })
    end,
  },
-- stylua: ignore start
  { "cohama/agit.vim",            cmd = { "Agit", "AgitFile" } },
  { "kshenoy/vim-signature",      event = "VeryLazy" },
  { "haya14busa/vim-asterisk",    event = "VeryLazy" },
  { "LeafCage/yankround.vim",     event = "VeryLazy" },
  { "Shougo/unite.vim",           event = "VeryLazy" },
  { "wellle/targets.vim",         event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim",   event = "VeryLazy" },
  { "tpope/vim-eunuch",           event = "VimEnter" },
  { "tpope/vim-rsi",              event = "VimEnter" },
  { "mbbill/undotree",            event = "BufReadPost" },
  { 'romainl/vim-cool',           event = "BufReadPost" },
  { "haya14busa/vim-edgemotion",  event = "BufReadPost" },
  -- { "nvim-tree/nvim-web-devicons" },
  -- { "nvim-lua/plenary.nvim" },
  -- stylua: ignore end
}
