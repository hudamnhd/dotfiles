vim.api.nvim_create_autocmd({ "FileType", "LspAttach" }, {
	group = "user_cmds",
	callback = function(e)
		-- execlude vim-fugitive
		if vim.bo.filetype == "fugitive" or e.file:match("^fugitive:") then
			return
		end
		require("plugins.conform")._set_gq_keymap(e)
	end,
})

return {
	"stevearc/conform.nvim",
	event = "BufReadPost",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				sh = { "shfmt" },
				javascript = { "biome" },
				typescript = { "dprint" },
				javascriptreact = { "dprint" },
				typescriptreact = { "dprint" },
				css = { "biome" },
				scss = { "dprint" },
				html = { "dprint" },
				json = { "dprint" },
				json5 = { "dprint" },
				jsonc = { "dprint" },
				yaml = { "dprint" },
				markdown = { "biome" },
				astro = { "dprint" },
				lua = { "stylua" },
				["_"] = { "trim_whitespace", "trim_newlines" },
			},
		})
	end,
	_set_gq_keymap = function(e)
		-- priortize LSP formatting as `gq`
		local lsp_has_formatting = false
		local lsp_clients = vim.lsp.get_clients({ bufnr = e.buf })
		local lsp_keymap_set = function(m, c)
			vim.keymap.set(m, "gq", function()
				vim.lsp.buf.format({ async = true, bufnr = e.buf })
			end, {
				silent = true,
				buffer = e.buf,
				desc = string.format("format document [LSP:%s]", c.name),
			})
		end
		vim.tbl_map(function(c)
			if c:supports_method("textDocument/rangeFormatting", { bufnr = e.buf }) then
				lsp_keymap_set("x", c)
				lsp_has_formatting = true
			end
			if c:supports_method("textDocument/formatting", { bufnr = e.buf }) then
				lsp_keymap_set("n", c)
				lsp_has_formatting = true
			end
		end, lsp_clients)
		-- check conform.nvim for formatters:
		--   (1) if we have no LSP formatter map as `gq`
		--   (2) if LSP formatter exists, map as `gQ`
		local ok, conform = pcall(require, "conform")
		local formatters = ok and conform.list_formatters(e.buf) or {}
		if #formatters > 0 then
			vim.keymap.set("n", lsp_has_formatting and "gQ" or "gq", function()
				require("conform").format({ async = true, buffer = e.buf, lsp_fallback = false })
			end, {
				silent = true,
				buffer = e.buf,
				desc = string.format("format document [%s]", formatters[1].name),
			})
		end
	end,
}
