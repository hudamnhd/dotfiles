-- stylua: ignore start
local M = {}

 M.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
}

function M.bind(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- toogle number
M.bind("n", '[n', [[:set nonumber norelativenumber<CR>]], { desc ="noactive number" } )
M.bind("n", ']n', [[:set number relativenumber<CR>]], { desc ="active number" } )

-- NOTE disable default keybind
M.bind("n", "q", "<Nop>")
M.bind("n", "a", "<Nop>")
M.bind("n", "t", "<Nop>")
M.bind("n", "s", "<Nop>")
M.bind("n", "r", "<Nop>")
M.bind("n", " ", "<Nop>") -- NOTE <space>

M.bind("n", "<C-Z>", "<Nop>") -- NOTE <space>

M.bind({ "o", "x" }, "{", [[i{]], { remap = true })
M.bind({ "o", "x" }, "[", [[i[]], { remap = true })
M.bind({ "o", "x" }, "(", [[i(]], { remap = true })
M.bind({ "o", "x" }, "q", [[iq]], { remap = true })
M.bind({ "o", "x" }, "Q", [[aq]], { remap = true })
M.bind({ "o", "x" }, "b", [[ib]], { remap = true })
M.bind({ "o", "x" }, "B", [[iB]], { remap = true })
M.bind({ "o", "x" }, "w", [[iw]], { remap = true })
M.bind({ "o", "x" }, "W", [[iW]], { remap = true })
M.bind({ "o", "x" }, "t", [[it]], { remap = true })
M.bind({ "o", "x" }, "T", [[at]], { remap = true })

M.bind("n", "S", "ysiw", { remap = true })
M.bind("n", "M", "Vgm",  { remap = true })

-- NOTE OVERRIDE DEFAULTS
M.bind("n", "<tab>",   [[g;]])
M.bind("n", "<s-tab>", [[g,]])

M.bind("n", "zq", [[:wq!<CR>]], { noremap = true,  desc ="save quit" })

M.bind('n', '<a-c>', [[gcc]], { remap = true })
M.bind('x', '<a-c>', [[gc]],  { remap = true })

M.bind('n', '<C-c>', [[<cmd>close<CR>]])

M.bind("n", "<a-w>",  [[<C-W>w]], { remap = true })
M.bind("t", "<a-w>",  [[<C-\><C-n><C-w>w]])
M.bind("t", "<C-\\>", [[<C-\><C-n>]])

M.bind("n", "!", [[:<up><cr>]])

M.bind({ "n", "v" }, "<C-H>", [[^]])
M.bind({ "n", "v" }, "<C-L>", [[g_]])
M.bind({ "n", "v" }, "<C-Z>", [[%]], { remap = true })

M.bind({ "n", "v" }, "c", [["_c]])
M.bind({ "n", "v" }, "x", [["_x]])

M.bind("n", "Y",  [[yy]])
M.bind("n", "i",  [[a]])
M.bind("n", "d;",  [[q:]])

-- NOTE without copying to clipboard
M.bind("n", "D", [["_D]])
M.bind("n", "C", [["_C]])
M.bind("n", "d", [["_c]])

M.bind("n", "<leader>d", [["_d]], { desc = "delete opr" })

M.bind("n", "rT", [[vat"_dP]])
M.bind("n", "rt", [[vit"_dP]])

-- emulate some basic commands from `vim-abolish`
M.bind("n", "ct", "mzguiwgUl`z", { desc = "󰬴 Titlecase" })
M.bind("n", "cu", "mzgUiw`z",    { desc = "󰬴 lowercase to UPPERCASE" })
M.bind("n", "cl", "mzguiw`z",    { desc = "󰬴 UPPERCASE to lowercase" })

M.bind("c", "<C-X><C-A>", [[\<\><Left><Left>]], { silent = false })
M.bind("c", "<C-X><C-S>", [[\(.*\)/X \1 X]],    { silent = false })
M.bind("c", "<C-X><C-X>", [[\(\)<Left><Left>]], { silent = false })

-- NOTE Lua expression
M.bind("c", "=",  [[getcmdtype() == ':' && getcmdline() == '' ? 'lua=' : '=']], { silent = false, expr = true })
M.bind("c", "%%", 'getcmdtype() == ":" ? expand("%:p:h") : "%%"',               { silent = false, expr = true })

M.bind("c" , "<C-V>",      [[<C-R>"]], { desc = "paste cmd-mode", silent = false  })
M.bind("c" , "<C-X><C-V>", [[<C-R>+]], { desc = "paste cmd-mode", silent = false  })

M.bind("c", "<c-space>", [[.\{-}]], { silent = false })
M.bind("c", "<a-space>", [[\s\+]], { silent = false })

-- NOTE join
M.bind("n", "J", "'mz' . v:count1 . 'J`z'", { expr = true })

-- NOTE Select last pasted/yanked text
M.bind("n", "g<C-v>", "`[v`]", { desc = "visual select last yank/paste" })

M.bind({ "n", "v", "i" }, "<C-S>", "<esc>:update<cr>", { desc = "Save" })

M.bind("x", "p", [['pgv"' . v:register . 'y']], { noremap = true, expr = true, desc = "paste in visual mode without replacing register content" })

M.bind("x", "C", [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>"_cgn]], { noremap = true, desc = "Add selection to search then replace"})

M.bind("n", "C", [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_cgn]], { noremap = true, desc = "Add word to search then replace"})

-- NOTE Keep matches center screen when cycling with n|N
M.bind("n", "n", "nzzzv", { desc = "Fwd  search '/' or '?'" })
M.bind("n", "N", "Nzzzv", { desc = "Back search '/' or '?'" })

-- NOTE resize window
M.bind("n", "<C-Up>",    "<cmd>lua require'utils.helper'.resize(false, -5)<CR>", { desc = "horizontal split increase" })
M.bind("n", "<C-Down>",  "<cmd>lua require'utils.helper'.resize(false,  5)<CR>", { desc = "horizontal split decrease" })
M.bind("n", "<C-Left>",  "<cmd>lua require'utils.helper'.resize(true,  -5)<CR>", { desc = "vertical split decrease" })
M.bind("n", "<C-Right>", "<cmd>lua require'utils.helper'.resize(true,   5)<CR>", { desc = "vertical split increase" })

M.bind("x", "<C-F>", [[<CMD>SearchReplaceSingleBufferVisualSelection<CR>]],  { desc = "replace visual" })
M.bind("x", "<C-B>", [[<CMD>SearchReplaceWithinVisualSelectionCWord<CR>]],   { desc = "replace cword" })
M.bind("n", "<C-F>", [[<CMD>SearchReplaceSingleBufferCWord<CR>]],            { desc = "replace cword" })
M.bind("n", "<C-B>", [[:'<,'>s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>]], { desc = "replace cword", silent = false })

M.bind("n", "zk", [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]], { desc = "newline above (no insert-mode)" })
M.bind("n", "zj", [[:<C-u>call append(line("."),   repeat([""], v:count1))<CR>]], { desc = "newline below (no insert-mode)" })

M.bind('n', '<a-e>', [[:<C-u>call append(0, expand('<cword>'))<CR>]], { noremap = true, silent = true })

local file100k         = [[<cmd>lua require('fzf-lua').fzf_exec("fdfind --size +100k", { actions = require'fzf-lua'.defaults.actions.files })<cr>]]
local duplicate_bak    = [[<cmd>call luaeval('require"utils.helper".duplicate_bak_file()')<cr>]]
local toggle_diff_buff = [[<cmd>call luaeval('require"utils.helper".toggle_diff_buff()')<cr>]]
local oldfiles         = [[<cmd>call luaeval('require"plugins.fzf-lua.cmds".oldfiles()')<cr>]]
local grep_curbuf      = [[<cmd>call luaeval('require"plugins.fzf-lua.cmds".grep_curbuf()')<cr>]]
local translate_nm     = [[<cmd>call luaeval('require"utils.helper".translate_nm()')<cr>]]
local translate_vm     = [[<cmd>call luaeval('require"utils.helper".translate_vm()')<cr>]]
local set_cwd          = [[<cmd>lua require"utils.helper".set_cwd()<cr>]]
local asynctasks       = [[<cmd>lua require"utils.helper".asynctasks()<cr>]]
local git_diff_buff    = [[<cmd>lua MiniDiff.toggle_overlay()<cr>]]

M.bind("n", "go", git_diff_buff,    { desc = "Toggle overlay" })
M.bind("n", "s=", toggle_diff_buff, { desc = "󱇠  TOGGLE_DIFF_BUFF" })
M.bind("n", "s0", file100k,         { desc = "󱂥  FILES +100K" })
M.bind("n", "s%", set_cwd,          { desc = "󰏅  set_cwd" })
M.bind("n", "s.", duplicate_bak,    { desc = "󰄢  DUPLICATE_BAK_FILE" })
M.bind("n", "st", translate_nm,     { desc = "󰈥  translate" })
M.bind("x", "st", translate_vm,     { desc = "󰈥  translate" })
M.bind("n", "sw", asynctasks,       { desc = "ASYNCTASKS" })

M.bind("n", "s1", "<cmd>F ~/.config/nvim<cr>",          { desc = "󱂥  VIMRC" })
M.bind("n", "s2", "<cmd>F ~/vimwiki<cr>",               { desc = "󰙯  NOTES" })
M.bind("n", "s'", "<cmd>FzfLua marks<cr>",              { desc = "󰗼  MARKS" })
M.bind("n", "s;", "<cmd>FzfLua command_history<cr>",    { desc = "󰎟  COMMAND_HISTORY" })
M.bind("n", "sa", "<cmd>Agit<cr>",                      { desc = "󰊢  AGIT" })
M.bind("n", "sA", "<cmd>AgitFile<cr>",                  { desc = "󰊢  AGITfILE" })
M.bind("n", "sC", "<cmd>FzfLua git_bcommits<cr>",       { desc = "󰊢  GIT_BCOMMITS" })
M.bind("n", "sc", "<cmd>FzfLua git_commits<cr>",        { desc = "󰊢  GIT_COMMITS" })
M.bind("n", "sj", "<cmd>FzfLua changes<cr>",            { desc = "󰏜  CHANGES" })
M.bind("n", "sJ", "<cmd>FzfLua jumps<cr>",              { desc = "󰏜  JUMPS" })
M.bind("n", "so", "<cmd>MRU<cr>",                       { desc = "󰕮  MRU" })
M.bind("n", "sO", oldfiles,                             { desc = "󰕮  OLDFILES" })
M.bind("n", "sb", "<cmd>FzfLua buffers<cr>",            { desc = "󰕮  BUFFERS" })
M.bind("n", "sg", "<cmd>FzfLua grep<cr>",               { desc = "󰎒  GREP PROMP" })
M.bind("n", "sh", "<cmd>FzfLua search_history<cr>",     { desc = "󰍰  SEARCH_HISTORY" })
M.bind("n", "sl", grep_curbuf,                          { desc = "󰎒  grep_curbuf" })
M.bind("n", "sL", "<cmd>Lazy<cr>",                      { desc = "󰏋  LAZY" })
M.bind("n", "sp", "<cmd>F<cr>",                         { desc = "󱂥  FILES" })
M.bind("n", "sP", "<cmd>F %:h<cr>",                     { desc = "󱂥  FILES Sibling" })
M.bind("n", "sr", "<cmd>FzfLua grep resume=true<cr>",   { desc = "󰎒  GREP" })
M.bind("n", "su", "<cmd>UndotreeToggle<cr>",            { desc = "󱎌  UNDOTREEtOGGLE" })
M.bind("n", "sy", "<cmd>Unite -vertical yankround<cr>", { desc = "󱁄  YANKROUND" })
M.bind("n", "sY", "<cmd>CopyFullPath<cr>",              { desc = "󰋦  CopyFullPath" })
M.bind("n", "ss", "<cmd>FzfLua builtin<cr>",            { desc = "󰍰  BUILTIN" })
M.bind("n", "sk", "<cmd>FzfLua grep_cword<cr>",         { desc = "󰎒  grep_cword" })
M.bind("x", "sk", "<cmd>FzfLua grep_visual<cr>",        { desc = "󰎒  grep_visual" })
M.bind("n", "sK", "<cmd>FzfLua grep_cWORD<cr>",         { desc = "󰎒  grep_cWORD" })


M.bind({ "n", "v" }, "<Leader>y", '"+y', { desc = "yank to clipboard" })
M.bind({ "n", "v" }, "<Leader>p", '"+p', { desc = "paste from clipboard" })

M.bind("n", "<Leader>Y", '"+Y$',        { desc = "yank line to clipboard" })
M.bind("n", "<Leader>f", ":Pick <Tab>", { desc = "Pick" })
M.bind("n", "<Leader>w", "<C-W>",       { desc = "Window", remap = true })

M.bind("n", "<Leader>m",    "<Cmd>messages<CR>",                                                            { desc = "Messages" })
M.bind("n", "<Leader>r",    "<CMD>SearchReplaceSingleBufferSelections<CR>",                                 { desc = "SearchReplaceSingleBufferSelections" })
M.bind("n", "<Leader>bd",   "<Cmd>CloseBuffer<CR>",                                                         { desc = "Delete" })
M.bind("n", "<Leader>bs",   "<Cmd>vsplit Scracth<CR>",                                                      { desc = "Scratch" })
M.bind("n", "<Leader>bq",   '<CMD>%bdelete|edit #|normal `"<CR>',                                           { desc = "Delete all!" })
M.bind("n", "<Leader>tt",   "<Cmd>lua MiniTrailspace.trim()<CR>",                                           { desc = "Trim trailspace" })
M.bind("n", "<Leader>tT",   "<Cmd>lua vim.b.minitrailspace_disable = not vim.b.minitrailspace_disable<CR>", { desc = "Trailspace hl toggle" })
M.bind("n", "<Leader>th",   "<Cmd>TSBufToggle highlight<CR>",                                               { desc = "Highlight toggle" })
M.bind("n", "<Leader>tH",   "<Cmd>lua MiniHipatterns.toggle()<CR>",                                         { desc = "Hipatterns toggle" })
M.bind("n", "<Leader>q",    "<Cmd>SmartClose<CR>",                                                          { desc = "SmartClose!" })
M.bind("n", "<Leader>n",    "<Cmd>nohlsearch|diffupdate|echo<CR>",                                          { desc = "nohlsearch" })
M.bind("n", "<Leader>1",    "<Cmd>AsyncTask regex-tutor<CR>",                                               { desc = "regex-tutor" })
M.bind("n", "<Leader>2",    "<Cmd>AsyncTask vim-tutor<CR>",                                                 { desc = "vim-tutor" })
M.bind("n", "<Leader>a",    '<Cmd>lua MiniVisits.add_label("core")<CR>',                                    { desc = 'Add "core" label' })
M.bind("n", "<Leader>A",    '<Cmd>lua MiniVisits.remove_label("core")<CR>',                                 { desc = 'Remove "core" label' })
M.bind("n", "<Leader>sp",   ":echo expand('%:p')<CR>",                                                      { desc = "Show path" })
M.bind("n", "<Leader><bs>", ":g/^$/d<CR>",                                                                  { desc = "Delete empty lines" })

local function replacer()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":%s///g<left><left>", true, false, true), "n", true)
end

M.bind("n", "<Leader>R", replacer,{ desc = "Replace Search" })

local function visit_paths()
  local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
  MiniExtra.pickers.visit_paths({ cwd = '', filter = 'core', sort = sort_latest }, { source = { name = "Core visits (all)" } })
end

M.bind("n", "<Leader>h",  visit_paths, { desc = "Core visits (all)" })

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

local function toggle_smart_case()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.o.smartcase = not vim.o.smartcase
  return " <BS>" -- NOTE update search
end

M.bind("c", "<c-s>", toggle_smart_case, { expr = true, desc = "Toggle smartcase" })

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

-- Membuat pemetaan kunci menggunakan vim.api.nvim_set_keymap
M.bind('n', '<c-space>', zoom_toggle, {})

-- stylua: ignore end
return M
