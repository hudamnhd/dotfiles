-- stylua: ignore start
local map    = require("utils.map")
local silent = { noremap = true, silent = true }

map.nx({ ["/"] = "ms/", ["?"] = "ms?" }) -- Save initial search position
map.x({ ["<"] = "<gv", [">"] = ">gv" })

map.n("gh", [[:lua require'utils.menus'.gitsigns()<CR>]],   { desc = "Git Sign + Fzflua Git" })
map.n("go", [[:lua require'utils.menus'.options()<CR>]],    { desc = "Options" })
map.n("sq", [[:lua require'utils.menus'.bookmarks()<CR>]],  { desc = "FzfLua" })
map.n("se", [[:lua require'utils.menus'.genghist()<CR>]],   { desc = "Session & File Operation" })

-- bak file
map.n("dy", [[:clear<bar>silent exec "!cp '%:p' '%:p:h/%:t:r.%:e.bak'"<bar>redraw<bar>echo "Copied " . expand('%:t') . ' to ' . expand('%:t:r') . '.' . expand('%:e'). '.bak' <cr>]])

-- Comment 
map.v({
  ["gcb"] = [[:s@^\(.*\)$@{{--\1--}}<CR>:let @/ = ""<CR>]],
  ["gub"] = [[:s@^{{--\(\(.*[^{\{--]\)\)\?--}}$@\1<CR>:let @/ = ""<CR>]],
  ["gcj"] = [[:s@^\(.*\)$@{/*\1*/}<CR>:let @/ = ""<CR>]],
  ["guj"] = [[:s@^{/\*\(\(.*[^{/\*]\)\)\?\*/}$@\1<CR>:let @/ = ""<CR>]],
  ["gch"] = [[:s@^\(.*\)$@<!--\1--><CR>:let @/ = ""<CR>]],
  ["guh"] = [[:s@^<!--\(\(.*[^<!--]\)\)\?-->$@\1<CR>:let @/ = ""<CR>]],
})

-- Toggle smartcase
map.c("<c-s>", function()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.o.smartcase  = not vim.o.smartcase
  return " <BS>" -- update search
end, { expr = true })

-- disable default keybind
map.nv({
  ["q"]       = "<Nop>",
  ["a"]       = "<Nop>",
  ["t"]       = "<Nop>",
  ["s"]       = "<Nop>",
  ["r"]       = "<Nop>",
  ["<space>"] = "<Nop>",
})

map.t({
  ["<a-w>"] = [[<C-\><C-n><C-w>w]],
})

map.n({
  ["<Tab>"]     = [[g;zzzv]],
  ["<S-Tab>"]   = [[g,zzzv]],
  ["<c-w>n"]    = [[:vnew<CR>]],
  ["<a-w>"]     = [[<C-W>w]],
  ["sv"]        = [[<C-W>v]],
  ["sc"]        = [[<C-W>c]],
  ["<leader>w"] = [[<C-W>]],
  ["gj"]        = [[i<c-j><esc>k$]],
  ["d;"]        = [[q:]],
  ["Y"]         = [[y$]],
  ["i"]         = [[a]],
  ["<F4>"]      = [[:vsp term://$SHELL<CR>]],
})

map.vn({
  [";"]     = [[:]],
  ["<C-H>"] = [[^]],
  ["<C-L>"] = [[g_]],
})

map.n({
  ["rt"]  = [[vit"_dP]],
  ["rat"] = [[vat"_dP]],
  ["rw"]  = [[viw"_dP]],
})

map.xo({
  ["{"] = [[i{]],
  ["["] = [[i[]],
  ["("] = [[i(]],
  ["b"] = [[ib]],
  ["B"] = [[iB]],
  ["w"] = [[iw]],
  ["W"] = [[iW]],
  ["t"] = [[it]],
  ["T"] = [[at]],
}, { desc = "operator pending" })

map.nvi("<C-S>", "<esc>:update<cr>", { silent = true, desc = "Save" })

-- w!! to save with sudo
-- nmap("c", "w!!", "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

map.n("<leader>Y", [["+y$]], { desc = "yank to clipboard" })
map.nv("<leader>y", [["+y]], { desc = "yank to clipboard" })

map.nx("<leader>p", [["+p]], { desc = "paste AFTER from clipboard" })
map.nx("<leader>P", [["+P]], { desc = "paste BEFORE from clipboard" })

-- paste in visual mode without replacing register content
map.x("p", [['pgv"' . v:register . 'y']], { noremap = true, expr = true })

-- without copying to clipboard
map.n({
  ["D"] = [["_D]],
  ["d"] = [["_c]],
})

map.nx({
  ["c"] = [["_c]],
  ["x"] = [["_x]],
})

map.n("dd", function()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end, { expr = true, desc = "delete blank lines to black hole register" })

-- Keep matches center screen when cycling with n|N
map.n("n", "nzzzv", { desc = "Fwd  search '/' or '?'" })
map.n("N", "Nzzzv", { desc = "Back search '/' or '?'" })

map.n("<C-Up>",    "<cmd>lua require'utils.other'.resize(false, -5)<CR>", { silent = true, desc = "horizontal split increase" })
map.n("<C-Down>",  "<cmd>lua require'utils.other'.resize(false,  5)<CR>", { silent = true, desc = "horizontal split decrease" })
map.n("<C-Left>",  "<cmd>lua require'utils.other'.resize(true,  -5)<CR>", { silent = true, desc = "vertical split decrease" })
map.n("<C-Right>", "<cmd>lua require'utils.other'.resize(true,   5)<CR>", { silent = true, desc = "vertical split increase" })

map.n("<a-[>", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map.n("<a-]>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

-- join
map.n("J", "'mz' . v:count1 . 'J`z'", { expr = true })

-- Select last pasted/yanked text
map.n("g<C-v>", "`[v`]", { desc = "visual select last yank/paste" })

-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
map.n("<leader>n", function()
  return "<Cmd>nohlsearch|diffupdate|echo<CR>" .. (vim.v.hlsearch == 0 and "<C-l>" or "")
end, { expr = true, desc = "Clear highlighting" })

---Remove all trailing whitespaces within the current buffer
---Retain cursor position & last search content
local function remove_trailing_whitespaces()
  local pos         = vim.api.nvim_win_get_cursor(0)
  local last_search = vim.fn.getreg("/")
  local hl_state    = vim.v.hlsearch

  vim.cmd(":%s/\\s\\+$//e")

  vim.fn.setreg("/", last_search) -- restore last search
  vim.api.nvim_win_set_cursor(0, pos) -- restore cursor position
  if hl_state == 0 then
    vim.cmd.nohlsearch() -- disable search highlighting again if it was disabled before
  end
end

map.n("<F5>", remove_trailing_whitespaces, { desc = "remove trailing whitespaces" })

map.c({
  ["<C-V>"]      = [[<C-R>"]],                                           
  ["<C-X><C-V>"] = [[<C-R>+]],                                           
  ["<C-space>"]  = [[.\{-}]],                                            -- fuzzy search
  ["<C-X><C-I>"] = [[s/^//gI<Left><Left><Left>]],                        -- add begin line
  ["<C-X><C-A>"] = [[s/$//gI<Left><Left><Left>]],                        -- add end only
  ["<C-X><C-Z>"] = [[s/\(.*\)/X \1 X/gI<Left><Left><Left>]],             -- add word begin and end
  ["<C-X><C- >"] = [[s/\s\+//g<Left><Left>]],                            -- delete space
  ["<C-X><C-G>"] = [[\(\)<Left><Left>]],                                 
  ["<C-X><C-W>"] = [[\<\><Left><Left>]],                                 
  ["<C-X><C-S>"] = [[%s///g<Left><Left>]],                               
  ["<C-X><C-B>"] = [['<,'>s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]],
}, { remap = true, desc = "paste n subtitute" }, { desc = "PASTE N SUBTITUTE" })

-- Lua expression
map.c("=", [[getcmdtype() == ':' && getcmdline() == '' ? 'lua=' : '=']], { expr = true })

local api = vim.api

local function modify_line_end_delimiter(character)
  local delimiters = { ",", ";", "." }
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

map.n("z,", modify_line_end_delimiter(","), { desc = "add ',' to end of line" })
map.n("z;", modify_line_end_delimiter(";"), { desc = "add ';' to end of line" })
map.n("z.", modify_line_end_delimiter("."), { desc = "add '.' to end of line" })

map.n("zj", [[:<C-u>call append(line("."),   repeat([""], v:count1))<CR>]], { silent = true, desc = "newline below (no insert-mode)" })
map.n("zk", [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]], { silent = true, desc = "newline above (no insert-mode)" })

map.n("<a-m>", "<cmd>20messages<CR>", { desc = "open :messages" })
map.n("<a-M>", [[<cmd>mes clear|echo "cleared :messages"<CR>]], { desc = "clear :messages" })

map.n({["zq"] = [[:wq!<CR>]], }, silent)
map.n({["z<esc>"] = [[:q!<CR>]], }, silent)

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep  grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")


-- Add word to search then replace
map.n("C", [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_cgn]])

-- Add selection to search then replace
map.x("C", [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>"_cgn]])

-- -- Begin a "searchable" macro
-- map.x("<a-q>", [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>gvqi]])
-- -- Apply macro in the next instance of the search
-- map.n("<F8>", "gn@i")

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
for _, c in ipairs({
  { "k", "<up>", "Visual line up" },
  { "j", "<down>", "Visual line down" },
}) do
  map.nv(
    c[1],
    ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]),
    { expr = true, silent = true, desc = c[3] }
  )
end

for k, v in pairs({ ["<down>"] = "<C-n>", ["<up>"] = "<C-p>" }) do
  map.c(k, function()
    local key = vim.fn.pumvisible() ~= 0 and v or k
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
  end, { silent = false })
end

map.c("%%", 'getcmdtype() == ":" ? expand("%:h")."/" : "%%"', { expr = true })

-- emulate some basic commands from `vim-abolish`
local case_state = 0

local function cycle_case(count)
  vim.cmd("normal! mz")

  if count then
    case_state = (count - 1) % 3
  end

  if case_state == 0 then
    -- Change to Titlecase
    vim.cmd("normal! guiwgUl`z")
  elseif case_state == 1 then
    -- Change to UPPERCASE
    vim.cmd("normal! gUiw`z")
  else
    -- Change to lowercase
    vim.cmd("normal! guiw`z")
  end

  if not count then
    case_state = (case_state + 1) % 3
  end
  vim.cmd("normal! `z")
end

-- Function wrapper to handle count and call cycle_case
local function cycle_case_wrapper()
  local count = vim.v.count
  if count == 0 then
    count = nil
  end
  cycle_case(count)
end

map.n( "<a-c>", cycle_case_wrapper, { noremap = true, silent = true, desc = "Cycle case transformations" })
-- stylua: ignore end
