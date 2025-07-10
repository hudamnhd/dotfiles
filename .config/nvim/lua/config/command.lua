--------------------------------------------------------------------------------
-- User Command                                   See :lua-guide-commands-create
--------------------------------------------------------------------------------

vim.cmd('command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen')
vim.cmd('command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen')

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir

-- remove all buffers except the current one
vim.api.nvim_create_user_command('BufClean', function()
  local cur = vim.api.nvim_get_current_buf()

  local deleted, modified = 0, 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value('modified', { buf = buf }) then
      modified = modified + 1
    elseif buf ~= cur and vim.api.nvim_get_option_value('modifiable', { buf = buf }) then
      vim.api.nvim_buf_delete(buf, { force = true })
      deleted = deleted + 1
    end
  end

  vim.notify(('%s deleted, %s modified'):format(deleted, modified), vim.log.levels.WARN, {})
end, {
  desc = 'Remove all buffers except the current one.',
})

-- scratch buffer
vim.api.nvim_create_user_command(
  'Scratch',
  function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end,
  {
    desc = 'New scratch buffer',
  }
)

-- diff toggle
vim.api.nvim_create_user_command('Difftoggle', function()
  if vim.wo.diff then
    vim.cmd('windo diffoff')
    vim.cmd('windo set nowrap')
  else
    vim.cmd('windo diffthis')
    vim.cmd('windo set wrap')
  end
end, {
  desc = 'toggle diff',
})

--------------------------------------------------------------------------------
