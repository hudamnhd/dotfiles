local map  = require('utils.map')

local silent = { silent = true }

-- OVERRIDE DEFAULTS ---------------------------------------------------------------------
map.nx({ ["/"] = "ms/", ["?"] = "ms?"  }) -- Save initial search position
map.x({ ["<"] = "<gv", [">"] = ">gv"  })

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

-- Toggle smartcase
map.c("<C-X><C-I>", function()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.o.smartcase  = not vim.o.smartcase
  return " <BS>" -- update search
end, { expr = true })

-- disable default keybind
map.nv({
  ["a"]       = "<Nop>",
  ["t"]       = "<Nop>",
  ["s"]       = "<Nop>",
  ["r"]       = "<Nop>",
  ["<space>"] = "<Nop>",
})

map.t({
  ["<esc>"] = [[<C-\><C-n>]],
  ["<a-w>"] = [[<C-\><C-n><C-w>w]],
})

map.n({
  ["df"]        = [[:!cp '%:p' '%:p:h/%:t:r.%:e.copy'<CR>]],
  ["d;"]        = [[q:]],
  ["<Tab>"]     = [[g;zvzz]],
  ["<S-Tab>"]   = [[g,zvzz]],
  ["<a-w>"]     = [[<C-W>w]],
  ["<leader>w"] = [[<C-W>]],
  ["<c-w>n"]    = [[:vnew<CR>]],
  ["<leader>k"] = [[:help <C-r>=expand("<cword>")<CR>]],
  ["Y"]         = [[y$]],
  ["i"]         = [[a]],
  ["<F4>"]      = [[:vsp term://$SHELL<CR>]],
  -- ["<a-a>"]     = [[<cmd>keepjumps norm! ggVG<CR>]],
})

map.vn({
  ["<C-H>"]     = [[^]],
  ["<C-L>"]     = [[g_]],
})

map.n({
  ["rt"]        = [[vit"_dP]],
  ["rat"]       = [[vat"_dP]],
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

map.nvi("<C-S>", "<esc>:update<cr>", { silent = true, desc = "Save" })

-- SearchReplace with plugin
map.n("<C-F>", "<CMD>SearchReplaceSingleBufferCWord<CR>")
map.v("<C-F>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>")
map.n("<C-B>", [[:'<,'>s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]])
map.v("<C-B>", "<CMD>SearchReplaceWithinVisualSelection<CR>")

map.v("H",              [[:s/^//gI<Left><Left><Left>]])            -- add begin line only
map.v("L",              [[:s/$//gI<Left><Left><Left>]])            -- add end only
map.v("K",              [[:s/\(.*\)/X \1 X/gI<Left><Left><Left>]]) -- add word begin and end line
map.v("<space><space>", [[:s/\s\+//g<Left><Left>]])               -- delete space

-- w!! to save with sudo
-- nmap("c", "w!!", "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- .nQuickfix list mappings
map.n("<a-q>", "<cmd>lua require'utils.other'.toggle_qf('q')<CR>", { desc = "toggle quickfix list" })
map.n("L",     ":cnext<CR>", { silent = true, desc = "Next quickfix" })
map.n("H",     ":cprevious<CR>", { silent = true, desc = "Previous quickfix" })

-- .nLocation list mappings
map.n("<a-a>", "<cmd>lua require'utils.other'.toggle_qf('l')<CR>", { desc = "toggle location list" })
map.n("<A-[>", ":lprevious<CR>", { silent = true, desc = "Previous location" })
map.n("<A-]>", ":lnext<CR>", { silent = true, desc = "Next location" })

map.n("<leader>Y", [["+Y]])
map.nv("<leader>y", [["+y]])

map.nx("<leader>p", [["+p]], { desc = "paste AFTER from clipboard" })
map.nx("<leader>P", [["+P]], { desc = "paste BEFORE from clipboard" })

-- paste in visual mode without replacing register content
map.x("p", [['pgv"' . v:register . 'y']], { noremap = true, expr = true })

-- without copying to clipboard
map.n({
  -- ["S"]  = [["_S]],
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

-- Keep matches center screen when cycling with n|N
map.n("n", "nzzzv", { desc = "Fwd  search '/' or '?'" })
map.n("N", "Nzzzv", { desc = "Back search '/' or '?'" })

-- emulate some basic commands from `vim-abolish`
map.n("ct", "mzguiwgUl`z", { desc = "󰬴 Titlecase" })
map.n("cu", "mzgUiw`z", { desc = "󰬴 lowercase to UPPERCASE" })
map.n("cl", "mzguiw`z", { desc = "󰬴 UPPERCASE to lowercase" })

map.n("<a-m>", "<CMD>SignatureListBufferMarks<CR>")

-- stylua: ignore start
map.n("<C-Up>",    "<cmd>lua require'utils.other'.resize(false, -5)<CR>", { silent = true, desc = "horizontal split increase" })
map.n("<C-Down>",  "<cmd>lua require'utils.other'.resize(false,  5)<CR>", { silent = true, desc = "horizontal split decrease" })
map.n("<C-Left>",  "<cmd>lua require'utils.other'.resize(true,  -5)<CR>", { silent = true, desc = "vertical split decrease" })
map.n("<C-Right>", "<cmd>lua require'utils.other'.resize(true,   5)<CR>", { silent = true, desc = "vertical split increase" })
-- stylua: ignore end

map.n("]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map.n("[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

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

map.c({
  ["<C-X><C-V>"] = [[<C-R>"]],
  ["<C-V>"]      = [[<C-R>+]],
})

local api = vim.api

local function modify_line_end_delimiter(character)
  local delimiters = { ',', ';', '.' }
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
map.n('z.', modify_line_end_delimiter('.'), { desc = "add '.' to end of line" })

-- stylua: ignore start
map.n("zj", [[:<C-u>call append(line("."),   repeat([""], v:count1))<CR>]], { silent = true, desc = "newline below (no insert-mode)" })
map.n("zk", [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]], { silent = true, desc = "newline above (no insert-mode)" })

map.nx("zm", "<cmd>20messages<CR>", { desc = "open :messages" })
map.nx("zM", [[<cmd>mes clear|echo "cleared :messages"<CR>]], { desc = "clear :messages" })

map.n({["zq"] = [[:wq!<CR>]], }, silent)
-- stylua: ignore end

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep  grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")

map.n("C",  [[*N"_cgn]], { desc = "mc change word (forward)", noremap = true })

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

-- '<,'>s/\v(\w+),/\1={\1}/g clone text exp test to test={test}

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
  map.n( c[1], ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]), { expr = true, silent = true, desc = c[2] })
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