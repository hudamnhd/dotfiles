-- Customize 'mini.nvim'
vim.b.minisurround_config = {
  custom_surroundings = {
    s = { input = { '%[%[().-()%]%]' }, output = { left = '[[', right = ']]' } },
  }
}
