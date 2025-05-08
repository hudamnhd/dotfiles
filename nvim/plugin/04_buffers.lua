local M = {}

local notify = function(msg)
  vim.notify("Buffers: " .. msg, vim.log.levels.WARN)
end

---Remove all buffers except the current one
function M.only()
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

  notify(("%s deleted, %s modified"):format(deleted, modified))
end

M.scratch = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

bind('n', '<c-g><c-t>', "<Cmd>lua MiniBracketed.buffer('first')<CR>")
bind('n', '<c-g><c-y>', "<Cmd>lua MiniBracketed.buffer('last')<CR>")
bind('n', '<c-t>', "<Cmd>lua MiniBracketed.buffer('backward')<CR>")
bind('n', '<c-y>', "<Cmd>lua MiniBracketed.buffer('forward')<CR>")

bind("n", "<space>bq", M.only, { desc = "buffer delete all" })
bind("n", "<space>bs", M.scratch, { desc = "buffer delete all" })
bind('n', '<space>bd', '<Cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete' })
bind('n', '<space>bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', { desc = 'Delete!' })
bind('n', '<space>bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', { desc = 'Wipeout' })
bind('n', '<space>bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', { desc = 'Wipeout!' })
