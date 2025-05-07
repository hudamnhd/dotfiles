vim.api.nvim_create_autocmd('TextYankPost', {
    group = 'user_cmds',
    desc = 'Highlight text after is copied',
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 80 })
    end
})

vim.api.nvim_create_autocmd('FileType', {
    group = 'user_cmds',
    pattern = { 'qf', 'help', 'man' },
    command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'user_cmds',
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
