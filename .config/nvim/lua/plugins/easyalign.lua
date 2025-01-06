return {
  {
    "RRethy/nvim-align",
    keys = function()
      return {
        { "gn", mode = { "x" }, ":Align<space>", desc = "nvim-align" },
      }
    end,
    config = function()
      -- :'<,'>Align regex_pattern.*
      -- :'<,'>Align =
      -- :Align x\s*=
      -- (escape \ , ., *, +, ?, |, (, ), [, ], {, }, \, /).
    end,
  },
  {
    "junegunn/vim-easy-align",
    keys = function()
      return {
        { "ga", mode = { "n", "x" }, "<Plug>(EasyAlign)", desc = "EasyAlign" },
        { "gA", mode = { "n", "x" }, "<Plug>(LiveEasyAlign)", desc = "LiveEasyAlign" },
      }
    end,
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
    end,
  },
}
