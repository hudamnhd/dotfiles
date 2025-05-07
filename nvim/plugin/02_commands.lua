vim.api.nvim_create_autocmd('TextYankPost', {
    group = 'user_cmds',
    desc = 'Highlight text after is copied',
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 400 })
    end
})

vim.api.nvim_create_autocmd('FileType', {
    group = 'user_cmds',
    pattern = { 'help', 'man' },
    callback = function()
        local buftype = vim.bo.buftype
        if buftype == "help" or buftype == "nofile" then
            vim.keymap.set("n", "q", vim.cmd.bd, { buffer = true, nowait = true })
            vim.cmd("wincmd H")
        end
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = 'user_cmds',
    pattern = { "markdown", "txt" },
    callback = function()
        vim.opt_local.spell = false
    end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = 'user_cmds',
    pattern = "*",
    command =
    [[if line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG' | exe "normal! g`\"" | endif]],
    desc = "Return to last edit position when opening files",
})

vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'user_cmds',
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
