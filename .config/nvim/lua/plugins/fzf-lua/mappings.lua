local fzf = require("fzf-lua")

local map_fzf = function(mode, key, f, options, buffer)
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
map("i",  "<C-k>", function() require("fzf-lua").complete_path({ cmd = "fdfind --hidden --type d --exclude .git", file_icons = false }) end, { silent = true, desc = "Fuzzy complete path" })
map("i",  "<C-l>", function() require("fzf-lua").complete_line() end, { silent = true, desc = "Fuzzy complete line" })

map("n",  "so", "<CMD>MRU<CR>", { desc = "file history (MRU)" })
map_fzf("n", "s0", "oldfiles", function() return { desc = "file history (cwd)", cwd = vim.loop.cwd(), cwd_header = true, cwd_only = true } end)

map_fzf("n", "sp", "files", { desc = "find files"})
map_fzf("n", "sb", "buffers", { desc = "find files"})

map_fzf("v", "sk", "grep_visual", { desc = "grep visual selection" })
map_fzf("n", "sk", "grep_cword", { desc = "grep <word> (project)" })

map_fzf("n", "s/", "grep_curbuf", { desc = "grep  (buffer)", prompt = "Buffer❯ " })
map_fzf("n", "sl", "grep_curbuf", function() return { desc = "grep <word> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cword>") } end)
map_fzf("v", "sl", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = require("utils.other").get_visual_selection(true) } end)

-- stylua: ignore end
map_fzf("n", "z=", "spell_suggest", {
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
