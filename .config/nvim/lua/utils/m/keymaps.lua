local m = require("utils.m")
local map  = m.map
local silent = { silent = true }


-- OVERRIDE DEFAULTS ---------------------------------------------------------------------
map.n("Y", "y$") -- Yank to the end of the line
map.nx({ ["/"] = "ms/", ["?"] = "ms?", ["<a-u>"] = "~"  }) -- Save initial search position
map.x({ ["<BS>"] = "<gv", ["<"] = "<gv", [">"] = ">gv", ["<Tab>"] = ">gv" })

-- BUFFERS -------------------------------------------------------------------------------
map.n({ ["zq"] = [[:wq!<CR>]], }, silent)

map.n("s<C-G>", "2<C-G>")

-- FILES ---------------------------------------------------------------------------------
map.n({
  ["sq"]    = [[:lua require'utils.m.ui.menus'.bookmarks()<CR>]],
  ["sa"]    = [[:lua require'utils.m.ui.menus'.gitsigns()<CR>]],
  ["sd"]    = [[:lua require'utils.m.ui.menus'.options()<CR>]],
})

map.n("s<C-a>", [[<cmd>keepjumps norm! ggVG<CR>]])

-- COMMENT ---------------------------------------------------------------------------
-- stylua: ignore start
map.v({
  ["gcb"] = [[:s@^\(.*\)$@{{--\1--}}<CR>:let @/ = ""<CR>]],
  ["gub"] = [[:s@^{{--\(\(.*[^{\{--]\)\)\?--}}$@\1<CR>:let @/ = ""<CR>]],
  ["gcj"] = [[:s@^\(.*\)$@{/*\1*/}<CR>:let @/ = ""<CR>]],
  ["guj"] = [[:s@^{/\*\(\(.*[^{/\*]\)\)\?\*/}$@\1<CR>:let @/ = ""<CR>]],
  ["gch"] = [[:s@^\(.*\)$@<!--\1--><CR>:let @/ = ""<CR>]],
  ["guh"] = [[:s@^<!--\(\(.*[^<!--]\)\)\?-->$@\1<CR>:let @/ = ""<CR>]],
})

-- stylua: ignore end
-- Insert stuff
map.i({
  ["<C-X><C-T>"] = [[<C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>]],
}, silent)

-- Toggle smartcase
map.c("<C-X><C-I>", function()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.o.smartcase  = not vim.o.smartcase
  return " <BS>" -- update search
end, { expr = true })

-- disable default keybind
map.nv({
  -- ["a"]       = "<Nop>",
  ["t"]       = "<Nop>",
  ["s"]       = "<Nop>",
  ["r"]       = "<Nop>",
  ["<space>"] = "<Nop>",
})

map.n({
  ["e"]         = [[E]],
  ["d;"]        = [[q:]],
  ["<Tab>"]     = [[g;zvzz]],
  ["<S-Tab>"]   = [[g,zvzz]],
  ["<leader>k"] = [[:help <C-r>=expand("<cword>")<CR>]],
  ["<leader>w"] = [[<C-W>]],
  ["<a-w>"]     = [[<C-W>w]],
})

map.vn({
  ["<C-H>"]     = [[^]],
  ["<C-L>"]     = [[g_]],
})

map.n({
  ["rt"]        = [[vit"_dP]],
  ["rat"]       = [[vat"_dP]],
})

map.n({
  ["rw"]        = [[viw"_dP]],
})

map.xo({
  ["{"]         = [[i{]],
  ["["]         = [[i[]],
  ["("]         = [[i(]],
  ["b"]         = [[ib]],
  ["B"]         = [[iB]],
  ["w"]         = [[iw]],
  ["W"]         = [[iW]],
  ["t"]         = [[it]],
  ["T"]         = [[at]],
},{ desc = "operator pending" })

-- .nshortcut to view :messages
map.nx("zm", "<cmd>20messages<CR>", { desc = "open :messages" })
map.nx("zM", [[<cmd>mes clear|echo "cleared :messages"<CR>]], { desc = "clear :messages" })
-- .nstylua: ignore end

-- .n<ctrl-s> to Save
map.nvi("<C-S>", "<esc>:update<cr>", { silent = true, desc = "Save" })

-- SearchReplace with plugin
map.n("<C-F>", "<CMD>SearchReplaceSingleBufferCWord<CR>")
map.v("<C-F>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>")
map.n("<C-B>", [[:'<,'>s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]])
map.v("<C-B>",     "<CMD>SearchReplaceWithinVisualSelection<CR>")

map.v("H",         [[:s/^//gI<Left><Left><Left>]]) -- add begin line only
map.v("L",         [[:s/$//gI<Left><Left><Left>]]) -- add end only
map.v("K",         [[:s/\(.*\)/X \1 X/gI<Left><Left><Left>]]) -- add word begin and end line
map.v("<c-space>", [[:s/\s\+/ /g<Left><Left>]]) -- delete space
map.v("c'",        [[:s/"\([^"]*\)"/""/g<Left><Left>]]) -- change word in quotes
map.v("c9",        [[:s/"\([^"]*\)"/(\1)/g <Left><Left>]]) -- add word after ()

-- w!! to save with sudo
-- nmap("c", "w!!", "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- .nQuickfix list mappings
map.n("<leader>q", "<cmd>lua require'utils.other'.toggle_qf('q')<CR>", { desc = "toggle quickfix list" })
map.n("L", ":cnext<CR>", { silent = true, desc = "Next quickfix" })
map.n("H", ":cprevious<CR>", { silent = true, desc = "Previous quickfix" })

-- .nLocation list mappings
map.n("<space>Q", "<cmd>lua require'utils'.other.toggle_qf('l')<CR>", { desc = "toggle location list" })
-- map.n("<A-H>", ":lprevious<CR>", { silent = true, desc = "Previous location" })
-- map.n("<A-L>", ":lnext<CR>", { silent = true, desc = "Next location" })

map.n("<leader>Y", [["+Y]])
map.nv("<leader>y", [["+y]])

-- for i = 1, 9 do
--   map.nv(i % 9 .. "s", '"' .. i % 9 .. "y", silent)
-- end
--
-- for i = 1, 9 do
--   map.nv(i % 9 .. "r", '"' .. i % 9 .. "P", silent)
-- end

map.nx("<leader>r", [["*p]], { desc = "paste AFTER from clipboard" })
map.nx("<leader>r", [["*P]], { desc = "paste BEFORE from clipboard" })
map.nx("<leader>p", [["+p]], { desc = "paste AFTER from clipboard" })
map.nx("<leader>P", [["+P]], { desc = "paste BEFORE from clipboard" })
-- map.nx("<leader>p", [["0p]], { desc = "paste AFTER  from yank (reg:0)" })
-- map.nx("<leader>P", [["0P]], { desc = "paste BEFORE from yank (reg:0)" })

-- without copying to clipboard
map.n({
  ["S"]  = [["_S]],
  ["D"]  = [["_D]],
})

map.nx({
  ["c"]  = [["_c]],
  ["x"]  = [["_x]],
})

--  Change
map.n({
  ["db"] = [["_cib]],
  ["dB"] = [["_ciB]],
  ["dw"] = [["_ciw]],
  ["dW"] = [["_ciW]],
  ["dt"] = [["_cit]],
})

map.n("dd", function()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end, { expr = true, desc = "delete blank lines to black hole register" })

-- paste in visual mode without replacing register content
map.x("p", [['pgv"' . v:register . 'y']], { noremap = true, expr = true })

-- Keep matches center screen when cycling with n|N
map.n("n", "nzzzv", { desc = "Fwd  search '/' or '?'" })
map.n("N", "Nzzzv", { desc = "Back search '/' or '?'" })

-- Map <leader>o & <leader>O to newline without insert mode
-- stylua: ignore start
map.n("zj", [[:<C-u>call append(line("."),   repeat([""], v:count1))<CR>]], { silent = true, desc = "newline below (no insert-mode)" })
map.n("zk", [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]], { silent = true, desc = "newline above (no insert-mode)" })
-- stylua: ignore end

-- Custom
-- map.n("tpa", [[:lua require('utils.other').paste_text_to_register('a')<CR>]], { silent = true })

-- emulate some basic commands from `vim-abolish`
map.n("ct", "mzguiwgUl`z", { desc = "󰬴 Titlecase" })
map.n("cu", "mzgUiw`z", { desc = "󰬴 lowercase to UPPERCASE" })
map.n("cl", "mzguiw`z", { desc = "󰬴 UPPERCASE to lowercase" })

map.n("i", "a")
map.n("si", "i")

map.i("<C-Z>", "<ESC>")

-- map.n("<a-[>", "[`")
-- map.n("<a-]>", "]`")
-- map.n("<leader>m", "<CMD>SignatureListBufferMarks<CR>")
-- custom for lang laravel
-- map.n("cp", 'vit"apfT')
-- map.n("co", 'vi""apFDviwpFTciw')
-- map.i("<C-P>", "<ESC>f=ww\"_ci'")

-- tmux like directional window resizes
-- stylua: ignore start
map.n("<C-Up>",    "<cmd>lua require'utils.other'.resize(false, -5)<CR>", { silent = true, desc = "horizontal split increase" })
map.n("<C-Down>",  "<cmd>lua require'utils.other'.resize(false,  5)<CR>", { silent = true, desc = "horizontal split decrease" })
map.n("<C-Left>",  "<cmd>lua require'utils.other'.resize(true,  -5)<CR>", { silent = true, desc = "vertical split decrease" })
map.n("<C-Right>", "<cmd>lua require'utils.other'.resize(true,   5)<CR>", { silent = true, desc = "vertical split increase" })
-- stylua: ignore end

map.n("]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map.n("[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

-- map.nx("<C-Z>", "<Plug>(matchup-%)")
-- map.nx("<C-Z>", "%")

-- join
map.n("J", "'mz' . v:count1 . 'J`z'", { expr = true })

-- Break undo chain on punctuation so we can
-- use 'u' to undo sections of an edit
-- DISABLED, ALL KINDS OF ODDITIES
for _, c in ipairs({ ",", ".", "!", "?", ";" }) do
  map.i(c, c .. "<C-g>u", {})
end
-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
-- for _, c in ipairs({
--   { "k", "Line up" },
--   { "j", "Line down" },
-- }) do
--   map.n( c[1], ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]), { expr = true, silent = true, desc = c[2] })
-- end
-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
-- for _, c in ipairs({
--   { "k", "<up>", "Visual line up" },
--   { "j", "<down>", "Visual line down" },
-- }) do
--   map.nv(
--     c[1],
--     ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]),
--     { expr = true, silent = true, desc = c[3] }
--   )
-- end

for k, v in pairs({ ["<down>"] = "<C-n>", ["<up>"] = "<C-p>" }) do
  map.c(k, function()
    local key = vim.fn.pumvisible() ~= 0 and v or k
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
  end, { silent = false })
end

-- Select last pasted/yanked text
map.n("g<C-v>", "`[v`]", { desc = "visual select last yank/paste" })
-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
map.n("<leader>n", function()
  return "<Cmd>nohlsearch|diffupdate|echo<CR>" .. (vim.v.hlsearch == 0 and "<C-l>" or "")
end, { expr = true, desc = "Clear highlighting" })
-- Use operator pending mode to visually select entire buffer, e.g.
-- d<A-a> = delete entire buffer
-- y<A-a> = yank entire buffer
-- v<A-a> = visual select entire buffer
-- map.o("<A-a>", ":<C-U>normal! mzggVG<CR>`z")
-- map.x("<A-a>", ":<C-U>normal! ggVG<CR>")

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
map.n("<F5>", remove_trailing_whitespaces, { desc = "remove trailing whitespaces" })
-- stylua: ignore end

-- Use <C-\><C-r> to insert contents of a register in terminal mode
-- vim.keymap.set("t", [[<C-\><C-r>]], [['<C-\><C-n>"' . nr2char(getchar()) . 'pi']], { expr = true })

-- Insert stuff
map.c({
  ["<C-X><C-V>"] = [[<C-R>"]],
  ["<C-V>"]      = [[<C-R>+]],
})

-- Remap c_CTRL-{G,T} to free up CTRL-G mapping
map.c({
  ["<C-G><C-N>"] = [[<C-G>]],
  ["<C-G><C-P>"] = [[<C-T>]],
})

-- Pairs
map.c({
  ["<C-G><C-O>"] = [[()<Left>]],
  ["<C-G><C-B>"] = [[{}<Left>]],
  ["<C-G><C-A>"] = [[<><Left>]],
  ["<C-G><C-I>"] = [[""<Left>]],
  ["<C-G><C-G>"] = [[\(\)<Left><Left>]],
  ["<C-G><C-W>"] = [[\<\><Left><Left>]],
}, { remap = true })

local api = vim.api

local function modify_line_end_delimiter(character)
  local delimiters = { ',', ';' }
  return function()
    local line = api.nvim_get_current_line()
    local last_char = line:sub(-1)
    if last_char == character then
      api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(delimiters, last_char) then
      api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
    else
      api.nvim_set_current_line(line .. character)
    end
  end
end

map.n('z,', modify_line_end_delimiter(','), { desc = "add ',' to end of line" })
map.n('z;', modify_line_end_delimiter(';'), { desc = "add ';' to end of line" })

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~ multiple cusors (sort of) ~
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

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep  grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")

map.n("C", [[*N"_cgn]], { desc = "mc change word (forward)", noremap = true })

map.n("<a-s>", "*Nqz", { desc = "mc start macro (foward)" })
map.x("<a-s>", mc_select .. "``qz", { desc = "mc start macro (foward)" })
map.n("<a-a>", mc_macro(), { expr = true, desc = "mc end or replay macro" })
map.x("<a-a>", mc_macro(mc_select), { expr = true, desc = "mc end or replay macro" })
-- map.n("<leader>c", "*``cgn", { desc = "mc change word (forward)" })
-- map.x("<leader>c", mc_select .. "``cgn", { desc = "mc change selection (forward)" })

-- map.n("<a-C>", "*``cgN", { desc = "mc change word (backward)" })
-- map.x("<a-C>", mc_select .. "``cgN", { desc = "mc change selection (backward)" })

-- map.n("cQ", "#Nqz", { desc = "mc start macro (backward)" })
-- map.x("cQ", mc_select:gsub("/", "?") .. "``qz", { desc = "mc start macro (backward)" })


-- vim regex
-- (.*) -- find all word
-- ^ -- start of line
-- \r -- add new line
-- $ -- end of line
-- %s -- subtitute (find and replace)
-- \v -- very magic
-- (abc|cba) -- match either abc or cba
-- :%s/\v(abc|cba)//g  -- find and remove abc and cba
-- :s/\(.*\)/abc \1 abc -- add abc first and last word, using visual mode
-- :s/<\(.*\)/{\/*\<\1 *\/} -- find < and add {*/ *\} before and after
-- :4,9s/^/#/ -- add # at first line 4-9

-- Search and Replace
-- :cdo \ cfdo for all buffer
-- %s/\\n/\r/g
-- stylua: ignore start

