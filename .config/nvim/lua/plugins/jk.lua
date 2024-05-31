return {
   {
     "rainbowhxch/accelerated-jk.nvim",
     event = { "VimEnter" },
     config = function()
       require("accelerated-jk").setup({
         mode = "time_driven",
         enable_deceleration = false,
         acceleration_motions = { "l", "h" },
         acceleration_limit = 150,
         acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
         -- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
         deceleration_table = { { 150, 9999 } },
       })
       vim.api.nvim_set_keymap("n", "j", "<Plug>(accelerated_jk_gj)", {})
       vim.api.nvim_set_keymap("n", "k", "<Plug>(accelerated_jk_gk)", {})
     end,
   },
  -- {
  --   "rhysd/accelerated-jk",
  --   event = { "VimEnter" },
  --   config = function()
  --     vim.api.nvim_set_keymap("n", "j", "<Plug>(accelerated_jk_gj)", {})
  --     vim.api.nvim_set_keymap("n", "k", "<Plug>(accelerated_jk_gk)", {})
  --   end,
  -- },
  -- {
  --   "rainbowhxch/beacon.nvim",
  --   event = { "BufReadPost" },
  --   config = function()
  --     require("beacon").setup({
  --       enable = true,
  --       size = 40,
  --       fade = true,
  --       minimal_jump = 10,
  --       show_jumps = true,
  --       focus_gained = false,
  --       shrink = true,
  --       timeout = 500,
  --       ignore_buffers = {},
  --       ignore_filetypes = {},
  --     })
  --   end,
  -- },
}
