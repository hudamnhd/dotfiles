local o          = vim.opt

o.title          = true -- Change title of window to filename
o.synmaxcol      = 200  -- for `syntax`
o.guicursor      = ""
o.nu             = true
o.relativenumber = true
o.cursorline     = true
o.tabstop        = 4
o.softtabstop    = 4
o.shiftwidth     = 4
o.expandtab      = true
o.smartindent    = true
o.wrap           = false
o.swapfile       = false
o.backup         = false
o.inccommand     = 'split'
o.hlsearch       = false
o.incsearch      = true
o.termguicolors  = true
o.scrolloff      = 8
o.updatetime     = 50
o.textwidth      = 80
o.formatoptions  = 'rqnl1j' -- Improve comment editing
o.foldmethod     = "indent"
o.foldenable     = true
o.foldlevel      = 99

o.guicursor      = {
  "n-v-c-sm:block-Cursor", -- Use 'Cursor' highlight for normal, visual, and command modes
  "i-ci-ve:ver25-lCursor", -- Use 'lCursor' highlight for insert and visual-exclusive modes
  "r-cr:hor20-CursorIM",   -- Use 'CursorIM' for replace mode
}

vim.cmd.colorscheme("default")
