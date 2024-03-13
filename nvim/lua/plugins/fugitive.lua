local M = {
  "tpope/vim-fugitive",
  keys = function()
    return {
      { "gh", "<cmd>vert Git<cr><c-w>r", desc = "Git" },
    }
  end,
}

M.init = function()
  local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
  local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

  autocmd("BufWinEnter", {
    group = ThePrimeagen_Fugitive,
    pattern = "*",
    callback = function()
      -- Check if the buffer file type is "fugitive"
      if vim.bo.ft ~= "fugitive" then
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      local opts = { buffer = bufnr, remap = false }

      -- stylua: ignore start
      vim.keymap.set("n", "<leader>l", function() vim.cmd("Git pull") end, opts)
      vim.keymap.set("n", "<leader>p", function() vim.cmd("Git push") end, opts)
      vim.keymap.set("n", "q",         function() vim.cmd("bd") end, opts)
      -- stylua: ignore end
    end,
  })
end

return M

-- local function get_branch_name()
--   local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
--   return branch
-- end
-- { "<leader>gl", "<cmd>Gllog<cr>", desc = "Diff" },
-- { "<leader>gL", "<cmd>Gllog -- %<cr>", desc = "Diff" },
-- { "<leader>gl", "<cmd>tab Git log --decorate=short<cr>", desc = "Logs" },
-- { "<leader>gw", "<cmd>tab Git show --decorate=short<cr>", desc = "Show" },
-- { "<leader>grs", ":Git rebase ", desc = "Start" },
-- { "<leader>grc", "<cmd>Git rebase --continue<cr>", desc = "Continue" },
-- { "<leader>gra", "<cmd>Git rebase --abort<cr>", desc = "Abort" },
-- { "<leader>gsm", "<cmd>Git switch master <cr>", desc = "Master" },
-- { "<leader>gtt", "<cmd>Git stash<cr>", desc = "Stash" },
-- { "<leader>gtp", "<cmd>Git stash pop<cr>", desc = "Pop" },
-- { "<leader>gx", "<cmd>Git reset .<cr>", desc = "Reset soft" },
-- { "<leader>gpp", "<cmd>Git push<cr>", desc = "Push" },
-- { "<leader>gu", "<cmd>Git pull<cr>", desc = "Pull" },
-- { "<leader>gpf", "<cmd>Git push --force-with-lease<cr>", desc = "Force" },
-- { "<leader>gpu", "<cmd>Git push -u origin " .. get_branch_name() .. "<cr>", desc = "Upstream", },
-- { "<leader>gss", ":Git switch ", desc = "Switch" },
-- { "<leader>gsc", ":Git switch -c ", desc = "Create" },
-- { "<leader>gm", ":Git merge " .. get_branch_name() .. " ", desc = "Merge" },
-- { "<leader>gca", "<cmd>tab Git commit --amend --no-edit<cr>", desc = "Ammend" },
