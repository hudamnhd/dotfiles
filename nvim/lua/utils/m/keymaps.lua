local m = require("utils.m")
local map, lazy = m.map, m.lazy
local silent = { silent = true }

-- OVERRIDE DEFAULTS ---------------------------------------------------------------------
map.n("Y", "y$") -- Yank to the end of the line
map.nx({ ["/"] = "ms/", ["?"] = "ms?" }) -- Save initial search position
map.x({ ["<"] = "<gv", [">"] = ">gv" })

-- BUFFERS -------------------------------------------------------------------------------
map.n({
  ["<leader>q"] = [[:Bq<CR>]],
  ["zq"] = [[:wq!<CR>]],
})

do
  local buf = lazy.require("utils.m.buf")
  map.n({
    ["b"] = -buf.gobuf(lazy.vim.v.count), -- if no count auto move buff alternate
    ["w"] = -buf.next(lazy.vim.v.count1),
    ["q"] = -buf.prev(lazy.vim.v.count1),
    ["W"] = -buf.move_right(lazy.vim.v.count1),
    ["Q"] = -buf.move_left(lazy.vim.v.count1),
  }, { desc = "buffer change" })
end

map.n("s<C-G>", "2<C-G>")

-- FILES ---------------------------------------------------------------------------------
map.n({
  ["<C-F>"] = [[:lua require'utils.m.ui.menus'.bookmarks()<CR>]],
  ["<C-B>"] = [[:lua require'utils.m.ui.menus'.options()<CR>]],
  ["<C-G>"] = [[:lua require'utils.m.ui.menus'.gitsigns()<CR>]],
})

map.n({
  ["<F1>"] = [[:lua require"utils.m.drawer.term".term(1)<CR>]],
  ["<F2>"] = [[:lua require"utils.m.drawer.term".term(2)<CR>]],
  ["<F3>"] = [[:lua require"utils.m.drawer.term".term(3)<CR>]],
  ["<F4>"] = [[:lua require"utils.m.drawer.term".term(4)<CR>]],
})

-- TEXT OBJECTS --------------------------------------------------------------------------
map.xo({
  ["ii"] = [[:<C-U>exe luaeval('require"utils.m.textobj".inner_indent()')<CR>]],
  ["ai"] = [[:<C-U>exe luaeval('require"utils.m.textobj".outer_indent()')<CR>]],
}, silent)

map.n("s<C-a>", [[<cmd>keepjumps norm! ggVG<CR>]])
-- COMMENT ---------------------------------------------------------------------------

-- stylua: ignore start
map.x({
  ["gcb"] = [[:s@^\(.*\)$@{{--\1--}}<CR>:let @/ = ""<CR>]],
  ["guB"] = [[:s@^{{--\(\(.*[^{\{--]\)\)\?--}}$@\1<CR>:let @/ = ""<CR>]],
  ["gcj"] = [[:s@^\(.*\)$@{/*\1*/}<CR>:let @/ = ""<CR>]],
  ["guj"] = [[:s@^{/\*\(\(.*[^{/\*]\)\)\?\*/}$@\1<CR>:let @/ = ""<CR>]],
  ["gch"] = [[:s@^\(.*\)$@<!--\1--><CR>:let @/ = ""<CR>]],
  ["guh"] = [[:s@^<!--\(\(.*[^<!--]\)\)\?-->$@\1<CR>:let @/ = ""<CR>]],
})
-- stylua: ignore end
-- Insert stuff
map.i({
  ["<C-R><C-T>"] = [[<C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>]],
  ["<C-R><C-K>"] = [[<C-K>]],
  ["<C-R><C-Y>"] = [[<C-R>"]],
  ["<C-R><C-Space>"] = [[<C-R>+]],
}, silent)

-- New line below/above
map.i({
  ["<C-G><C-J>"] = "<C-G>u<C-O>o",
  ["<C-G><C-K>"] = "<C-G>u<C-O>O",
})

-- Toggle smartcase
map.c("<C-X><C-I>", function()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.o.smartcase = not vim.o.smartcase
  return " <BS>" -- update search
end, { expr = true })

-- Insert stuff
map.c({
  ["<C-R><C-T>"] = [[<C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>]],
  ["<C-R><C-Y>"] = [[<C-R>"]],
  ["<C-R><C-Space>"] = [[<C-R>+]],
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

-- other
map.n({
  ["i"]     = [[a]],
  ["s;"]    = [[:]],
  ["d;"]    = [[q:]],
  ["<Tab>"] = [[g;zvzz]],
})

map.n("i", function()
  if #vim.fn.getline "." == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

map.n({
  ["e"] = [[E]],
  ["E"] = [[B]],
  ["<leader>w"] = [[<C-W>]],
  ["<C-W>"] = [[<C-W>w]],
})

map.vn({
  ["H"] = [[^]],
  ["L"] = [[$]],
})

map.x({
  ["="] = [[g<C-a>]],
  ["ss"] = [[<ESC>]],
})

map.n({
  ["<C-D>"] = [[<C-D>zz]],
  ["<C-U>"] = [[<C-U>zz]],
  ["{"] = [[{zz]],
  ["}"] = [[}zz]],
})

map.n({
  ["yt"] = [[yit]],
  ["rt"] = [[vit"_dP]],
  ["rat"] = [[vat"_dP]],
})

map.n({
  ["yw"] = [[yiw]],
  ["rw"] = [[viw"_dP]],
})

map.v({
  ["w"] = [[iw]],
  ["W"] = [[iW]],
  ["t"] = [[it]],
  ["T"] = [[at]],
  ["'"] = [[i']],
  ['"'] = [[i"]],
})

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
vim.cmd("command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")

map.n("cn", "*``cgn", { desc = "mc change word (forward)" })
map.n("cN", "*``cgN", { desc = "mc change word (backward)" })
map.x("cn", mc_select .. "``cgn", { desc = "mc change selection (forward)" })
map.x("cN", mc_select .. "``cgN", { desc = "mc change selection (backward)" })

map.n("cq", "*Nqz", { desc = "mc start macro (foward)" })
map.n("cQ", "#Nqz", { desc = "mc start macro (backward)" })
map.n("<a-q>", mc_macro(), { expr = true, desc = "mc end or replay macro" })

map.x("cq", mc_select .. "``qz", { desc = "mc start macro (foward)" })
map.x("cQ", mc_select:gsub("/", "?") .. "``qz", { desc = "mc start macro (backward)" })
map.x("<a-q>", mc_macro(mc_select), { expr = true, desc = "mc end or replay macro" })


-- vim regex
-- (.*) -- find all word
-- ^ -- start of line
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

-- stylua: ignore start


-- map.n("cs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g]] .. string.rep("<left>", 2), { desc = "search and replace word under cursor" })
-- map.x("cs", [[:<C-u>%s/\V<C-r>=luaeval("require'utils.other'.get_visual_selection(true)")<CR>/<C-r>=luaeval("require'utils.other'.get_visual_selection(true)")<CR>/g<Left><Left>]], {})
-- map.n("cS", [[:%s/\V<C-r><C-a>/<C-r><C-a>/g]] .. string.rep("<left>", 1), { desc = "search and replace WORD under cursor" })


-- .nshortcut to view :messages
map.nx("<leader>m", "<cmd>messages<CR>", { desc = "open :messages" })
map.nx("<leader>M", [[<cmd>mes clear|echo "cleared :messages"<CR>]], { desc = "clear :messages" })
-- .nstylua: ignore end

-- .n<ctrl-s> to Save
map.ni("<C-S>", "<esc>:update<cr>", { silent = true, desc = "Save" })

-- SearchReplace with plugin
map.n("z<C-H>", "<CMD>SearchReplaceSingleBufferCWORD<CR>")
map.n("<C-H>", "<CMD>SearchReplaceSingleBufferCWord<CR>")
map.v("<C-H>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>")
map.v("<C-B>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>")
map.v("<C-R>", "<CMD>SearchReplaceWithinVisualSelection<CR>")

-- w!! to save with sudo
-- nmap("c", "w!!", "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- .nQuickfix list mappings
map.n("sq", "<cmd>lua require'utils.other'.toggle_qf('q')<CR>", { desc = "toggle quickfix list" })
map.n("[q", ":cprevious<CR>", { silent = true, desc = "Next quickfix" })
map.n("]q", ":cnext<CR>", { silent = true, desc = "Previous quickfix" })

-- .nLocation list mappings
map.n("sQ", "<cmd>lua require'utils'.other.toggle_qf('l')<CR>", { desc = "toggle location list" })
map.n("[e", ":lprevious<CR>", { silent = true, desc = "Previous location" })
map.n("]e", ":lnext<CR>", { silent = true, desc = "Next location" })

-- .n<leader>v|<leader>r act as <cmd-v>|<cmd-s>
-- .n<leader>p|P paste from yank register (0)
map.nx("<leader>r", [["*p]], { desc = "paste AFTER from primary" })
map.nx("<leader>R", [["*P]], { desc = "paste BEFORE from primary" })
map.nx("<leader>v", [["+p]], { desc = "paste AFTER from clipboard" })
map.nx("<leader>V", [["+P]], { desc = "paste BEFORE from clipboard" })
map.nx("<leader>p", [["0p]], { desc = "paste AFTER  from yank (reg:0)" })
map.nx("<leader>P", [["0P]], { desc = "paste BEFORE from yank (reg:0)" })

-- without copying to clipboard
map.n({
  ["S"] = [["_S]],
  ["C"] = [["_C]],
  ["D"] = [["_D]],
})

map.nx({
  ["c"] = [["_c]],
  ["x"] = [["_x]],
})

--  Change
map.n({
  ["dc"] = [["_cc]],
  ["dw"] = [["_ciw]],
  ["dW"] = [["_ciW]],
  ["dt"] = [["_cit]],
  ["d'"] = [["_ci']],
  ['d"'] = [["_ci"]],
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
map.n("zj", [[:<C-u>call append(line("."), repeat([""], v:count1))<CR>]],
  { silent = true, desc = "newline below (no insert-mode)" })
map.n("zk", [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]],
  { silent = true, desc = "newline above (no insert-mode)" })
-- stylua: ignore end

-- Custom
map.n("tpa", [[:lua require('utils').paste_text_to_register('a')<CR>]], { silent = true })

-- emulate some basic commands from `vim-abolish`
map.n("ct", "mzguiwgUl`z", { desc = "󰬴 Titlecase" })
map.n("cu", "mzgUiw`z", { desc = "󰬴 lowercase to UPPERCASE" })
map.n("cl", "mzguiw`z", { desc = "󰬴 UPPERCASE to lowercase" })

-- disable default keybind
map.n({
  ["a"] = "<Nop>",
  ["t"] = "<Nop>",
  ["s"] = "<Nop>",
  ["r"] = "<Nop>",
  ["sa"] = "<Nop>",
  ["<space>"] = "<Nop>",
})

-- custom for lang laravel
map.n("cp", 'vit"apfT')
map.n("co", 'vi""apFDviwpFTciw')
map.i("<C-L>", "<ESC>f=ww\"_ci'")

-- tmux like directional window resizes
-- stylua: ignore start
map.n("<C-Up>",    "<cmd>lua require'utils.other'.resize(false, -5)<CR>", { silent = true, desc = "horizontal split increase" })
map.n("<C-Down>",  "<cmd>lua require'utils.other'.resize(false,  4)<CR>", { silent = true, desc = "horizontal split decrease" })
map.n("<C-Left>",  "<cmd>lua require'utils.other'.resize(true,  -5)<CR>", { silent = true, desc = "vertical split decrease" })
map.n("<C-Right>", "<cmd>lua require'utils.other'.resize(true,   5)<CR>", { silent = true, desc = "vertical split increase" })
-- stylua: ignore end

map.n("]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map.n("[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

map.nx("<C-Z>", "<Plug>(matchup-%)")

map.n("<leader><C-Z>", "<cmd>MatchupWhereAmI?<CR>")
-- .njoin
map.n("J", "'mz' . v:count1 . 'J`z'", { expr = true })


-- Break undo chain on punctuation so we can
-- use 'u' to undo sections of an edit
-- DISABLED, ALL KINDS OF ODDITIES
for _, c in ipairs({ ",", ".", "!", "?", ";" }) do
  map.i(c, c .. "<C-g>u", {})
end
-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
for _, c in ipairs({
  { "k", "Line up" },
  { "j", "Line down" },
}) do
  map.n(
    c[1],
    ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]),
    { expr = true, silent = true, desc = c[2] }
  )
end
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
-- -- TMUX aware navigation
-- for _, k in ipairs({ "h", "j", "k", "l", "\\" }) do
--   map({ "n", "x", "t" }, string.format("<M-%s>", k), function()
--     require("utils").tmux_aware_navigate(k, true)
--   end, { silent = true })
-- end

-- Select last pasted/yanked text
map.n("g<C-v>", "`[v`]", { desc = "visual select last yank/paste" })
-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
map.n("<leader>n", function()
  return "<Cmd>nohlsearch|diffupdate|echo<CR>" .. (vim.v.hlsearch == 0 and "<leader>n" or "")
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
vim.keymap.set(
  't',
  [[<C-\><C-r>]],
  [['<C-\><C-n>"' . nr2char(getchar()) . 'pi']],
  { expr = true }
)



-- Don't include extra spaces around quotes
vim.keymap.set({ 'o', 'x' }, 'a"', '2i"', { noremap = false })
vim.keymap.set({ 'o', 'x' }, "a'", "2i'", { noremap = false })
vim.keymap.set({ 'o', 'x' }, 'a`', '2i`', { noremap = false })

-- Edit current file's directory
vim.keymap.set({ 'n', 'x' }, '-', '<Cmd>e%:p:h<CR>')

-- Text object: current buffer
-- stylua: ignore start
vim.keymap.set('x', 'af', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
vim.keymap.set('x', 'if', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'af', '<Cmd>silent! normal m`Vaf<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'if', '<Cmd>silent! normal m`Vif<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set('x', 'iz', [[':<C-u>silent! keepjumps normal! ' . v:lua.require'utils.misc'.textobj_fold('i') . '<CR>']], { silent = true, expr = true, noremap = false })
vim.keymap.set('x', 'az', [[':<C-u>silent! keepjumps normal! ' . v:lua.require'utils.misc'.textobj_fold('a') . '<CR>']], { silent = true, expr = true, noremap = false })
vim.keymap.set('o', 'iz', '<Cmd>silent! normal Viz<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'az', '<Cmd>silent! normal Vaz<CR>', { silent = true, noremap = false })
-- stylua: ignore end

-- Use 'g{' and 'g}' to move to the first/last line of a paragraph
-- stylua: ignore start
vim.keymap.set({ 'o' }, 'g{', '<Cmd>silent! normal Vg{<CR>', { noremap = false })
vim.keymap.set({ 'o' }, 'g}', '<Cmd>silent! normal Vg}<CR>', { noremap = false })
vim.keymap.set({ 'n', 'x' }, 'g{', function() require('utils.misc').goto_paragraph_firstline() end, { noremap = false })
vim.keymap.set({ 'n', 'x' }, 'g}', function() require('utils.misc').goto_paragraph_lastline() end, { noremap = false })
-- stylua: ignore end

-- Abbreviations
vim.keymap.set('!a', 'ture', 'true')
vim.keymap.set('!a', 'Ture', 'True')
vim.keymap.set('!a', 'flase', 'false')
vim.keymap.set('!a', 'fasle', 'false')
vim.keymap.set('!a', 'Flase', 'False')
vim.keymap.set('!a', 'Fasle', 'False')
vim.keymap.set('!a', 'lcaol', 'local')
vim.keymap.set('!a', 'lcoal', 'local')
vim.keymap.set('!a', 'locla', 'local')
vim.keymap.set('!a', 'sahre', 'share')
vim.keymap.set('!a', 'saher', 'share')
vim.keymap.set('!a', 'balme', 'blame')

vim.api.nvim_create_autocmd('CmdlineEnter', {
  once = true,
  callback = function()
    local utils = require('utils')
    -- utils.keymap.command_map('S', '%s/')
    utils.keymap.command_map(':', 'lua ')
    utils.keymap.command_abbrev('man', 'Man')
    utils.keymap.command_abbrev('bt', 'bel te')
    utils.keymap.command_abbrev('ep', 'e%:p:h')
    utils.keymap.command_abbrev('vep', 'vs%:p:h')
    utils.keymap.command_abbrev('sep', 'sp%:p:h')
    utils.keymap.command_abbrev('tep', 'tabe%:p:h')
    utils.keymap.command_abbrev('rm', '!rm')
    utils.keymap.command_abbrev('mv', '!mv')
    utils.keymap.command_abbrev('git', '!git')
    utils.keymap.command_abbrev('mkd', '!mkdir')
    utils.keymap.command_abbrev('mkdir', '!mkdir')
    utils.keymap.command_abbrev('touch', '!touch')
    return true
  end,
})
