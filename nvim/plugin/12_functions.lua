-- Create listed scratch buffer and focus on it
Config.new_scratch_buffer = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

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
    if not noerr then M.info(unpack(output)) end
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
    if not cache[s] then cache[s] = vim.api.nvim_replace_termcodes(s, true, false, true) end
    return cache[s]
  end
end
