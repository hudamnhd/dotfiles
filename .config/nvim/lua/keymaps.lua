-- stylua: ignore start
local M = {}

M.leader_group_clues = {
  { mode = 'n', keys = '<space>t', desc = '+Toggle and other' },
  { mode = 'n', keys = '<space>b', desc = '+Bookmark' },
  { mode = 'n', keys = '<space>g', desc = '+LSP' },
}

function M.bind(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.bind("x", ">", [[>gv]])
M.bind("x", "<", [[<gv]])

M.bind("t", "<C-\\>",   [[<C-\><C-n>]])

M.bind("n", "<a-w>", [[<c-w>w]])
M.bind("t", "<a-w>", [[<C-\><C-n><c-w>w]])

M.bind({ "n", "v" }, "<C-H>", [[^]])
M.bind({ "n", "v" }, "<C-L>", [[g_]])
M.bind({ "n", "v" }, "<C-Z>", [[%]], { remap = true })

M.bind({ "n", "v" }, "c", [["_c]])
M.bind({ "n", "v" }, "x", [["_x]])

M.bind("n", "!", [[:<up><cr>]])

-- NOTE without copying to clipboard
local blackhole_key = { "S", "D", "C", "d" }
for _, key in ipairs(blackhole_key) do
    M.bind("n", key, '"_' .. key, { desc = "blackhole" .. key })
end

local function delete_line()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end

M.bind("n", "dd", delete_line, { expr = true, desc = "delete blank lines to black hole register" })

-- emulate some basic commands from `vim-abolish`
M.bind("n", "ct", "mzguiwgUl`z", { desc = "󰬴 Titlecase" })
M.bind("n", "cu", "mzgUiw`z",    { desc = "󰬴 lowercase to UPPERCASE" })
M.bind("n", "cl", "mzguiw`z",    { desc = "󰬴 UPPERCASE to lowercase" })

-- NOTE Lua expression
M.bind("c", "<F1>", [[\(.*\)]], { silent = false })
M.bind("c", "<F2>", [[s/\(.*\)/X\ \1\ X/g>]], { silent = false })
M.bind("c", "<F3>", 'getcmdtype() == ":" ? expand("%:h/") . "/" : ""',   { silent = false, expr = true })
M.bind("c", "<F4>", 'getcmdtype() == ":" ? expand("%:p:h/") . "/" : ""', { silent = false, expr = true })
M.bind("c", "<F5>", 'getcmdtype() == ":" ? expand("%:p")  : ""',         { silent = false, expr = true })

M.bind("c", "<c-v>", [[<C-R>"]], { desc = "paste cmd-mode", silent = false  })
M.bind("c", "<a-v>", [[<C-R>+]], { desc = "paste cmd-mode", silent = false  })

-- M.bind("t", "<M-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })
M.bind("t", "<c-v>", [['<C-\><C-N>""pi']], { expr = true })
M.bind("t", "<a-v>", [['<C-\><C-N>"+pi']], { expr = true })

M.bind("c", "<c-space>", [[.\{-}]], { silent = false })
M.bind("c", "<a-space>", [[\s\+]], { silent = false })

-- NOTE join
M.bind("n", "J", "'mz' . v:count1 . 'J`z'", { expr = true })

-- NOTE Select last pasted/yanked text
M.bind("n", "<M-v>", "`[v`]", { desc = "visual select last yank/paste" })

M.bind("n", "<space>w", vim.cmd.update, { desc = "Save" })

M.bind("x", "p", [['pgv"' . v:register . 'y']], { noremap = true, expr = true, desc = "paste in visual mode without replacing register content" })

-- NOTE Keep matches center screen when cycling with n|N
M.bind("n", "n", "nzz", {desc = "Fwd  search '/' or '?'"})
M.bind("n", "N", "Nzz", { desc = "Back search '/' or '?'" })

M.bind("n", "<C-d>", "<C-d>zz")
M.bind("n", "<C-u>", "<C-u>zz")

-- NOTE resize window
M.bind("n", "<C-Up>",    "<cmd>lua require'utils.helper'.resize(false, -5)<CR>", { desc = "horizontal split increase" })
M.bind("n", "<C-Down>",  "<cmd>lua require'utils.helper'.resize(false,  5)<CR>", { desc = "horizontal split decrease" })
M.bind("n", "<C-Left>",  "<cmd>lua require'utils.helper'.resize(true,  -5)<CR>", { desc = "vertical split decrease" })
M.bind("n", "<C-Right>", "<cmd>lua require'utils.helper'.resize(true,   5)<CR>", { desc = "vertical split increase" })

M.bind("n", "zk", [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]], { desc = "newline above (no insert-mode)" })
M.bind("n", "zj", [[:<C-u>call append(line("."),   repeat([""], v:count1))<CR>]], { desc = "newline below (no insert-mode)" })
M.bind('n', 'zg', [[:<C-u>call append(0, expand('<cword>'))<CR>]], { desc = "append word in first line" })

M.bind({ "n", "v" }, "<space>y", [["+y]], { desc = "yank to clipboard" })
M.bind({ "n", "v" }, "<space>P", [["+P]], { desc = "paste BEFORE from clipboard" })
M.bind({ "n", "v" }, "<space>p", [["+p]], { desc = "paste AFTER from clipboard" })

M.toggle_diff_buff = [[<cmd>call luaeval('require"utils.helper".toggle_diff_buff()')<cr>]]
M.translate_nm     = [[<cmd>call luaeval('require"utils.translate".translate_nm()')<cr>]]
M.translate_vm     = [[<cmd>call luaeval('require"utils.translate".translate_vm()')<cr>]]
M.set_cwd          = [[<cmd>lua require"utils.helper".set_cwd()<cr>]]
M.asynctasks       = [[<cmd>lua require"utils.helper".asynctasks()<cr>]]
M.git_diff_buff    = [[<cmd>lua MiniDiff.toggle_overlay()<cr>]]
M.yankround        = [[<cmd>Unite -vertical yankround<cr>]]
M.regex_tutor      = [[<Cmd>AsyncTask regex-tutor<CR>]]
M.vim_tutor        = [[<Cmd>AsyncTask vim-tutor<CR>]]
M.undotree         = [[<Cmd>UndotreeToggle<CR>]]

M.bind("n", "<space>to", M.git_diff_buff,    { desc = "Toggle overlay" })
M.bind("n", "<space>td", M.toggle_diff_buff, { desc = "TOGGLE_DIFF_BUFF" })
M.bind("n", "<space>tu", M.undotree,         { desc = "UNDOTREEtOGGLE" })
M.bind("n", "<space>t%", M.set_cwd,          { desc = "SET CWD" })
M.bind("n", "<space>tr", M.translate_nm,     { desc = "translate" })
M.bind("x", "<space>tr", M.translate_vm,     { desc = "translate" })
M.bind("n", "<space>tt", M.asynctasks,       { desc = "ASYNCTASKS" })
M.bind("n", "<space>t1", M.regex_tutor,      { desc = "regex-tutor" })
M.bind("n", "<space>t2", M.vim_tutor,        { desc = "vim-tutor" })

M.bind("n", "sy", M.yankround, { desc = "YANKROUND" })

M.bind("n", '<space>tw', [[:set wrap!<CR>]], { desc ="toggle wrap" } )
-- toogle number
M.bind("n", '<space>tn', [[:set nonumber norelativenumber<CR>]], { desc ="noactive number" } )
M.bind("n", '<space>tN', [[:set number relativenumber<CR>]], { desc ="active number" } )

M.bind("n", "<esc>",  "<Cmd>nohlsearch|diffupdate|echo<CR>",  { desc = "nohlsearch" })
M.bind("c", "<C-J>",  function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, false, true), "n", false) end )
M.bind("c", "<C-K>",  function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, false, true), "n", false) end )

-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
for _, c in ipairs({
  { "k", "Line up" },
  { "j", "Line down" },
}) do
  M.bind("n", c[1], ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]), { expr = true, desc = c[2] })
end

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
for _, m in ipairs({ "n", "v" }) do
  for _, c in ipairs({
    { "k", "k", "Visual line up" },
    { "j", "j", "Visual line down" },
  }) do
    M.bind( m, c[1], ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]), { expr = true, desc = c[3] })
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

-- M.bind("n", "<space>l", ":syntax sync fromstart<CR>:redraw<CR>:echo 'syntax sync fromstart done'<CR>")

-- Definisikan fungsi zoom_toggle
local function zoom_toggle()
        vim.cmd('normal! ' .. '|')

    -- Periksa apakah hanya ada satu jendela terbuka.
    if vim.fn.winnr('$') == 1 then
        return
    end

    local restore_cmd = vim.fn.winrestcmd()
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')

    -- Proses untuk menyimpan dan mengembalikan t:zoom_restore
    if vim.g.zoom_restore then
        vim.cmd(vim.g.zoom_restore)
        vim.g.zoom_restore = nil
    elseif vim.fn.winrestcmd() ~= restore_cmd then
        vim.g.zoom_restore = restore_cmd
    end
end

M.bind('n', '|', zoom_toggle, { desc = "ZOOM_TOGGLE"} )

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~ multiple cursors (sort of) ~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- see: http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript

local mc_select = [[y/\V\C<C-r>=escape(@", '/')<CR><CR>]]
local function mc_macro(selection)
    selection = selection or ''

    return function()
        if vim.fn.reg_recording() == 'z' then
            return 'q'
        end

        if vim.fn.getreg('z') ~= '' then
            return 'n@z'
        end

        return selection .. '*Nqz'
    end
end

M.bind({ 'n', 'v' }, 'Q', '@q', { desc = 'start macro q' }) -- execute macro
M.bind('n', '<a-q>', 'q', { desc = 'remap q' })

M.bind('n', 'zq', '*Nqz', { desc = 'mc start macro (foward)' })
M.bind('n', 'zQ', '#Nqz', { desc = 'mc start macro (backward)' })
M.bind('n', '<F8>', mc_macro(), { expr = true, desc = 'mc end or replay macro' })

M.bind('x', 'zq', mc_select .. '``qz', { desc = 'mc start macro (foward)' })
M.bind('x', 'zQ', mc_select:gsub('/', '?') .. '``qz', { desc = 'mc start macro (backward)' })
M.bind('x', '<F8>', mc_macro(mc_select), { expr = true, desc = 'mc end or replay macro' })

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

-- stylua: ignore start
M.bind("n", "<F5>", remove_trailing_whitespaces, { desc = "remove trailing whitespaces" })

M.bind({ "o", "x" }, "q", [[iq]], { remap = true })
M.bind({ "o", "x" }, "Q", [[aq]], { remap = true })
M.bind({ "o", "x" }, "w", [[iw]], { remap = true })
M.bind({ "o", "x" }, "W", [[iW]], { remap = true })
M.bind({ "o", "x" }, "t", [[it]], { remap = true })
M.bind({ "o", "x" }, "T", [[at]], { remap = true })

-- Quickfix|loclist toggles
M.bind("n", ">", "<cmd>lua require'utils.helper'.toggle_qf('l')<CR>", { desc = "toggle location list" })
M.bind("n", "<", "<cmd>lua require'utils.helper'.toggle_qf('q')<CR>", { desc = "toggle quickfix list" })

M.bind("n", "sm", "gmm",  { remap = true, desc = "MiniOperator clone line" })
M.bind("n", "sx", "gxiw", { remap = true, desc = "MiniOperator exchange word" })
M.bind("n", "rw", "griw", { remap = true, desc = "MiniSurround replace word" })
M.bind("n", "sw", "ysiw", { remap = true, desc = "MiniSurround add word" })

M.sad = function(pattern)
  local utils   = require("utils.helper")
  local term    = ":FloatermNew --name=sr --disposable --autoclose=2 --width=0.95 --height=0.95 fd . | sad  --pager 'delta -w 160' "
  local query   = "'".. pattern .."'" .. " " .. "'".. pattern .."'"
  local switch  = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
  local cmd     = term .. query
  vim.api.nvim_feedkeys(cmd .. switch, "n", false)
  return cmd
end

M.sad_visual = function()
  M.sad(require("utils.helper").get_visual_selection())
end

M.sad_cword = function()
  M.sad(vim.fn.expand("<cword>"))
end


local sr_visual_g       = vim.cmd.SearchReplaceSingleBufferVisualSelection
local sr_word_g         = vim.cmd.SearchReplaceSingleBufferCWord
local sr_visual_word    = vim.cmd.SearchReplaceWithinVisualSelectionCWord
local sr_selection_word = [[:'<,'>s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>]]
local sr_visual_word    = vim.cmd.SearchReplaceWithinVisualSelectionCWord
local sr_visual         = vim.cmd.SearchReplaceWithinVisualSelection
local sr_normal         = vim.cmd.SearchReplaceSingleBufferOpen

-- Search and Replace
M.bind("x", "<c-f>", sr_visual_g,       { desc = "replace visual" })
M.bind("n", "<c-f>", sr_word_g,         { desc = "replace cword" })
M.bind("x", "<c-b>", sr_visual_word,    { desc = "replace cword" })
M.bind("n", "<c-b>", sr_selection_word, { desc = "replace cword", silent = false })
M.bind("x", "<c-s>", sr_visual,         { desc = "Search Replace Search" })
M.bind("n", "<c-s>", sr_normal,         { desc = "Search Replace Search" })
M.bind('x', '<a-f>', M.sad_visual,      { desc = 'sad_visual' })
M.bind('n', '<a-f>', M.sad_cword,       { desc = 'sad_cword' })

local function toggle_smart_case()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.o.smartcase = not vim.o.smartcase

  local status_message = "Ignorecase: " .. (vim.o.ignorecase and "on" or "off") .. ", Smartcase: " .. (vim.o.smartcase and "on" or "off")
  vim.notify(status_message)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<space>", true, false, true), "c", false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<bs>", true, false, true), "c", false)
end

M.bind("c", "<C-S>", toggle_smart_case, {  desc = "Toggle smartcase" })

M.bind({ "n", "v" }, "0", ":", { desc = "cmd", silent = false })

M.bind("n", "<space>e", [[:<C-U>call signature#mark#ToggleAtLine()<CR>]], { desc = "toggle mark line" })
M.bind("n", "<space>E", [[:<C-U>call signature#mark#Purge('all')<CR>]],   { desc = "purge all mark buffer" })
M.bind("n", "<C-E>", [[:<C-U>call signature#mark#List(0,0)<CR>]],      { desc = "list all mark in quickfix" })

M.bind("n", "<C-;>", [[:<C-U>call signature#mark#Goto("prev", "spot", "alpha")<CR>]], { desc = "prev mark" })
M.bind("n", "<C-'>", [[:<C-U>call signature#mark#Goto("next", "spot", "alpha")<CR>]], { desc = "next mark" })

local function cgn(pattern)
  local cmd  = vim.api.nvim_replace_termcodes('<CR>N"_cgn', true, false, true)
  vim.api.nvim_feedkeys('/'.. pattern .. cmd, "n", false)
end

local function cgn_word()
 -- require("utils.helper").get_range(function(result) cgn(result) end)
  cgn(vim.fn.expand("<cword>"))
end

local function cgn_opr()
 require("utils.helper").get_range(function(result) cgn(result) end)
end

local function cgn_visual()
  cgn(require("utils.helper").get_visual_selection())
end

M.bind("n", "cg", cgn_opr,    { desc = "cgn word" })
M.bind("n", "<a-c>", cgn_word,   { desc = "cgn word" })
M.bind("x", "<a-c>",  cgn_visual, { desc = "cgn visual" })

M.show_documentation = function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand "<cword>")
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand "<cword>")
  else
    vim.lsp.buf.hover()
  end
end

M.bind('n', 'K', M.show_documentation, { desc = 'show_documentation' })


-- Tabpages
-- @param tab_action function
-- @param default_count number?
-- @return function
 local function tabswitch(tab_action, default_count)
   return function()
     local count = default_count or vim.v.count
     local num_tabs = vim.fn.tabpagenr('$')
     if num_tabs >= count then
       tab_action(count ~= 0 and count or nil)
       return
     end
     vim.cmd.tablast()
     for _ = 1, count - num_tabs do
       vim.cmd.tabnew()
     end
   end
 end

M.bind('n', '<space>k', '<c-w>T')
M.bind("n", '<space>Q', vim.cmd.tabonly, { desc = "tab only"})
M.bind("n", '<space>q', vim.cmd.close, { desc = "tab close"})
M.bind("n", 'gt', tabswitch(vim.cmd.tabnext), { desc = "tab next"})
M.bind("n", 'gy', tabswitch(vim.cmd.tabprev), { desc = "tab prev"}) -- gT is too hard to press
M.bind("n", '<space>0', '<Cmd>0tabnew<CR>', { desc = "tab new"})

M.bind("t", "<C-^>", "<cmd>b#<cr>",                { desc = "tab term" })
M.bind("n", "<C-7>", "<cmd>tab terminal<cr>",      { desc = "tab term" })
M.bind("n", "<C-8>", "<cmd>vertical terminal<cr>", { desc = "tab term" })
M.bind("n", "<C-9>", "<cmd>terminal<cr>",          { desc = "tab term" })
M.bind("t", "<C-0>", "<cmd>bd!<cr>",               { desc = "tab term" })
-- M.bind("n", '<space>bd', vim.cmd.bd, { desc = "bdelete"})
-- M.bind("n", '<space>bw', vim.cmd.bw, { desc = "bwipeout"})


local keys = '123456789'
for i = 1, #keys do
  local key = keys:sub(i,i)
  local key_combination = string.format('<space>%s', key)
  M.bind('n', key_combination, tabswitch(vim.cmd.tabnext, i), { desc = "go tab " .. i })
end

return M
