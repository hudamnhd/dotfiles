---@diagnostic disable: codestyle-check
local fzf = require("fzf-lua")
local utils = require("utils")

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

fzf.setup({ "borderless-full" })

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

local bind = require("utils.keymap").bind

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
bind("i", "<c-k>", fzf.complete_path, { desc = "(FZF) complete_path" } ) -- remap <C-X><C-F>
bind("i", "<c-l>", fzf.complete_line, { desc = "(FZF) complete_line" } ) -- remap <C-X><C-L>
bind("n", "<c-p>", fzf.builtin,       { desc = "(FZF) builtin" } )

bind("x", "sk", fzf.grep_visual,      { desc = "(FZF) grep_visual" } )
bind("n", "sr", fzf.live_grep_resume, { desc = "(FZF) live_grep_resume" } )
bind("n", "si", fzf.grep,             { desc = "(FZF) grep" } )
bind("n", "sk", fzf.grep_cword,       { desc = "(FZF) grep_cword" } )
bind("n", "sl", fzf.lgrep_curbuf,     { desc = "(FZF) live_grep_buffer" } )
bind("n", "s`", fzf.resume,           { desc = "(FZF) resume" } )
bind("n", "s0", fzf.command_history,  { desc = "(FZF) command_history" } ) -- remap : to 0 easy press
bind("n", "sp", fzf.files,            { desc = "(FZF) files" } )
bind("n", "sh", fzf.search_history,   { desc = "(FZF) search_history" } )
bind("n", "so", fzf.mru,              { desc = "(FZF) oldfiles cwd" } )
bind("n", "z=", fzf.spell_suggest,    { desc = "(FZF) spell_suggest" } )
bind("n", "<c-b>", fzf.buffers,          { desc = "(FZF) buffers" } )

--global
local fzf_cmds = require("plugins.fzf-lua.cmds")

local config_dir =  vim.fn.stdpath("config")

local show_toolbox_files = fzf_cmds.create_show_toolbox("Toolbox Files", {
  { execute = fzf.list_paths,                  name = "(FZF) PATH" },
  { execute = files(vim.fn.expand(logs_path)), name = "(FZF) logs for current year" },
  { execute = require("utils.helper").set_cwd, name = "(SET) Set cwd current dir" },
  { execute = files("~/.config"),              name = "(FZF) CONFIG" },
  { execute = files(config_dir),               name = "(FZF) VIMRC" },
  { execute = files("~/vimwiki"),              name = "(FZF) Vimwiki" },
  { execute = files("~/Projects/notes"),       name = "(FZF) NOTES_DIR" },
  { execute = fzf_cmds.show_bookmark_dir,      name = "Show bookmark dir" },

  { execute = function() vim.cmd("e " .. vim.fn.expand(file_path)) end,          name = "(FZF) daily log file" },
  { execute = function() vim.cmd.vsplit(os.getenv("HOME") .. "/.cdg_paths") end, name = "Edit bookmark dir" },
})

bind("n", "<space>pq", show_toolbox_files, { desc = "Files Command" } )


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

bind("n", "<space>l", show_toolbox_lsp, { desc = "LSP Command" } )
end

-- stylua: ignore end
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("FzfLuaLspAttachGroup", { clear = true }),
  callback = lsp_attach,
})

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
