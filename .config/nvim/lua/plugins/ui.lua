return {
  -- {
  --   "catppuccin/nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.g.catppuccin_flavour = "mocha"
  --     require("catppuccin").setup({
  --       compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  --       color_overrides = {
  --         mocha = {
  --           base = "#131313",
  --         },
  --       },
  --       term_colors = true,
  --       integrations = {
  --         treesitter = true,
  --         gitsigns = true,
  --         cmp = true,
  --         ufo = true,
  --       },
  --     })
  --      pcall(vim.cmd, [[colorscheme catppuccin]])
  --   end,
  -- },
  {
    "bluz71/nvim-linefly",
    lazy = false,
    config = function()
      vim.g.linefly_options = {
        separator_symbol = "◆",
        progress_symbol = "↓",
        active_tab_symbol = "▪",
        git_branch_symbol = "",
        error_symbol = "E",
        warning_symbol = "W",
        information_symbol = "I",
        ellipsis_symbol = "…",
        tabline = false,
        winbar = false,
        with_file_icon = true,
        with_git_branch = true,
        with_git_status = true,
        with_diagnostic_status = true,
        with_session_status = true,
        with_attached_clients = true,
        with_macro_status = false,
        with_search_count = false,
        with_spell_status = false,
        with_indent_status = true,
      }
    end,
  },
}
