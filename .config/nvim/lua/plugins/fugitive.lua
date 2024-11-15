local M = {
  "tpope/vim-fugitive",
  dependencies = {
    {
      "junegunn/gv.vim",
      cmd = { "GV" },
    },
  },
  cmd = { "Git", "Gvdiffsplit" },
}

M.init = function()
  -- copas ThePrimeagen
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
      vim.keymap.set("n", "<space>l", function() vim.cmd("Git pull") end, opts)
      vim.keymap.set("n", "<space>p", function() vim.cmd("Git push") end, opts)
      vim.keymap.set("n", "q", function() vim.cmd("bd") end, opts)
      -- stylua: ignore end
    end,
  })
end

return M
