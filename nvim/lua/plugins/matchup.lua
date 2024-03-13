return {
  "andymass/vim-matchup",
  event = "VeryLazy",
  config = function()
    vim.g.matchup_matchparen_enabled = 0
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
