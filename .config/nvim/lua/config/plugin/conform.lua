require('conform').setup({
  formatters_by_ft = {
    astro = { 'dprint' },
    css = { 'biome' },
    html = { 'dprint' },
    json = { 'dprint' },
    json5 = { 'dprint' },
    jsonc = { 'dprint' },
    lua = { 'stylua' },
    markdown = { 'biome' },
    scss = { 'dprint' },
    sh = { 'shfmt' },
    javascript = { 'dprint' },
    javascriptreact = { 'dprint' },
    typescript = { 'dprint' },
    typescriptreact = { 'dprint' },
  },
})


vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set('n', 'gq', '<Cmd>lua require("conform").format()<CR>', { desc = 'Buf format' })
