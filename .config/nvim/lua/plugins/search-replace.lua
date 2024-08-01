return {
  {
    "hudamnhd/search-replace.nvim",
    event = "BufReadPost",
    config = function()
      require("search-replace").setup({
        default_replace_single_buffer_options = "g",
      })
      -- stylua: ignore start
      local bind  = require("keymaps").bind

      bind("x", "<C-F>",     [[<CMD>SearchReplaceSingleBufferVisualSelection<CR>]],  { desc = "replace visual" })
      bind("n", "<C-F>",     [[<CMD>SearchReplaceSingleBufferCWord<CR>]],            { desc = "replace cword" })
      bind("x", "<C-B>",     [[<CMD>SearchReplaceWithinVisualSelectionCWord<CR>]],   { desc = "replace cword" })
      bind("n", "<C-B>",     [[:'<,'>s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>]], { desc = "replace cword", silent = false })
      bind("n", "<leader>r", [[<CMD>SearchReplaceSingleBufferOpen<CR>]],             { desc = "Search Replace Search" })
      bind("x", "<leader>r", [[<CMD>SearchReplaceWithinVisualSelection<CR>]],        { desc = "Search Replace Search" })

      -- stylua: ignore end
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
