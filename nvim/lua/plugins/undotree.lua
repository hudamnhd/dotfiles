return {
  "mbbill/undotree",
  event = { "BufReadPost" },
  config = function()
    vim.g.undotree_WindowLayout = 2
    vim.keymap.set("n", "U", vim.cmd.UndotreeToggle, { desc = "Undotree Toggle" })
  end,
}
