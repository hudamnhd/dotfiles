local M = {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost" },
}

M.config = function()
  require("gitsigns").setup({
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    sign_priority = 4, -- Lower priorirty means diag signs supercede
    preview_config = { border = "rounded" },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      local opts = { buffer = buf, expr = true, replace_keycodes = false }

      -- Navigation
      map("n", "]c", "&diff ? ']c' : '<CMD>Gitsigns next_hunk<CR>'", opts)
      map("n", "[c", "&diff ? '[c' : '<CMD>Gitsigns prev_hunk<CR>'", opts)

      -- Actions
      map({ "n", "v" }, "gr", gs.reset_hunk, { buffer = buf })
      map({ "n", "v" }, "ga", gs.stage_hunk)

      map("n", "gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "sh", gs.preview_hunk, { buffer = buf })

      -- text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = buf })
    end,
  })
end

return M
