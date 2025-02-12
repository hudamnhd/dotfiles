return {
  {
    "hudamnhd/search-replace.nvim",
    enabled = true,
    event = "BufReadPost",
    config = function()
      require("search-replace").setup({
        default_replace_single_buffer_options = "g",
      })
    end,
  },
}
