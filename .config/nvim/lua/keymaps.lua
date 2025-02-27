---@diagnostic disable: codestyle-check
local M = {}

local utils = require("utils")
local k = utils.keymap
local map, bind, feedkeys = k.map, k.bind, k.feedkeys

M.leader_group_clues = {
  { mode = "n", keys = "<space>t", desc = "+Toggle and other" },
  { mode = "n", keys = "<space>b", desc = "+Bookmark" },
  { mode = "n", keys = "<space>s", desc = "+SNACKS" },
  { mode = "n", keys = "<space>g", desc = "+LSP" },
  { mode = "n", keys = "sq", desc = "+FZF" },
  { mode = "n", keys = "sf", desc = "+FZF" },
}

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~ multiple cursors (sort of) ~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- see: http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript
local mc_select = [[y/\V\C<C-r>=escape(@", '/')<CR><CR>]]
local function mc_macro(selection)
  selection = selection or ""

  return function()
    if vim.fn.reg_recording() == "z" then
      return "q"
    end

    if vim.fn.getreg("z") ~= "" then
      return "n@z"
    end

    return selection .. "*Nqz"
  end
end

-- NOTE without copying to clipboard
local blackhole_key = { "S", "D", "C", "d" }
for _, key in ipairs(blackhole_key) do
  bind("n", key, '"_' .. key, { desc = "blackhole" .. key })
end

local function delete_line()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end


-- stylua: ignore start
map({
  [{ "t" }] = {
    { "<c-\\>", [[<C-\><C-n>]] },
    { "<a-x>",  [[<C-\><C-n>:bd!<Cr>]] },
    { "<a-w>",  [[<C-\><C-n><c-w>w]] },
    { "<m-r>",  [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true } },
  },
  [{ "c" }] = {
    { "<c-v>",     [[<C-R>"]], { desc = "paste cmd-mode", silent = false } },
    { "<a-v>",     [[<C-R>+]], { desc = "paste cmd-mode", silent = false } },
    { "<c-space>", [[.\{-}]],  { silent = false } },
    { "<s-space>", [[\s\+]],   { silent = false } },
    { "<F2>", 'getcmdtype() == ":" ? expand("%:p")  : ""',         { silent = false, expr = true } },
  },
  [{"v", "o", "x" }] = {
    { "zq",        mc_select .. "``qz",                { desc = "mc start macro (foward)" } },
    { "zQ",        mc_select:gsub("/", "?") .. "``qz", { desc = "mc start macro (backward)" } },
    { "<c-0>",     mc_macro(mc_select),                { desc = "mc end or replay macro",  expr = true  } },
    { "<space>tr", utils.translate.translate_vm,       { desc = "translate visual" } },

    { "<c-f>", require("utils.search-replace").visual_charwise_selection, { desc = "replace visual" } },
    { "<c-s>", [[:s/\v//g<left><left><left>]], { desc = "Search Replace Search", silent = false  } },

    { "q", [[iq]], { remap = true } },
    { "Q", [[aq]], { remap = true } },
    { "w", [[iw]], { remap = true } },
    { "W", [[iW]], { remap = true } },
    { "t", [[it]], { remap = true } },
    { "T", [[at]], { remap = true } },

    { "<leader>n", [[:s/\d\+/number/g]],               { desc = "Number to type number", silent = false } },
    { "<leader>s", [[:s/"[^"]*"/string/g]],            { desc = "String to type string", silent = false } },
    { "<leader>c", [[:s/\(\l\)\(\u\)/\1\_\l\2/g<CR>]], { desc = "Camel to snack",        silent = false } },
    { "<leader>-", [[:s/\([a-zA-Z]\)\(-\)\([a-zA-Z]\)/\1\u\3/g<CR>]], { desc = "Rmv - and change to capitalize", silent = false } },

    { "p", [['pgv"' . v:register . 'y']], { desc = "paste without replacing register", expr = true } },
    { ".", [[:normal .<cr>]],             { desc = "Repeat last command for each line of a visual selection." }, },

    { ">", [[>gv]] },
    { "<", [[<gv]] },
  },
  [{ "n" }] = {
    { "zq",    "*Nqz",     { desc = "mc start macro (foward)" } },
    { "zQ",    "#Nqz",     { desc = "mc start macro (backward)" } },
    { "<c-0>", mc_macro(), { desc = "mc end or replay macro",  expr = true } },

    { "<c-s>", [[:'<,'>s/\v<C-r><C-w>//g<left><left>]], { desc = "replace cword", silent = false } },
    { "<c-f>", [[:%s/\v<C-r><C-w>//g<left><left>]], { desc = "replace cword", silent = false } },

    { "sm", "gmm",  { remap = true, desc = "MiniOperator clone line" } },
    { "sw", "ysiw", { remap = true, desc = "MiniSurround add word" } },

    { "<C-T>", "<Cmd>lua MiniBracketed.buffer('backward')<CR>"},
    { "<C-Y>", "<Cmd>lua MiniBracketed.buffer('forward')<CR>"},
    { "<a-w>", [[<c-w>w]] },
    { "<a-a>", require("plugins.fzf-lua.cmds").asynctasks },

    {"sq", [[:lua require'menu'.bookmarks()<CR>]]},

    { "<a-w>",    [[<c-w>w]] },
    { "!",        [[:<up><cr>]] },
    { "J",        [['mz' . v:count1 . 'J`z']], { desc = "Join", expr = true } },
    { "dd",       delete_line,                 { desc = "delete line", expr = true  } },
    { "gn",       [[:normal n.<cr>]],          { desc = "Repeat the last edit on the next [count] matches." } },
    { "<M-v>",    [[`[v`]],                    { desc = "visual select last yank/paste" } },
    { "\\q",      [[q]],                       { desc = "remap q" } },
    { "<space>k", [[<c-w>T]],                  { desc = "move splite" } },
    { "<space>c", [[<c-w>c]],                  { desc = "close" } },
    { "<space>v", [[<c-w>v]],                  { desc = "vsplite" } },
    { "<space>w", vim.cmd.update,              { desc = "update" } },

    { "<space>tr", utils.translate.translate_nm,               { desc = "translate" } },
    { "<space>ty", [[<cmd>Unite -vertical yankround<cr>]],     { desc = "YANKROUND" } },
    { "<esc>",     [[<Cmd>nohlsearch|diffupdate|echo<cr>]],    { desc = "Nohl search" } },

    { "<c-d>", "<C-d>zz" },
    { "<c-u>", "<C-u>zz" },

    -- emulate some basic commands from `vim-abolish`
    { "ct", "mzguiwgUl`z", { desc = "󰬴 Titlecase" } },
    { "cu", "mzgUiw`z",    { desc = "󰬴 lowercase to UPPERCASE" } },
    { "cl", "mzguiw`z",    { desc = "󰬴 UPPERCASE to lowercase" } },

    -- NOTE Keep matches center screen when cycling with n|N
    { "n", "nzz", { desc = "Fwd  search '/' or '?'" } },
    { "N", "Nzz", { desc = "Back search '/' or '?'" } },
  },
  [{ "n", "v" }] = {
    { "0",     [[:]] , { silent = false }},
    { "c",     [["_c]] },
    { "x",     [["_x]] },
    { "<c-h>", [[^]] },
    { "<c-l>", [[g_]] },
    { "<c-z>", [[%]], { remap = true } },

    { "<space>y", [["+y]],   { desc = "Yank to clipboard (primary)" } },
    { "<space>P", [["+P]],   { desc = "Paste before from clipboard (primary)" } },
    { "<space>p", [["+p]],   { desc = "Paste after from clipboard (primary)" } },
  },
}, {})

-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
for _, c in ipairs({
  { "k", "Line up" },
  { "j", "Line down" },
}) do
  bind(
    "n",
    c[1],
    ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]),
    { expr = true, desc = c[2] }
  )
end

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
for _, m in ipairs({ "n", "v" }) do
  for _, c in ipairs({
    { "k", "k", "Visual line up" },
    { "j", "j", "Visual line down" },
  }) do
    bind(
      m,
      c[1],
      ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]),
      { expr = true, desc = c[3] }
    )
  end
end

local delimiters = { ",", ";", "." }

local function modify_line_end_delimiter(character)
  return function()
    local line = vim.api.nvim_get_current_line()
    local last_char = line:sub(-1)
    if last_char == character then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(delimiters, last_char) then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
    else
      vim.api.nvim_set_current_line(line .. character)
    end
  end
end

for _, key in ipairs(delimiters) do
  local key_combination = string.format("z%s", key)
  local desc_combination = string.format("add '%s' to end of line", key)
  vim.keymap.set("n", key_combination, modify_line_end_delimiter(key), { desc = desc_combination })
end


local function cgn(pattern)
  feedkeys("<esc>", "v")
  local cmd = vim.api.nvim_replace_termcodes('<CR>N"_cgn', true, false, true)
  vim.api.nvim_feedkeys("/\\V" .. pattern .. cmd, "n", false)
end

local function cgn_action(type)
  return function()
    if type == "v" then
      cgn(require("utils.search-replace").get_visual_selection())
    else
      cgn(vim.fn.expand("<cword>"))
    end
  end
end

bind("n", "<C-N>", cgn_action("n"), { desc = "cgn word" })
bind("x", "<C-N>", cgn_action("v"), { desc = "cgn visual" })

---Remove all trailing whitespaces within the current buffer
---Retain cursor position & last search content
local function remove_trailing_whitespaces()
  local pos = vim.api.nvim_win_get_cursor(0)
  local last_search = vim.fn.getreg("/")
  local hl_state = vim.v.hlsearch

  vim.cmd(":%s/\\s\\+$//e")

  vim.fn.setreg("/", last_search) -- restore last search
  vim.api.nvim_win_set_cursor(0, pos) -- restore cursor position

  if hl_state == 0 then
    vim.cmd.nohlsearch() -- disable search highlighting again if it was disabled before
  end
end

bind("n", "<F5>", remove_trailing_whitespaces, { desc = "remove trailing whitespaces" })

bind("n", "<F3>", function ()
  vim.cmd('tabedit')
  vim.cmd('setlocal nonumber signcolumn=no')

  -- Unset vim environment variables to be able to call `vim` without errors
  -- Use custom `--git-dir` and `--work-tree` to be able to open inside
  -- symlinked submodules
  vim.fn.termopen('VIMRUNTIME= VIM= gitui', {
    on_exit = function()
      vim.cmd('silent! :checktime')
      vim.cmd('silent! :bw')
    end,
  })
  vim.cmd('startinsert')
  vim.b.minipairs_disable = true
end, { desc = "remove trailing whitespaces" })


return M
