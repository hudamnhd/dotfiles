return {
	"gelguy/wilder.nvim",
	event = "CmdlineEnter",
	-- event = "VeryLazy",
	build = function()
		vim.cmd("UpdateRemotePlugins")
	end,
	config = function()
		-- require("wilder").setup({ modes = { ":", "/", "?" } })
		vim.opt.wildmenu = false -- disable wildmenu because wilder is enough
		local wilder = require("wilder")
		wilder.setup({ modes = { ":", "/", "?" } })

		wilder.set_option("pipeline", {
			wilder.branch(wilder.cmdline_pipeline(), wilder.search_pipeline()),
		})

		wilder.set_option(
			"renderer",
			wilder.wildmenu_renderer({
				highlighter = wilder.basic_highlighter(),
				-- taken from: https://github.com/gelguy/wilder.nvim#better-highlighting
				highlights = {
					accent = wilder.make_hl(
						"WilderAccent",
						"Pmenu",
						{ { a = 1 }, { a = 1 }, { foreground = "#cccccc" } }
					),
				},
			})
		)
	end,
}
