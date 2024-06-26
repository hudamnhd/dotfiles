return {
  {
    "RRethy/nvim-align",
    keys = { { "<C-N>", mode = { "x" } } },
    config = function()
      -- :'<,'>Align regex_pattern.*
      -- :'<,'>Align =
      -- :Align x\s*=
      -- (escape \ , ., *, +, ?, |, (, ), [, ], {, }, \, /).
      vim.keymap.set("x", "<C-N>", ":Align<space>")
    end,
  },
  {
    "junegunn/vim-easy-align",
    keys = { { "=", mode = { "n", "x" } }, { "=", mode = { "n", "x" } } },
    config = function()
      vim.g.easy_align_delimiters = {
        ["\\"] = {
          pattern = [[\\\+]],
        },
        ["/"] = {
          pattern = [[//\+\|/\*\|\*/]],
          delimiter_align = "c",
          ignore_groups = "!Comment",
        },
      }

    -- stylua: ignore start
       vim.keymap.set({ "n", "x" }, "=",  "<Plug>(EasyAlign)",     { noremap = false })
       vim.keymap.set({ "n", "x" }, "<leader>=",  "<Plug>(LiveEasyAlign)", { noremap = false })
      -- stylua: ignore end
    end,
  },
}
