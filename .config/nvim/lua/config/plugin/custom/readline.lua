--- Readline
local function readline()
  vim.keymap.set('i', '<C-a>', '<C-o>^', { desc = 'move to end of first non-whitespace character in line' })
  vim.keymap.set('c', '<C-a>', '<Home>', { silent = false, desc = 'move cursor to start of command line' })
  vim.keymap.set('i', '<C-b>', function()
    local line = vim.fn.getline('.')
    local col = vim.fn.col('.')
    if line:match('^%s*$') and col > #line then
      return '0<C-D><Esc>kJs'
    else
      return '<Left>'
    end
  end, { expr = true, desc = 'move cursor left or handle empty line' })
  vim.keymap.set('c', '<C-b>', '<left>', { silent = false, desc = 'move cursor one position left in command line' })
  vim.keymap.set('i', '<C-d>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len then
      return '<C-d>'
    else
      return '<Del>'
    end
  end, { expr = true, desc = 'delete character or handle end of line in insert mode' })
  vim.keymap.set('c', '<C-d>', function()
    local pos = vim.fn.getcmdpos()
    local len = #vim.fn.getcmdline()
    if pos > len then
      return '<C-d>'
    else
      return '<Del>'
    end
  end, { expr = true, silent = false, desc = 'delete in command line depending on cursor position' })
  vim.keymap.set('i', '<C-e>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len or vim.fn.pumvisible() == 1 then
      return '<C-e>'
    else
      return '<End>'
    end
  end, { expr = true, desc = 'move to end of line or show completion menu' })
  vim.keymap.set('i', '<C-f>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len then
      return '<C-f>'
    else
      return '<Right>'
    end
  end, { expr = true, desc = 'move cursor right or handle end of line' })
  vim.keymap.set('c', '<C-f>', function()
    local pos = vim.fn.getcmdpos()
    local len = #vim.fn.getcmdline()
    if pos > len then
      return vim.o.cedit
    else
      return '<Right>'
    end
  end, {
    expr = true,
    silent = false,
    desc = 'move cursor right in command line depending on position',
  })
end

-- Readline
vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'InsertEnter' }, {
  group = 'UserCmds',
  desc = 'Readline setup',
  once = true,
  callback = vim.schedule_wrap(function() readline() end),
})
