-- Insert section
Config.insert_section = function(symbol, total_width)
  symbol = symbol or '='
  total_width = total_width or 79

  -- Insert template: 'commentstring' but with '%s' replaced by section symbols
  local comment_string = vim.bo.commentstring
  local content = string.rep(symbol, total_width - (comment_string:len() - 2))
  local section_template = comment_string:format(content)
  vim.fn.append(vim.fn.line('.'), section_template)

  -- Enable Replace mode in appropriate place
  local inner_start = comment_string:find('%%s')
  vim.fn.cursor(vim.fn.line('.') + 1, inner_start)
  vim.cmd([[startreplace]])
end

Config.git_root = function(cwd, noerr)
  local cmd = { 'git', 'rev-parse', '--show-toplevel' }
  if cwd then
    table.insert(cmd, 2, '-C')
    table.insert(cmd, 3, vim.fn.expand(cwd))
  end
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    if not noerr then vim.notify(unpack(output), vim.log.levels.INFO, {}) end
    return nil
  end
  return output[1]
end

Config.set_cwd = function(pwd)
  if not pwd then
    local parent = vim.fn.expand('%:h')
    pwd = Config.git_root(parent, true) or parent
  end
  if vim.loop.fs_stat(pwd) then
    vim.cmd('cd ' .. pwd)
    vim.notify(('pwd set to %s'):format(vim.fn.shellescape(pwd)), vim.log.levels.INFO, {})
  else
    vim.notify(('pwd set to %s'):format(vim.fn.shellescape(pwd)), vim.log.levels.WARN, {})
  end
end

do
  local cache = {}
  ---Replace termcodes
  ---@param s string
  ---@return string
  function Config.T(s)
    assert(type(s) == 'string', 'expected string')
    if not cache[s] then
      cache[s] = vim.api.nvim_replace_termcodes(s, true, false, true)
    end
    return cache[s]
  end
end

-- 'q': find the quickfix window
-- 'l': find all loclist windows
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
Config.toggle_qf = function(type)
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
