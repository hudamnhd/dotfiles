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

---remove all trailing whitespaces within the current buffer
---retain cursor position & last search content
vim.api.nvim_create_user_command('Trailspace', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local last_search = vim.fn.getreg('/')
  local hl_state = vim.v.hlsearch

  vim.cmd(':%s/\\s\\+$//e')

  vim.fn.setreg('/', last_search) -- restore last search
  vim.api.nvim_win_set_cursor(0, pos) -- restore cursor position
  if hl_state == 0 then
    vim.cmd.nohlsearch() -- disable search highlighting again if it was disabled before
  end
end, {
  desc = 'remove all trailing whitespaces within the current buffer',
})

-- diff toggle
vim.api.nvim_create_user_command('Difftoggle', function()
  if vim.wo.diff then
    vim.cmd('windo diffoff')
  else
    vim.cmd('windo diffthis')
    vim.cmd('windo set wrap')
  end
end, {
  desc = 'toggle diff',
})

-- zoom toggle
vim.api.nvim_create_user_command('Zoom', function()
  vim.cmd('normal! ' .. '|')

  if vim.fn.winnr('$') == 1 then return end

  local restore_cmd = vim.fn.winrestcmd()
  vim.cmd('wincmd |')
  vim.cmd('wincmd _')

  if vim.g.zoom_restore then
    vim.cmd(vim.g.zoom_restore)
    vim.g.zoom_restore = nil
  elseif vim.fn.winrestcmd() ~= restore_cmd then
    vim.g.zoom_restore = restore_cmd
  end
end, {
  desc = 'toggle zoom split',
})

--------------------------------------------------------------------------------
