-------------------------------------------------------------------------------
-- Autocommands ===============================================================
-------------------------------------------------------------------------------
local augroup = require('native.utils').augroup

augroup(
  'UserBufferBehavior',
  {
    'Filetype',
    {
      pattern = { 'help', 'man' },
      callback = function()
        local buftype = vim.bo.buftype
        if buftype == 'help' or buftype == 'nofile' then
          vim.keymap.set('n', 'q', vim.cmd.bd, { buffer = true, nowait = true })
          vim.cmd('wincmd H')
        end
      end,
    },
  },
  {
    'TextYankPost',
    {
      desc = 'Highlight the selection on yank.',
      callback = function()
        pcall(vim.highlight.on_yank, {
          higroup = 'Search',
          timeout = 400,
        })
      end,
    },
  },
  {
    'BufReadPost',
    {
      pattern = '*',
      command = [[if line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG' | exe "normal! g`\"" | endif]],
      desc = 'Return to last edit position when opening files.',
    },
  },
  {
    'BufWritePre',
    {
      pattern = '*',
      command = [[%s/\s\+$//e]],
      desc = 'Delete Trailing Whitespace.',
    },
  },
  -- ( Autocommand Autosave )
  {
    { 'BufLeave', 'WinLeave', 'FocusLost' },
    {
      nested = true,
      desc = 'Autosave on focus change.',
      callback = function(info)
        -- Don't auto-save non-file buffers
        if (vim.uv.fs_stat(info.file) or {}).type ~= 'file' then return end
        vim.cmd.update({
          mods = { emsg_silent = true },
        })
      end,
    },
  },
  -- ( Autocommand Terminal )
  {
    'TermOpen',
    {
      pattern = 'term://*',
      callback = vim.schedule_wrap(function(data)
        -- Try to start terminal mode only if target terminal is current
        if not (vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == 'terminal') then return end
        vim.cmd('startinsert')
      end),
      desc = 'Start terminal mode ',
    },
  },
  {
    'Filetype',
    {
      callback = function()
        -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
        -- If don't do this on `FileType`, this keeps reappearing due to being set in
        -- filetype plugins.
        vim.cmd('setlocal formatoptions-=c formatoptions-=o')
      end,
      desc = [[Ensure proper 'formatoptions']],
    },
  }
)
