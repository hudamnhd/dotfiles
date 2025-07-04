require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' }, -- https://github.com/JohnnyMorganz/StyLua?tab=readme-ov-file#installation
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set('n', 'gq', '<Cmd>lua require("conform").format()<CR>', { desc = 'Format buffer' })
