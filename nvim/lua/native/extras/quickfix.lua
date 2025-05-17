-------------------------------------------------------------------------------
-- Grep =======================================================================
-------------------------------------------------------------------------------
if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case --hidden'
  vim.o.grepformat = '%f:%l:%c:%m'
end

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir

vim.cmd('command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen')
vim.cmd('command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen')

vim.keymap.set('ca', 'grf', [[Grep <c-r><c-w> %<cr>]])
vim.keymap.set('ca', 'Grf', [[LGrep <c-r><c-w> %<cr>]])
vim.keymap.set('ca', 'grd', [[Grep <c-r><c-w> %:h<cr>]])
vim.keymap.set('ca', 'Grd', [[LGrep <c-r><c-w> %:h<cr>]])

-------------------------------------------------------------------------------
-- QF =========================================================================
-------------------------------------------------------------------------------
local find_qf = function(type)
  local wininfo = vim.fn.getwininfo()
  local win_tbl = {}
  for _, win in pairs(wininfo) do
    local found = false
    if type == 'l' and win['loclist'] == 1 then found = true end
    -- loclist window has 'quickfix' set, eliminate those
    if type == 'q' and win['quickfix'] == 1 and win['loclist'] == 0 then found = true end
    if found then table.insert(win_tbl, { winid = win['winid'], bufnr = win['bufnr'] }) end
  end
  return win_tbl
end

-- open quickfix if not empty
local open_qf = function()
  local qf_name = 'quickfix'
  local qf_empty = function() return vim.tbl_isempty(vim.fn.getqflist()) end
  if not qf_empty() then
    vim.cmd('copen')
    vim.cmd('wincmd J')
  else
    print(string.format('%s is empty.', qf_name))
  end
end

-- enum all non-qf windows and open
-- loclist on all windows where not empty
local open_loclist_all = function()
  local wininfo = vim.fn.getwininfo()
  local qf_name = 'loclist'
  local qf_empty = function(winnr) return vim.tbl_isempty(vim.fn.getloclist(winnr)) end
  for _, win in pairs(wininfo) do
    if win['quickfix'] == 0 then
      if not qf_empty(win['winnr']) then
        -- switch active window before ':lopen'
        vim.api.nvim_set_current_win(win['winid'])
        vim.cmd('lopen')
      else
        print(string.format('%s is empty.', qf_name))
      end
    end
  end
end

-- toggle quickfix/loclist on/off
-- type='*': qf toggle and send to bottom
-- type='l': loclist toggle (all windows)
local toggle_qf = function(type)
  local windows = find_qf(type)
  if #windows > 0 then
    -- hide all visible windows
    for _, win in ipairs(windows) do
      vim.api.nvim_win_hide(win.winid)
    end
  else
    -- no windows are visible, attempt to open
    if type == 'l' then
      open_loclist_all()
    else
      open_qf()
    end
  end
end

vim.keymap.set('n', '>', function() toggle_qf('q') end, { desc = 'Toggle QF' })
vim.keymap.set('n', '<', function() toggle_qf('l') end, { desc = 'Toggle LL' })

-------------------------------------------------------------------------------
-- Helper QF ==================================================================
-------------------------------------------------------------------------------
local function delete_quickfix_entries()
  local is_quickfix = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].quickfix == 1
  if not is_quickfix then return end

  local start_line, end_line

  -- If in visual mode, delete the selected lines. Otherwise, delete the current line
  if vim.fn.mode():lower() == 'v' then
    start_line = vim.fn.line('v')
    end_line = vim.fn.line('.')
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', false)
  else
    start_line = vim.fn.line('.')
    end_line = start_line
  end

  local quickfix_list = vim.fn.getqflist()

  for i = end_line, start_line, -1 do
    table.remove(quickfix_list, i)
  end

  vim.fn.setqflist(quickfix_list, 'r')

  vim.cmd('copen')

  local new_line = math.min(start_line, #quickfix_list)
  vim.api.nvim_win_set_cursor(0, { new_line, 0 })
end

local augroup = require('native.utils').augroup

augroup('QuickfixFiletype', {
  'Filetype',
  {
    pattern = 'qf',
    callback = function()
      vim.keymap.set('n', 'dd', delete_quickfix_entries, { buffer = true, desc = 'Delete quickfix entry' })
      vim.keymap.set('v', 'd', delete_quickfix_entries, { buffer = true, desc = 'Delete quickfix entries' })
      vim.keymap.set('n', 'q', vim.cmd.bd, { buffer = true, nowait = true })
    end,
  },
})
