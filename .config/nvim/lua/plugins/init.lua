return {
  {
    "thinca/vim-partedit",
    keys = { { "<CR>", ":Partedit -opener vnew -filetype vimpe -prefix '>'<CR>", mode = { "x" } } },
  },
  {
    "danymat/neogen",
    event = "BufReadPost",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          typescriptreact = {
            template = {
              annotation_convention = "tsdoc", -- for a full list of annotation_conventions, see supported-languages below,
            },
          },
        },
      })
      local opts = { noremap = true, silent = true, desc = "Toggle Neogen" }
      vim.api.nvim_set_keymap("n", "<space>n", ":lua require('neogen').generate()<CR>", opts)
    end,
  },
  {
    "Blovio/512-words",
    event = "BufReadPost",
    config = function()
      vim.keymap.set("n", "gW", function()
        require("512-words").open()
      end)
    end,
  },

  { "stefandtw/quickfix-reflector.vim", ft = "qf" },
  { "LeafCage/yankround.vim", event = "VeryLazy" },
  { "Shougo/unite.vim", event = "VeryLazy" },
  { "tpope/vim-eunuch", event = "VeryLazy" },
  { "tpope/vim-rsi", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "cohama/agit.vim", event = "BufReadPost" },
  { "tpope/vim-sleuth", event = "BufReadPost" },
  { "mbbill/undotree", event = "BufReadPost" },
  -- replace with mini ai
  -- { "wellle/targets.vim", event = "VeryLazy" },
}
