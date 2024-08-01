-- stylua: ignore start
return {
  "tpope/vim-fugitive",
  keys = { "<C-G>", "<leader>g" },
  config = function()
    vim.keymap.set("n", "<C-G>", ":vertical Git<cr><c-w>r", { desc = "Git " })

    function map(mode, lhs, rhs, desc, opts)
      opts = {}
      opts.silent = opts.silent ~= false
      opts.desc = desc
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    map("n", "<leader>gr", "<Esc>:Gread<CR>",                 "Gread (reset)" )
    map("n", "<leader>gw", "<Esc>:Gwrite<CR>",                "Gwrite (stage)" )
    map("n", "<leader>gb", "<Esc>:Git blame<CR>",             "git blame" )
    map('n', '<leader>gc', '<Esc>:Git commit<CR>',            "git commit" )
    map("n", "<leader>gd", "<Esc>:Git diff<CR>",              "Git diff (project)" )
    map("n", "<leader>gv", "<Esc>:Gvdiffsplit!<CR>",          "Git diff (buffer)" )
    map("n", "<leader>gp", "<Esc>:Git push<CR>",              "Git push" )
    map("n", "<leader>gf", "<Esc>:Git pull<CR>",              "Git pull" )
    map("n", "<leader>g+", "<Esc>:Git stash push<CR>",        "Git stash push" )
    map("n", "<leader>g-", "<Esc>:Git stash pop<CR>",         "Git stash pop" )
    map("n", "<leader>gl", "<Esc>:Git log --stat %<CR>",      "Git log (buffer)" )
    map("n", "<leader>gL", "<Esc>:Git log --stat -n 100<CR>", "Git log (project)" )


    local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

    local autocmd = vim.api.nvim_create_autocmd
    autocmd("BufWinEnter", {
        group = ThePrimeagen_Fugitive,
        pattern = "*",
        callback = function()
            if vim.bo.ft ~= "fugitive" then
                return
            end

            local bufnr = vim.api.nvim_get_current_buf()
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "q", vim.cmd.bd, opts)

            vim.keymap.set("n", "<leader>p", function() vim.cmd('AsyncTask git-push') end, opts)
            vim.keymap.set("n", "<leader>f", function() vim.cmd('AsyncTask git-pull') end, opts)

            -- rebase always
            vim.keymap.set("n", "<leader>P", function() vim.cmd.Git({'pull',  '--rebase'}) end, opts)

            -- NOTE: It allows me to easily set the branch i am pushing and any tracking
            -- needed if i did not set the branch up correctly
            vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
        end,
    })


    -- vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
    -- vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
  end,
}
-- stylua: ignore end
