return {
  "numToStr/Buffers.nvim",
  event = { "BufReadPost" },
  config = function()
    vim.keymap.set(
      "n",
      "<leader>x",
      '<CMD>lua require("Buffers").only()<CR>',
      { desc = "delete all buff not current" }
    )
    vim.keymap.set(
      "n",
      "<leader>X",
      '<CMD>lua require("Buffers").clear()<CR>',
      { desc = "delete all buff" }
    )
    vim.keymap.set(
      "n",
      "<leader>q",
      '<CMD>lua require("Buffers").delete()<CR>',
      { desc = "delete buff  current" }
    )
  end,
}
