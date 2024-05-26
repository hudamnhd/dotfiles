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
    -- use deepcopy so options ref isn't saved in the mapping
    -- as this can create weird issues, for example, `lgrep_curbuf`
    -- saving the filename in between executions
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
map("i",  "<C-x><C-f>", function() require("fzf-lua").complete_path({ file_icons = false }) end, { silent = true, desc = "Fuzzy complete path" })
map("i",  "<C-x><C-l>", function() require("fzf-lua").complete_line() end, { silent = true, desc = "Fuzzy complete line" })

map("n",  "so", "<CMD>MRU<CR>", { desc = "file history (MRU)" })
mfzf("n", "s0", "oldfiles", function() return { desc = "file history (cwd)", cwd = vim.loop.cwd(), cwd_header = true, cwd_only = true } end)

mfzf("n", "sp", "files", { desc = "find files"})

mfzf("n", "dp", "git_files", { desc = "find git_files"})

mfzf("n", "sb", "buffers", { desc = "Fzf buffers" })

mfzf("v", "sk", "grep_visual", { desc = "grep visual selection" })
mfzf("n", "sk", "grep_cword", { desc = "grep <word> (project)" })

mfzf("n", "sl", "grep_curbuf", function() return { desc = "grep <word> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cword>") } end)
mfzf("v", "sl", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = require("utils.other").get_visual_selection(true) } end)

-- mfzf("n", "sL", "lines", function() return { desc = "Fzf blines", query = vim.fn.expand("<cword>") } end)
-- mfzf("n", "sL", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cWORD>") } end)  -- not used

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

-- mfzf("n", "sH", "oldfiles", { desc = "file history (all)", cwd = "~", cwd_header = false }) --replace with mru
-- mfzf("n", "sfp", "files", { desc = "plugin files", prompt = "Plugins❯ ", cwd = vim.fn.stdpath("data") .. "/lazy", })
-- mfzf("n", [[<leader>;]], "tmux_buffers", { desc = "tmux paste buffers" })
