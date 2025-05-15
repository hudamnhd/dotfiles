-------------------------------------------------------------------------------
-- Plugin https://github.com/nvimdev
-------------------------------------------------------------------------------
-- Phoenix: A blazing-fast asynchronous in-process server providing word and path and snippets completion.
-- Modeline: neovim statusline plugin blazing fast than any statusline plugin .
-- Indentmini: A minimal and blazing fast indentline plugin .
-- Dired: dired + fp.
-- Guard: Lightweight, fast and async formatting and linting plugin for Neovim .
-------------------------------------------------------------------------------

-- See :help phoenix.nvim-phoenix-config
vim.g.phoenix = {
  dict = {
    capacity = 50000, -- Store up to 50k words
    min_word_length = 5, -- Ignore single_letter words
    word_pattern = '[%w_]+', -- default "[^%s%.%_:%p%d]+"
  },
  snippet = vim.fn.stdpath('config') .. '/snippets/',
}

-- Completion Keymaps
-- Reference: https://github.com/glepnir/nvim/blob/996bed3f5db284fcb8bfbb26f3f594910294afd5/lua/private/keymap.lua#L189
-------------------------------------------------------------------------------
-- Ctrl-y works like emacs
map.i('<C-y>', function()
  if tonumber(vim.fn.pumvisible()) == 1 or vim.fn.getreg('"+'):find('%w') == nil then return '<C-y>' end
  return '<Esc>p==a'
end, { expr = true })

-- move line down
map.i('<A-k>', function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, lnum - 3, lnum - 2, false)[1]
  return #line > 0 and '<Esc>:m .-2<CR>==gi' or '<Esc>kkddj:m .-2<CR>==gi'
end, { expr = true })

map.i('<TAB>', function()
  if tonumber(vim.fn.pumvisible()) == 1 then
    return '<C-n>'
  elseif vim.snippet.active({ direction = 1 }) then
    return '<cmd>lua vim.snippet.jump(1)<cr>'
  else
    return '<TAB>'
  end
end, { expr = true })

map.i('<S-TAB>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'
  elseif vim.snippet.active({ direction = -1 }) then
    return '<cmd>lua vim.snippet.jump(-1)<CR>'
  else
    return '<S-TAB>'
  end
end, { expr = true })

map.i('<CR>', function()
  if tonumber(vim.fn.pumvisible()) == 1 then return '<C-y>' end
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(col, col)
  local after = line:sub(col + 1, col + 1)
  local t = {
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
  }
  if t[before] and t[before] == after then return '<CR><ESC>O' end
  return '<CR>'
end, { expr = true })

map.i('<C-e>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-e>'
  else
    return '<End>'
  end
end, { expr = true })

-- Dired
-------------------------------------------------------------------------------
map.n('<space>e', '!Dired')

return {
  { 'nvimdev/phoenix.nvim', event = 'VeryLazy', dev = true },
  { 'nvimdev/modeline.nvim', event = 'VeryLazy', dev = true, opts = {} },
  { 'nvimdev/indentmini.nvim', event = 'BufEnter', opts = {} },
  { 'nvimdev/dired.nvim', cmd = 'Dired', dev = true },
  {
    'nvimdev/guard.nvim',
    event = { 'BufReadPost', 'FileType' },
    dependencies = 'nvimdev/guard-collection',
    config = function()
      -- See :help guard.nvim.txt
      local ft = require('guard.filetype')
      ft('lua'):fmt('stylua')
      ft(
          'javascript, markdown, css, typescript, javascriptreact, typescriptreact, scss, html, json, json5, jsonc, yaml, astro'
        )
        :fmt('dprint')
        :fmt('biome')
    end,
  },
}
