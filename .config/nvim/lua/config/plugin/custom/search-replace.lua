local M = {}

-- SAD: CLI search and replace | Space Age seD
-- https://github.com/ms-jpq/sad/releases/download/v0.4.32/x86_64-unknown-linux-gnu.zip
-------------------------------------------------------------------------------
if vim.fn.executable("sad") == 1 then
	M.search_sad = function()
		local before = vim.fn.input("Search: ")
		if before == "" then
			return
		end

		local after = vim.fn.input("Replace: ")
		if after == "" then
			return
		end

		local cmd = string.format([[rg -l -F %q | sad %q %q]], before, before, after)

		-- Buka tab baru dan nonaktifkan number/signcolumn
		vim.cmd("tabnew")
		vim.cmd("setlocal nonumber signcolumn=no")

		vim.fn.jobstart({
			"sh",
			"-c",
			cmd,
		}, {
			term = true,
			on_exit = function()
				vim.cmd("silent! :bw")
			end,
		})
	end
end

-- SD: Intuitive find & replace CLI (sed alternative)
-- https://github.com/chmln/sd/releases/download/v1.0.0/sd-v1.0.0-x86_64-unknown-linux-musl.tar.gz
-------------------------------------------------------------------------------
local last_cmd_preview = nil
local last_cmd_replace = nil
local last_search_preview = nil
if vim.fn.executable("sd") == 1 then
	-- NOTE: Faster replacer
	M.search_sd = function(replace)
		replace = replace or false
		local before = vim.fn.input("Search: ")
		if before == "" then
			return
		end

		local after = vim.fn.input("Replace: ")
		if after == "" then
			return
		end

		last_cmd_preview = string.format([[rg -l -F %q | xargs -r -I{} sd -F -p %q %q {}]], before, before, after)

		last_search_preview = string.format([[%q with %q]], before, after)

		last_cmd_replace = string.format([[rg -l -F %q | xargs -r -I{} sd -F %q %q {}]], before, before, after)

		if replace then
			M.replace_sd()
			return
		end
		-- Buka tab baru dan nonaktifkan number/signcolumn
		vim.cmd("tabnew")
		vim.cmd("setlocal nonumber signcolumn=no")

		vim.fn.jobstart({
			"sh",
			"-c",
			string.format(
				[[ %s | fzf --ansi --query %q --preview="echo {}" --preview-window=up:70%% --bind=enter:accept ]],
				last_cmd_preview,
				after
			),
		}, {
			term = true,
			cwd = vim.fn.getcwd(),
			-- on_exit = function() vim.cmd('silent! :bw') end,
		})
	end

	M.replace_sd = function()
		if not last_cmd_replace then
			vim.notify("No previous command to rerun.", vim.log.levels.WARN)
			return
		end

		vim.cmd("tabnew")
		vim.cmd("setlocal nonumber signcolumn=no")

		vim.fn.jobstart({ "sh", "-c", last_cmd_replace }, {
			term = true,
			cwd = vim.fn.getcwd(),
			on_exit = function()
				vim.cmd("silent! :checktime")
				vim.cmd("silent! bw")
				last_cmd_preview = nil
				last_cmd_replace = nil
				vim.schedule(function()
					vim.api.nvim_echo({
						{ "Success replace: " },
						{ ("%s."):format(last_search_preview), "WarningMsg" },
					}, true, {})
					last_search_preview = nil
				end)
			end,
		})
	end
end

vim.keymap.set("n", "<Leader>xs", M.search_sad, { desc = "Search Replace Sad" })
vim.keymap.set("n", "<Leader>xx", function()
	M.search_sd(true)
end, { desc = "Replace Sd" })
vim.keymap.set("n", "<Leader>xz", function()
	if last_cmd_preview then
		M.replace_sd()
	else
		M.search_sd()
	end
end, { desc = "Search Replace Sd (preview)" })
return M

--------------------------------------------------------------------------------
