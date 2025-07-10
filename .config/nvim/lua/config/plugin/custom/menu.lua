-- lua/improve/menus.lua
local picker = require('config.util').echo_picker

local M = {}

-------------------------------------------------------------------------------
-- Quick MENUS

local w_key = {
  { key = 't', cmd = 'wincmd T' },
}

local b_key = {
  { key = 'c', cmd = 'BufClean' },
  { key = 's', cmd = 'Scratch' },
  { key = 'd', cmd = 'Difftoggle' },
}

--stylua: ignore
local q_menus = {
  { key = 'm', label = 'FzfLua Menu',   cmd = 'FzfLua' },
  { key = 'q', label = 'Quickfix List', cmd = 'lua config.toggle_qf("q")' },
  { key = 'l', label = 'Location List', cmd = 'lua config.toggle_qf("l")' },
  { key = 'b', label = '+B key',        cmd = b_key },
  { key = 'w', label = '+W key',        cmd = w_key },
}

function M.q()
  local close_with_q = { 'qf', 'man', 'help', 'checkhealth', 'vimpe', 'qfreplace' }
  local ft = vim.bo.filetype

  if vim.tbl_contains(close_with_q, ft) then
    vim.cmd('close')
  else
    picker({ title = 'Quick menu', items = q_menus })
  end
end

-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('UIEnter', {
  group = 'UserCmds',
  desc = 'Setup Keymaps on UIEnter Event ',
  once = true,
  callback = vim.schedule_wrap(function()
    vim.keymap.set('n', 'q', "<cmd>lua require('config.plugin.custom.menu').q()<cr>")
  end),
})

function M.show_keymaps(modes)
  modes = modes or { 'n' }

  local keymaps = {}
  for _, mode in ipairs(modes) do
    for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
      table.insert(keymaps, map)
    end
  end

  local lines = {}
  table.insert(lines, string.format('%-4s %-14s %s', 'M', 'Key', 'Description'))
  table.insert(lines, string.rep('-', 40))

  for _, map in ipairs(keymaps) do
    local lhs = map.lhs
    if lhs:sub(1, 1) == ' ' then lhs = '<Space>' .. lhs:sub(2) end
    local desc = map.desc or ''
    if map.desc then table.insert(lines, string.format('%-4s %-14s %s', map.mode, lhs, desc)) end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'keymapview'

  local width = 70
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })

  -- Optional: tekan `q` buat keluar
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, nowait = true, silent = true })
end

vim.api.nvim_create_user_command('Map', M.show_keymaps, { desc = 'Show keymaps' })


-- Jalankan fungsi

return M

--------------------------------------------------------------------------------
