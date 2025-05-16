local M = {
  t = {},
  w = {},
  q = {},
}

local terms = {}

local function tmap(lhs, rhs) vim.api.nvim_buf_set_keymap(0, 't', lhs, rhs, { silent = true }) end

function M.t.getterm(id, opts)
  if terms[id] == nil then
    local term_dir = vim.fn.expand('%:p:h')
    vim.cmd('enew')
    local title = 'Term ' .. id

    opts = opts or {}
    local job_opts = {}

    if opts.buffer then job_opts.cwd = term_dir end

    local job = vim.fn.jobstart(
      vim.o.shell,
      vim.tbl_extend('force', job_opts, {

        env = { TITLE = title },
        term = true,
      })
    )

    vim.api.nvim_buf_set_var(0, 'term_title', title)
    vim.api.nvim_create_autocmd('TermClose', {
      buffer = 0, -- <buffer> = current buffer
      nested = true,
      callback = function() M.t._termclose(id) end,
    })
    vim.cmd('setl nobuflisted signcolumn=no')
    terms[id] = {
      bufnr = vim.api.nvim_get_current_buf(),
      job = job,
    }

    tmap('<F1>', [[<cmd>lua Config.drawer.t.term(1)<CR>]])
    tmap('<F2>', [[<cmd>lua Config.drawer.t.term(2,1)<CR>]])

    tmap('<C-G><C-L>', [[<cmd>lua Config.drawer.w.move("l")<CR>]])
    tmap('<C-G><C-H>', [[<cmd>lua Config.drawer.w.move("h")<CR>]])
    tmap('<C-G><C-J>', [[<cmd>lua Config.drawer.w.move("j")<CR>]])
    tmap('<C-G><C-K>', [[<cmd>lua Config.drawer.w.move("k")<CR>]])

    tmap('<C-G><C-I>', [[<cmd>lua Config.drawer.w.resize(24)<CR>]])
    tmap('<C-G><C-D>', [[<cmd>lua Config.drawer.w.resize(12)<CR>]])
    vim.cmd('startinsert')
    return 0
  end

  local bufnr = terms[id].bufnr
  if bufnr == vim.api.nvim_get_current_buf() then return 2 end

  vim.cmd(bufnr .. 'b')
  vim.cmd('startinsert')
  return 1
end

function M.t.term(id, buffer)
  local a = M.w.getwin()

  buffer = buffer or false
  local b = M.t.getterm(id, { buffer = buffer })
  if a == 2 and b == 2 then
    vim.cmd('stopinsert')
    vim.cmd('close')
  end
end

function M.t.send(id, keys)
  local term = terms[id]
  if term == nil then return end
  vim.fn.chansend(term.job, Config.T(keys))
end

function M.t._termclose(id)
  local term = terms[id]
  if term ~= nil then
    pcall(vim.cmd, term.bufnr .. 'bdelete!')
    terms[id] = nil
  end
end

local POSITIONS = {
  h = 'H',
  j = 'J',
  k = 'K',
  l = 'L',
}

local height = 12
local position = 'J'

local function findwin()
  local tabnr = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.tabnr == tabnr and win.variables.drawer ~= nil then return win.winid end
  end
  return 0
end

function M.w.setupwin()
  vim.cmd('wincmd ' .. position)
  if position == 'J' or position == 'K' then vim.api.nvim_win_set_height(0, height) end
  vim.cmd('setl winfixheight')
  vim.api.nvim_win_set_var(0, 'drawer', true)
end

function M.w.getwin()
  local winid = findwin()
  if winid == 0 then
    vim.cmd('vsplit')
    M.w.setupwin()
    return 0
  elseif winid ~= vim.api.nvim_get_current_win() then
    vim.api.nvim_set_current_win(winid)
    return 1
  else
    return 2
  end
end

function M.w.resize(h)
  height = h
  if position == 'J' or position == 'K' then
    local winid = findwin()
    if winid ~= 0 then vim.api.nvim_win_set_height(winid, height) end
  end
end

function M.w.move(pos)
  if POSITIONS[pos] == nil then return end
  position = POSITIONS[pos]
  local winid = findwin()
  if winid == 0 then return end
  local win = vim.fn.win_id2win(winid)
  if win == 0 then return end
  vim.cmd(win .. 'wincmd ' .. position)
  if position == 'J' or position == 'K' then vim.api.nvim_win_set_height(winid, height) end
end

function M.w._bufwinenter()
  local bufnr = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
  if buftype == 'quickfix' and vim.b.qf_isLoc ~= 1 then
    -- close other drawer windows
    local tabnr = vim.api.nvim_get_current_tabpage()
    local winid = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.tabnr == tabnr and win.winid ~= winid and win.variables.drawer ~= nil then
        vim.api.nvim_win_close(win.winid, false)
      end
    end
    M.w.setupwin()
  end
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local usercmd = vim.api.nvim_create_user_command
local keymap = vim.keymap.set

-- Keymaps to toggle terminals
keymap('n', '<F1>', function() M.t.term(1) end, { silent = true, desc = 'Toggle terminal 1' })
keymap('n', '<F2>', function() M.t.term(2, 1) end, { silent = true, desc = 'Toggle terminal 2 (with cwd)' })

-- User commands
usercmd('Dresize', function(opts) M.w.resize(opts.count) end, { bar = true, count = 12 })

usercmd('Dmove', function(opts) M.w.move(opts.args) end, { bar = true, nargs = 1 })

usercmd('Tsend', function(opts) M.t.send(opts.count, opts.args) end, { nargs = '+', count = 1 })

-- Autocommand group
augroup('m_drawer', {})
autocmd('BufWinEnter', {
  group = 'm_drawer',
  callback = function() M.w._bufwinenter() end,
})

Config.drawer = M
