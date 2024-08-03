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
  -- {
  --   "chrisgrieser/nvim-rip-substitute",
  --   cmd = "RipSubstitute",
  --   keys = {
  --     {
  --       "<leader>s",
  --       function()
  --         require("rip-substitute").sub()
  --       end,
  --       mode = { "n", "x" },
  --       desc = " rip substitute",
  --     },
  --   },
  --   config = function()
  --     require("rip-substitute").setup({
  --       prefill = {
  --         startInReplaceLineIfPrefill = true,
  --       },
  --     })
  --   end,
  -- },
}
