return {
  "andrewferrier/debugprint.nvim",
  opts = {
    keymaps = {
      normal = {
        variable_below = "<F8>",
      },
      visual = {
        variable_below = "<F8>",
      },
    },
    commands = {
      toggle_comment_debug_prints = "ToggleCommentDebugPrints",
      delete_debug_prints = "DeleteDebugPrints",
    },
  },
  keys = {
    { "<F8>", mode = "n" },
    { "<F8>", mode = "x" },
  },
  cmd = {
    "ToggleCommentDebugPrints",
    "DeleteDebugPrints",
  },
  version = "*",
}
