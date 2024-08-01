return {
  "nvimdev/indentmini.nvim",
  event = { "BufReadPost" },
  config = function()
    require("indentmini").setup() -- use default config
    vim.cmd.highlight("IndentLine guifg=#45475a")
    vim.cmd.highlight("IndentLineCurrent guifg=#9CABCA")
  end,
}
