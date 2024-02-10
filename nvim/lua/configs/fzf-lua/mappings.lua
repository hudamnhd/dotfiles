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
    local custom = require("configs.fzf-lua.cmds")
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

-- mappings
map("i", "<C-x><C-f>", function() require("fzf-lua").complete_path({ file_icons = true }) end, { silent = true, desc = "Fuzzy complete path" })
map("i", "<C-x><C-l>", function() require("fzf-lua").complete_line() end, { silent = true, desc = "Fuzzy complete line" })

map("n", "so", '<CMD>MRU<CR>' )

map_fzf("n", "sO", "oldfiles", function() return { desc = "file history (cwd)", cwd = vim.loop.cwd(), cwd_header = true, cwd_only = true, } end)

map_fzf("n", "sp", "files", { desc = "find files" })
map_fzf("n", "sP", "files", function() return { desc = "find files (parent)", cwd = vim.fn.expand('%:p:h'), cwd_header = true, cwd_only = true, } end)

map_fzf("n", "sH", "oldfiles", { desc = "file history (all)", cwd = "~", cwd_header = false, })

map_fzf("n", "sh", "buffers", { desc = "Fzf buffers" })

map_fzf("n", "<F12>", "workdirs", { desc = "cwd workdirs" })

map_fzf("v", "sk", "grep_visual", { desc = "grep visual selection" })
map_fzf("n", "sk", "grep_cword", { desc = "grep <word> (project)" })
map_fzf("n", "sK", "grep_cWORD", { desc = "grep <WORD> (project)" })

map_fzf("n", "sl", "grep_curbuf", function() return { desc = "grep <word> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cword>"), } end)
map_fzf("n", "sL", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cWORD>"), } end)
map_fzf("x", "sl", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = require'utils.other'.get_visual_selection(true), } end)

map_fzf("n", "sR", "grep", { desc = "grep string resume", resume = true })
map_fzf("n", "sr",  "grep", { desc = "grep string (prompt)" })

map_fzf("n", "<leader>sl", "blines", function() return { desc = "blines <word>", fzf_opts = { ["--query"] = vim.fn.expand("<cword>") }, } end)
map_fzf("n", "<leader>sk", "lines", function() return { desc = "lines <word>", fzf_opts = { ["--query"] = vim.fn.expand("<cword>") }, } end)

map_fzf("n", "<leader>sR", "live_grep", { desc = "live grep resume", resume = true })
map_fzf("n", "<leader>sr", "live_grep", { desc = "live grep (project)" })

map_fzf("n", "<leader>sq", "quickfix", { desc = "quickfix list" })
map_fzf("n", "<leader>sQ", "loclist", { desc = "location list" })

map_fzf("n", "<leader>sy", "registers", { desc = "registers" })

map_fzf("n", "z=", "spell_suggest", {
  desc = "spell suggestions",
  prompt = "Spell> ",
  winopts = {
    relative = "cursor",
    row      = 1.01,
    col      = 0,
    height   = 0.30,
    width    = 0.30,
  }
})


-- map_fzf("n", "sfT", "tags", { desc = "tags (project)" })
-- map_fzf("n", "sft", "btags", { desc = "tags (buffer)" })
-- map_fzf("n", "sfP", "profiles", { desc = "fzf-lua profiles" })
-- map_fzf("n", "sfp", "files", { desc = "plugin files", prompt = "Plugins❯ ", cwd = vim.fn.stdpath("data") .. "/lazy", })
-- map_fzf("n", [[<leader>;]], "tmux_buffers", { desc = "tmux paste buffers" })
