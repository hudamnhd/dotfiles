return {
  {
    "hudamnhd/search-replace.nvim",
    event = "BufReadPost",
    config = function()
      require("search-replace").setup({
        default_replace_single_buffer_options = "g",
      })
    end,
  },
}
