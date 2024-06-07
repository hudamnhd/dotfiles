local fzf = require("fzf-lua")

local mfzf = function(mode, key, f, options, buffer)
  local desc = nil
  if type(options) == "table" then
    desc = options.desc
    options.desc = nil
  elseif type(options) == "function" then
    desc = options().desc
  end

  local rhs = function()
    local fzf_lua = require("fzf-lua")
    local custom = require("plugins.fzf-lua.cmds")
    if custom[f] then
      custom[f](options and vim.deepcopy(options) or {})
    else
      fzf_lua[f](options and vim.deepcopy(options) or {})
    end
  end

  local map_options = {
    silent = true,
    buffer = buffer,
    desc = desc or string.format("FzfLua %s", f),
  }

  vim.keymap.set(mode, key, rhs, map_options)
end

local map = vim.keymap.set

-- stylua: ignore start
mfzf("n", "<leader>.", "builtin", { desc = "builtin commands" })
mfzf("n", "<leader><F1>", "man_pages", { desc = "man pages" })

mfzf("n", "sqm", "marks", { desc = "marks" })
mfzf("n", "sqc", "commands", { desc = "commands" })
mfzf("n", "sqq", "command_history", { desc = "command history" })
mfzf("n", "sqs", "search_history", { desc = "search history" })
mfzf("n", "sqe", "diagnostics_document", { desc = "document diagnostics [LSP]" })
mfzf("n", "sqd", "diagnostics_workspace", { desc = "workspace diagnostics [LSP]" })
mfzf("n", "sqn", "files", {
  desc = "Note files",
  prompt = "Notes❯ ",
  cwd = "~/vimwiki"
})
map("i",  "<C-x><C-f>", function() require("fzf-lua").complete_path({ file_icons = false }) end, { silent = true, desc = "Fuzzy complete path" })
map("i",  "<C-x><C-l>", function() require("fzf-lua").complete_line() end, { silent = true, desc = "Fuzzy complete line" })

map("n",  "so", "<CMD>MRU<CR>", { desc = "file history (MRU)" })
mfzf("n", "s0", "oldfiles", function() return { desc = "file history (cwd)", cwd = vim.loop.cwd(), cwd_header = true, cwd_only = true } end)

mfzf("n", "sp", "files", { desc = "find files"})
mfzf("n", "dp", "git_files", { desc = "find git_files"})
mfzf("n", "sb", "buffers", { desc = "Fzf buffers" })

mfzf("v", "sk", "grep_visual", { desc = "grep visual selection" })
mfzf("n", "sk", "grep_cword", { desc = "grep <word> (project)" })

-- git
mfzf("n", "sgs", "git_status", { desc = "git status" })
mfzf("n", "sgB", "git_branches", { desc = "git branches" })
mfzf("n", "sgc", "git_commits", { desc = "git commits (project)" })
mfzf({ "n", "v" }, "sgb", "git_bcommits", { desc = "git commits (buffer)" })

mfzf("n", "sl", "grep_curbuf", function() return { desc = "grep <word> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cword>") } end)
mfzf("v", "sl", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = require("utils.other").get_visual_selection(true) } end)

mfzf("n", "zf", "files", function() return { desc = "grep <word> (buffer)", prompt = "Files❯ ", query = vim.fn.expand("<cword>") } end)
mfzf("v", "zf", "files", function() return { desc = "grep files", prompt = "Files❯ ", query = require("utils.other").get_visual_selection(true) } end)

mfzf("n", "sf", "grep", { desc = "grep string (prompt)" })
mfzf("n", "sr", "grep", { desc = "grep string resume", resume = true })

mfzf("n", '"', "registers", { desc = "registers" })
-- stylua: ignore end

mfzf("n", "z=", "spell_suggest", {
  desc = "spell suggestions",
  prompt = "Spell> ",
  winopts = {
    relative = "cursor",
    row = 1.01,
    col = 0,
    height = 0.30,
    width = 0.30,
  },
})

