return {
  "tpope/vim-fugitive",
  dependencies = {
    {
      "junegunn/gv.vim",
      cmd = { "GV" },
    },
  },
  keys = {
    {
      "<space>gh",
      vim.cmd.Git,
      mode = { "n" },
      desc = "Git",
    },
  },
  config = function()
    vim.keymap.set("n", "\\gu", "<cmd>diffget //2<CR>", { desc = "diffget 2" })
    vim.keymap.set("n", "\\gh", "<cmd>diffget //3<CR>", { desc = "diffget 3" })
  end,
}
