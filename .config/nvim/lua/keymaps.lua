---@diagnostic disable: codestyle-check
local M = {}

local map = require("utils.keymap").map

M.leader_group_clues = {
  { mode = "n", keys = "<space>t", desc = "+Toggle and other" },
  { mode = "n", keys = "<space>b", desc = "+Bookmark" },
  { mode = "n", keys = "<space>s", desc = "+SNACKS" },
  { mode = "n", keys = "<space>g", desc = "+LSP" },
  { mode = "n", keys = "sq", desc = "+FZF" },
  { mode = "n", keys = "sf", desc = "+FZF" },
}

function M.bind(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.feedkeys(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

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
  M.bind("n", key, '"_' .. key, { desc = "blackhole" .. key })
end

local function delete_line()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end

-- stylua: ignore start
map({
  [{ "t" }] = {
    { "<c-\\>", [[<C-\><C-n>]] },
    { "<c-^>",  [[<C-\><C-n><c-^>]] },
    { "<a-x>",  [[<C-\><C-n>:bd!<Cr>]] },
    { "<a-w>",  [[<C-\><C-n><c-w>w]] },
    { "<m-r>",  [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true } },
  },
  [{ "c" }] = {
    { "<c-v>",  [[<C-R>"]], { desc = "paste cmd-mode", silent = false } },
    { "<a-v>",  [[<C-R>+]], { desc = "paste cmd-mode", silent = false } },
    { "<C-BS>", [[.\{-}]],  { silent = false } },
    { "<S-BS>", [[\s\+]],   { silent = false } },

    { "<F3>", 'getcmdtype() == ":" ? expand("%:h/") . "/" : ""',   { silent = false, expr = true } },
    { "<F4>", 'getcmdtype() == ":" ? expand("%:p:h/") . "/" : ""', { silent = false, expr = true } },
    { "<F5>", 'getcmdtype() == ":" ? expand("%:p")  : ""',         { silent = false, expr = true } },
  },
  [{"v", "o", "x" }] = {
    { "zq",    mc_select .. "``qz",                { desc = "mc start macro (foward)" } },
    { "zQ",    mc_select:gsub("/", "?") .. "``qz", { desc = "mc start macro (backward)" } },
    { "<c-0>", mc_macro(mc_select),                { desc = "mc end or replay macro",  expr = true  } },

    { "<c-f>", vim.cmd.SearchReplaceSingleBufferVisualSelection, { desc = "replace visual" } },
    { "<c-s>", vim.cmd.SearchReplaceWithinVisualSelectionCWord,  { desc = "replace cword" } },
    { "<c-r>", vim.cmd.SearchReplaceWithinVisualSelection,       { desc = "Search Replace Search" } },

    { "q", [[iq]], { remap = true } },
    { "Q", [[aq]], { remap = true } },
    { "w", [[iw]], { remap = true } },
    { "W", [[iW]], { remap = true } },
    { "t", [[it]], { remap = true } },
    { "T", [[at]], { remap = true } },

    { "<a-n>", [[:s/\d\+/number/g]],               { desc = "All number to type number", silent = false } },
    { "<a-s>", [[:s/"[^"]*"/string/g]],            { desc = "All string to type string", silent = false } },
    { "<a-c>", [[:s/\(\l\)\(\u\)/\1\_\l\2/g<CR>]], { desc = "camel to snack", silent = false } },

    { "<a-->", [[:s/\([a-zA-Z]\)\(-\)\([a-zA-Z]\)/\1\u\3/g<CR>]], { desc = "Rmv - and change to capitalize", silent = false } },

    { "p", [['pgv"' . v:register . 'y']], { desc = "paste without replacing register", expr = true } },
    { ".", [[:normal .<cr>]],             { desc = "Repeat last command for each line of a visual selection." }, },

    { ">", [[>gv]] },
    { "<", [[<gv]] },
  },
  [{ "n" }] = {
    { "zq",    "*Nqz",     { desc = "mc start macro (foward)" } },
    { "zQ",    "#Nqz",     { desc = "mc start macro (backward)" } },
    { "<c-0>", mc_macro(), { desc = "mc end or replay macro",  expr = true } },

    { "<c-f>", vim.cmd.SearchReplaceSingleBufferCWord,         { desc = "replace cword" } },
    { "<c-s>", [[:'<,'>s/\v<C-r><C-w>//gI<left><left><left>]], { desc = "replace cword", silent = false } },

    { "<C-Up>",    require("utils.helper").resize(false, -5), { desc = "hsplit increase" } },
    { "<C-Down>",  require("utils.helper").resize(false, 5),  { desc = "hsplit decrease" } },
    { "<C-Left>",  require("utils.helper").resize(true, -5),  { desc = "vsplit decrease" } },
    { "<C-Right>", require("utils.helper").resize(true, 5),   { desc = "vsplit increase" } },

    { "sm", "gmm",  { remap = true, desc = "MiniOperator clone line" } },
    { "sx", "gxiw", { remap = true, desc = "MiniOperator exchange word" } },
    { "rw", "griw", { remap = true, desc = "MiniSurround replace word" } },
    { "sw", "ysiw", { remap = true, desc = "MiniSurround add word" } },

    { "<a-w>",    [[<c-w>w]] },
    { "!",        [[:<up><cr>]] },
    { "J",        [['mz' . v:count1 . 'J`z']], { desc = "Join", expr = true } },
    { "gn",       [[:normal n.<cr>]],          { desc = "Repeat the last edit on the next [count] matches." } },
    { "<M-v>",    [[`[v`]],                    { desc = "visual select last yank/paste" } },
    { "\\q",      [[q]],                       { desc = "remap q" } },
    { "<space>k", [[<c-w>T]],                  { desc = "move splite" } },
    { "<space>c", [[<c-w>c]],                  { desc = "close" } },
    { "<space>v", [[<c-w>v]],                  { desc = "vsplite" } },
    { "<space>w", vim.cmd.update,              { desc = "update" } },
    { "<space>d", vim.diagnostic.open_float,   { desc = "diagnostic.open_float" } },
    { "dd",       delete_line,                 { desc = "delete blank lines", expr = true  } },

    { "<",         require("utils.helper").toggle_qf("l"),     { desc = "toggle location list" } },
    { ">",         require("utils.helper").toggle_qf("q"),     { desc = "toggle quickfix list" } },
    { "<a-a>",     require("utils.helper").asynctasks,         { desc = "ASYNCTASKS" } },
    { "<space>%",  require("utils.helper").set_cwd,            { desc = "SET CWD" } },
    { "<space>td", require("utils.helper").toggle_diff_buff,   { desc = "Toggle overlay" } },
    { "<space>tr", require("utils.translate").translate_nm,    { desc = "translate" } },
    { "<space>tr", require("utils.translate").translate_vm,    { desc = "translate" } },
    { "<space>tu", vim.cmd.UndotreeToggle,                     { desc = "Undotree toggle" } },
    { "<space>to", [[<cmd>lua MiniDiff.toggle_overlay()<cr>]], { desc = "TOGGLE_DIFF_BUFF" } },
    { "<space>ty", [[<cmd>Unite -vertical yankround<cr>]],     { desc = "YANKROUND" } },
    { "<esc>",     [[<Cmd>nohlsearch|diffupdate|echo<cr>]],    { desc = "Nohl search" } },

    { "<C-d>", "<C-d>zz" },
    { "<C-u>", "<C-u>zz" },
    -- emulate some basic commands from `vim-abolish`
    { "ct", "mzguiwgUl`z", { desc = "󰬴 Titlecase" } },
    { "cu", "mzgUiw`z",    { desc = "󰬴 lowercase to UPPERCASE" } },
    { "cl", "mzguiw`z",    { desc = "󰬴 UPPERCASE to lowercase" } },

    -- NOTE Keep matches center screen when cycling with n|N
    { "n", "nzz",          { desc = "Fwd  search '/' or '?'" } },
    { "N", "Nzz",          { desc = "Back search '/' or '?'" } },
  },
  [{ "n", "v" }] = {
    { "0",     [[:]] , { silent = false }},
    { "c",     [["_c]] },
    { "x",     [["_x]] },
    { "<C-H>", [[^]] },
    { "<C-L>", [[g_]] },
    { "<C-Z>", [[%]], { remap = true } },

    { "<space>y", [["+y]],   { desc = "Yank to clipboard (primary)" } },
    { "<space>P", [["+P]],   { desc = "Paste before from clipboard (primary)" } },
    { "<space>p", [["+p]],   { desc = "Paste after from clipboard (primary)" } },
  },
}, {})
-- stylua: ignore end

-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
for _, c in ipairs({
  { "k", "Line up" },
  { "j", "Line down" },
}) do
  M.bind(
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
    M.bind(
      m,
      c[1],
      ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]),
      { expr = true, desc = c[3] }
    )
  end
end

local function modify_line_end_delimiter(character)
  local delimiters = { ",", ";", "." }
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

M.bind("n", "z,", modify_line_end_delimiter(","), { desc = "add ',' to end of line" })
M.bind("n", "z;", modify_line_end_delimiter(";"), { desc = "add ';' to end of line" })
M.bind("n", "z.", modify_line_end_delimiter("."), { desc = "add '.' to end of line" })

-- NOTE Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- NOTE without output or jumping to first match
-- NOTE Use ':Grep <pattern> %' to search only current file
-- NOTE Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep  grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")

-- Definisikan fungsi zoom_toggle
local function zoom_toggle()
  vim.cmd("normal! " .. "|")

  -- Periksa apakah hanya ada satu jendela terbuka.
  if vim.fn.winnr("$") == 1 then
    return
  end

  local restore_cmd = vim.fn.winrestcmd()
  vim.cmd("wincmd |")
  vim.cmd("wincmd _")

  -- Proses untuk menyimpan dan mengembalikan t:zoom_restore
  if vim.g.zoom_restore then
    vim.cmd(vim.g.zoom_restore)
    vim.g.zoom_restore = nil
  elseif vim.fn.winrestcmd() ~= restore_cmd then
    vim.g.zoom_restore = restore_cmd
  end
end

M.bind("n", "<C-=>", zoom_toggle, { desc = "ZOOM_TOGGLE" })

local sr_key = {
  '"',
  "`",
  "'",
  ")",
  "]",
  "}",
}

for _, key in ipairs(sr_key) do
  local key_combination = string.format("<space>%s", key)
  local act_combination = string.format("ysiw%s", key)
  local desc_combination = string.format("MiniSurround add word %s", key)
  vim.keymap.set("n", key_combination, act_combination, { remap = true, desc = desc_combination })
end

local function toggle_smart_case()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.o.smartcase = not vim.o.smartcase

  local status_message = "Ignorecase: "
    .. (vim.o.ignorecase and "on" or "off")
    .. ", Smartcase: "
    .. (vim.o.smartcase and "on" or "off")
  vim.notify(status_message)
  M.feedkeys("<space>", "c")
  M.feedkeys("<bs>", "c")
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<space>", true, false, true), "c", false)
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<bs>", true, false, true), "c", false)
end

M.bind("c", "<C-S>", toggle_smart_case, { desc = "Toggle smartcase" })

local function cgn(pattern)
  local cmd = vim.api.nvim_replace_termcodes('<CR>N"_cgn', true, false, true)
  vim.api.nvim_feedkeys("/" .. pattern .. cmd, "n", false)
end

local function cgn_action(type)
  return function()
    if type == "v" then
      cgn(require("utils.helper").get_visual_selection())
    else
      cgn(vim.fn.expand("<cword>"))
    end
  end
end

M.bind("n", "<C-N>", cgn_action("n"), { desc = "cgn word" })
M.bind("x", "<C-N>", cgn_action("v"), { desc = "cgn visual" })

M.bind(
  { "x", "n" },
  "<space>r",
  '<cmd>lua require("user.nui").local_menu()<cr>',
  { desc = "(SUB) Search Replace" }
)
M.bind("n", "sqg", '<cmd>lua require("user.nui").git_menu()<cr>', { desc = "(GIT) Menu" })

-- stylua: ignore start

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

M.bind("n", "<F5>", remove_trailing_whitespaces, { desc = "remove trailing whitespaces" })

-- stylua: ignore end
return M
