return {
  {
    --- https://github.com/stevearc/oil.nvim
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "-",
        ":Oil<CR>",
        mode = "n",
        desc = "Open Oil",
        noremap = true,
        silent = true,
      },
      {
        "z-",
        ":lua require('oil').toggle_float()<CR>",
        mode = "n",
        desc = "Toggle Oil float",
        noremap = true,
        silent = true,
      },
    },
    config = function()
      require("user.oil")
    end,
  },
}
