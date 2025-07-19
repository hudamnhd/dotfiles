--------------------------------------------------------------------------------
-- Helper function
--------------------------------------------------------------------------------
-- Pretty print
function _G.P(...)
  local p = { ... }
  for i = 1, select('#', ...) do
    p[i] = vim.inspect(p[i])
  end
  print(table.concat(p, ', '))
  return ...
end

-- taken from: https://github.com/rebelot/dotfiles/blob/0b7e3b4f5063173f38d69a757ab03a8d9323af2e/nvim/lua/utilities.lua#L3
function config.visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

local escape_characters = '"\\/.*$^~[]'

function config.get_visual_selection(escape)
  local sr, sc, er, ec = config.visual_selection_range()
  local text = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})
  if #text == 1 then return escape ~= false and vim.fn.escape(text[1], escape_characters) or text[1] end
end

-- taken from: https://github.com/ibhagwan/nvim-lua/blob/59cf9397cdab97fd19e3b761bdf9312f2114d518/lua/utils.lua#L76
function config.git_root(cwd, noerr)
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

function config.set_cwd()
  local parent = vim.fn.expand('%:h')
  local pwd = config.git_root(parent, true) or parent
  if vim.loop.fs_stat(pwd) then
    vim.cmd('cd ' .. pwd)
    vim.notify(('pwd set to %s'):format(vim.fn.shellescape(pwd)), vim.log.levels.INFO, {})
  else
    vim.notify(('pwd set to %s'):format(vim.fn.shellescape(pwd)), vim.log.levels.WARN, {})
  end
end

do
  local cache = {}
  ---Replace termcodes (cached)
  ---@param s string
  ---@return string
  function config.T(s)
    assert(type(s) == 'string', 'expected string')
    if not cache[s] then cache[s] = vim.api.nvim_replace_termcodes(s, true, false, true) end
    return cache[s]
  end
end

---@param key string
---@param mode string? feedkeys mode, e.g. 'n', 'x'
function config.feedkeys(key, mode) vim.api.nvim_feedkeys(config.T(key), mode or 'n', false) end

---@param opts vim.api.keyset.win_config
---@param buf_id? integer
---@return integer win_id, integer prev_win_id, integer buf_id
function config.win_open(opts, buf_id)
  local prev_win_id = vim.api.nvim_get_current_win()
  if not (buf_id and vim.api.nvim_buf_is_valid(buf_id)) then buf_id = vim.api.nvim_create_buf(false, true) end

  vim.bo[buf_id].bufhidden = 'wipe'
  vim.bo[buf_id].buftype = 'nofile'

  local win_id = vim.api.nvim_open_win(buf_id, true, opts)
  return win_id, buf_id, prev_win_id
end

local function run_and_open(cmd, fn)
  if cmd and cmd ~= '' then
    vim.cmd('noswapfile vnew')
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.api.nvim_buf_set_lines(0, 0, -1, false, fn(cmd))
  end
end

function config.run_shell()
  local cmd = vim.fn.input({ prompt = 'Run shell> ', completion = 'shellcmd' })
  if cmd and cmd ~= '' then run_and_open(cmd, vim.fn.systemlist) end
end

function config.run_vim()
  local cmd = vim.fn.input({ prompt = 'Vim command> ', completion = 'command' })
  if cmd and cmd ~= '' then
    cmd = string.format('lua P(%s)', cmd)
    run_and_open(cmd, function(c) return vim.split(vim.fn.execute(c), '\n') end)
  end
end

-- remove all buffers except the current one
function config.buf_delete_all()
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
end

-- scratch buffer
function config.buf_scratch() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

-- toggle diff
function config.toggle_diff()
  if vim.wo.diff then
    vim.cmd('windo diffoff')
    vim.cmd('windo set nowrap')
  else
    vim.cmd('windo diffthis')
    vim.cmd('windo set wrap')
  end
end

return config

--------------------------------------------------------------------------------
