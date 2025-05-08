vim.api.nvim_create_user_command("BuffClean", function()
  local cur = vim.api.nvim_get_current_buf()

  local deleted, modified = 0, 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("modified", { buf = buf }) then
      modified = modified + 1
    elseif buf ~= cur and vim.api.nvim_get_option_value("modifiable", { buf = buf }) then
      vim.api.nvim_buf_delete(buf, { force = true })
      deleted = deleted + 1
    end
  end

  notify.warn(("%s deleted, %s modified"):format(deleted, modified))
end, {
  desc = "Remove all buffers except the current one.",
})

vim.api.nvim_create_user_command("Scratch", function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, {
  nargs = "?",
  complete = "dir",
  desc = "New scratch buffer",
})
