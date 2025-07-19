_G.config = {}

config.plugin = {
  picker = true,
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
