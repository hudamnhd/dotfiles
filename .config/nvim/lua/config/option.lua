--------------------------------------------------------------------------------
-- Setting Options                                               See :help vim.o
--------------------------------------------------------------------------------

-- Set global and local Leader keys to space
vim.g.mapleader = vim.keycode('<Space>')
vim.g.maplocalleader = vim.keycode('<Space>')

vim.o.number = true -- Show line numbers
vim.o.relativenumber = true -- Show relative line numbers
vim.o.signcolumn = 'yes' -- Always show the sign column (e.g., for linting)
vim.o.title = true -- Enable window title in the terminal
vim.o.titlestring = 'nvim: %F' -- Set the title string to display filename
vim.o.wrap = false -- Disable line wrapping
vim.o.confirm = true -- Ask for confirmation before closing unsaved changes
vim.o.splitkeep = 'screen' -- Keep the screen content when splitting
vim.o.laststatus = 3 -- only show status last window
vim.o.showmode = false -- disable because use custom statusline

vim.o.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!
vim.o.breakindent = true -- Enable break indent for wrapped lines
vim.o.splitbelow = true -- Open new split windows below current window
vim.o.splitright = true -- Open new vertical split to the right of current window
vim.o.scrolloff = 8 -- Keep 8 lines visible when scrolling
vim.o.switchbuf = 'useopen,uselast' -- Use open or last buffer when switching buffers

vim.o.tabstop = 2 -- Set tab width to 2 spaces
vim.o.shiftwidth = 2 -- Set indentation to 2 spaces
vim.o.softtabstop = 2 -- Set soft tab stop to 2 spaces
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.smartindent = true -- Use smart indentation based on syntax

vim.o.hlsearch = false -- Disable search highlighting after search
vim.o.incsearch = true -- Enable incremental search highlight
vim.o.ignorecase = false -- Do not ignore case in searches
vim.o.smartcase = false -- Disable smart case search (case-sensitive if uppercase used)

vim.o.hidden = true -- Keep buffers hidden when abandoned
vim.o.writebackup = false -- Do not create backup files before overwriting
vim.o.swapfile = false -- Disable swap files
vim.o.undofile = true -- Enable persistent undo so history is saved

vim.o.updatetime = 250 -- Set delay before triggering CursorHold event
vim.o.timeoutlen = 600 -- Set timeout length for mapped sequences

-- vim.o.shada = [[!,'25,<0,s40,h]] -- :help shada

vim.cmd([[set path=.,,,$PWD/**]]) -- recursive :find in current dir

--------------------------------------------------------------------------------
