return {
  "numToStr/FTerm.nvim",
  keys = { "<c-g>" },
  config = function()
    require("FTerm").setup({
      border = "rounded",
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
    })
    local fterm = require("FTerm")

    local gitui = fterm:new({
      ft = "fterm_gitui", -- You can also override the default filetype, if you want
      cmd = "gitui",
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })
    -- Use this to toggle gitui in a floating terminal
    vim.keymap.set("n", "<c-g>", function()
      gitui:toggle()
    end)
    vim.keymap.set("t", "<c-g>", function()
      gitui:toggle()
    end)
    -- Example keybindings
    -- vim.keymap.set("n", "<a-t>", '<CMD>lua require("FTerm").toggle()<CR>')
    -- vim.keymap.set("t", "<a-t>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
  end,
}
