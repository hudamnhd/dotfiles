return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  -- event = "BufReadPre",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    local icons = require("utils").icons.ui
    local gs = require("gitsigns")

    gs.setup({
      preview_config = {
        border = "solid",
        style = "minimal",
      },
      signs = {
        add = { text = vim.trim(icons.GitSignAdd) },
        untracked = { text = vim.trim(icons.GitSignUntracked) },
        change = { text = vim.trim(icons.GitSignChange) },
        delete = { text = vim.trim(icons.GitSignDelete) },
        topdelete = { text = vim.trim(icons.GitSignTopdelete) },
        changedelete = { text = vim.trim(icons.GitSignChangedelete) },
      },
      signs_staged_enable = false,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 100,
      },
    })
  end,
}
