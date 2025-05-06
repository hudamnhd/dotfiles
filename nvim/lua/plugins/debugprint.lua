return {
	"andrewferrier/debugprint.nvim",
	event = "BufReadPost",
	opts = {
		keymaps = {
			normal = {
				plain_below = "<space>gp",
				plain_above = "<space>gP",
				variable_below = "<space>gv",
				variable_above = "<space>gV",
				variable_below_alwaysprompt = "",
				variable_above_alwaysprompt = "",
				textobj_below = "<space>go",
				textobj_above = "<space>gO",
				toggle_comment_debug_prints = "",
				delete_debug_prints = "",
			},
			insert = {
				plain = "<C-G>p",
				variable = "<C-G>v",
			},
			visual = {
				variable_below = "<space>gv",
				variable_above = "<space>gV",
			},
		},
		commands = {
			toggle_comment_debug_prints = "ToggleCommentDebugPrints",
			delete_debug_prints = "DeleteDebugPrints",
			reset_debug_prints_counter = "ResetDebugPrintsCounter",
		},
		-- … Other options
	},
	cmd = {
		"ToggleCommentDebugPrints",
		"DeleteDebugPrints",
	},
	version = "*",
	config = function(_, opts)
		require("debugprint").setup(opts)
	end,
}
