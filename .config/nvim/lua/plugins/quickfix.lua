vim.keymap.set("n", "gw", "<cmd>cclose | Grep <cword><CR>", { desc = "Grep for word" })
return {
  -- {
  --   "thinca/vim-qfreplace",
  --   ft = "qf",
  --   config = function()
  --     vim.keymap.set("n", "<A-r>", "<CMD>Qfreplace<CR>")
  --   end,
  -- },
  {
    "stefandtw/quickfix-reflector.vim",
    ft = "qf",
  },
  {
    "stevearc/qf_helper.nvim",
    ft = "qf",
    keys = {
      { "[[", "<cmd>QFToggle!<CR>", desc = "Toggle [Q]uickfix" },
      { "]]", "<cmd>LLToggle!<CR>", desc = "Toggle [L]oclist" },
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
