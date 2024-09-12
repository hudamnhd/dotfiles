-- statuscolumn
vim.api.nvim_create_autocmd({ "BufWritePost", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("StatusColumn", {}),
  desc = "Init statuscolumn plugin.",
  once = true,
  callback = function()
    require("plugin.statuscolumn").setup()
    return true
  end,
})

-- statusline
vim.go.statusline = [[%!v:lua.require'plugin.statusline'.get()]]

-- term
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TermSetup", {}),
  callback = function(info)
    require("plugin.term").setup(info.buf)
  end,
})
