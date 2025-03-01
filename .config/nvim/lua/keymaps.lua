---@diagnostic disable: codestyle-check
local M = {}

local utils = require("utils")
local k = utils.keymap
local bind, feedkeys = k.bind, k.feedkeys
local nm, tm, cm, vm, nvm = "n", "t", "c", { "v", "o", "x" }, { "n", "v", "o", "x" }

M.leader_group_clues = {
  { mode = "n", keys = "<space>t", desc = "+Toggle and other" },
  { mode = "n", keys = "<space>b", desc = "+Bookmark" },
  { mode = "n", keys = "<space>g", desc = "+LSP" },
  { mode = "n", keys = "sq", desc = "+Other" },
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
  bind(nm, key, '"_' .. key, { desc = "blackhole" .. key })
end

local function delete_line()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end

-- https://neovim.discourse.group/t/delete-all-but-current-buffer/3953/2
local function bdall()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, i in ipairs(bufs) do
    if i ~= current_buf then
      vim.api.nvim_buf_delete(i, {})
    end
  end
end

-- stylua: ignore start
bind(nm, "zQ",    [[#Nqz]],            { desc = "mc start macro (backward)" } )
bind(nm, "zq",    [[*Nqz]],            { desc = "mc start macro (foward)" } )
bind(nm, "<c-0>", mc_macro(),          { desc = "mc end or replay macro", expr = true } )

bind(vm, "zq",    mc_select .. "``qz", { desc = "mc start macro (foward)" } )
bind(vm, "zQ",    mc_select:gsub("/",  "?") .. "``qz",                    { desc = "mc start macro (backward)" } )
bind(vm, "<c-0>", mc_macro(mc_select), { desc = "mc end or replay macro", expr = true  } )

bind(tm, "<c-\\>", [[<C-\><C-n>]] )
bind(tm, "<a-x>",  [[<C-\><C-n>:bd!<Cr>]] )
bind(tm, "<a-w>",  [[<C-\><C-n><c-w>w]] )
bind(tm, "<m-r>",  [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true } )

bind(cm, "<c-v>", [[<C-R>"]], { desc = "paste cmd-mode", silent = false } )
bind(cm, "<a-v>", [[<C-R>+]], { desc = "paste cmd-mode", silent = false } )
bind(cm, "<F1>", [[\(.*\)<Left><Left>]], { silent = false })
bind(cm, "<F2>", [[\<\><Left><Left>]],   { silent = false })
bind(cm, "<F3>", [[.\{-}]],              { silent = false } ) --\s\+
bind(cm, "<F4>", 'getcmdtype() == ":" ? expand("%:p")  : ""', { silent = false, expr = true } )

-- NOTE Lua expression
bind(cm, "=",  [[getcmdtype() == ':' && getcmdline() == '' ? 'lua=' : '=']], { silent = false, expr = true })

bind(vm, "<c-f>", [[<cmd>lua require("utils.search-replace").visual_charwise_selection()<cr>]], { desc = "replace visual" } )
bind(vm, "<c-s>", [[:s/\v//g<left><left><left>]],          { desc = "Search Replace", silent = false  } )
bind(nm, "<c-f>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],     { desc = "Replace cword", silent = false } )
bind(nm, "<c-s>", [[:'<,'>s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace cword", silent = false } )
bind(nm, "<a-x>", [[<cmd>!chmod +x %<CR>]], { silent = false } )

bind(vm, "<leader>n", [[:s/\d\+/number/g]],                              { desc = "Number to type number",          silent = false } )
bind(vm, "<leader>s", [[:s/"[^"]*"/string/g]],                           { desc = "String to type string",          silent = false } )
bind(vm, "<leader>c", [[:s/\(\l\)\(\u\)/\1\_\l\2/g<CR>]],                { desc = "Camel to snack",                 silent = false } )
bind(vm, "<leader>-", [[:s/\([a-zA-Z]\)\(-\)\([a-zA-Z]\)/\1\u\3/g<CR>]], { desc = "Rmv - and change to capitalize", silent = false } )

bind(vm, "p", [['pgv"' . v:register . 'y']], { desc = "paste without replacing register", expr = true } )
bind(vm, ">", [[>gv]] )
bind(vm, "<", [[<gv]] )

bind(nm, "!",     [[:<up><cr>]] )
bind(nm, "<a-w>", [[<c-w>w]] )
bind(nm, "<esc>", [[<Cmd>nohlsearch|diffupdate|echo<cr>]] )

bind(nm, "<space>w", vim.cmd.write, { desc = "update" } )
bind(nm, "<space>q", vim.cmd.bd, { desc = "bd" } )
bind(nm, "<space>bw", vim.cmd.bw, { desc = "bw" } )
bind(nm, "<space>bq", bdall, { desc = "bd all" } )
bind(nm, "<space>bs", function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, { desc = "scratch" })

bind(nm, "J",   [['mz' . v:count1 . 'J`z']], { desc = "Join", expr = true } )

-- emlate some basic commands from `vim-abolish`
bind(nm, "cl",  [[mzguiw`z]],       { desc = "󰬴 UPPERCASE to lowercase" } )
bind(nm, "ct",  [[mzguiwgUl`z]],    { desc = "󰬴 Titlecase" } )
bind(nm, "cu",  [[mzgUiw`z]],       { desc = "󰬴 lowercase to UPPERCASE" } )
bind(nm, "dd",  delete_line,        { desc = "delete line", expr = true  } )

-- NOE Keep matches center screen when cycling with n|N
bind(nm, "sx", [[gxiw]], { remap = true, desc = "Exchange word" } )
bind(nm, "sm", [[gmm]],  { remap = true, desc = "Clone line" } )
bind(nm, "sw", [[ysiw]], { remap = true, desc = "Surround cword" } )

bind(nm, "sc", [[<c-w>c]], { desc = "close" } )
bind(nm, "ss", [[<c-w>s]], { desc = "split" } )
bind(nm, "sv", [[<c-w>v]], { desc = "vsplit" } )


bind(nvm, "0",     [[:]],   { silent = false })
bind(nvm, "c",     [["_c]] )
bind(nvm, "x",     [["_x]] )
bind(nvm, "gy",    [["+y]], { desc = "Yank to clipboard (primary)" } )
bind(nvm, "gp",    [["+p]], { desc = "Paste after from clipboard (primary)" } )
bind(nvm, "<c-h>", [[^]] )
bind(nvm, "<c-l>", [[g_]] )
bind(nvm, "<c-z>", [[%]] )

bind(vm, "<space>tr", [[<cmd>lua utils.translate.translate_vm()<cr>]],               { desc = "translate visual" } )
bind(nm, "<space>tr", [[<cmd>lua utils.translate.translate_nm()<cr>]],               { desc = "translate normal" } )
bind(nm, "<space>tc", [[<cmd>lua require("utils.helper").set_cwd()<cr>]],            { desc = "Set cwd" } )
bind(nm, "<space>ty", [[<cmd>Unite -vertical yankround<cr>]],                        { desc = "YANKROUND" } )
bind(nm, "<space>tu", [[<cmd>UndotreeToggle<cr>]],                                   { desc = "Toggle Undotree" } )
bind(nm, "<space>td", [[<cmd>lua require("utils.helper").toggle_diff_buff()<cr>]],   { desc = "Toggle diff" } )
bind(nm, "<space>to", [[<cmd>lua require("mini.diff").toggle_overlay()<cr>]],        { desc = "Toggle overlay" } )
bind(nm, "<space>th", [[<cmd>lua require("mini.hipatterns").toggle()<cr>]],          { desc = "Toggle Hipatterns" } )
bind(nm, "<a-a>",     [[<cmd>lua require("plugins.fzf-lua.cmds").asynctasks()<cr>]], { desc = "Asynctasks" } )

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

bind(nm, "<C-N>", cgn_action("n"), { desc = "cgn word" })
bind(vm, "<C-N>", cgn_action("v"), { desc = "cgn visual" })

-- bind(nm, "<F3>", function ()
--   vim.cmd('tabedit')
--   vim.cmd('setlocal nonumber signcolumn=no')
--   vim.fn.jobstart('gitui', {
--     term = true,
--     on_exit = function()
--       vim.cmd('silent! :checktime')
--       vim.cmd('silent! :bw')
--     end,
--   })
--   vim.cmd('startinsert')
--   vim.b.minipairs_disable = true
-- end, { desc = "terminal gitui" })


return M
