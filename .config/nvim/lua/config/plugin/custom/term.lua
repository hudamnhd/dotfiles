local H = {}
local Term = {}

function H.buf_delete(buf_id)
  if vim.api.nvim_buf_is_valid(buf_id) then pcall(vim.api.nvim_buf_delete, buf_id, { force = true }) end
end

function H.win_close(win_id)
  if vim.api.nvim_win_is_valid(win_id) then pcall(vim.api.nvim_win_close, win_id, true) end
end

function H.win_focus(win_id)
  if win_id and vim.api.nvim_win_is_valid(win_id) then vim.api.nvim_set_current_win(win_id) end
end

-- Hide all terminal drawers in current tab
function H.close_drawer_opened(win_id)
  local tabnr = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.tabnr == tabnr and win.winid ~= win_id and win.variables.drawer ~= nil then
      if #Term > 0 then
        for id, term in ipairs(Term) do
          if term.win_id == win.winid then H.term_close({ id = id }) end
        end
      else
        H.win_close(win.winid)
      end
    end
  end
end

function H.win_open(buf_id)
  local prev_win_id = vim.api.nvim_get_current_win()
  if not (buf_id and vim.api.nvim_buf_is_valid(buf_id)) then buf_id = vim.api.nvim_create_buf(false, true) end

  local win_id = vim.api.nvim_open_win(buf_id, true, {
    split = 'below',
    height = 10,
    win = -1,
  })

  vim.api.nvim_win_set_var(win_id, 'drawer', true)
  vim.bo.buflisted = false
  vim.wo.signcolumn = 'no'
  return win_id, buf_id, prev_win_id
end

--- Kill terminal instance
function H.term_close(opts)
  local id, mode = opts.id, opts.mode
  if not Term[id] then return end

  H.win_close(Term[id].win_id)

  if mode ~= nil then
    H.win_focus(Term[id].prev_win_id)
    Term[id].win_id, Term[id].prev_win_id = nil, nil
    if mode == 'kill' then
      H.buf_delete(Term[id].buf_id)
      Term[id] = nil
    end
  end
end

--- Toggle terminal window
function H.toggle_term(opts)
  local cmd = opts.cmd or vim.o.shell

  local t = Term[opts.id] or {}

  -- -- If already open, close it
  if t.win_id and vim.api.nvim_win_is_valid(t.win_id) then
    H.term_close({ id = opts.id, mode = 'close' })
    return
  end

  H.close_drawer_opened(t.win_id)

  local cwd = opts.cwd or vim.loop.cwd()
  if opts.buffer then cwd = vim.fn.expand('%:p:h') end

  local win_id, buf_id, prev_win_id = H.win_open(t.buf_id)

  -- If already has terminal buffer, attach it
  if t.buf_id and vim.api.nvim_buf_is_valid(t.buf_id) then
    vim.api.nvim_win_set_buf(win_id, t.buf_id)
    Term[opts.id].win_id = win_id
    Term[opts.id].prev_win_id = prev_win_id
  else
    -- Start new terminal job_id
    local job_id = vim.fn.jobstart(cmd, {
      term = true,
      cwd = cwd,
      on_exit = function()
        vim.schedule(function() H.term_close({ id = opts.id, mode = 'kill' }) end)
      end,
    })

    Term[opts.id] = {
      buf_id = buf_id,
      win_id = win_id,
      job_id = job_id,
      prev_win_id = prev_win_id,
    }
  end

  vim.cmd.startinsert()
end

function H.send(id, keys)
  if Term[id] == nil then return end

  vim.fn.chansend(Term[id].job_id, config.T(keys) .. '\r')
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
