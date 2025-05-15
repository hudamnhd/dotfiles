return {
	"ibhagwan/fzf-lua",
	enabled = vim.fn.executable("fzf") == 1,
	event = "VeryLazy",
	build = "fzf --version",
	config = function()
		local fzf = require("fzf-lua")
		local actions = require("fzf-lua.actions")
		local core = require("fzf-lua.core")
		local config = require("fzf-lua.config")

		local _mt_cmd_wrapper = core.mt_cmd_wrapper
		---@param opts table?
		---@diagnostic disable-next-line: duplicate-set-field
		function core.mt_cmd_wrapper(opts)
			if not opts or not opts.cwd then
				return _mt_cmd_wrapper(opts)
			end
			local _opts = {}
			for k, v in pairs(opts) do
				_opts[k] = v
			end
			_opts.cwd = nil
			return _mt_cmd_wrapper(_opts)
		end

		---Switch provider while preserving the last query and cwd
		---@return nil
		function actions.switch_provider()
			local opts = {
				query = fzf.config.__resume_data.last_query,
				cwd = fzf.config.__resume_data.opts.cwd,
			}
			fzf.builtin({
				actions = {
					["enter"] = function(selected)
						fzf[selected[1]](opts)
					end,
					["esc"] = actions.resume,
				},
			})
		end

		---Switch cwd while preserving the last query
		---@return nil
		function actions.switch_cwd()
			local cwd = vim.uv.cwd()
			vim.ui.input({
				prompt = "New cwd: ",
				default = cwd,
				completion = "dir",
			}, function(input)
				if not input then
					return
				end
				input = vim.fs.normalize(input)
				local stat = vim.uv.fs_stat(input)
				if not stat or not stat.type == "directory" then
					print("\n")
					vim.notify("[Fzf-lua] invalid path: " .. input .. "\n", vim.log.levels.ERROR)
					vim.cmd.redraw()
					return
				end
				cwd = input
			end)

			fzf.files({
				cwd = cwd
			})
		end

		core.ACTION_DEFINITIONS[actions.switch_cwd] = { "Change cwd", pos = 1 }
		config._action_to_helpstr[actions.switch_provider] = 'switch-provider'
		config._action_to_helpstr[actions.switch_cwd] = 'change-cwd'

		fzf.setup({
			{ "border-fused", "hide" },
			winopts = {
				backdrop = 100,
				split = [[botright 15new | setlocal bt=nofile bh=wipe nobl noswf wfh ]],
				on_create = function()
					vim.o.cmdheight = 0
					vim.o.laststatus = 0
				end,
				on_close = function()
					vim.o.cmdheight = 1
					vim.o.laststatus = 2
				end,
				preview = {
					hidden = 'hidden',
				},
			},
			files = {
				actions = {
					["alt-c"] = actions.switch_cwd,
				},
			},
			defaults = {
				headers = { "actions" },
				actions = {
					["ctrl-]"] = actions.switch_provider,
				},
			},
		}
		)

		fzf.register_ui_select()

		vim.api.nvim_create_user_command('F', function(info) fzf.files({ cwd = info.fargs[1] }) end, {
			nargs = '?',
			complete = 'dir',
			desc = 'Fuzzy find files.',
		})


		-------------------------------------------------------------------------------
		-- FzfLua Luasnip =============================================================
		-------------------------------------------------------------------------------
		local luasnip = require("luasnip")

		-- taken from : https://gist.github.com/fira42073/c5bc8d4d1f60dc73722acbbf8ab55cb4
		function fzf.luansnip()
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
			fzf.fzf_exec(entries, {
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
								print(
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

		-------------------------------------------------------------------------------
		-- FzfLua Lsp Cmd =============================================================
		-------------------------------------------------------------------------------
		local function transform_label(str)
			-- Match group helper
			local function match_and_format(pattern, label)
				local matched = str:match(pattern)
				if matched then
					return string.format("%s '%s'", label, matched)
				end
			end

			-- Known patterns
			local patterns = {
				{ [[^FzfLua%.lsp_(.+)]], "Lsp" },
				{ [[^vim%.lsp%.(.+)]],   "Lsp" },
				{ [[^FzfLua%.(.+)]],     "FzfLua" },
				{ [[^vim%.(.+)]],        "Vim" },
			}

			for _, pat in ipairs(patterns) do
				local result = match_and_format(pat[1], pat[2])
				if result then return result end
			end

			-- Default: split PascalCase → spaced words
			local words = str
					:gsub("(%u)(%l+)", " %1%2")
					:gsub("(%u)(%u%l)", " %1%2")

			return vim.trim(words)
		end

		local function is_typescript_tools_active()
			for _, client in pairs(vim.lsp.get_clients()) do
				if client.name == 'typescript-tools' then return true end
			end
			return false
		end

		local lsp_cmds = {
			"FzfLua.diagnostics_workspace",
			"FzfLua.diagnostics_document",
		}

		local lsp_attach = function()
			local function reverse_list(list)
				local reversed = {}
				for i = #list, 1, -1 do
					table.insert(reversed, list[i])
				end
				return reversed
			end

			local fzf_lsp = {
				"FzfLua.lsp_document_symbols",
				"FzfLua.lsp_live_workspace_symbols",
				"FzfLua.lsp_definitions",
				"FzfLua.lsp_definitions",
				"FzfLua.lsp_typedefs",
				"FzfLua.lsp_implementations",
				"FzfLua.lsp_incoming_calls",
				"FzfLua.lsp_outgoing_calls",
				"FzfLua.lsp_references",
				"FzfLua.lsp_finder",
				"FzfLua.lsp_code_actions",
				"vim.lsp.buf.rename",
			}

			local ts_tools = {
				'TSToolsOrganizeImports',
				'TSToolsSortImports',
				'TSToolsRemoveUnusedImports',
				'TSToolsRemoveUnused',
				'TSToolsAddMissingImports',
				'TSToolsFixAll',
				'TSToolsGoToSourceDefinition',
				'TSToolsRenameFile',
				'TSToolsFileReferences',
			}

			local merged = vim.tbl_extend("force", {}, lsp_cmds)
			vim.list_extend(merged, fzf_lsp)

			if is_typescript_tools_active() then
				vim.list_extend(merged, ts_tools)
			end

			merged = reverse_list(merged)
			function fzf.lsp()
				vim.ui.select(merged, {
					prompt = "Lsp Menu:",
					format_item = function(item) return transform_label(item) end,
				}, function(choice)
					if choice then
						vim.cmd(string.format("lua %s()", choice))
					end
				end)
			end
		end

		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('FzfLuaLspAttachGroup', { clear = true }),
			callback = lsp_attach,
		})

		-------------------------------------------------------------------------------
		-- FzfLua MRU =============================================================
		-------------------------------------------------------------------------------
		local api, uv = vim.api, vim.loop

		function fzf.mru()
			local current
			if api.nvim_get_option_value('buftype', { buf = 0 }) == '' then
				current = uv.fs_realpath(api.nvim_buf_get_name(0))
			end

			local files_all = {}
			local files_cwd = {}
			local cwd = vim.fn.expand(vim.uv.cwd())
			local show_all = false

			local mru_files = MRU.get()

			for _, file in ipairs(mru_files) do
				if file ~= current then table.insert(files_all, file) end
			end

			local function update_files_cwd()
				files_cwd = {}
				for _, file in ipairs(files_all) do
					local file_absolute_path = vim.fn.fnamemodify(file, ':p')
					if vim.fn.stridx(file_absolute_path, cwd) == 0 then
						local relative_path = vim.fn.fnamemodify(file_absolute_path, ':.')
						table.insert(files_cwd, relative_path)
					end
				end
			end

			update_files_cwd()

			local prompt = 'MRU'
			prompt = prompt .. ' CWD'

			local function show_fzf(files)
				require('fzf-lua').fzf_exec(files, {
					actions = {
						['default'] = require('fzf-lua').actions.file_edit,
						['ctrl-space'] = function()
							show_all = not show_all
							if show_all then
								prompt = 'MRU ALL'
								show_fzf(files_all)
							else
								prompt = 'MRU CWD'
								update_files_cwd()
								show_fzf(files_cwd)
							end
						end,
					},
					fzf_opts = {
						['--multi'] = '',
					},
					prompt = prompt .. '> ',
				})
			end

			show_fzf(files_cwd)
		end

		-------------------------------------------------------------------------------
		-- FzfLua Bookmark =============================================================
		-------------------------------------------------------------------------------
		local cdg_paths = os.getenv("HOME") .. "/.cdg_paths"

		function fzf.bookmark_dir()
			local prompt = 'DIR'
			prompt = prompt .. ' CWD'
			require('fzf-lua').fzf_exec('cat ' .. cdg_paths, {
				actions = {
					['default'] = function(selected) vim.cmd('F ' .. selected[1]) end,
					['alt-c'] = function(selected)
						vim.cmd('cd ' .. selected[1])
						vim.notify('cwd change to: ' .. selected[1])
					end,
				},
				fzf_opts = {
					['--multi'] = '',
				},
			})
		end

		local bookmark_cmds = {
			"FzfLua.files({ cwd = '~/dot' })",
			"FzfLua.files({ cwd = '~/projects' })",
			"FzfLua.files({ cwd = '~/.config/nvim' })",
			"vim.cmd.vsplit(cdg_paths)",
			"FzfLua.bookmark_dir()",
		}

		function fzf.bookmark()
			vim.ui.select(bookmark_cmds, {
				prompt = "Bookmark Menu:",
				format_item = function(item) return transform_label(item) end,
			}, function(choice)
				if choice then
					vim.cmd(string.format("lua %s", choice))
				end
			end)
		end

		-------------------------------------------------------------------------------
		-- FzfLua Snippet =============================================================
		-------------------------------------------------------------------------------
		local H = {}
		H._snippet_cache = {}

		H.load_snippets_file = function(path)
			if vim.fn.filereadable(path) ~= 1 then return nil end
			local content = vim.fn.readfile(path)
			local data = table.concat(content, "\n")
			local ok, decoded = pcall(vim.json.decode, data)
			if ok then return decoded end
			return nil
		end

		H.load_snippets = function(ft)
			local dir = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets")

			local global = H.load_snippets_file(vim.fs.joinpath(dir, "global.json")) or {}
			local local_ = H.load_snippets_file(vim.fs.joinpath(dir, ("%s.json"):format(ft))) or {}

			return vim.tbl_extend("force", global, local_)
		end

		H.fzf_use_snippets = function(ft, snippets)
			local entries, snippet_lookup = {}, {}

			for name, info in pairs(snippets) do
				local prefix = type(info.prefix) == "table" and table.concat(info.prefix, ", ") or info.prefix
				local label = string.format("%s  [%s]", name, prefix)
				table.insert(entries, label)

				local single_prefix = type(info.prefix) == "table" and info.prefix[1] or info.prefix
				snippet_lookup[label] = vim.tbl_extend("force", info, { name = name, prefix = single_prefix })
			end

			fzf.fzf_exec(entries, {
				prompt = "Select Snippet> ",
				actions = {
					["default"] = function(selected)
						local choice = selected[1]
						local snippet = snippet_lookup[choice]
						if snippet then
							local body = type(snippet.body) == "table"
									and table.concat(snippet.body, "\n")
									or snippet.body
							vim.snippet.expand(body)
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>i", true, true, true), "n", true)
						else
							vim.notify("Snippet not found", vim.log.levels.WARN)
						end
					end
				}
			})
		end

		function fzf.snippets()
			local ft = vim.bo.filetype

			if H._snippet_cache[ft] then
				return H.fzf_use_snippets(ft, H._snippet_cache[ft])
			end

			local snippets = H.load_snippets(ft)

			if not snippets or vim.tbl_isempty(snippets) then
				vim.notify("No snippets found for filetype: " .. ft, vim.log.levels.INFO)
				return
			end

			H._snippet_cache[ft] = snippets
			H.fzf_use_snippets(ft, snippets)
		end
	end,
}
