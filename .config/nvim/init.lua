_G.config = {}

config.plugin = {
  lsp = true,
  treesitter = true,
  completion = true,
  formatter = true,
  picker = true,
  colorscheme = false,
  custom = true,
}

local modules = {
  'function',
  'option',
  'autocmd',
  'keymap',
  'plugin',
}

for _, mod in ipairs(modules) do
  require('config.' .. mod)
end

vim.cmd('colo iceberg')
