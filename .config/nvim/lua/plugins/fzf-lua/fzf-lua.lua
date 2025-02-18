local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")
local core = require("fzf-lua.core")
local path = require("fzf-lua.path")
local config = require("fzf-lua.config")
local utils = require("utils")

local _arg_del = actions.arg_del
local _vimcmd_buf = actions.vimcmd_buf

---@diagnostic disable-next-line: duplicate-set-field
function actions.arg_del(...)
  pcall(_arg_del, ...)
end

---@diagnostic disable-next-line: duplicate-set-field
function actions.vimcmd_buf(...)
  pcall(_vimcmd_buf, ...)
end

local _mt_cmd_wrapper = core.mt_cmd_wrapper

---Wrap `core.mt_cmd_wrapper()` used in fzf-lua's file and grep providers
---to ignore `opts.cwd` when generating the command string because once the
---cwd is hard-coded in the command string, `opts.cwd` will be ignored.
---
---This fixes the bug where `switch_cwd()` does not work if it is used after
---`switch_provider()`:
---
---In `switch_provider()`, `opts.cwd` will be passed the corresponding fzf
---provider (file or grep) where it will be compiled in the command string,
---which will then be stored in `fzf.config.__resume_data.contents`.
---
---`switch_cwd()` internally calls the resume action to resume the last
---provider and reuse other info in previous fzf session (e.g. last query, etc)
---except `opts.cwd`, `opts.fn_selected`, etc. that needs to be changed to
---reflect the new cwd.
---
---Thus if `__resume_data.contents` contains information about the previous
---cwd, the new cwd in `opts.cwd` will be ignored and `switch_cwd()` will not
---take effect.
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
-- function actions.switch_cwd()
--   fzf.config.__resume_data.opts = fzf.config.__resume_data.opts or {}
--   local opts = fzf.config.__resume_data.opts
--
--   -- Remove old fn_selected, else selected item will be opened
--   -- with previous cwd
--   opts.fn_selected = nil
--   opts.cwd = opts.cwd or vim.uv.cwd()
--   opts.query = fzf.config.__resume_data.last_query
--
--   vim.ui.input({
--     prompt = "New cwd: ",
--     default = opts.cwd,
--     completion = "dir",
--   }, function(input)
--     if not input then
--       return
--     end
--     input = vim.fs.normalize(input)
--     local stat = vim.uv.fs_stat(input)
--     if not stat or not stat.type == "directory" then
--       print("\n")
--       vim.notify("[Fzf-lua] invalid path: " .. input .. "\n", vim.log.levels.ERROR)
--       vim.cmd.redraw()
--       return
--     end
--     opts.cwd = input
--   end)
--
--   -- Adapted from fzf-lua `core.set_header()` function
--   if opts.cwd_prompt then
--     opts.prompt = vim.fn.fnamemodify(opts.cwd, ":.:~")
--     local shorten_len = tonumber(opts.cwd_prompt_shorten_len)
--     if shorten_len and #opts.prompt >= shorten_len then
--       opts.prompt = path.shorten(opts.prompt, tonumber(opts.cwd_prompt_shorten_val) or 1)
--     end
--     if not path.ends_with_separator(opts.prompt) then
--       opts.prompt = opts.prompt .. path.separator()
--     end
--   end
--
--   if opts.headers then
--     opts = core.set_header(opts, opts.headers)
--   end
--
--   actions.resume()
-- end

function actions.switch_cwd()
  local resume_data = vim.deepcopy(fzf.config.__resume_data)
  resume_data.opts = resume_data.opts or {}

  -- Remove old fn_selected, else selected item will be opened
  -- with previous cwd
  local opts = resume_data.opts
  opts.fn_selected = nil
  opts.cwd = opts.cwd or vim.uv.cwd()
  opts.query = fzf.config.__resume_data.last_query

  local at_home = utils.fs.contains("~", opts.cwd)
  fzf.files({
    cwd_prompt = false,
    prompt = "New cwd: " .. (at_home and "~/" or "/"),
    cwd = at_home and "~" or "/",
    query = vim.fn.fnamemodify(opts.cwd, at_home and ":~" or ":p"):gsub("^~", ""):gsub("^/", ""),
    -- Append current dir './' to the result list to allow switching to home
    -- or root directory
    cmd = string.format(
      [[%s | sed '1i ./']],
      (function()
        local fd_cmd = vim.fn.executable("fd") == 1 and "fd"
          or vim.fn.executable("fdfind") == 1 and "fdfind"
          or nil

        if not fd_cmd then
          return [[find -L * -type d -print0 | xargs -0 ls -Fd]]
        end

        local grep_cmd = vim.fn.executable("rg") == 1 and "rg" or "grep"
        return string.format([[%s --hidden --follow --type d --type l | %s /$]], fd_cmd, grep_cmd)
      end)()
    ),
    fzf_opts = { ["--no-multi"] = true },
    winopts = {
      preview = {
        hidden = "hidden",
      },
    },
    actions = {
      ["enter"] = function(selected)
        opts.cwd = vim.fs.normalize(
          vim.fs.joinpath(at_home and "~" or "/", path.entry_to_file(selected[1]).path)
        )

        -- Adapted from fzf-lua `core.set_header()` function
        if opts.cwd_prompt then
          opts.prompt = vim.fn.fnamemodify(opts.cwd, ":.:~")
          local shorten_len = tonumber(opts.cwd_prompt_shorten_len)
          if shorten_len and #opts.prompt >= shorten_len then
            opts.prompt = path.shorten(opts.prompt, tonumber(opts.cwd_prompt_shorten_val) or 1)
          end
          if not path.ends_with_separator(opts.prompt) then
            opts.prompt = opts.prompt .. path.separator()
          end
        end

        if opts.headers then
          opts = core.set_header(opts, opts.headers)
        end

        fzf.config.__resume_data = resume_data
        actions.resume()
      end,
      ["esc"] = function()
        fzf.config.__resume_data = resume_data
        actions.resume()
      end,
      -- Should not change dir or exclude dirs when selecting cwd
      ["alt-c"] = false,
      ["alt-/"] = false,
    },
  })
end

---Include directories, not only files when using the `files` picker
---@return nil
function actions.toggle_dir(_, opts)
  local exe = opts.cmd:match("^%s*(%S+)")
  local flag = opts.toggle_dir_flag
    or (exe == "fd" or exe == "fdfind") and "--type d"
    or (exe == "find") and "-type d"
    or ""
  actions.toggle_flag(_, vim.tbl_extend("force", opts, { toggle_flag = flag }))
end

---Delete selected autocmd
---@return nil
function actions.del_autocmd(selected)
  for _, line in ipairs(selected) do
    local event, group, pattern = line:match("^.+:%d+:(%w+)%s*│%s*(%S+)%s*│%s*(.-)%s*│")
    if event and group and pattern then
      vim.cmd.autocmd({
        bang = true,
        args = { group, event, pattern },
        mods = { emsg_silent = true },
      })
    end
  end
  local query = fzf.config.__resume_data.last_query
  fzf.autocmds({
    fzf_opts = {
      ["--query"] = query ~= "" and query or nil,
    },
  })
end

---Search & select files then add them to arglist
---@return nil
function actions.arg_search_add()
  local opts = fzf.config.__resume_data.opts
  fzf.files({
    cwd_header = true,
    cwd_prompt = false,
    headers = { "actions", "cwd" },
    prompt = "Argadd> ",
    actions = {
      ["enter"] = function(selected, _opts)
        local cmd = "argadd"
        vim.ui.input({
          prompt = "Argadd cmd: ",
          default = cmd,
        }, function(input)
          if input then
            cmd = input
          end
        end)
        actions.vimcmd_file(cmd, selected, _opts)
        fzf.args(opts)
      end,
      ["esc"] = function()
        fzf.args(opts)
      end,
    },
    find_opts = [[-type f -type l -not -path '*/\.git/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --type l --hidden --follow --exclude .git]],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
  })
end

function actions._file_edit_or_qf(selected, opts)
  if #selected > 1 then
    actions.file_sel_to_qf(selected, opts)
    vim.cmd.cfirst()
    vim.cmd.copen()
  else
    actions.file_edit(selected, opts)
  end
end

function actions._file_sel_to_qf(selected, opts)
  actions.file_sel_to_qf(selected, opts)
  if #selected > 1 then
    vim.cmd.cfirst()
    vim.cmd.copen()
  end
end

function actions._file_sel_to_ll(selected, opts)
  actions.file_sel_to_ll(selected, opts)
  if #selected > 1 then
    vim.cmd.lfirst()
    vim.cmd.lopen()
  end
end

core.ACTION_DEFINITIONS[actions.toggle_dir] = {
  function(o)
    -- When using `fd` the flag is '--type d', but for `find` the flag is
    -- '-type d', use '-type d' as default flag here anyway since it is
    -- the common substring for both `find` and `fd` commands
    local flag = o.toggle_dir_flag or "-type d"
    local escape = require("fzf-lua.utils").lua_regex_escape
    return o.cmd and o.cmd:match(escape(flag)) and "Exclude dirs" or "Include dirs"
  end,
}
core.ACTION_DEFINITIONS[actions.switch_cwd] = { "Change cwd", pos = 1 }
core.ACTION_DEFINITIONS[actions.arg_del] = { "delete" }
core.ACTION_DEFINITIONS[actions.del_autocmd] = { "delete autocmd" }
core.ACTION_DEFINITIONS[actions.arg_search_add] = { "add new file" }
core.ACTION_DEFINITIONS[actions.search] = { "edit" }
core.ACTION_DEFINITIONS[actions.ex_run] = { "edit" }

-- stylua: ignore start
config._action_to_helpstr[actions.toggle_dir] = 'toggle-dir'
config._action_to_helpstr[actions.switch_provider] = 'switch-provider'
config._action_to_helpstr[actions.switch_cwd] = 'change-cwd'
config._action_to_helpstr[actions.arg_del] = 'delete'
config._action_to_helpstr[actions.del_autocmd] = 'delete-autocmd'
config._action_to_helpstr[actions.arg_search_add] = 'search-and-add-new-file'
config._action_to_helpstr[actions.buf_sel_to_qf] = 'buffer-select-to-quickfix'
config._action_to_helpstr[actions.buf_sel_to_ll] = 'buffer-select-to-loclist'
config._action_to_helpstr[actions._file_sel_to_qf] = 'file-select-to-quickfix'
config._action_to_helpstr[actions._file_sel_to_ll] = 'file-select-to-loclist'
config._action_to_helpstr[actions._file_edit_or_qf] = 'file-edit-or-qf'
-- stylua: ignore end

-- Use different prompts for document and workspace diagnostics
-- by overriding `fzf.diagnostics_workspace()` and `fzf.diagnostics_document()`
-- because fzf-lua does not support setting different prompts for them via
-- the `fzf.setup()` function, see `defaults.lua` & `providers/diagnostic.lua`
local _diagnostics_workspace = fzf.diagnostics_workspace
local _diagnostics_document = fzf.diagnostics_document

---@param opts table?
function fzf.diagnostics_document(opts)
  return _diagnostics_document(vim.tbl_extend("force", opts or {}, {
    prompt = "Document Diagnostics> ",
  }))
end

---@param opts table?
function fzf.diagnostics_workspace(opts)
  return _diagnostics_workspace(vim.tbl_extend("force", opts or {}, {
    prompt = "Workspace Diagnostics> ",
  }))
end

local icon_dir = utils.icons.kinds.Folder

-- FZF alternative
-- Skim is slower than FZF but more efficient RAM
local is_skim = false

fzf.setup({
  fzf_bin = is_skim and "sk" or "fzf",
  -- Use nbsp in tty to avoid showing box chars
  -- nbsp = not vim.g.modern_ui and "\xc2\xa0" or nil,
  dir_icon = icon_dir,
  winopts = {
    backdrop = 100,
    split = [[
        let tabpage_win_list = nvim_tabpage_list_wins(0) |
        \ call v:lua.require'utils.win'.saveheights(tabpage_win_list) |
        \ call v:lua.require'utils.win'.saveviews(tabpage_win_list) |
        \ unlet tabpage_win_list |
        \ let g:_fzf_vim_lines = &lines |
        \ let g:_fzf_leave_win = win_getid(winnr()) |
        \ let g:_fzf_splitkeep = &splitkeep | let &splitkeep = "topline" |
        \ let g:_fzf_cmdheight = &cmdheight | let &cmdheight = 0 |
        \ let g:_fzf_laststatus = &laststatus | let &laststatus = 0 |
        \ botright 10new |
        \ exe 'resize' .
          \ (10 + g:_fzf_cmdheight + (g:_fzf_laststatus ? 1 : 0)) |
        \ let w:winbar_no_attach = v:true |
        \ setlocal bt=nofile bh=wipe nobl noswf wfh
    ]],
    on_create = function()
      vim.keymap.set(
        "t",
        "<C-r>",
        [['<C-\><C-N>"' . nr2char(getchar()) . 'pi']],
        { expr = true, buffer = true }
      )
    end,
    on_close = function()
      ---@param name string
      ---@return nil
      local function _restore_global_opt(name)
        if vim.g["_fzf_" .. name] then
          vim.go[name] = vim.g["_fzf_" .. name]
          vim.g["_fzf_" .. name] = nil
        end
      end

      _restore_global_opt("splitkeep")
      _restore_global_opt("cmdheight")
      _restore_global_opt("laststatus")

      if
        vim.g._fzf_leave_win
        and vim.api.nvim_win_is_valid(vim.g._fzf_leave_win)
        and vim.api.nvim_get_current_win() ~= vim.g._fzf_leave_win
      then
        vim.api.nvim_set_current_win(vim.g._fzf_leave_win)
      end
      vim.g._fzf_leave_win = nil

      if vim.go.lines == vim.g._fzf_vim_lines then
        utils.win.restheights()
      end
      vim.g._fzf_vim_lines = nil
      utils.win.clearheights()
      utils.win.restviews()
      utils.win.clearviews()
    end,
    preview = {
      hidden = "hidden",
    },
  },
  hls = {
    title = "TelescopeTitle",
    preview_title = "TelescopeTitle",
    -- Builtin preview only
    cursor = "Cursor",
    cursorline = "TelescopePreviewLine",
    cursorlinenr = "TelescopePreviewLine",
    search = "IncSearch",
  },
  fzf_colors = {
    ["hl"] = { "fg", "TelescopeMatching" },
    ["fg+"] = { "fg", "TelescopeSelection" },
    ["bg+"] = { "bg", "TelescopeSelection" },
    ["hl+"] = { "fg", "TelescopeMatching" },
    ["info"] = { "fg", "TelescopeCounter" },
    ["prompt"] = { "fg", "TelescopePrefix" },
    ["pointer"] = { "fg", "TelescopeSelectionCaret" },
    ["marker"] = { "fg", "TelescopeMultiIcon" },
  },
  keymap = {},
  actions = {
    files = {
      ["alt-s"] = actions.file_split,
      ["alt-v"] = actions.file_vsplit,
      ["alt-t"] = actions.file_tabedit,
      ["alt-q"] = actions._file_sel_to_qf,
      ["alt-o"] = actions._file_sel_to_ll,
      ["enter"] = actions._file_edit_or_qf,
    },
    buffers = {
      ["enter"] = actions.buf_edit,
      ["alt-s"] = actions.buf_split,
      ["alt-v"] = actions.buf_vsplit,
      ["alt-t"] = actions.buf_tabedit,
    },
  },
  defaults = {
    headers = { "actions" },
    actions = {
      ["ctrl-]"] = actions.switch_provider,
    },
  },
  args = {
    files_only = false,
    actions = {
      ["ctrl-s"] = actions.arg_search_add,
      ["ctrl-x"] = {
        fn = actions.arg_del,
        reload = true,
      },
    },
  },
  autocmds = {
    actions = {
      ["ctrl-x"] = {
        fn = actions.del_autocmd,
        -- reload = true,
      },
    },
  },
  blines = {
    actions = {
      ["alt-q"] = actions.buf_sel_to_qf,
      ["alt-o"] = actions.buf_sel_to_ll,
      ["alt-l"] = false,
    },
  },
  lines = {
    actions = {
      ["alt-q"] = actions.buf_sel_to_qf,
      ["alt-o"] = actions.buf_sel_to_ll,
      ["alt-l"] = false,
    },
  },
  buffers = {
    show_unlisted = false,
    show_unloaded = false,
    ignore_current_buffer = false,
    no_action_set_cursor = true,
    current_tab_only = false,
    no_term_buffers = false,
    cwd_only = false,
    ls_cmd = "ls",
    -- formatter = { "path.dirname_first", v = 2 },
    actions = {
      ["ctrl-l"] = require("fzf-lua").actions.file_edit,
    },
  },
  helptags = {
    actions = {
      ["enter"] = actions.help,
      ["alt-s"] = actions.help,
      ["alt-v"] = actions.help_vert,
      ["alt-t"] = actions.help_tab,
    },
  },
  manpages = {
    actions = {
      ["enter"] = actions.man,
      ["alt-s"] = actions.man,
      ["alt-v"] = actions.man_vert,
      ["alt-t"] = actions.man_tab,
    },
  },
  keymaps = {
    actions = {
      ["enter"] = actions.keymap_edit,
      ["alt-s"] = actions.keymap_split,
      ["alt-v"] = actions.keymap_vsplit,
      ["alt-t"] = actions.keymap_tabedit,
    },
  },
  colorschemes = {
    actions = {
      ["enter"] = actions.colorscheme,
    },
  },
  highlights = {
    actions = {
      ["enter"] = function(selected)
        vim.defer_fn(function()
          vim.cmd.hi(selected[1])
        end, 0)
      end,
    },
  },
  command_history = {
    actions = {
      ["alt-e"] = actions.ex_run,
      ["ctrl-e"] = false,
    },
  },
  search_history = {
    actions = {
      ["alt-e"] = actions.search,
      ["ctrl-e"] = false,
    },
  },
  files = {
    actions = {
      ["alt-c"] = actions.switch_cwd,
      ["ctrl-/"] = actions.toggle_dir,
      ["ctrl-g"] = actions.toggle_ignore,
    },
    fzf_opts = {
      ["--info"] = "inline-right",
    },
    find_opts = [[-type f -type l -not -path '*/\.git/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --type l --hidden --follow --exclude .git]],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
  },
  oldfiles = {
    prompt = "Oldfiles> ",
  },
  fzf_opts = is_skim and {} or {
    ["--no-scrollbar"] = "",
    ["--no-separator"] = "",
    ["--info"] = "inline-right",
    ["--layout"] = "reverse",
    ["--marker"] = "+",
    ["--pointer"] = "→",
    ["--prompt"] = "/ ",
    ["--border"] = "none",
    ["--padding"] = "0,1",
    ["--margin"] = "0",
    ["--no-preview"] = "",
    ["--preview-window"] = "hidden",
  },
  grep = {
    actions = {
      ["alt-c"] = actions.switch_cwd,
    },
    rg_opts = table.concat({
      "--hidden",
      "--follow",
      "--smart-case",
      "--column",
      "--line-number",
      "--no-heading",
      "--color=always",
      "-g=!.git/",
      "-e",
    }, " "),
    fzf_opts = {
      ["--info"] = "inline-right",
    },
  },
  lsp = {
    finder = {
      fzf_opts = {
        ["--info"] = "inline-right",
      },
    },
    definitions = {
      sync = false,
      jump_to_single_result = true,
    },
    references = {
      sync = false,
      ignore_current_line = true,
      jump_to_single_result = true,
    },
    typedefs = {
      sync = false,
      jump_to_single_result = true,
    },
    symbols = {
      symbol_icons = vim.tbl_map(vim.trim, utils.icons.kinds),
    },
  },
})

local map = require("utils.keymap").map

function fzf.lgrep_curbuf_custom()
  fzf.lgrep_curbuf({ search = vim.fn.expand("<cword>") })
end

function fzf.mru()
  require("plugins.fzf-lua.cmds").mru()
end
function fzf.list_paths()
  utils.copy.list_paths()
end

local function files(cwd)
  return function()
    fzf.files({ cwd = cwd })
  end
end

local year = os.date("%Y") -- Tahun saat ini
local logs_path = "~/daily-logs/" .. year
local month_number = os.date("%m") -- Nomor bulan
local month_name = os.date("%B") -- Nama bulan (contoh: December)
local file_name = month_number .. "-" .. month_name .. "-" .. year .. ".md"
local file_path = "~/daily-logs/" .. year .. "/" .. file_name

-- stylua: ignore start
map({
  [{ "i" }] = {
    { "<c-k>", fzf.complete_path, { desc = "(FZF) complete_path" } }, -- remap <C-X><C-F>
    { "<c-l>", fzf.complete_line, { desc = "(FZF) complete_line" } }, -- remap <C-X><C-L>
  },
  [{ "x" }] = {
    { "sk", fzf.grep_visual, { desc = "(FZF) grep_visual" } },
  },
  [{ "n" }] = {
    { "sr",    fzf.live_grep_resume,    { desc = "(FZF) live_grep_resume" } },
    { "si",    fzf.grep,                { desc = "(FZF) grep" } },
    { "sk",    fzf.grep_cword,          { desc = "(FZF) grep_cword" } },
    { "sl",    fzf.lgrep_curbuf_custom, { desc = "(FZF) live_grep_buffer" } },
    { "s/",    fzf.blines,              { desc = "(FZF) blines" } },
    { "s'",    fzf.registers,           { desc = "(FZF) registers" } },
    { "s.",    fzf.resume,              { desc = "(FZF) resume" } },
    { "s0",    fzf.command_history,     { desc = "(FZF) command_history" } }, -- remap : to 0 easy press
    { "sp",    fzf.files,               { desc = "(FZF) files" } },
    { "sh",    fzf.search_history,      { desc = "(FZF) search_history" } },
    { "so",    fzf.mru,                 { desc = "(FZF) mru" } },
    { "z=",    fzf.spell_suggest,       { desc = "(FZF) spell_suggest" } },
    { "<a-p>", fzf.builtin,             { desc = "(FZF) builtin" } },
    { "<c-b>", fzf.buffers,             { desc = "(FZF) buffers" } },
  },
}, {})

--global
local fzf_cmds = require("plugins.fzf-lua.cmds")
local helper = utils.helper

local show_toolbox_qlstack = fzf_cmds.create_show_toolbox("Toolbox Files", {
  { execute = helper.toggle_qf("q"), name = "(TOGGLE) quickfix_list" },
  { execute = helper.toggle_qf("l"), name = "(TOGGLE) loclist_list" },
  { execute = fzf.loclist_stack,     name = "(FZF) loclist_stack" },
  { execute = fzf.quickfix_stack,    name = "(FZF) quickfix_stack" },
  { execute = fzf.loclist,           name = "(FZF) loclist" },
  { execute = fzf.quickfix,          name = "(FZF) quickfix" },
})

map({
  [{ "n" }] = {
    { "<a-q>", show_toolbox_qlstack, { desc = "Files Command" } },
  },
}, {})


local show_toolbox_files = fzf_cmds.create_show_toolbox("Toolbox Files", {
  { execute = files(vim.fn.expand(logs_path)),                                       name = "(FZF) logs for current year" },
  { execute = function() vim.cmd("e " .. vim.fn.expand(file_path)) end,              name = "(FZF) daily log file" },
  { execute = files("~/.config/nvim"),                                               name = "(FZF) VIMRC" },
  { execute = files("~/vimwiki"),                                                    name = "(FZF) Vimwiki" },
  { execute = files(vim.env.NOTES_DIR),                                              name = "(FZF) NOTES_DIR" },
  { execute = fzf_cmds.save_bookmark_file,                                           name = "Toggle bookmark file" },
  { execute = fzf_cmds.save_bookmark_dir,                                            name = "Toggle bookmark dir" },
  { execute = fzf_cmds.show_bookmark_file,                                           name = "Show bookmark file" },
  { execute = fzf_cmds.show_bookmark_dir,                                            name = "Show bookmark dir" },
  { execute = function() vim.cmd.vsplit(vim.fn.stdpath("cache") .. "/bookmark") end, name = "Edit bookmark file" },
  { execute = function() vim.cmd.vsplit(os.getenv("HOME") .. "/.cdg_paths") end,     name = "Edit bookmark dir" },
  { execute = fzf.list_paths,                                                        name = "(FZF) list_paths" },
})

map({
  [{ "n" }] = {
    { "<space>f", show_toolbox_files, { desc = "Files Command" } },
  },
}, {})



local commands = {
  { execute = fzf.diagnostics_document,  name = "(FZF) diagnostics_document" },
  { execute = fzf.diagnostics_workspace, name = "(FZF) diagnostics_workspace" },
}

local lsp_attach = function()

  local ft = vim.bo.filetype

  -- Cek apakah filetype termasuk dalam daftar yang diinginkan
  local allowed_ft = { typescript = true, typescriptreact = true, javascriptreact = true }

  if allowed_ft[ft] then
    local extra_commands = {
      { execute = vim.cmd.TSToolsOrganizeImports, name = "(TS) OrganizeImports" },
      { execute = vim.cmd.TSToolsSortImports, name = "(TS) SortImports" },
      { execute = vim.cmd.TSToolsRemoveUnusedImports, name = "(TS) RemoveUnusedImports" },
      { execute = vim.cmd.TSToolsRemoveUnused, name = "(TS) RemoveUnused" },
      { execute = vim.cmd.TSToolsAddMissingImports, name = "(TS) AddMissingImports" },
      { execute = vim.cmd.TSToolsFixAll, name = "(TS) FixAll" },
      { execute = vim.cmd.TSToolsGoToSourceDefinition, name = "(TS) GoToSourceDefinition" },
      { execute = vim.cmd.TSToolsRenameFile, name = "(TS) RenameFile" },
      { execute = vim.cmd.TSToolsFileReferences, name = "(TS) FileReferences" },
    }

    for _, cmd in ipairs(extra_commands) do
      table.insert(commands, cmd)
    end
  end

  local lsp_commands = {
    { execute = fzf.lsp_document_symbols, name = "(FZF) lsp_document_symbols" },
    { execute = fzf.lsp_live_workspace_symbols, name = "(FZF) lsp_live_workspace_symbols" },
    { execute = fzf.lsp_definitions, name = "(FZF) lsp_definitions" },
    { execute = fzf.lsp_definitions, name = "(FZF) lsp_definitions" },
    { execute = fzf.lsp_typedefs, name = "(FZF) lsp_typedefs" },
    { execute = fzf.lsp_implementations, name = "(FZF) lsp_implementations" },
    { execute = fzf.lsp_incoming_calls, name = "(FZF) lsp_incoming_calls" },
    { execute = fzf.lsp_outgoing_calls, name = "(FZF) lsp_outgoing_calls" },
    { execute = fzf.lsp_references, name = "(FZF) lsp_references" },
    { execute = fzf.lsp_finder, name = "(FZF) lsp_finder" },
    { execute = fzf.lsp_code_actions, name = "(FZF) lsp_code_actions" },
    { execute = vim.lsp.buf.rename, name = "(LSP) vim.lsp.buf.rename" },
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
  local show_toolbox_lsp = fzf_cmds.create_show_toolbox("Toolbox Files", commands)

  map({
    [{ "n" }] = {
      { "<space>l", show_toolbox_lsp, { desc = "LSP Command" } },
    },
  }, {})
end

-- stylua: ignore end
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("FzfLuaLspAttachGroup", { clear = true }),
  callback = lsp_attach,
})

local _lsp_workspace_symbol = vim.lsp.buf.workspace_symbol

---Overriding `vim.lsp.buf.workspace_symbol()`, not only the handler here
---to skip the 'Query:' input prompt -- with `fzf.lsp_live_workspace_symbols()`
---as handler we can update the query in live
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.buf.workspace_symbol(query, options)
  _lsp_workspace_symbol(query or "", options)
end

vim.lsp.handlers["callHierarchy/incomingCalls"] = fzf.lsp_incoming_calls
vim.lsp.handlers["callHierarchy/outgoingCalls"] = fzf.lsp_outgoing_calls
vim.lsp.handlers["textDocument/codeAction"] = fzf.code_actions
vim.lsp.handlers["textDocument/declaration"] = fzf.declarations
vim.lsp.handlers["textDocument/definition"] = fzf.lsp_definitions
vim.lsp.handlers["textDocument/documentSymbol"] = fzf.lsp_document_symbols
vim.lsp.handlers["textDocument/implementation"] = fzf.lsp_implementations
vim.lsp.handlers["textDocument/references"] = fzf.lsp_references
vim.lsp.handlers["textDocument/typeDefinition"] = fzf.lsp_typedefs
vim.lsp.handlers["workspace/symbol"] = fzf.lsp_live_workspace_symbols

vim.diagnostic.setqflist = fzf.diagnostics_workspace
vim.diagnostic.setloclist = fzf.diagnostics_document

vim.api.nvim_create_user_command("F", function(info)
  fzf.files({ cwd = info.fargs[1] })
end, {
  nargs = "?",
  complete = "dir",
  desc = "Fuzzy find files.",
})

---Generate a completion function for user command that wraps a builtin command
---@param user_cmd string user command pattern
---@param builtin_cmd string builtin command
---@return fun(_, cmdline: string, cursorpos: integer): string[]
local function complfn(user_cmd, builtin_cmd)
  return function(_, cmdline, cursorpos)
    local cmdline_before = cmdline:sub(1, cursorpos):gsub(user_cmd, builtin_cmd, 1)
    return vim.fn.getcompletion(cmdline_before, "cmdline")
  end
end

local fzf_ls_cmd = {
  function(info)
    local suffix = string.format("%s %s", info.bang and "!" or "", info.args)
    return fzf.buffers({
      prompt = vim.trim(info.name .. suffix) .. "> ",
      ls_cmd = "ls" .. suffix,
    })
  end,
  {
    bang = true,
    nargs = "?",
    complete = function()
      return {
        "+",
        "-",
        "=",
        "a",
        "u",
        "h",
        "x",
        "%",
        "#",
        "R",
        "F",
        "t",
      }
    end,
  },
}

local fzf_hi_cmd = {
  function(info)
    if vim.tbl_isempty(info.fargs) then
      fzf.highlights()
      return
    end
    if #info.fargs == 1 and info.fargs[1] ~= "clear" then
      local hlgroup = info.fargs[1]
      if vim.fn.hlexists(hlgroup) == 1 then
        vim.cmd.hi({
          args = { hlgroup },
          bang = info.bang,
        })
      else
        fzf.highlights({
          fzf_opts = {
            ["--query"] = hlgroup,
          },
        })
      end
      return
    end
    vim.cmd.hi({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = "*",
    complete = complfn("Highlight", "hi"),
  },
}

local fzf_reg_cmd = {
  function(info)
    local query = table.concat(
      vim.tbl_map(
        function(reg)
          return string.format("^[%s]", reg:upper())
        end,
        vim.split(info.args, "", {
          trimempty = true,
        })
      ),
      " | "
    )
    fzf.registers({
      fzf_opts = {
        ["--query"] = query ~= "" and query or nil,
      },
    })
  end,
  {
    nargs = "*",
    complete = complfn("Registers", "registers"),
  },
}

local fzf_display_cmd = vim.tbl_deep_extend("force", fzf_reg_cmd, {
  [2] = { complete = complfn("Display", "display") },
})

local fzf_au_cmd = {
  function(info)
    if #info.fargs <= 1 and not info.bang then
      fzf.autocmds({
        fzf_opts = {
          ["--query"] = info.fargs[1] ~= "" and info.fargs[1] or nil,
        },
      })
      return
    end
    vim.cmd.autocmd({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = "*",
    complete = complfn("Autocmd", "autocmd"),
  },
}

local fzf_marks_cmd = {
  function(info)
    local query = table.concat(
      vim.tbl_map(
        function(mark)
          return "^" .. mark
        end,
        vim.split(info.args, "", {
          trimempty = true,
        })
      ),
      " | "
    )
    fzf.marks({
      fzf_opts = {
        ["--query"] = query ~= "" and query or nil,
      },
    })
  end,
  {
    nargs = "*",
    complete = complfn("Marks", "marks"),
  },
}

local fzf_args_cmd = {
  function(info)
    if not info.bang and vim.tbl_isempty(info.fargs) then
      fzf.args()
      return
    end
    vim.cmd.args({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = "*",
    complete = complfn("Args", "args"),
  },
}

vim.api.nvim_create_user_command("Ls", unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command("Files", unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command("Args", unpack(fzf_args_cmd))
vim.api.nvim_create_user_command("Autocmd", unpack(fzf_au_cmd))
vim.api.nvim_create_user_command("Buffers", unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command("Marks", unpack(fzf_marks_cmd))
vim.api.nvim_create_user_command("Highlight", unpack(fzf_hi_cmd))
vim.api.nvim_create_user_command("Registers", unpack(fzf_reg_cmd))
vim.api.nvim_create_user_command("Display", unpack(fzf_display_cmd))
vim.api.nvim_create_user_command("Oldfiles", fzf.oldfiles, {})
vim.api.nvim_create_user_command("Changes", fzf.changes, {})
vim.api.nvim_create_user_command("Tags", fzf.tagstack, {})
vim.api.nvim_create_user_command("Jumps", fzf.jumps, {})
vim.api.nvim_create_user_command("Tabs", fzf.tabs, {})

---Set telescope default hlgroups for a borderless view
---@return nil
local function set_default_hlgroups()
  local hl = utils.hl
  local hl_norm = hl.get(0, { name = "Normal", link = false })
  local hl_special = hl.get(0, { name = "Special", link = false })
  hl.set_default(0, "FzfLuaSymDefault", { link = "Special" })
  hl.set_default(0, "FzfLuaSymArray", { link = "Operator" })
  hl.set_default(0, "FzfLuaSymBoolean", { link = "Boolean" })
  hl.set_default(0, "FzfLuaSymClass", { link = "Type" })
  hl.set_default(0, "FzfLuaSymConstant", { link = "Constant" })
  hl.set_default(0, "FzfLuaSymConstructor", { link = "@constructor" })
  hl.set_default(0, "FzfLuaSymEnum", { link = "Constant" })
  hl.set_default(0, "FzfLuaSymEnumMember", { link = "FzfLuaSymEnum" })
  hl.set_default(0, "FzfLuaSymEvent", { link = "@lsp.type.event" })
  hl.set_default(0, "FzfLuaSymField", { link = "FzfLuaSymDefault" })
  hl.set_default(0, "FzfLuaSymFile", { link = "Directory" })
  hl.set_default(0, "FzfLuaSymFunction", { link = "Function" })
  hl.set_default(0, "FzfLuaSymInterface", { link = "Type" })
  hl.set_default(0, "FzfLuaSymKey", { link = "@keyword" })
  hl.set_default(0, "FzfLuaSymMethod", { link = "Function" })
  hl.set_default(0, "FzfLuaSymModule", { link = "@module" })
  hl.set_default(0, "FzfLuaSymNamespace", { link = "@lsp.type.namespace" })
  hl.set_default(0, "FzfLuaSymNull", { link = "Constant" })
  hl.set_default(0, "FzfLuaSymNumber", { link = "Number" })
  hl.set_default(0, "FzfLuaSymObject", { link = "Statement" })
  hl.set_default(0, "FzfLuaSymOperator", { link = "Operator" })
  hl.set_default(0, "FzfLuaSymPackage", { link = "@module" })
  hl.set_default(0, "FzfLuaSymProperty", { link = "FzfLuaSymDefault" })
  hl.set_default(0, "FzfLuaSymString", { link = "@string" })
  hl.set_default(0, "FzfLuaSymStruct", { link = "Type" })
  hl.set_default(0, "FzfLuaSymTypeParameter", { link = "FzfLuaSymDefault" })
  hl.set_default(0, "FzfLuaSymVariable", { link = "FzfLuaSymDefault" })
  hl.set(0, "FzfLuaBufFlagAlt", { link = "FzfLuaSymDefault" })
  hl.set(0, "FzfLuaBufFlagCur", { link = "Operator" })
  hl.set(0, "FzfLuaLiveSym", { link = "WarningMsg" })
  hl.set(0, "FzfLuaPathColNr", { link = "FzfLuaSymDefault" })
  hl.set(0, "FzfLuaPathLineNr", { link = "FzfLuaSymDefault" })
  hl.set(0, "FzfLuaBufFlagCur", {})
  hl.set(0, "FzfLuaBufName", {})
  hl.set(0, "FzfLuaBufNr", {})
  hl.set(0, "FzfLuaBufLineNr", { link = "LineNr" })
  hl.set(0, "FzfLuaCursor", { link = "None" })
  hl.set(0, "FzfLuaHeaderBind", { link = "FzfLuaSymDefault" })
  hl.set(0, "FzfLuaHeaderText", { link = "FzfLuaSymDefault" })
  hl.set(0, "FzfLuaTabMarker", { link = "Keyword" })
  hl.set(0, "FzfLuaTabTitle", { link = "Title" })
  hl.set_default(0, "TelescopeSelection", { link = "Visual" })
  hl.set_default(0, "TelescopePrefix", { link = "Operator" })
  hl.set_default(0, "TelescopeCounter", { link = "LineNr" })
  hl.set_default(0, "TelescopeTitle", {
    fg = hl_norm.bg,
    bg = hl_special.fg,
    ctermfg = hl_norm.ctermbg,
    ctermbg = hl_special.ctermfg,
    bold = true,
  })
  hl.set(0, "TelescopeNormal", {
    fg = hl.blend("NonText", "Normal").fg,
    bg = hl_norm.bg,
  })
end

set_default_hlgroups()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("FzfLuaSetDefaultHlgroups", {}),
  desc = "Set default hlgroups for fzf-lua.",
  callback = set_default_hlgroups,
})

-- stylua: ignore start
-- if vim.fn.has("nvim") == 1 then
--   vim.g.terminal_color_0  = "#2A2A37"
--   vim.g.terminal_color_1  = "#E78A4E"
--   vim.g.terminal_color_2  = "#99c794"
--   vim.g.terminal_color_3  = "#fac863"
--   vim.g.terminal_color_4  = "#6699cc"
--   vim.g.terminal_color_5  = "#c594c5"
--   vim.g.terminal_color_6  = "#5fb3b3"
--   vim.g.terminal_color_7  = "#c0caf5"
--   vim.g.terminal_color_8  = "#555555"
--   vim.g.terminal_color_9  = "#FFA066"
--   vim.g.terminal_color_10 = "#99c794"
--   vim.g.terminal_color_11 = "#fac863"
--   vim.g.terminal_color_12 = "#6699cc"
--   vim.g.terminal_color_13 = "#c594c5"
--   vim.g.terminal_color_14 = "#5fb3b3"
--   vim.g.terminal_color_15 = "#c0caf5"
-- else
--   vim.g.terminal_ansi_colors = {
--     "#1a1b26", "#ec5f67", "#99c794", "#fac863",
--     "#6699cc", "#c594c5", "#5fb3b3", "#c0caf5",
--     "#555555", "#ec5f67", "#99c794", "#fac863",
--     "#6699cc", "#c594c5", "#5fb3b3", "#c0caf5",
--   }
-- end
-- stylua: ignore end
