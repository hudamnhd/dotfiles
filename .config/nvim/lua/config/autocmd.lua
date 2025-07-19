--------------------------------------------------------------------------------
-- Autocommands                               See `:help lua-guide-autocommands`
--------------------------------------------------------------------------------
vim.api.nvim_create_augroup('UserCmds', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'UserCmds',
  desc = 'Highlighted yank',
  callback = function() vim.hl.on_yank({ timeout = 100 }) end,
})

-- https://github.com/mhinz/vim-galore?tab=readme-ov-file#restore-cursor-position-when-opening-file
vim.api.nvim_create_autocmd('FileType', {
  group = 'UserCmds',
  desc = 'Restore cursor position',
  callback = function(ctx)
    if vim.bo[ctx.buf].buftype ~= '' then return end
    vim.cmd([[silent! normal! g`"]])
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = 'UserCmds',
  desc = 'Auto create dir when saving a file, in case some intermediate directory does not exist',
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = 'UserCmds',
  desc = 'Check if we need to reload the file when it changed',
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave', 'FocusLost' }, {
  group = 'UserCmds',
  desc = 'Autosave on focus change',
  nested = true,
  callback = function(info)
    -- Don't auto-save non-file buffers
    if (vim.uv.fs_stat(info.file) or {}).type ~= 'file' then return end
    vim.cmd.update({
      mods = { emsg_silent = true },
    })
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'UserCmds',
  desc = 'Delete trailing whitespace',
  pattern = '*',
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    local last_search = vim.fn.getreg('/')
    local hl_state = vim.v.hlsearch

    vim.cmd(':%s/\\s\\+$//e')

    vim.fn.setreg('/', last_search) -- restore last search
    vim.api.nvim_win_set_cursor(0, pos) -- restore cursor position
    if hl_state == 0 then
      vim.cmd.nohlsearch() -- disable search highlighting again if it was disabled before
    end
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = 'term://*',
  callback = vim.schedule_wrap(function(data)
    -- Try to start terminal mode only if target terminal is current
    if not (vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == 'terminal') then return end
    vim.cmd('startinsert')
  end),
  desc = 'auto insert current terminal',
})
