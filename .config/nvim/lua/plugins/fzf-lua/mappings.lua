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
map("i",  "<C-k>", function() require("fzf-lua").complete_path({ cmd = "fdfind --hidden --type d --exclude .git", file_icons = false }) end, { silent = true, desc = "Fuzzy complete path" })
map("i",  "<C-l>", function() require("fzf-lua").complete_line() end, { silent = true, desc = "Fuzzy complete line" })

map("n",  "so", "<CMD>MRU<CR>", { desc = "file history (MRU)" })
mfzf("n", "s0", "oldfiles", function() return { desc = "file history (cwd)", cwd = vim.loop.cwd(), cwd_header = true, cwd_only = true } end)

mfzf("n", "sp", "files", { desc = "find files"})
mfzf("n", "sb", "buffers", { desc = "find files"})
mfzf("n", "sP", "files", { cwd = "%:h" })

mfzf("v", "sk", "grep_visual", { desc = "grep visual selection" })
mfzf("n", "sk", "grep_cword", { desc = "grep <word> (project)" })

mfzf("n", "s/", "grep_curbuf", { desc = "grep  (buffer)", prompt = "Buffer❯ " })
mfzf("n", "sl", "grep_curbuf", function() return { desc = "grep <word> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cword>") } end)
mfzf("v", "sl", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = require("utils.other").get_visual_selection(true) } end)

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
