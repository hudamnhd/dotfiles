return { -- Better input/selection fields
  "stevearc/dressing.nvim",
  init = function()
    -- lazy load triggers
    vim.ui.select = function(...) ---@diagnostic disable-line: duplicate-set-field
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    vim.ui.input = function(...) ---@diagnostic disable-line: duplicate-set-field
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
  -- keys = {
  --   { "<Tab>", "j", ft = "DressingSelect" },
  --   { "<S-Tab>", "k", ft = "DressingSelect" },
  -- },
  opts = {
    input = {
      insert_only = true, -- = enable normal mode
      start_in_insert = true,
      trim_prompt = true,
      border = vim.g.borderStyle,
      relative = "editor",
      title_pos = "left",
      prefer_width = 45,
      min_width = 0.4,
      max_width = 0.8,
      mappings = { n = { ["q"] = "Close" } },
    },
    select = {
      enabled = false,
      backend = { "fzf-lua", "builtin" },
      trim_prompt = true,
      builtin = {
        mappings = { ["q"] = "Close" },
        show_numbers = false,
        border = vim.g.borderStyle,
        relative = "editor",
        max_width = 80,
        min_width = 20,
        max_height = 12,
        min_height = 3,
      },
    },
  },
}
