--------------------------------------------------------------------------------
-- Utils
--------------------------------------------------------------------------------
local M = {}

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
function M.visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

local escape_characters = '"\\/.*$^~[]'

function M.get_visual_selection(escape)
  local sr, sc, er, ec = M.visual_selection_range()
  local text = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})
  if #text == 1 then return escape ~= false and vim.fn.escape(text[1], escape_characters) or text[1] end
end

function M.toggle_qf(type)
  local wininfo = vim.fn.getwininfo()
  local windows = {}
  -- collect matching windows
  for _, win in ipairs(wininfo) do
    if type == 'l' and win.loclist == 1 then
      table.insert(windows, win.winid)
    elseif type == 'q' and win.quickfix == 1 and win.loclist == 0 then
      table.insert(windows, win.winid)
    end
  end

  -- toggle between qf and lf
  if vim.b.win_qf_or_lf ~= nil then vim.api.nvim_win_hide(vim.b.win_qf_or_lf) end

  if #windows > 0 then
    -- if any qf/loclist windows are open, close them
    for _, winid in ipairs(windows) do
      vim.api.nvim_win_hide(winid)
    end
  else
    if type == 'l' then
      -- open all non-empty loclists
      for _, win in ipairs(wininfo) do
        if win.quickfix == 0 then
          if not vim.tbl_isempty(vim.fn.getloclist(win.winnr)) then
            vim.api.nvim_set_current_win(win.winid)
            vim.cmd('lopen')
            vim.cmd('wincmd J')
            vim.b.win_qf_or_lf = vim.api.nvim_get_current_win()
          else
            vim.notify('loclist is empty.', vim.log.levels.WARN)
          end
          return
        end
      end
    else
      -- open quickfix if not empty
      if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd('copen')
        vim.cmd('wincmd J')
        vim.b.win_qf_or_lf = vim.api.nvim_get_current_win()
      else
        vim.notify('quickfix is empty.', vim.log.levels.WARN)
      end
    end
  end
end

M.git_root = function(cwd, noerr)
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

do
  local cache = {}
  ---Replace termcodes (cached)
  ---@param s string
  ---@return string
  function M.T(s)
    assert(type(s) == 'string', 'expected string')
    if not cache[s] then cache[s] = vim.api.nvim_replace_termcodes(s, true, false, true) end
    return cache[s]
  end
end

---@param key string
---@param mode string? feedkeys mode, e.g. 'n', 'x'
function M.feedkeys(key, mode) vim.api.nvim_feedkeys(M.T(key), mode or 'n', false) end

-- PICKER

--- Title Picker
local function center_title_line_parts(title, width, fill_char, title_hl, line_hl)
  local pad = width - #title - 3
  local left = string.rep(fill_char, math.floor(pad / 2))
  local right = string.rep(fill_char, math.ceil(pad / 2))
  return {
    { left .. ' ', line_hl },
    { ' ' .. title .. ' ', title_hl },
    { ' ' .. right, line_hl },
  }
end

--- Execute menu item based on key input
---@param ch integer|string
---@param items table
---@param fallback_title? string
---@return boolean
local function execute_item(ch, items, fallback_title)
  ch = type(ch) == 'number' and vim.fn.nr2char(ch) or ch
  for _, item in ipairs(items) do
    if item.key == ch then
      local cmd = item.cmd
      if type(cmd) == 'function' then
        cmd()
      elseif type(cmd) == 'string' then
        vim.cmd(cmd)
      elseif type(cmd) == 'table' then
        M.echo_picker({ title = item.label or fallback_title, items = cmd })
      end
      return true
    end
  end
  return false
end

---Picker base of `vim.api.nvim_echo`.
--------------------------------------------------------------------------------
---
---@param opts? {
---  title?: string,
---  items: { mode?: string, key: string, label?: string, cmd: string|function, hl?: string }[],
---  width?: integer,
---  cr?: function,
---  space?: function }
function M.echo_picker(opts)
  opts = opts or {}
  local title = opts.title or ''
  local items = opts.items or {}
  local width = opts.width or 40
  local top_line = center_title_line_parts(title, width, '-', 'Label', 'Comment')
  local bottom_line = { { string.rep('-', width), 'Comment' } }

  -- Render menu
  vim.api.nvim_echo(top_line, false, {})
  for _, item in ipairs(items) do
    local cmd = item.cmd
    local hl = item.hl
    local label = item.label

    -- jika cmd adalah nested menu (table), dan tidak ada highlight diberikan, beri warna khusus
    if type(cmd) == 'table' and not hl then
      hl = 'WarningMsg' -- atau 'Title', 'MoreMsg', dll sesuai selera
    end
    if type(cmd) == 'string' and not item.label then label = item.cmd end
    vim.api.nvim_echo({
      { ' [', 'Comment' },
      { item.key, 'WarningMsg' },
      { '] ', 'Comment' },
      { label, hl or 'Normal' },
    }, false, {})
  end
  vim.api.nvim_echo(bottom_line, false, {})

  -- Input handling
  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end

  if ch == 0 or ch == 27 then
    return
  else
    execute_item(ch, items, title)
  end
end

local function run_and_open(cmd, fn)
  if cmd and cmd ~= '' then
    vim.cmd('noswapfile vnew')
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.api.nvim_buf_set_lines(0, 0, -1, false, fn(cmd))
  end
end

function M.run_shell()
  local cmd = vim.fn.input({ prompt = 'Run shell> ', completion = 'shellcmd' })
  if cmd and cmd ~= '' then run_and_open(cmd, vim.fn.systemlist) end
end

function M.run_vim()
  local cmd = vim.fn.input({ prompt = 'Vim command> ', completion = 'command' })
  if cmd and cmd ~= '' then
    cmd = string.format('lua P(%s)', cmd)
    run_and_open(cmd, function(c) return vim.split(vim.fn.execute(c), '\n') end)
  end
end

---@param opts? vim.api.keyset.win_config
---@param buf_id? integer
---@return integer win_id, integer prev_win_id, integer buf_id
function M.win_open(opts, buf_id)
  local prev_win_id = vim.api.nvim_get_current_win()
  if not (buf_id and vim.api.nvim_buf_is_valid(buf_id)) then buf_id = vim.api.nvim_create_buf(false, true) end

  vim.bo[buf_id].bufhidden = 'wipe'
  vim.bo[buf_id].buftype = 'nofile'

  local columns = vim.o.columns
  local lines = vim.o.lines
  local width = math.floor(columns * 0.9)
  local height = math.floor(lines * 0.59)
  local default_opts = {
    relative = 'editor',
    style = 'minimal',
    row = math.floor((lines - height) * 0.5),
    col = math.floor((columns - width) * 0.5),
    width = width,
    height = height,
    border = 'single',
    title = '',
    title_pos = 'center',
  }

  local win_opts = vim.tbl_deep_extend('force', default_opts, opts or {})

  local win_id = vim.api.nvim_open_win(buf_id, true, win_opts)
  return win_id, buf_id, prev_win_id
end

_G.config = M

return M

--------------------------------------------------------------------------------
