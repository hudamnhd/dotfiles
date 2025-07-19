local M = {}

-------------------------------------------------------------------------------
-- Quick MENUS

local w_key = {
  { key = 't', cmd = 'wincmd T' },
  { key = 'q', cmd = 'wincmd q' },
  { key = 'k', label = 'Run Shell Cmd', cmd = 'lua config.run_shell()' },
  { key = 'K', label = 'Run Vim Cmd', cmd = 'lua config.run_vim()' },
}

local b_key = {
  { key = 'c', label = 'Buf Clean', cmd = 'lua config.buf_delete_all()' },
  { key = 's', label = 'Buf Scratch', cmd = 'lua config.buf_scratch()' },
  { key = 'd', label = 'Toggle Diff', cmd = 'lua config.toggle_diff()' },
}

local h_key = {
  { key = 'c', cmd = 'FzfLua command_history' },
  { key = 's', cmd = 'FzfLua search_history' },
  { key = 'f', cmd = 'FzfLua oldfiles' },
  { key = 'b', cmd = 'FzfLua buffers' },
  { key = 'g', cmd = 'FzfLua grep_last' },
}

local v_key = {
  { key = '%', label = 'Set cwd', cmd = 'lua config.set_cwd()' },
  { key = 'm', cmd = 'messages' },
  { key = 'M', cmd = 'messages clear' },
}

local q_menus = {
  { key = 'b', label = '+Buffer', cmd = b_key },
  { key = 'w', label = '+Win', cmd = w_key },
  { key = 'v', label = '+Vim', cmd = v_key },
}

local fzf_lua = {
  { key = 'h', label = '+History', cmd = h_key },
  { key = 'm', label = 'FzfLua Menu', cmd = 'FzfLua' },
  { key = 's', label = 'FzfLua Snippet', cmd = 'FzfLua snippets' },
  { key = 'z', label = 'FzfLua Bookmark', cmd = 'FzfLua bookmark_dir' },
  { key = '8', label = 'FzfLua Bcword', cmd = 'FzfLua buf' },
}

if config.plugin.picker then vim.list_extend(q_menus, fzf_lua) end

function M.q()
  local close_with_q = { 'qf', 'man', 'help', 'checkhealth', 'vimpe', 'qfreplace' }
  local ft = vim.bo.filetype

  if vim.tbl_contains(close_with_q, ft) then
    vim.cmd('bd')
  else
    M.echo_picker({ title = 'Quick menu', items = q_menus })
  end
end

--------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('UIEnter', {
  group = 'UserCmds',
  desc = 'Setup Keymaps on UIEnter Event ',
  once = true,
  callback = vim.schedule_wrap(
    function() vim.keymap.set('n', 'q', "<cmd>lua require('config.plugin.custom.menu').q()<cr>") end
  ),
})

return M

--------------------------------------------------------------------------------
