-- stylua: ignore start
local o   = vim.opt
local g   = vim.g
local env = vim.env

-- o.synmaxcol     = 200    -- for `syntax`
-- o.mouse         = ""     -- disable the mouse
-- o.laststatus    = 0                            -- cmdline height
-- o.switchbuf     = "useopen"

-- DO NOT NEED ANY OF THIS, CRUTCH THAT POULLUTES REGISTERS
-- vim clipboard copies to system clipboard
-- unnamed         = use the * register (cmd-s paste in our term)
-- unnamedplus     = use the + register (cmd-v paste in our term)
-- o.clipboard     = 'unnamedplus'

o.title            = true                         -- Change title of window to filename
-- o.background            = "light"                         -- Change title of window to filename
o.inccommand       = "split" -- for live subtitute
o.termguicolors    = true    -- enable 24bit colors
o.timeoutlen       = 650
o.updatetime       = 250     -- decrease update time
o.fileformat       = "unix"  -- <nl> for EOL
o.fileencoding     = "utf-8"
o.matchpairs       = { "(:)", "{:}", "[:]", "<:>" }
o.lazyredraw       = true

o.showmode         = true
o.cmdheight        = 1                            -- cmdline height
o.scrolloff        = 3                            -- min number of lines to keep between cursor and screen edge
o.sidescrolloff    = 5                            -- min number of cols to keep between cursor and screen edge
o.textwidth        = 99                           -- max inserted text width for paste operations
o.number           = true                         -- show absolute line no. at the cursor pos
o.relativenumber   = true                         -- otherwise, show relative numbers in the ruler
o.cursorline       = true                         -- Show a line where the current cursor is
o.signcolumn       = "yes:2"                      -- Show sign column as first column

-- o.cursorlineopt = "number"
-- g._colorcolumn  = 0        -- global var, mark column 100
-- g._colorcolumn  = 100      -- global var, mark column 100
-- o.colorcolumn   = tostring(g._colorcolumn)

o.hlsearch         = true
o.wrap             = false
o.linebreak        = true
o.breakindent      = true
o.smoothscroll     = true
o.ts               = 4
o.autoindent       = true
-- o.guicursor     =
-- "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- show menu even for one item do not auto select/insert
o.completeopt      = { 'noinsert', 'menuone', 'noselect'}
o.wildmode         = "longest:full,full"
o.wildoptions      = "pum" -- Show completion items using the pop-up-menu (pum)
o.pumblend         = 0     -- completion menu transparency
o.pumwidth         = 15    -- min width
o.pumheight        = 12    -- max height
o.joinspaces       = true  -- insert spaces after '.?!' when joining lines

-- o.smartindent   = true  -- add <tab> depending on syntax (C/C++)
-- o.startofline   = false -- keep cursor column on navigation

o.tabstop          = 4     -- Tab indentation levels every two columns
o.softtabstop      = 4     -- Tab indentation when mixing tabs & spaces
o.shiftwidth       = 4     -- Indent/outdent by two columns
o.shiftround       = true  -- Always indent/outdent to nearest tabstop
o.expandtab        = true  -- Convert all tabs that are typed into spaces

-- c: auto-wrap comments using textwidth
-- r: auto-insert the current comment leader after hitting <Enter>
-- o: auto-insert the current comment leader after hitting 'o' or 'O'
-- q: allow formatting comments with 'gq'
-- n: recognize numbered lists
-- 1: don't break a line after a one-letter word
-- j: remove comment leader when it makes sense
-- this gets overwritten by ftplugins (:verb set fo)
-- we use autocmd to remove 'o' in '/lua/autocmd.lua'
-- borrowed from tjdevries
o.formatoptions    = o.formatoptions
    - "a"                                   -- Auto formatting is BAD.
    - "t"                                   -- Don't auto format my code. I got linters for that.
    + "c"                                   -- In general, I like it when comments respect textwidth
    + "q"                                   -- Allow formatting comments w/ gq
    - "o"                                   -- O and o, don't continue comments
    + "r"                                   -- But do continue when pressing enter.
    + "n"                                   -- Indent past the formatlistpat, not underneath it.
    + "j"                                   -- Auto-remove comments if possible.
    - "2"                                   -- I'm not in gradeschool anymore

o.splitbelow       = true                   -- ':new' ':split' below current
o.splitright       = true                   -- ':vnew' ':vsplit' right of current

-- o.undodir       = os.getenv("HOME") .. "/.vim/undodir"
-- o.undofile      = false                  -- no undo file
o.hidden           = true                   -- do not unload buffer when abandoned

o.ignorecase       = false                  -- ignore case on search
o.smartcase        = true                   -- case sensitive when search includes uppercase
o.showmatch        = true                   -- highlight matching [{()}]
-- o.cpoptions        = o.cpoptions .. "x" -- stay on search item when <esc>

o.writebackup      = false                  -- do not backup file before write
o.swapfile         = false                  -- no swap file

o.foldenable       = false                   -- disable folding
-- o.foldmethod    = "indent"

-- Disable providers we do not care a about
g.loaded_python_provider = 0
g.loaded_ruby_provider   = 0
g.loaded_perl_provider   = 0
g.loaded_node_provider   = 0

g.markdown_fenced_languages = {
  "vim",
  "lua",
  "cpp",
  "sql",
  "python",
  "bash=sh",
  "console=sh",
  "javascript",
  "typescript",
  "js=javascript",
  "ts=typescript",
  "yaml",
  "json",
}

-- NOTE disable default keybind
local disabled = { "s", "c", "<c-z>", "<space>" }

for _, key in ipairs(disabled) do
  vim.keymap.set("", key, "<Nop>")
end

-- use ':grep' to send resulsts to quickfix
-- use ':lgrep' to send resulsts to loclist
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- NOTE Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- NOTE without output or jumping to first match
-- NOTE Use ':Grep <pattern> %' to search only current file
-- NOTE Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep  grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")
-- stylua: ignore end
