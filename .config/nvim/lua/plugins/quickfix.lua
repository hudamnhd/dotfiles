-- vim.keymap.set("n", "<leader>gw", "<cmd>cclose | Grep <cword><CR>", { desc = "Grep for word" })
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
}
