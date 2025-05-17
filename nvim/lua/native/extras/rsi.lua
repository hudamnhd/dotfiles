vim.keymap.set('i', '<C-A>', '<C-O>^')
vim.keymap.set('c', '<C-A>', '<Home>', { silent = false })

vim.keymap.set('i', '<C-B>', function()
  local line = vim.fn.getline('.')
  local col = vim.fn.col('.')
  if line:match('^%s*$') and col > #line then
    return '0<C-D><Esc>kJs'
  else
    return '<Left>'
  end
end, { expr = true })

vim.keymap.set('c', '<C-B>', '<Left>', { silent = false })

vim.keymap.set('i', '<C-D>', function()
  local col = vim.fn.col('.')
  local len = #vim.fn.getline('.')
  if col > len then
    return '<C-D>'
  else
    return '<Del>'
  end
end, { expr = true })

vim.keymap.set('c', '<C-D>', function()
  local pos = vim.fn.getcmdpos()
  local len = #vim.fn.getcmdline()
  if pos > len then
    return '<C-D>'
  else
    return '<Del>'
  end
end, { expr = true, silent = false })

vim.keymap.set('i', '<C-E>', function()
  local col = vim.fn.col('.')
  local len = #vim.fn.getline('.')
  if col > len or vim.fn.pumvisible() == 1 then
    return '<C-E>'
  else
    return '<End>'
  end
end, { expr = true })

vim.keymap.set('i', '<C-F>', function()
  local col = vim.fn.col('.')
  local len = #vim.fn.getline('.')
  if col > len then
    return '<C-F>'
  else
    return '<Right>'
  end
end, { expr = true })

vim.keymap.set('c', '<C-F>', function()
  local pos = vim.fn.getcmdpos()
  local len = #vim.fn.getcmdline()
  if pos > len then
    return vim.o.cedit
  else
    return '<Right>'
  end
end, { expr = true, silent = false })
