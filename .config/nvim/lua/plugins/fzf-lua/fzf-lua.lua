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

fzf.setup({
  { "borderless-full", "hide" },
  -- for neovim custom color
  fzf_colors = {
    bg = { "bg", "PmenuSbar" },
    ["bg+"] = { "bg", "Visual" },
    ["fg+"] = { "fg", "Normal" },
    gutter = { "bg", "PmenuSbar" },
  },
})

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
bind("i", "<c-x><c-f>", fzf.complete_path, { desc = "Fzf 'complete_path'" } ) -- remap
bind("i", "<c-x><c-l>", fzf.complete_line, { desc = "Fzf 'complete_line'" } ) -- remap
bind("n", "<a-p>", fzf.builtin,       { desc = "Fzf 'builtin'" } )
bind("n", "<c-b>", fzf.buffers,       { desc = "Fzf 'buffers'" } )

bind("x", "sk", fzf.grep_visual,      { desc = "Fzf 'grep_visual'" } )
bind("n", "sk", fzf.grep_cword,       { desc = "Fzf 'grep_cword'" } )
bind("n", "sr", fzf.live_grep_resume, { desc = "Fzf 'live_grep_resume'" } )
bind("n", "si", fzf.grep,             { desc = "Fzf 'grep'" } )
bind("n", "sl", fzf.lgrep_curbuf,     { desc = "Fzf 'live_grep_buffer'" } )
bind("n", "ss", fzf.resume,           { desc = "Fzf 'resume'" } )
bind("n", "s0", fzf.command_history,  { desc = "Fzf 'command_history'" } ) -- remap : to 0 easy press
bind("n", "sp", fzf.files,            { desc = "Fzf 'files'" } )
bind("n", "sh", fzf.search_history,   { desc = "Fzf 'search_history'" } )
bind("n", "so", fzf.mru,              { desc = "Fzf 'oldfiles cwd'" } )
bind("n", "z=", fzf.spell_suggest,    { desc = "Fzf 'spell_suggest'" } )

--global
local fzf_cmds = require("plugins.fzf-lua.cmds")

local config_dir =  vim.fn.stdpath("config")

local show_toolbox_files = fzf_cmds.create_show_toolbox("Toolbox Files", {
  { execute = fzf.list_paths,                  name = "Fzf 'PATH'" },
  { execute = files(vim.fn.expand(logs_path)), name = "Fzf 'logs for current year'" },
  { execute = files("~/.config"),              name = "Fzf 'Config'" },
  { execute = files(config_dir),               name = "Fzf 'Vimrc'" },
  { execute = files("~/vimwiki"),              name = "Fzf 'Vimwiki'" },
  { execute = files("~/Projects/notes"),       name = "Fzf 'Notes_dir'" },
  { execute = fzf_cmds.show_bookmark_dir,      name = "Fzf 'bookmark dir'" },

  { execute = function() vim.cmd("e " .. vim.fn.expand(file_path)) end,          name = "Fzf 'daily log file'" },
  { execute = function() vim.cmd.vsplit(os.getenv("HOME") .. "/.cdg_paths") end, name = "Edit bookmark dir" },
  { execute = function() vim.cmd.ShowFile(config_dir .. "/cheatsheet.txt") end, name = "Cheatsheet Subtitute" },
})

bind("n", "<space>e", show_toolbox_files, { desc = "Files Command" } )


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

  local ft = vim.bo.filetype

  -- Cek apakah filetype termasuk dalam daftar yang diinginkan
  local allowed_ft = { typescript = true, typescriptreact = true, javascriptreact = true }

if is_typescript_tools_active() then
    local extra_commands = {
      { execute = vim.cmd.TSToolsOrganizeImports, name      = "TS 'OrganizeImports'" },
      { execute = vim.cmd.TSToolsSortImports, name          = "TS 'SortImports'" },
      { execute = vim.cmd.TSToolsRemoveUnusedImports, name  = "TS 'RemoveUnusedImports'" },
      { execute = vim.cmd.TSToolsRemoveUnused, name         = "TS 'RemoveUnused'" },
      { execute = vim.cmd.TSToolsAddMissingImports, name    = "TS 'AddMissingImports'" },
      { execute = vim.cmd.TSToolsFixAll, name               = "TS 'FixAll'" },
      { execute = vim.cmd.TSToolsGoToSourceDefinition, name = "TS 'GoToSourceDefinition'" },
      { execute = vim.cmd.TSToolsRenameFile, name           = "TS 'RenameFile'" },
      { execute = vim.cmd.TSToolsFileReferences, name       = "TS 'FileReferences'" },
    }

    for _, cmd in ipairs(extra_commands) do
      table.insert(commands, cmd)
    end
  end

  local lsp_commands = {
    { execute = fzf.lsp_document_symbols, name       = "Fzf 'lsp_document_symbols'" },
    { execute = fzf.lsp_live_workspace_symbols, name = "Fzf 'lsp_live_workspace_symbols'" },
    { execute = fzf.lsp_definitions, name            = "Fzf 'lsp_definitions'" },
    { execute = fzf.lsp_definitions, name            = "Fzf 'lsp_definitions'" },
    { execute = fzf.lsp_typedefs, name               = "Fzf 'lsp_typedefs'" },
    { execute = fzf.lsp_implementations, name        = "Fzf 'lsp_implementations'" },
    { execute = fzf.lsp_incoming_calls, name         = "Fzf 'lsp_incoming_calls'" },
    { execute = fzf.lsp_outgoing_calls, name         = "Fzf 'lsp_outgoing_calls'" },
    { execute = fzf.lsp_references, name             = "Fzf 'lsp_references'" },
    { execute = fzf.lsp_finder, name                 = "Fzf 'lsp_finder'" },
    { execute = fzf.lsp_code_actions, name           = "Fzf 'lsp_code_actions'" },
    { execute = vim.lsp.buf.rename, name             = "Lsp 'vim.lsp.buf.rename'" },
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
