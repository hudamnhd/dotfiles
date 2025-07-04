--------------------------------------------------------------------------------
-- Utils
--------------------------------------------------------------------------------
local util = {}

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
function util.visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

local escape_characters = '"\\/.*$^~[]'

function util.get_visual_selection(escape)
  local sr, sc, er, ec = util.visual_selection_range()
  local text = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})
  if #text == 1 then return escape ~= false and vim.fn.escape(text[1], escape_characters) or text[1] end
end

local terms = {}

local function float_cfg()
  return {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = 'minimal',
    border = 'rounded',
  }
end

function util.toggle_qf(type)
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
      else
        vim.notify('quickfix is empty.', vim.log.levels.WARN)
      end
    end
  end
end

-- Minimal multi-instance floating terminal in Neovim
-- Toggle terminal with <count><C-t>, e.g.:
--    <C-t>    → toggle terminal #1
--    2<C-t>   → toggle terminal #2
function util.toggle_floating_term()
  local count = vim.v.count
  if count == 0 then count = 1 end

  -- create state if not exists
  terms[count] = terms[count] or { buf = nil, win = nil, was_insert = true }

  local state = terms[count]
  local buf, win = state.buf, state.win

  -- validate
  buf = (buf and vim.api.nvim_buf_is_valid(buf)) and buf or nil
  win = (win and vim.api.nvim_win_is_valid(win)) and win or nil
  state.buf, state.win = buf, win

  if not buf and not win then
    -- new terminal
    vim.cmd('split | terminal')
    buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
    win = vim.api.nvim_open_win(buf, true, float_cfg())
    state.buf = buf
    state.win = win
  elseif not win and buf then
    -- reopen
    win = vim.api.nvim_open_win(buf, true, float_cfg())
    state.win = win
  elseif win then
    -- close
    state.was_insert = vim.api.nvim_get_mode().mode == 't'
    vim.api.nvim_win_close(win, true)
    state.win = nil
    return
  end

  if state.was_insert then vim.cmd('startinsert') end
end

_G.config = util

--------------------------------------------------------------------------------
