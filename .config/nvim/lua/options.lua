local o          = vim.opt

-- o.mouse      = ""     -- disable the mouse
o.termguicolors  = true   -- enable 24bit colors
o.synmaxcol      = 200    -- for `syntax`
o.timeoutlen     = 650 
o.updatetime     = 100    -- decrease update time
o.fileformat     = "unix" -- <nl> for EOL
o.switchbuf      = "useopen"
o.fileencoding   = "utf-8"
-- o.matchpairs     = { "(:)", "{:}", "[:]", "<:>" }
-- o.lazyredraw   = true
-- recursive :find in current dir
vim.cmd [[set path=.,,,$PWD/**]]

-- DO NOT NEED ANY OF THIS, CRUTCH THAT POULLUTES REGISTERS
-- vim clipboard copies to system clipboard
-- unnamed     = use the * register (cmd-s paste in our term)
-- unnamedplus = use the + register (cmd-v paste in our term)
-- o.clipboard         = 'unnamedplus'
o.showmode       = false
o.cmdheight      = 1                            -- cmdline height
o.cmdwinheight   = math.floor(vim.o.lines / 3)  -- 'q:' window height
o.scrolloff      = 3                            -- min number of lines to keep between cursor and screen edge
o.sidescrolloff  = 5                            -- min number of cols to keep between cursor and screen edge
o.textwidth      = 99                           -- max inserted text width for paste operations
o.number         = true                        -- show absolute line no. at the cursor pos
o.relativenumber = false                        -- otherwise, show relative numbers in the ruler
o.cursorline     = false                        -- Show a line where the current cursor is
o.signcolumn     = "yes:1"  -- Show sign column as first column

-- o.cursorlineopt    = "number"
-- vim.g._colorcolumn = 0        -- global var, mark column 100
-- vim.g._colorcolumn = 100      -- global var, mark column 100
-- o.colorcolumn      = tostring(vim.g._colorcolumn)

-- o.hlsearch     = false
o.wrap           = false
o.linebreak      = true
o.breakindent    = true
o.smoothscroll   = true
o.ts             = 4
o.autoindent     = true
-- o.guicursor        =
-- "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
-- Characters to display on ':set list',explore glyphs using:
-- `xfd -fa "InputMonoNerdFont:style:Regular"` or
-- `xfd -fn "-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-1"`
-- input special chars with the sequence <C-v-u> followed by the hex code
o.listchars        = {
  tab      = "→ ",
  eol      = "↲",
  nbsp     = "␣",
  lead     = "␣",
  space    = "␣",
  trail    = "•",
  extends  = "⟩",
  precedes = "⟨",
}
o.showbreak        = "↪ "

-- show menu even for one item do not auto select/insert
o.completeopt      = { 'noinsert', 'menuone', 'noselect'}
o.wildmode         = "longest:full,full"
o.wildoptions      = "pum" -- Show completion items using the pop-up-menu (pum)
o.pumblend         = 0    -- completion menu transparency
o.pumwidth         = 15 -- min width
o.pumheight        = 12 -- max height
o.joinspaces       = true  -- insert spaces after '.?!' when joining lines
-- o.smartindent      = true  -- add <tab> depending on syntax (C/C++)
-- o.startofline      = false -- keep cursor column on navigation

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


o.undofile         = false                  -- no undo file
o.hidden           = true                   -- do not unload buffer when abandoned

o.ignorecase       = false                  -- ignore case on search
o.smartcase        = true                   -- case sensitive when search includes uppercase
o.showmatch        = true                   -- highlight matching [{()}]
vim.o.cpoptions    = vim.o.cpoptions .. "x" -- stay on search item when <esc>

o.writebackup      = false                  -- do not backup file before write
o.swapfile         = false                  -- no swap file

--[[
  ShDa (viminfo for vim): session data history
  --------------------------------------------
  ! - Save and restore global variables (their names should be without lowercase letter).
  ' - Specify the maximum number of marked files remembered. It also saves the jump list and the change list.
  < - Maximum of lines saved for each register. All the lines are saved if this is not included, <0 to disable pessistent registers.
  % - Save and restore the buffer list. You can specify the maximum number of buffer stored with a number.
  / or : - Number of search patterns and entries from the command-line history saved. o.history is used if it’s not specified.
  f - Store file (uppercase) marks, use 'f0' to disable.
  s - Specify the maximum size of an item’s content in KiB (kilobyte).
      For the viminfo file, it only applies to register.
      For the shada file, it applies to all items except for the buffer list and header.
  h - Disable the effect of 'hlsearch' when loading the shada file.

  :oldfiles - all files with a mark in the shada file
  :rshada   - read the shada file (:rviminfo for vim)
  :wshada   - write the shada file (:wrviminfo for vim)
]]

o.shada          = [[!,'100,<0,s100,h]]
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize"
o.diffopt        = "internal,filler,algorithm:histogram,indent-heuristic"

-- use ':grep' to send resulsts to quickfix
-- use ':lgrep' to send resulsts to loclist
if vim.fn.executable("rg") == 1 then
  o.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
  o.grepformat = "%f:%l:%c:%m"
end

-- Disable providers we do not care a about
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider   = 0
vim.g.loaded_perl_provider   = 0
vim.g.loaded_node_provider   = 0

-- Disable some in built plugins completely
local disabled_built_ins     = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  'matchit',
  'matchparen',
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 0
end

vim.g.markdown_fenced_languages = {
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

-- Map leader to <space>
vim.g.mapleader                 = " "
vim.g.maplocalleader            = " "
-- We do this to prevent the loading of the system fzf.vim plugin. This is
-- present at least on Arch/Manjaro/Void
-- vim.api.nvim_command("set rtp-=/usr/share/vim/vimfiles")


-- vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
--   desc = "Highlight the cursor line in the active window",
--   pattern = "*",
--   command = "setlocal cursorline",
--   group = aug,
-- })
-- vim.api.nvim_create_autocmd("WinLeave", {
--   desc = "Clear the cursor line highlight when leaving a window",
--   pattern = "*",
--   command = "setlocal nocursorline",
--   group = aug,
-- })

-- built-in ftplugins should not change my keybindings
vim.g.no_plugin_maps = true
vim.cmd.filetype({ args = { "plugin", "on" } })
vim.cmd.filetype({ args = { "plugin", "indent", "on" } })

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last edit position when opening files",
  pattern = "*",
  command = [[if line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG' | exe "normal! g`\"" | endif]],
  group = aug,
})

local obs = false
local function set_scrolloff(winid)
  if obs then
    vim.wo[winid].scrolloff = math.floor(math.max(10, vim.api.nvim_win_get_height(winid) / 10))
  else
    vim.wo[winid].scrolloff = 1 + math.floor(vim.api.nvim_win_get_height(winid) / 2)
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "WinNew", "VimResized" }, {
  desc = "Always keep the cursor vertically centered",
  pattern = "*",
  callback = function()
    if not vim.b.overseer_task then
      set_scrolloff(0)
    end
  end,
  group = aug,
})

vim.api.nvim_create_user_command("ToggleObs", function()
  obs = not obs
  vim.o.relativenumber = not obs
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(winid) then
      vim.wo[winid].relativenumber = not obs
      set_scrolloff(winid)
    end
  end
end, {
  desc = "Toggle settings that make me easier to follow while pairing",
})

-- o.foldlevel        = 1                     -- open most folds by default
-- o.foldnestmax      = 10                     -- 10 nested fold max
-- Start with folds open
o.foldenable     = true                   -- enable folding
o.foldmethod     = "indent"               -- fold based on indent level
o.foldlevelstart = 99
o.foldlevel      = 99

-- Disable fold column
o.foldcolumn     = "0"

vim.o.foldtext = [[v:lua.utils.other.foldtext()")]]
vim.opt.fillchars = {
  fold = " ",
  vert = "┃",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

-- Map leader-r to do a global replace of a word
-- vim.keymap.set("n", "<leader>r", [[*N:s//<C-R>=expand("<cword>")<CR>]])

-- Expand %% to current directory in command mode
vim.cmd.cabbr({ args = { "<expr>", "%%", "&filetype == 'oil' ? bufname('%')[6:] : expand('%:p:h')" } })

vim.api.nvim_create_autocmd("FocusGained", {
  desc = "Reload files from disk when we focus vim",
  pattern = "*",
  command = "if getcmdwintype() == '' | checktime | endif",
  group = aug,
})
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Every time we enter an unmodified buffer, check if it changed on disk",
  pattern = "*",
  command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
  group = aug,
})

-- Close the scratch preview automatically
vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertLeave" }, {
  desc = "Close the popup-menu automatically",
  pattern = "*",
  command = "if pumvisible() == 0 && !&pvw && getcmdwintype() == ''|pclose|endif",
  group = aug,
})
