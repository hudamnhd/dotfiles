-- vim.keymap.set("n", "gw", "<cmd>cclose | Grep <cword><CR>", { desc = "Grep for word" })
return {
  {
    "stefandtw/quickfix-reflector.vim",
    ft = "qf",
  },
  {
    "thinca/vim-qfreplace",
    ft = "qf",
    config = function()
      vim.keymap.set("n", "<A-r>", "<CMD>Qfreplace<CR>")
    end,
  },
  {
    "stevearc/qf_helper.nvim",
    ft = "qf",
    keys = {
      { "<A-q>", "<cmd>QFToggle!<CR>", desc = "Toggle [Q]uickfix" },
      { "<A-a>", "<cmd>LLToggle!<CR>", desc = "Toggle [Q]uickfix" },
    },
    config = function()
      require("qf_helper").setup({
        prefer_loclist = false,
        quickfix = {
          default_bindings = false, -- Set up recommended bindings in qf window
        },
      })
    end,
  },
}
