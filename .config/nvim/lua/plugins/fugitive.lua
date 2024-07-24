-- stylua: ignore start
return {
  "tpope/vim-fugitive",
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<C-G>", ":vertical Git<cr><c-w>r", { desc = "Git " })

    function map(mode, lhs, rhs, desc, opts)
      opts = { buffer = bufnr, remap = false }
      opts.silent = opts.silent ~= false
      opts.desc = desc
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    map("n", "<leader>gr", "<Esc>:Gread<CR>", "Gread (reset)" )
    map("n", "<leader>gw", "<Esc>:Gwrite<CR>", "Gwrite (stage)" )
    map("n", "<leader>gb", "<Esc>:Git blame<CR>", "git blame" )
    map('n', '<leader>gc', '<Esc>:Git commit<CR>', "git commit" )
    map("n", "<leader>gd", "<Esc>:Git diff<CR>", "Git diff (project)" )
    map("n", "<leader>gv", "<Esc>:Gvdiffsplit!<CR>", "Git diff (buffer)" )
    map("n", "<leader>gp", "<Esc>:Git push<CR>", "Git push" )
    map("n", "<leader>gP", "<Esc>:Git pull<CR>", "Git pull" )
    map("n", "<leader>g+", "<Esc>:Git stash push<CR>", "Git stash push" )
    map("n", "<leader>g-", "<Esc>:Git stash pop<CR>", "Git stash pop" )
    map("n", "<leader>gl", "<Esc>:Git log --stat %<CR>", "Git log (buffer)" )
    map("n", "<leader>gL", "<Esc>:Git log --stat -n 100<CR>", "Git log (project)" )

    local Fugitive = vim.api.nvim_create_augroup("Fugitive", {})

    local autocmd = vim.api.nvim_create_autocmd
    autocmd("BufWinEnter", {
      group = Fugitive,
      pattern = "*",
      callback = function()
        if vim.bo.ft ~= "fugitive" then
          return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }

        map("n", "q", function() vim.cmd("bd") end,"exit", opts)

        map("n", "<leader>p", function() vim.cmd.Git("push") end, "PUSH", opts)
        map("n", "<leader>f", function() vim.cmd.Git("pull") end,"PULL", opts)


        -- rebase always
        map("n", "<leader>P", function() vim.cmd.Git({ "pull", "--rebase" }) end, "REBASE", opts)

        map("n", "<leader>t", ":Git push -u origin ",'PUSH ORIGIN', opts)
        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
      end,
    })

    -- vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
    -- vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
  end,
}
-- stylua: ignore end
