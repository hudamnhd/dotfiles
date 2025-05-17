-------------------------------------------------------------------------------
-- Usercommands ================================================================
-------------------------------------------------------------------------------
local usercmd, git_root = require('native.utils').usercmd, require('native.utils').git_root

-- Remove all buffers except the current one.
usercmd('BuffClean', function()
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

-- Create scratch buffer.
usercmd('Scratch', function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end, {
  desc = 'New scratch buffer',
})

-- Open terminal in split with root directory.
usercmd('T', function()
  vim.cmd('belowright new')
  vim.fn.jobstart(vim.o.shell, {
    term = true,
    on_exit = function()
      vim.cmd('silent! :checktime')
      vim.cmd('silent! :bw')
    end,
  })
end, {
  desc = 'Open terminal in split with root directory',
})

-- Open terminal in split with buffer's directory.
usercmd('BT', function()
  local term_dir = vim.fn.expand('%:p:h')
  vim.cmd('belowright new')
  vim.fn.jobstart(vim.o.shell, {
    cwd = term_dir,
    term = true,
    on_exit = function()
      vim.cmd('silent! :checktime')
      vim.cmd('silent! :bw')
    end,
  })
end, {
  desc = "Open terminal in split with buffer's directory",
})

-- Smart change pwd
vim.api.nvim_create_user_command('Cd', function(info)
  local pwd = info.fargs[1]
  if not pwd then
    local parent = vim.fn.expand('%:h')
    pwd = git_root(parent, true) or parent
  end
  if vim.loop.fs_stat(pwd) then
    vim.cmd('cd ' .. pwd)
    vim.notify(('pwd set to %s'):format(vim.fn.shellescape(pwd)), vim.log.levels.INFO, {})
  else
    vim.notify(('pwd set to %s'):format(vim.fn.shellescape(pwd)), vim.log.levels.WARN, {})
  end
end, {
  nargs = '?',
  complete = 'dir',
  desc = 'Change pwd.',
})

local function insert_section(symbol, total_width)
  symbol = symbol or '='
  total_width = total_width or 79

  local comment_string = vim.bo.commentstring
  local content = string.rep(symbol, total_width - (comment_string:len() - 2))
  local section_template = comment_string:format(content)
  vim.fn.append(vim.fn.line('.'), section_template)

  local inner_start = comment_string:find('%%s')
  vim.fn.cursor(vim.fn.line('.') + 1, inner_start)
  vim.cmd([[startreplace]])
end

-- :InsertSection - 60
usercmd('InsertSection', function(opts)
  local symbol = opts.args:match('%S+') or '='
  local total_width = tonumber(opts.args:match('%d+')) or 79
  insert_section(symbol, total_width)
end, {
  nargs = '*',
  complete = function() return { '=', '-', '*', '#', '~' } end,
  desc = 'Insert comment section line',
})
