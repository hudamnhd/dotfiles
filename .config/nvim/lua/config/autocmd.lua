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
  command = [[%s/\s\+$//e]],
})
