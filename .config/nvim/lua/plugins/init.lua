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
      -- vim.api.nvim_set_keymap("n", "<space>n", ":lua require('neogen').generate()<CR>", opts)
    end,
  },
  {
    "haya14busa/vim-edgemotion",
    event = "BufReadPost",
    config = function()
      vim.cmd([[
      map <C-J> <Plug>(edgemotion-j)
      map <C-K> <Plug>(edgemotion-k)
    ]])
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

  {
    "pteroctopus/faster.nvim",
    event = "BufReadPost",
    init = function()
      require("faster").setup()
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
  { "RRethy/nvim-align", event = "BufReadPost" },
  { "mbbill/undotree", event = "BufReadPost" },
}
