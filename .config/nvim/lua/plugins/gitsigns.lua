local M = {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost" },
}

M.keys = {

  -- 	-- stylua: ignore start
  	{ ">", "<cmd>Gitsigns nav_hunk next<CR>",   desc = "󰊢 Next Hunk", mode = { "n" }, },
  	{ "<", "<cmd>Gitsigns nav_hunk prev<CR>",   desc = "󰊢 Previous Hunk", mode = { "n" },},
}

M.config = function()
  require("gitsigns").setup({
    -- signs_staged_enable = true, -- PENDING above

    attach_to_untracked = true,
    max_file_length = 3000, -- lines
			-- stylua: ignore
			count_chars = { "", "󰬻", "󰬼", "󰬽", "󰬾", "󰬿", "󰭀", "󰭁", "󰭂", ["+"] = "󰿮" },
    signs = {
      delete = { show_count = true },
      topdelete = { show_count = true },
      changedelete = { show_count = true },
    },
  })
end

return M
