return {
  {
    "RRethy/nvim-align",
    keys = { { "<C-N>", mode = { "x" } } },
    config = function()
      -- :'<,'>Align regex_pattern.*
      -- :'<,'>Align =
      -- :Align x\s*=
      -- (escape \ , ., *, +, ?, |, (, ), [, ], {, }, \, /).
      vim.keymap.set("x", "<C-N>", ":Align<space>", { desc = "Align" })
    end,
  },
  {
    "junegunn/vim-easy-align",
    keys = { { "=", mode = { "n", "x" } }, { "g=", mode = { "n", "x" } } },
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
       vim.keymap.set({ "n", "x" }, "=",  "<Plug>(EasyAlign)",     { noremap = false, desc ="EasyAlign" })
       vim.keymap.set({ "n", "x" }, "g=", "<Plug>(LiveEasyAlign)", { noremap = false, desc ="LiveEasyAlign"  })
      -- stylua: ignore end
    end,
  },
}
