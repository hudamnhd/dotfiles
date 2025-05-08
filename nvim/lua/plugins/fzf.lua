return {
	"ibhagwan/fzf-lua",
	enabled = vim.fn.executable("fzf") == 1,
	event = "VeryLazy",
	build = "fzf --version",
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			{ "border-fused", "hide" },

			hls = { border = "Normal" },
			fzf_colors = {
				true, -- inherit fzf colors that aren't specified below from
				["fg"] = { "fg", "Comment" },
				["bg"] = { "bg", "Normal" },
				["hl"] = { "fg", "Statement" },
				["fg+"] = { "fg", "Normal" },
				["bg+"] = { "bg", { "CursorLine", "Normal" } },
				["hl+"] = { "fg", "Statement" },
				["info"] = { "fg", "PreProc" },
				["prompt"] = { "fg", "Conditional" },
				["pointer"] = { "fg", "Exception" },
				["marker"] = { "fg", "Keyword" },
				["spinner"] = { "fg", "Label" },
				["header"] = { "fg", "Comment" },
				["gutter"] = "-1",
			},
		-- taken from: https://github.com/Bekaboo/dot/blob/b4f02b7a821a7f43c1175b0588987dd9f94d3efb/.config/nvim/lua/configs/fzf-lua.lua#L528
			winopts = {
				backdrop = 100,
				split = [[
					let tabpage_win_list = nvim_tabpage_list_wins(0) |
					\ call v:lua._G.win.saveheights(tabpage_win_list) |
					\ call v:lua._G.win.saveviews(tabpage_win_list) |
					\ unlet tabpage_win_list |
					\ let g:_fzf_vim_lines = &lines |
					\ let g:_fzf_leave_win = win_getid(winnr()) |
					\ let g:_fzf_splitkeep = &splitkeep | let &splitkeep = "topline" |
					\ let g:_fzf_cmdheight = &cmdheight | let &cmdheight = 0 |
					\ let g:_fzf_laststatus = &laststatus | let &laststatus = 0 |
					\ botright 10new |
					\ exe 'resize' .
					  \ (12 + g:_fzf_cmdheight + (g:_fzf_laststatus ? 1 : 0)) |
					\ let w:winbar_no_attach = v:true |
					\ setlocal bt=nofile bh=wipe nobl noswf wfh
				    ]],
				on_create = function()
					vim.keymap.set(
						't',
						'<C-r>',
						[['<C-\><C-N>"' . nr2char(getchar()) . 'pi']],
						{
							expr = true,
							buffer = true,
							desc = 'Insert contents in a register',
						}
					)
				end,
				on_close = function()
					---@param name string
					---@return nil
					local function _restore_global_opt(name)
						local backup_name = '_fzf_' .. name
						local backup = vim.g[backup_name]
						if backup ~= nil and vim.go[name] ~= backup then
							vim.go[name] = backup
							vim.g[backup_name] = nil
						end
					end

					_restore_global_opt('splitkeep')
					_restore_global_opt('cmdheight')
					_restore_global_opt('laststatus')

					if
						vim.g._fzf_leave_win
						and vim.api.nvim_win_is_valid(vim.g._fzf_leave_win)
						and vim.api.nvim_get_current_win() ~= vim.g._fzf_leave_win
					then
						vim.api.nvim_set_current_win(vim.g._fzf_leave_win)
					end
					vim.g._fzf_leave_win = nil

					if vim.go.lines == vim.g._fzf_vim_lines then
						win.restheights()
					end
					vim.g._fzf_vim_lines = nil
					win.clearheights()
					win.restviews()
					win.clearviews()
				end,
				preview = {
					hidden = 'hidden',
					layout = 'horizontal',
				},
			},
		}
		)

		fzf.register_ui_select(function(o, items)
			local min_h, max_h = 0.15, 0.70
			local preview = o.kind == "codeaction" and 0.20 or 0
			local h = (#items + 4) / vim.o.lines + preview
			if h < min_h then
				h = min_h
			elseif h > max_h then
				h = max_h
			end
			return { winopts = { height = h, width = 0.60, row = 0.40 } }
		end)

		-- stylua: ignore start
		vim.keymap.set("i", "<c-x><c-f>", fzf.complete_path, { desc = "Fzf 'complete_path'" }) -- remap
		vim.keymap.set("i", "<c-x><c-l>", fzf.complete_line, { desc = "Fzf 'complete_line'" }) -- remap
		vim.keymap.set("n", "<a-p>", fzf.builtin, { desc = "Fzf 'builtin'" })
		vim.keymap.set("n", "<c-b>", fzf.buffers, { desc = "Fzf 'buffers'" })
		vim.keymap.set("x", "sk", fzf.grep_visual, { desc = "Fzf 'grep_visual'" })
		vim.keymap.set("n", "sk", fzf.grep_cword, { desc = "Fzf 'grep_cword'" })
		vim.keymap.set("n", "sr", fzf.live_grep_resume, { desc = "Fzf 'live_grep_resume'" })
		vim.keymap.set("n", "si", fzf.grep, { desc = "Fzf 'grep'" })
		vim.keymap.set("n", "sl", fzf.lgrep_curbuf, { desc = "Fzf 'live_grep_buffer'" })
		vim.keymap.set("n", "ss", fzf.resume, { desc = "Fzf 'resume'" })
		vim.keymap.set("n", "s0", fzf.command_history, { desc = "Fzf 'command_history'" }) -- remap : to 0 easy press
		vim.keymap.set("n", "sp", fzf.files, { desc = "Fzf 'files'" })
		vim.keymap.set("n", "sh", fzf.search_history, { desc = "Fzf 'search_history'" })
		vim.keymap.set("n", "z=", fzf.spell_suggest, { desc = "Fzf 'spell_suggest'" })

		vim.api.nvim_create_user_command("F", function(info)
			fzf.files({ cwd = info.fargs[1] })
		end, {
			nargs = "?",
			complete = "dir",
			desc = "Fuzzy find files.",
		})

		local commands = {
			{ execute = fzf.diagnostics_document,  name = "Fzf 'diagnostics_document'" },
			{ execute = fzf.diagnostics_workspace, name = "Fzf 'diagnostics_workspace'" },
		}


		local function is_typescript_tools_active()
			for _, client in pairs(vim.lsp.get_clients()) do
				if client.name == "typescript-tools" then
					return true
				end
			end
			return false
		end

		local lsp_attach = function()
			if is_typescript_tools_active() then
				local extra_commands = {
					{ execute = vim.cmd.TSToolsOrganizeImports,      name = "TS 'OrganizeImports'" },
					{ execute = vim.cmd.TSToolsSortImports,          name = "TS 'SortImports'" },
					{ execute = vim.cmd.TSToolsRemoveUnusedImports,  name = "TS 'RemoveUnusedImports'" },
					{ execute = vim.cmd.TSToolsRemoveUnused,         name = "TS 'RemoveUnused'" },
					{ execute = vim.cmd.TSToolsAddMissingImports,    name = "TS 'AddMissingImports'" },
					{ execute = vim.cmd.TSToolsFixAll,               name = "TS 'FixAll'" },
					{ execute = vim.cmd.TSToolsGoToSourceDefinition, name = "TS 'GoToSourceDefinition'" },
					{ execute = vim.cmd.TSToolsRenameFile,           name = "TS 'RenameFile'" },
					{ execute = vim.cmd.TSToolsFileReferences,       name = "TS 'FileReferences'" },
				}

				for _, cmd in ipairs(extra_commands) do
					table.insert(commands, cmd)
				end
			end

			local lsp_commands = {
				{ execute = fzf.lsp_document_symbols,       name = "Fzf 'lsp_document_symbols'" },
				{ execute = fzf.lsp_live_workspace_symbols, name = "Fzf 'lsp_live_workspace_symbols'" },
				{ execute = fzf.lsp_definitions,            name = "Fzf 'lsp_definitions'" },
				{ execute = fzf.lsp_definitions,            name = "Fzf 'lsp_definitions'" },
				{ execute = fzf.lsp_typedefs,               name = "Fzf 'lsp_typedefs'" },
				{ execute = fzf.lsp_implementations,        name = "Fzf 'lsp_implementations'" },
				{ execute = fzf.lsp_incoming_calls,         name = "Fzf 'lsp_incoming_calls'" },
				{ execute = fzf.lsp_outgoing_calls,         name = "Fzf 'lsp_outgoing_calls'" },
				{ execute = fzf.lsp_references,             name = "Fzf 'lsp_references'" },
				{ execute = fzf.lsp_finder,                 name = "Fzf 'lsp_finder'" },
				{ execute = fzf.lsp_code_actions,           name = "Fzf 'lsp_code_actions'" },
				{ execute = vim.lsp.buf.rename,             name = "Lsp 'vim.lsp.buf.rename'" },
			}

			for _, cmd in ipairs(lsp_commands) do
				table.insert(commands, cmd)
			end

			local function reverse_table(t)
				local reversed = {}
				for i = #t, 1, -1 do
					table.insert(reversed, t[i])
				end
				return reversed
			end

			commands = reverse_table(commands)
			local show_toolbox_lsp = toolbox("Toolbox Files", commands)

			bind("n", "<space>l", show_toolbox_lsp, { desc = "LSP Command" })
		end

		-- stylua: ignore end
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("FzfLuaLspAttachGroup", { clear = true }),
			callback = lsp_attach,
		})


		local api, uv = vim.api, vim.loop

		function fzf.mru()
			local current
			if api.nvim_get_option_value("buftype", { buf = 0 }) == "" then
				current = uv.fs_realpath(api.nvim_buf_get_name(0))
			end

			local files_all = {}
			local files_cwd = {}
			local cwd = vim.fn.expand(vim.uv.cwd())
			local show_all = false

			local mru_files = require("mru").get()

			for _, file in ipairs(mru_files) do
				if file ~= current then
					table.insert(files_all, file)
				end
			end

			local function update_files_cwd()
				files_cwd = {}
				for _, file in ipairs(files_all) do
					local file_absolute_path = vim.fn.fnamemodify(file, ":p")
					if vim.fn.stridx(file_absolute_path, cwd) == 0 then
						local relative_path = vim.fn.fnamemodify(file_absolute_path, ":.")
						table.insert(files_cwd, relative_path)
					end
				end
			end

			update_files_cwd()

			local prompt = "MRU"
			prompt = prompt .. " CWD"

			local function show_fzf(files)
				require("fzf-lua").fzf_exec(files, {
					actions = {
						["default"] = require("fzf-lua").actions.file_edit,
						["ctrl-h"] = function()
							show_all = not show_all
							if show_all then
								prompt = "MRU ALL"
								show_fzf(files_all)
							else
								prompt = "MRU CWD"
								update_files_cwd()
								show_fzf(files_cwd)
							end
						end,
					},
					fzf_opts = {

						["--multi"] = "",
					},
					prompt = prompt .. "> ",
				})
			end

			show_fzf(files_cwd)
		end

		vim.keymap.set("n", "so", fzf.mru, { desc = "Fzf 'mru'" })

		local bookmark_file = os.getenv("HOME") .. "/.cdg_paths"

		function fzf.bookmark_dir()
			local prompt = "DIR"
			prompt = prompt .. " CWD"

			require("fzf-lua").fzf_exec("cat " .. bookmark_file, {
				actions = {
					["default"] = function(selected)
						vim.cmd("F " .. selected[1])
					end,
					["alt-c"] = function(selected)
						vim.cmd("cd " .. selected[1])
						notify.info("cwd change to: " .. selected[1])
					end,
				},
				fzf_opts = {
					["--multi"] = "",
				},
				prompt = prompt .. "> ",
				winopts = { height = 0.4, width = 0.6 },
			})
		end

		local bookmark = toolbox("Bookmark", {
			{ execute = function() fzf.files({ cwd = "~/dot" }) end,                  name = "Fzf 'dotfiles'" },
			{ execute = function() fzf.files({ cwd = vim.fn.stdpath("config") }) end, name = "Fzf 'nvimrc'" },
			{ execute = function() vim.cmd.vsplit(bookmark_file) end,                 name = "Edit bookmark dir" },
			{ execute = fzf.bookmark_dir,                                             name = "Show bookmark dir" },
		})

		bind("n", "<space><space>", bookmark, { desc = "Bookmark" })


		local luasnip = require("luasnip")
		local fzf_lua = require("fzf-lua")

		-- taken from : https://gist.github.com/fira42073/c5bc8d4d1f60dc73722acbbf8ab55cb4
		local function search_snippets()
			-- Get available snippets
			local snippets = luasnip.available()

			-- Flatten the snippets table and prepare entries for fzf-lua
			local entries = {}
			for category, snippet_list in pairs(snippets) do
				if type(snippet_list) == "table" then
					for _, snippet in ipairs(snippet_list) do
						local description = snippet.description[1] or "" -- Extract the first description if available
						local entry = string.format("%s - %s (%s) : %s", snippet.trigger, snippet.name, category,
							description)
						table.insert(entries, entry)
					end
				end
			end

			-- Use fzf-lua to search through snippets
			fzf_lua.fzf_exec(entries, {
				prompt = "Select Snippet> ",
				actions = {
					["default"] = function(selected)
						if #selected > 0 then
							-- Extract the trigger from the selected entry
							local trigger = selected[1]:match("^(.-)%s+-")
							-- Insert the trigger into the current buffer and go into insert mode
							vim.api.nvim_put({ trigger }, "c", true, true)
							if luasnip.expandable() then
								vim.cmd("startinsert")
								luasnip.expand()
								vim.cmd("stopinsert")
							else
								notify.warn(
									"Snippet '"
									.. trigger
									.. "'"
									.. "was selected, but LuaSnip.expandable() returned false"
								)
							end
							-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>i", true, true, true), "n", true)
						end
					end,
				},
			})
		end

		vim.keymap.set("n", "sn", search_snippets, { desc = "FZF search snippets" })
	end,
}

