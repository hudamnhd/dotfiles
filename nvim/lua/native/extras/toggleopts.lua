-------------------------------------------------------------------------------
-- Menu =============================================================
-------------------------------------------------------------------------------
local M = {}

local function echo(chunks) vim.api.nvim_echo(chunks, false, {}) end

function M.bookmarks()
  local bookmarks = {
    { 't', '$VIMRUNTIME' },
    { 'p', '$VIMPLUGINS' },
    { 'v', '$VIMCONFIG' },
    { 'k', '~/vimwiki' },
    { 's', '~/.local/share' },
    { 'b', '~/.local/bin' },
    { 'c', '~/.config' },
    { 'h', '~' },
  }

  if type(bookmarks) ~= 'table' then
    echo({ { 'Invalid bookmarks', 'ErrorMsg' } })
    return
  end

  for _, item in ipairs(bookmarks) do
    local hl
    if item[3] then hl = 'Function' end
    echo({
      { ' [', 'LineNr' },
      { item[1], 'WarningMsg' },
      { '] ', 'LineNr' },
      { item[2], hl },
    })
  end
  echo({ { ':F' } })

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end
  if
    ch == 0 or ch == 27 --[[<Esc>]]
  then
    return
  elseif
    ch == 13 --[[<CR>]]
  then
    vim.cmd('F')
  elseif
    ch == 32 --[[<Space>]]
  then
    vim.api.nvim_feedkeys(':F ', 'n', false)
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(bookmarks) do
      local s1, s2 = item[1], nil
      if s1 == ch or (s2 and s2 == ch) then
        vim.cmd(item[3] or ('F ' .. item[2]))
        return
      end
    end
  end
end

do
  local LINE_NUMBERS = {
    ff = '  number   relativenumber',
    ft = '  number norelativenumber',
    tf = 'nonumber norelativenumber',
    tt = '  number norelativenumber',
  }
  ---Toggle line numbers
  vim.api.nvim_create_user_command('ToggleLineNumber', function()
    local n = vim.o.number and 't' or 'f'
    local r = vim.o.relativenumber and 't' or 'f'
    local cmd = LINE_NUMBERS[n .. r]
    vim.api.nvim_command('set ' .. cmd)
    echo({ { ':set' .. cmd } })
  end, { desc = 'Toggle line numbers' })
end

--stylua: ignore start
local options = {
  { 'w', 'wrap',         [[setl wrap! | setl wrap?]] },
  { 'W', 'wrapscan',     [[set wrapscan! | set wrapscan?]] },
  { 'C', 'ignorecase',   [[set ignorecase! | set ignorecase?]] },
  { 's', 'spell',        [[setl spell! | setl spell?]] },
  { 'l', 'list',         [[setl list! | setl list?]] },
  { 'f', 'folds',        [[setl foldenable! | setl foldenable?]] },
  { 'm', 'mouse',        [[let &mouse = (&mouse ==# '' ? 'nvi' : '') | set mouse?]] },
  { 'n', 'line numbers', [[ToggleLineNumber]] },
  { 'S', 'syntax',       [[exec 'syntax '..(exists('syntax_on') ? 'off' : 'on')]] },
  { 'd', 'diagnostics',  function() vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text }) end },
}

--stylua: ignore end

function M.options()
  for _, item in ipairs(options) do
    echo({
      { ' [', 'LineNr' },
      { item[1], 'WarningMsg' },
      { '] ', 'LineNr' },
      { item[2] },
    })
  end
  echo({ { ':set' } })

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end
  if ch == 0 or ch == 27 or ch == 13 then
    return
  elseif ch == 32 then
    vim.api.nvim_feedkeys(':set ', 'n', false)
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(options) do
      if item[1] == ch then
        local cmd = item[3]
        if type(cmd) == 'function' then
          cmd()
        else
          vim.cmd(cmd)
        end
        return
      end
    end
  end
end

vim.keymap.set('n', 'yu', '<cmd>lua require("native.extras.toggleopts").options()<cr>', { desc = 'Options' })
vim.keymap.set('n', 'yo', '<cmd>lua require("native.extras.toggleopts").bookmarks()<cr>', { desc = 'Bookmarks' })

return M
