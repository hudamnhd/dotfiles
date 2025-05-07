return {
  "andrewferrier/debugprint.nvim",
  event = "BufReadPost",
  opts = {
    keymaps = {
      normal = {
        plain_below = "<c-g>p",
        plain_above = "<c-g>P",
        variable_below = "<c-g>v",
        variable_above = "<c-g>V",
        variable_below_alwaysprompt = "",
        variable_above_alwaysprompt = "",
        textobj_below = "<c-g>o",
        textobj_above = "<c-g>O",
        toggle_comment_debug_prints = "",
        delete_debug_prints = "",
      },
      insert = {
        plain = "<C-G>p",
        variable = "<C-G>v",
      },
      visual = {
        variable_below = "<c-g>v",
        variable_above = "<c-g>V",
      },
    },
    commands = {
      toggle_comment_debug_prints = "ToggleCommentDebugPrints",
      delete_debug_prints = "DeleteDebugPrints",
      reset_debug_prints_counter = "ResetDebugPrintsCounter",
    },
    -- … Other options
  },
  cmd = {
    "ToggleCommentDebugPrints",
    "DeleteDebugPrints",
  },
  version = "*",
  config = function(_, opts)
    require("debugprint").setup(opts)
  end,
}
