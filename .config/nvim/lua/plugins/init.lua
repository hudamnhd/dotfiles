vim.g.Eunuch_find_executable = "fd ."
vim.g.chadtree_settings = {}

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
  {
    "justinmk/vim-sneak",
    event = { "BufReadPost" },
    config = function()
      vim.cmd([[
        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
        map t <Plug>Sneak_t
        map T <Plug>Sneak_T
      ]])
    end,
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>s",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
    config = function()
      require("rip-substitute").setup({
        prefill = {
          startInReplaceLineIfPrefill = true,
        },
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
  { "RRethy/vim-eunuch",          event = "VeryLazy" },
  { "tpope/vim-rsi",              event = "VeryLazy" },
  { "tpope/vim-git",              event = "VeryLazy" },
  { "tpope/vim-repeat",           event = "VeryLazy" },
  { "mbbill/undotree",            event = "BufReadPost" },
  { 'romainl/vim-cool',           event = "BufReadPost" },
  { "haya14busa/vim-edgemotion",  event = "BufReadPost" },
  -- { "nvim-lua/plenary.nvim" },
  -- stylua: ignore end
}
