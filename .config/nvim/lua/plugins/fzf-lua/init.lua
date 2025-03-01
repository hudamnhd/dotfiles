return {
  "ibhagwan/fzf-lua",
  enabled = vim.fn.executable("fzf") == 1,
  event = "VeryLazy",
  build = "fzf --version",
  config = function()
    require("plugins.fzf-lua.fzf-lua")
  end,
}
