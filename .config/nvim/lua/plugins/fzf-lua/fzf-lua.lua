local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")
local config = require("fzf-lua.config")
local utils = require("utils")

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

-- FZF alternative
-- Skim is slower than FZF but more efficient RAM
local is_skim = false

fzf.setup({
  fzf_bin = is_skim and "sk" or "fzf",
  -- Use nbsp in tty to avoid showing box chars
  -- nbsp = not vim.g.modern_ui and "\xc2\xa0" or nil,
  dir_icon = utils.icons.kinds.Folder,
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
  keymap = {},
  defaults = {
    headers = { "actions" },
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
    { "s ",    fzf.resume,              { desc = "(FZF) resume" } },
    { "s0",    fzf.command_history,     { desc = "(FZF) command_history" } }, -- remap : to 0 easy press
    { "sp",    fzf.files,               { desc = "(FZF) files" } },
    { "sh",    fzf.search_history,      { desc = "(FZF) search_history" } },
    { "so",    fzf.mru,                 { desc = "(FZF) mru" } },
    { "sO",    fzf.oldfiles,            { desc = "(FZF) mru" } },
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
  { execute = files("~/.config"),                                                    name = "(FZF) CONFIG" },
  { execute = files("~/vimwiki"),                                                    name = "(FZF) Vimwiki" },
  { execute = files("~/Projects/notes"),                                             name = "(FZF) NOTES_DIR" },
  { execute = fzf_cmds.show_bookmark_dir,                                            name = "Show bookmark dir" },
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

-- stylua: ignore end
