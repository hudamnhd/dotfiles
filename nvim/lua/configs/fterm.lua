require('FTerm').setup({
  border = 'rounded',
  dimensions = {
    height = 0.9,
    width = 0.9,
  },
})
local fterm = require('FTerm')

local gitui = fterm:new({
  ft = 'fterm_gitui', -- You can also override the default filetype, if you want
  cmd = 'gitui',
  dimensions = {
    height = 0.95,
    width = 0.95,
  },
})

-- Use this to toggle gitui in a floating terminal
vim.keymap.set('n', '<F7>', function()
  gitui:toggle()
end)
vim.keymap.set('t', '<F7>', function()
  gitui:toggle()
end)
-- Example keybindings
vim.keymap.set('n', '<F8>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set(
  't',
  '<F8>',
  '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>'
)
