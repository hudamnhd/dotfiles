local H = {}
local T = {}

function H.set(enter)
  vim.o.cmdheight = enter and 0 or 1
  -- vim.o.laststatus = enter and 0 or 3
end

--- Helper: safely delete buffer
function H.buf_delete(buf)
  if vim.api.nvim_buf_is_valid(buf) then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
  H.set(false)
end

--- Helper: safely close window
function H.win_close(win)
  if vim.api.nvim_win_is_valid(win) then pcall(vim.api.nvim_win_close, win, true) end
  H.set(false)
end

function H.win_focus(win)
  if win and vim.api.nvim_win_is_valid(win) then vim.api.nvim_set_current_win(win) end
  H.set(false)
end

--- Kill terminal instance
function H.kill(id)
  local t = T[id]
  if not t then return end

  H.win_close(t.win)
  H.win_focus(t.last)
  H.buf_delete(t.buf)

  T[id] =nil
end

--- Toggle terminal window
function H.toggle_term(opts)
  local cmd = opts.cmd or vim.o.shell
  local cwd = opts.cwd or vim.loop.cwd()

  local t = T[opts.id] or {}
  local tabnr = vim.api.nvim_get_current_tabpage()

  -- Hide all terminal drawers in current tab
  for i, win in ipairs(vim.fn.getwininfo()) do

    if win.quickfix == 1 or win.loclist == 1 then
      H.win_close(win.winid)
    end

    if win.tabnr == tabnr and win.winid ~= t.win and win.variables.drawer ~= nil then
      H.win_close(win.winid)
      if T[i] then
        T[i].win, T[i].last = nil, nil
      end
    end
  end

  if opts.buffer then cwd = vim.fn.expand('%:p:h') end

  -- If already open, close it
  if t.win and vim.api.nvim_win_is_valid(t.win) then
    H.win_close(t.win)
    H.win_focus(t.last)
    t.win, t.last = nil, nil
    return
  end

  -- Create or reuse buffer
  local previous_win = vim.api.nvim_get_current_win()
  local buf = t.buf
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then buf = vim.api.nvim_create_buf(false, true) end

  -- Open split terminal
  local win = vim.api.nvim_open_win(buf, true, {
    split = 'below',
    height = 12,
    win = -1,
  })

  vim.api.nvim_win_set_var(win, 'drawer', true)
  vim.bo.buflisted = false
  vim.wo.signcolumn = 'no'
  H.set(true)
  -- If already has terminal buffer, attach it
  if t.buf and vim.api.nvim_buf_is_valid(t.buf) then
    vim.api.nvim_win_set_buf(win, t.buf)
    T[opts.id].win = win
    T[opts.id].last = previous_win
  else
    -- Start new terminal job
    local job = vim.fn.jobstart(cmd, {
      term = true,
      cwd = cwd,
      on_exit = function()
        vim.schedule(function() H.kill(opts.id) end)
      end,
    })

    T[opts.id] = {
      buf = buf,
      win = win,
      job = job,
      last = previous_win,
    }
  end

  vim.cmd.startinsert()
end

function H.send(id, keys)
  local t = T[id]
  if t == nil then return end

  vim.fn.chansend(t.job, config.T(keys) .. '\r')
end

-- Keybindings
vim.keymap.set(
  { 'n', 't' },
  '<F1>',
  function() H.toggle_term({ id = 1 }) end,
  { desc = 'Toggle Term 1', silent = true }
)
vim.keymap.set(
  { 'n', 't' },
  '<F2>',
  function() H.toggle_term({ id = 2, buffer = true }) end,
  { desc = 'Toggle Term 2', silent = true }
)
