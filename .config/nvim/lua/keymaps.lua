-- stylua: ignore start
local M = {}

M.leader_group_clues = {
  { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>l', desc = '+Lsp' },
  { mode = 'n', keys = '<Leader>i', desc = '+Insert Path' },
}

function M.bind(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.bind("n", "<tab>",   [[g;]])
M.bind("n", "<s-tab>", [[g,]])

M.bind('n', '<C-c>',  [[<cmd>close<CR>]])
M.bind("t", "<C-\\>", [[<C-\><C-n>]])
M.bind("t", "<a-r>",  [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })
M.bind("n", "<a-w>",  [[<c-w>w]])
M.bind("t", "<a-w>",  [[<C-\><C-n><c-w>w]])

M.bind({ "n", "v" }, "<C-H>", [[^]])
M.bind({ "n", "v" }, "<C-L>", [[g_]])
M.bind({ "n", "v" }, "<C-Z>", [[%]], { remap = true })

M.bind({ "n", "v" }, "c", [["_c]])
M.bind({ "n", "v" }, "x", [["_x]])

M.bind("n", "<leader>d", [[d]], { desc = "copying to clipboard" })

M.bind("n", "!", [[:<up><cr>]])
M.bind("n", "Y", [[yy]])

-- NOTE without copying to clipboard
M.bind("n", "D", [["_D]])
M.bind("n", "C", [["_C]])
M.bind("n", "d", [["_d]])

M.bind("n", "rT", [[vat"_dP]])
M.bind("n", "rt", [[vit"_dP]])

-- emulate some basic commands from `vim-abolish`
M.bind("n", "ct", "mzguiwgUl`z", { desc = "󰬴 Titlecase" })
M.bind("n", "cu", "mzgUiw`z",    { desc = "󰬴 lowercase to UPPERCASE" })
M.bind("n", "cl", "mzguiw`z",    { desc = "󰬴 UPPERCASE to lowercase" })

M.bind("c", "<F1>", [[\(.*\)]], { silent = false })
M.bind("c", "<F2>", [[\<.*\>]], { silent = false })

-- NOTE Lua expression
M.bind("c", "%%", 'getcmdtype() == ":" ? expand("%:p:h/") . "/" : "%%"', { silent = false, expr = true })
M.bind("c", "$$", 'getcmdtype() == ":" ? expand("%:p")  : "$"',          { silent = false, expr = true })

M.bind("c", "<C-V>",      [[<C-R>"]], { desc = "paste cmd-mode", silent = false  })
M.bind("c", "<C-X><C-V>", [[<C-R>+]], { desc = "paste cmd-mode", silent = false  })

M.bind("t", "<a-v>",      [['<C-\><C-N>""pi']], { desc = "paste cmd-mode" ,expr = true })
M.bind("t", "<a-x><c-v>", [['<C-\><C-N>"+pi']], { desc = "paste cmd-mode" ,expr = true })

M.bind("c", "<c-space>", [[.\{-}]], { silent = false })
M.bind("c", "<a-space>", [[\s\+]], { silent = false })

-- NOTE join
M.bind("n", "J", "'mz' . v:count1 . 'J`z'", { expr = true })
-- M.bind("n", "<leader>g", ":", { expr = true })

-- NOTE Select last pasted/yanked text
M.bind("n", "g<C-v>", "`[v`]", { desc = "visual select last yank/paste" })

-- M.bind({ "n", "v", "i" }, "<C-S>", "<esc>:update<cr>", { desc = "Save" })
M.bind("n", "<leader>w", "<cmd>update<cr>", { desc = "Save" })
M.bind("n", "<leader>W", "<cmd>wq<cr>", { desc = "Save and quit" })

M.bind("x", "p", [['pgv"' . v:register . 'y']], { noremap = true, expr = true, desc = "paste in visual mode without replacing register content" })

-- NOTE Keep matches center screen when cycling with n|N
M.bind("n", "n", "nzz", { desc = "Fwd  search '/' or '?'" })
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

-- M.bind('n', 'se', [[:<C-u>call append(0, expand('<cword>'))<CR>]], { noremap = true, silent = true })

local duplicate_bak    = [[<cmd>call luaeval('require"utils.helper".duplicate_bak_file()')<cr>]]
local toggle_diff_buff = [[<cmd>call luaeval('require"utils.helper".toggle_diff_buff()')<cr>]]
local translate_nm     = [[<cmd>call luaeval('require"utils.translate".translate_nm()')<cr>]]
local translate_vm     = [[<cmd>call luaeval('require"utils.translate".translate_vm()')<cr>]]
local set_cwd          = [[<cmd>lua require"utils.helper".set_cwd()<cr>]]
local asynctasks       = [[<cmd>lua require"utils.helper".asynctasks()<cr>]]
local git_diff_buff    = [[<cmd>lua MiniDiff.toggle_overlay()<cr>]]
local yankround        = [[<cmd>Unite -vertical yankround<cr>]]

M.bind("n", "go", git_diff_buff,    { desc = "Toggle overlay" })
M.bind("n", "st", translate_nm,     { desc = "translate" })
M.bind("x", "st", translate_vm,     { desc = "translate" })
M.bind("n", "sw", asynctasks,       { desc = "ASYNCTASKS" })
M.bind("n", "s=", toggle_diff_buff, { desc = "TOGGLE_DIFF_BUFF" })
M.bind("n", "s%", set_cwd,          { desc = "SET CWD" })
M.bind("n", "s.", duplicate_bak,    { desc = "DUPLICATE_BAK_FILE" })

M.bind("n", "sy", yankround,                 { desc = "YANKROUND" })
M.bind("n", "sa", "<cmd>Agit<cr>",           { desc = "AGIT" })
M.bind("n", "sA", "<cmd>AgitFile<cr>",       { desc = "AGITfILE" })
M.bind("n", "su", "<cmd>UndotreeToggle<cr>", { desc = "UNDOTREEtOGGLE" })

M.bind({ "n", "v" }, "<leader>y", '"+y', { desc = "yank to clipboard" })

M.bind("n", "<leader>Y", '"+Y$',{ desc = "yank line to clipboard" })

M.bind({ "n", "v" }, "<leader>p", [["+p]], { desc = "paste AFTER from clipboard" })
M.bind({ "n", "v" }, "<leader>P", [["+P]], { desc = "paste BEFORE from clipboard" })

M.bind({ "n", "v" }, "gp", [["*p]], { desc = "paste AFTER from primary" })
M.bind({ "n", "v" }, "gP", [["*P]], { desc = "paste BEFORE from primary" })

M.bind("n", "<Leader>t1", "<Cmd>AsyncTask regex-tutor<CR>",       { desc = "regex-tutor" })
M.bind("n", "<Leader>t2", "<Cmd>AsyncTask vim-tutor<CR>",         { desc = "vim-tutor" })
-- M.bind("n", "<Leader>th", "<Cmd>TSBufToggle highlight<CR>",       { desc = "Highlight toggle" })

-- toogle number
M.bind("n", '<Leader>tN', [[:set nonumber norelativenumber<CR>]], { desc ="noactive number" } )
M.bind("n", '<Leader>tn', [[:set number relativenumber<CR>]], { desc ="active number" } )

M.bind("n", "<Leader>n",  "<Cmd>nohlsearch|diffupdate|echo<CR>",  { desc = "nohlsearch" })

local function delete_line()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end

M.bind("n", "dd", delete_line, { expr = true, desc = "delete blank lines to black hole register" })

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
    { "<up>", "k", "Visual line up" },
    { "<down>", "j", "Visual line down" },
  }) do
    M.bind( m, c[1], ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]), { expr = true, desc = c[3] })
  end
end

for k, v in pairs({ ["<down>"] = "<C-n>", ["<up>"] = "<C-p>" }) do
  M.bind("c", k, function()
    local key = vim.fn.pumvisible() ~= 0 and v or k
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
  end, { silent = false })
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

-- M.bind("n", "<leader>l", ":syntax sync fromstart<CR>:redraw<CR>:echo 'syntax sync fromstart done'<CR>")

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

M.bind('n', '<leader>z', zoom_toggle, { desc = "ZOOM_TOGGLE"} )

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

M.bind({ 'n', 'v' }, 'Q', '@q') -- execute macro

M.bind("x", "<a-s>", [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>"_cgn]], { noremap = true, desc = "Add selection to search then replace"})
M.bind("n", "<a-s>", [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_cgn]], { noremap = true, desc = "Add word to search then replace"})

M.bind('n', 'zq', '*Nqz', { desc = 'mc start macro (foward)' })
M.bind('n', 'zQ', '#Nqz', { desc = 'mc start macro (backward)' })
M.bind('n', '<a-q>', mc_macro(), { expr = true, desc = 'mc end or replay macro' })

M.bind('x', 'zq', mc_select .. '``qz', { desc = 'mc start macro (foward)' })
M.bind('x', 'zQ', mc_select:gsub('/', '?') .. '``qz', { desc = 'mc start macro (backward)' })
M.bind('x', '<a-q>', mc_macro(mc_select), { expr = true, desc = 'mc end or replay macro' })

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
M.bind("n", "<F1>", "<cmd>lua require'utils.helper'.toggle_qf('q')<CR>", { desc = "toggle quickfix list" })
M.bind("n", "<F2>", "<cmd>lua require'utils.helper'.toggle_qf('l')<CR>", { desc = "toggle location list" })

M.bind("n", "X", "gxiw", { remap = true })
M.bind("n", "M", "Vgm",  { remap = true })
M.bind("n", "s", "ysiw", { remap = true }) -- easy press

M.sad_visual = function()
  local utils   = require("utils.helper")
	local pattern = utils.get_visual_selection()
  local term    = ":FloatermNew --name=sr --disposable --autoclose=2 --width=0.95 --height=0.95 fd . | sad  --pager 'delta -w 160' "
  local query   = "'".. pattern .."'" .. " " .. "'".. pattern .."'" 
  local switch  = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
  local cmd     = term .. query

  vim.api.nvim_feedkeys(cmd .. switch, "n", false)
end

M.sad_cword = function()
  local utils   = require("utils.helper")
	local pattern = vim.fn.expand "<cword>"
  local term    = ":FloatermNew --name=sr --disposable --autoclose=2 --width=0.95 --height=0.95 fd . | sad  --pager 'delta -w 160' "
  local query   = "'".. pattern .."'" .. " " .. "'".. pattern .."'" 
  local switch  = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
  local cmd     = term .. query

  vim.api.nvim_feedkeys(cmd .. switch, "n", false)
end

M.bind('x', 'gw', M.sad_visual, { desc = 'sad_visual' })
M.bind('n', 'gw', M.sad_cword,  { desc = 'sad_cword' })

local function toggle_smart_case()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.o.smartcase = not vim.o.smartcase

  local status_message = "Ignorecase: " .. (vim.o.ignorecase and "on" or "off") .. ", Smartcase: " .. (vim.o.smartcase and "on" or "off")
  vim.notify(status_message)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<space>", true, false, true), "c", false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<bs>", true, false, true), "c", false)
end

M.bind("c", "<c-s>", toggle_smart_case, {  desc = "Toggle smartcase" })

local copy = require("utils.copy")

M.bind({ "n", "v" }, "<leader>F", function() copy.list_paths() end, { desc = "List Path" })
M.bind({ "n", "v" }, "<leader><space>", ":", { desc = "Command", silent = false })

-- stylua: ignore end
return M
